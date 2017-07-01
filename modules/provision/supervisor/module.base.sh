import.require 'provision'
import.require 'params'
provision.supervisor_base.init() {
    provision.supervisor_base.__init() {
          import.useModule 'provision'
          import.useModule 'params'
    }
    provision.supervisor_base.require() {
        if ! provision.isPackageInstalled 'supervisor'; then
          sudo apt-get install -y supervisor
          return $?
        fi

        return 0
    }
    provision.supervisor_base.addService() {
        declare -A __params
        __params['name']=''
        __params['force']='0'
        __params['directory']=''
        __params['logfile']=''
        __params['command']=''
        __params['autostart']='true'
        __params['autorestart']='true'
        __params['user']="$USER"
        __params['redirect_stderr']='true'
        __params['stdout_logfile']=''
        __params['stderr_logfile']=''
        params.get "$@"

        if [ "${__params['logfile']}" != '' ]; then
            if [ "${__params['stdout_logfile']}" == '' ]; then
                __params['stdout_logfile']="${__params['logfile']}"
            fi
            if [ "${__params['stderr_logfile']}" == '' ]; then
                __params['stderr_logfile']="${__params['logfile']}"
            fi
        fi

        local __tmp_conf=$(mktemp)

        cat > "$__tmp_conf" << EOL
[program:${__params['name']}]
environment=HOME="${__params['user']}", USER="${__params['user']}"
directory=${__params['directory']}
command=${__params['command']}
autostart=${__params['autostart']}
autorestart=${__params['autorestart']}
user=${__params['user']}
redirect_stderr=${__params['redirect_stderr']}
stdout_logfile=${__params['stdout_logfile']}
stderr_logfile=${__params['stderr_logfile']}
EOL

        if [ "$?" != '0' ]; then
            logger.error --message \
                "Could not create file at \"${__tmp_conf}\""
            return 1
        fi

        local __config_file="/etc/supervisor/conf.d/${__params['name']}.conf"

        if [ ! -f "$__config_file" ] \
            || [ "${__params['force']}" == '1' ]; then
            sudo cp "$__tmp_conf" "$__config_file" || {
                logger.error --message \
                    "Could not copy config file to \"${__config_file}\" from \"${__tmp_conf}\""
                return 1
            }
            logger.info --message \
                "Copied config file to \"${__config_file}\""
        else
            logger.info --message \
                "Supervisor config file already exists at \"${__config_file}\"" \
                --verbosity 2
        fi

        return 0
    }
    provision.supervisor_base.restart() {
        declare -A __params
        __params['name']=''
        params.get "$@"

        if provision.isInstalled 'systemctl'; then
            sudo systemctl reload-or-restart supervisor
        else
            sudo service supervisor stop
            sudo service supervisor start
        fi

        # if [ "${__params['name']}" != '' ]; then
        #     sudo supervisorctl stop "${__params['name']}"
        # fi

        sudo supervisorctl reread || {
            # 2 means there were no config updates to read
            if [ "$?" != '2' ]; then
                logger.error --message \
                    "Failed to read supervisor config file"
                return 1
            fi
        }
        sudo supervisorctl update || {
            logger.warning --message \
                "Failed to update supervisor"
        }

        local __start_job_name="${__params['name']}"
        if [ "${__start_job_name}" == '' ]; then
            __start_job_name='all'
        fi
        # sudo supervisorctl start "${__start_job_name}" || {
        #     logger.error --message \
        #         "Failed to start supervisor process \"${__start_job_name}\""
        #     return 1
        # }
        return 0
    }
}
