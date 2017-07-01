#!/usr/bin/env bash
import.require 'provision'
import.require 'params'
provision.php_base.init() {
    provision.php_base.__init() {
          import.useModule 'provision'
          import.useModule 'params'
    }
    provision.php_base.require() {
        if ! provision.isInstalled 'php'; then
          sudo apt-get install -y php7.0-cli || {
            return 1
          }
        fi
        return 0
    }

    provision.php_base.installPhp7PPA() {
        sudo apt-get install -y \
            software-properties-common \
            python-software-properties

        sudo add-apt-repository ppa:ondrej/php -y || {
            logger.error --message \
                'Adding php7 ppa failed...'
            return 1
        }
        sudo apt-get update
    }

    provision.php_base.requireWithExtensions() {
        sudo apt-get install -y \
            php7.0-cli \
            php7.0-dev \
            php-pear \
            php7.0-pgsql \
            php7.0-mbstring \
            php-apcu \
            php7.0-json \
            php7.0-curl \
            php7.0-gd \
            php7.0-gmp\
            php7.0-imap \
            php7.0-mcrypt \
            php-memcached \
            php7.0-fpm \
            php7.0-xml \
        || {
            logger.error \
                --message "PHP Install failed"
            return 1
        }
        return 0
    }

    provision.php_base.enableFpmReload() {
        local -A __params
        __params['username']="${USER}"
        params.get "$@"

        local __fpm_ruser="${__params['username']}"
        logger.info --message \
            "Enabling php-fpm restart for user \"${__fpm_ruser}\"..."

        if [ ! -f '/etc/sudoers.d/php-fpm' ]; then
        logger.info --message \
            "Creating php-fpm restart sudo file at \"/etc/sudoers.d/php-fpm\""
            # Allow FPM Restart
            echo "${__fpm_ruser} ALL=NOPASSWD: /usr/sbin/service php7.0-fpm reload" \
                | sudo tee -a /etc/sudoers.d/php-fpm || {
                    script.exitWithError "Setting up php-fpm relaod failed"
                    return 1
                }
            return 0
        fi

        if grep -q \
            "^${__fpm_ruser} ALL=NOPASSWD: /usr/sbin/service php7.0-fpm reload" \
            '/etc/sudoers.d/php-fpm'; \
        then
            logger.info --message \
                "\"${__fpm_ruser}\" is being aded to an existing\"/etc/sudoers.d/php-fpm\" file."

            echo "${__fpm_ruser} ALL=NOPASSWD: /usr/sbin/service php7.0-fpm reload" \
                | sudo tee -a /etc/sudoers.d/php-fpm || {
                    script.exitWithError "Setting up php-fpm relaod failed"
                    return 1
                }
            return 0
        else
            logger.info --message \
                "\"${__fpm_ruser}\" already has permission to restart fpm."
        fi
        return 0
    }
    provision.php_base.fpmReload() {
        logger.info --message \
            "Reloading/restarting fpm"
        if provision.isInstalled 'systemctl'; then
            sudo systemctl reload-or-restart php7.0-fpm.service || {
                logger.info --message \
                    "Failed to restart fpm."
                return 1
            }
        else
            sudo service php7.0-fpm restart || {
                logger.info --message \
                    "Failed to restart fpm."
                return 1
            }
        fi
        return 0
    }
}
