#!/usr/bin/env bash
import.require 'provision'
import.require 'params'
provision.nginx_base.init() {
    provision.nginx_base.__init() {
          import.useModule 'provision'
          import.useModule 'params'
    }
    provision.nginx_base.require() {
        if ! provision.isInstalled 'nginx'; then
          sudo apt-get install -y nginx
          return $?
        fi
        return 0
    }
    provision.nginx_base.createSite() {
        local -A __params
        __params['port']='80'
        __params['path']='/var/www/html'
        __params['site-name']='site-name'
        params.get "$@"

        local __conf_en_dir='/etc/nginx/sites-enabled'
        local __conf_dir='/etc/nginx/sites-available'
        if [ ! -d "${__conf_dir}" ]; then
            logger.error \
                --message "Could not find nginx configs dir at \"${__conf_dir}\""
            return 1
        fi
        local __conf_file="${__conf_dir}/${__params['site-name']}"
        if [ ! -f "${__conf_file}" ]; then
            provision.nginx_base.createSiteConfig \
                "${__params['port']}" \
                "${__params['path']}" \
                "${__params['site-name']}" \
                | sudo tee "${__conf_file}"
        else
            logger.warning --message \
                "The config file \"${__conf_file}\" already exists"
        fi

        local __enabled_conf_file="${__conf_en_dir}/${__params['site-name']}"
        if [ ! -L "${__enabled_conf_file}" ]; then
            sudo ln -s "${__conf_file}" "${__enabled_conf_file}"
        else
            logger.warning --message \
                "The symlink to \"${__enabled_conf_file}\" already exists"
        fi

        return 0
    }

    provision.nginx_base.restart() {
        logger.info \
            --message 'Restarting nginx...' \
            --vebosity '2'
        if provision.isInstalled 'systemctl'; then
            sudo systemctl reload-or-restart nginx
        else
            sudo service nginx restart
        fi

        return "$?"
    }

    provision.nginx_base.clearAllSites() {
        logger.info \
            --message 'Clearing all existing enabled sites nginx...' \
            --vebosity '2'
        sudo rm -f /etc/nginx/sites-enabled/*
        return "$?"
    }

    # This function is required because of an nginx and vagrant/virtualbox issue
    # http://www.conroyp.com/2013/04/25/css-javascript-truncated-by-nginx-sendfile/
    provision.nginx_base.disableSendFile() {
        logger.info \
            --message 'Disabling sendfile in nginx...' \
            --vebosity '2'
        sudo sed -i 's/sendfile on;$/sendfile off;/g' /etc/nginx/nginx.conf
        return "$?"
    }

    provision.nginx_base.createSiteConfig() {
        local __port="$1"
        local __path="$2"
        local __site_domain="$3"
        cat << EOF
            server {
               listen ${__port} default_server;
               listen [::]:${__port} default_server;
               root ${__path};

               index index.html index.htm index.nginx-debian.html;

               server_name ${__site_domain};

               location / {
                       try_files \$uri \$uri/ =404;
               }
        }
EOF
    }

    provision.nginx_base.createNonDefaultSiteConfig() {
        local -A __params
        __params['port']='80'
        __params['site-name']=
        __params['path']=
        __params['gzip-on']='1'
        params.get "$@"
        local __port="${__params['port']}"
        local __path="${__params['path']}"
        local __site_name="${__params['site-name']}"
        local __gzip_on="${__params['gzip-on']}"

        local __gzip_conf=''
        if [ "${__gzip_on}" == '1' ]; then
            __gzip_conf="$(provision.nginx.getGzipSettings)"
        fi

        local __block="server {
               listen ${__port};
               root ${__path};

               index index.html index.htm index.nginx-debian.html;

               server_name ${__site_name};

               ${__gzip_conf}

               location / {
                       try_files \$uri \$uri/ =404;
               }
        }"

        local __conf_en_dir='/etc/nginx/sites-enabled'
        local __conf_dir='/etc/nginx/sites-available'
        local __conf_file="${__conf_dir}/${__site_name}"
        echo "${__block}" | sudo tee "${__conf_file}"

        local __enabled_conf_file="${__conf_en_dir}/${__site_name}"
        if [ ! -L "${__enabled_conf_file}" ]; then
            sudo ln -s "${__conf_file}" "${__enabled_conf_file}"
            logger.info --mesage "Enabled nginx site \"${__site_name}\""
        else
            logger.warning --message \
                "The symlink to \"${__enabled_conf_file}\" already exists"
        fi
    }

    provision.nginx_base.configureSSL() {

        local -A __params
        __params['site-name']='site-name'
        __params['ssl-certs-dir']='/etc/nginx/ssl'
        params.get "$@"

        local __key_name="${__params['site-name']}"
        # sudo mkdir -p "${__key_name}"
        local __ssl_path="${__params['ssl-certs-dir']}"
        sudo mkdir -p "${__ssl_path}"

        local __path_key="${__ssl_path}/${__key_name}.key"
        local __path_csr="${__ssl_path}/${__key_name}.csr"
        local __path_crt="${__ssl_path}/${__key_name}.crt"

        if [ ! -f "${__path_key}" ] || [ ! -f "${__path_csr}" ] || [ ! -f "${__path_crt}" ]
        then
            logger.info --message \
                "Creating SSL certificate files for \"${__key_name}\"."

            sudo openssl genrsa -out "${__path_key}" 2048 || {
                logger.error --message \
                    "Failed to create SSL keyfile at \"${__path_key}\""
                return 1
            }
            sudo openssl req -new -key "${__path_key}" \
                -out "${__path_csr}" -subj "/CN=${__key_name}/O=Vagrant/C=UK" \
            || {
                logger.error --message \
                    "Failed to create SSL csr file at \"${__path_csr}\""
                return 1
            }
            sudo openssl x509 -req -days 365 -in "${__path_csr}" \
                -signkey "${__path_key}" -out "${__path_crt}"  \
            || {
                logger.error --message \
                    "Failed to create SSL crt file at \"${__path_crt}\""
                return 1
            }
        else
            logger.info --verbosity 2 --message \
                "SSL certificate files for \"${__key_name}\" already exist."
        fi
        return 0
    }


    provision.nginx_base.getGzipSettings() {
        local __gzip_block="
            gzip on;
            gzip_types      text/plain application/xml application/json application/javascript text/css;
            gzip_proxied    no-cache no-store private expired auth;
            gzip_min_length 1000;
        "
        echo "${__gzip_block}"
    }

    provision.nginx_base.createLaravelSite() {
        local -A __params
        __params['port']='80'
        __params['ssl-port']='443'
        __params['path']='/var/www/html'
        __params['site-name']='site-name'
        __params['gzip-on']='1'
        params.get "$@"

        local __site_path="${__params['path']}"
        local __site_port="${__params['port']}"
        local __site_ssl_port="${__params['ssl-port']}"
        local __site_name="${__params['site-name']}"
        local __gzip_on="${__params['gzip-on']}"

        local __gzip_conf=''
        if [ "${__gzip_on}" == '1' ]; then
            __gzip_conf="$(provision.nginx.getGzipSettings)"
        fi

        provision.nginx_base.configureSSL --site-name "${__site_name}" || {
            logger.error --message \
                "SSL certificate generation failed for site \"${__site_name}\""
            return 1
        }

        local __block="server {
            listen ${__site_port};
            listen ${__site_ssl_port} ssl;
            server_name ${__site_name};
            root \"${__site_path}\";

            index index.html index.htm index.php;

            charset utf-8;

            location / {
                try_files \$uri \$uri/ /index.php?\$query_string;
            }

            location = /favicon.ico { access_log off; log_not_found off; }
            location = /robots.txt  { access_log off; log_not_found off; }

            access_log off;
            error_log  /var/log/nginx/${__site_name}-error.log error;

            sendfile off;

            client_max_body_size 100m;

            ${__gzip_conf}

            location ~ \.php$ {
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
                fastcgi_index index.php;
                include fastcgi_params;
                fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;

                fastcgi_intercept_errors off;
                fastcgi_buffer_size 16k;
                fastcgi_buffers 4 16k;
                fastcgi_connect_timeout 300;
                fastcgi_send_timeout 300;
                fastcgi_read_timeout 300;
            }

            location ~ /\.ht {
                deny all;
            }

            ssl_certificate     /etc/nginx/ssl/${__site_name}.crt;
            ssl_certificate_key /etc/nginx/ssl/${__site_name}.key;
        }
        "
        local __conf_en_dir='/etc/nginx/sites-enabled'
        local __conf_dir='/etc/nginx/sites-available'
        local __conf_file="${__conf_dir}/${__site_name}"
        echo "${__block}" | sudo tee "${__conf_file}"

        local __enabled_conf_file="${__conf_en_dir}/${__site_name}"
        if [ ! -L "${__enabled_conf_file}" ]; then
            sudo ln -s "${__conf_file}" "${__enabled_conf_file}"
            logger.info --mesage "Enabled nginx site \"${__site_name}\""
        else
            logger.warning --message \
                "The symlink to \"${__enabled_conf_file}\" already exists"
        fi

    }
}
