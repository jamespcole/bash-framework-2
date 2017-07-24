#!/usr/bin/env bash
import.require 'provision'
import.require 'os.updates'
import.require 'params'
import.require 'provision.software-properties-common'
provision.mssql_base.init() {
    provision.mssql_base.__init() {
          import.useModule 'provision'
          import.useModule 'params'
          import.useModule 'os.updates'
          import.useModule 'provision.software-properties-common'
    }
    provision.mssql_base.require() {
        declare -A __params
        __params['sa-pwd']=''
        params.get "$@"
        if [ ! -f '/lib/systemd/system/mssql-server.service' ]; then
            provision.mssql_base.addPpa

            export ACCEPT_EULA=Y \
                && export DEBIAN_FRONTEND=noninteractive \
                && sudo apt-get install -y mssql-server \
            || {
                logger.error --message \
                    'Failed to install SQL Server'
                return 1
            }

            expect -c "
            spawn sudo /opt/mssql/bin/mssql-conf setup
            expect \"Enter your edition:\"
            send \"3\r\"
            expect \"Enter the SQL Server system administrator password:\"
            send \"${__params['sa-pwd']}\r\"
            expect \"Confirm the SQL Server system administrator password:\"
            send \"${__params['sa-pwd']}\r\"
            expect eof"

          return $?
        fi
        return 0
    }

    provision.mssql_base.addPpa() {
        provision.require 'software-properties-common'
        provision.isPpaInstalled 'mssql-server' && {
            return 0
        }

        export DEBIAN_FRONTEND=noninteractive && \
            sudo apt-get install -y curl  && \
            curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - && \
            sudo add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server.list)" \
            || {
                logger.error --message \
                    'Failed to add SQL Server ppa'
                return 1
            }

        # update the apt-get cache before we try and install anything
        script.tryCommand --command 'os.updates.check' --retries 4 || {
            script.exitWithError "Updating apt-cache failed"
        }
    }
}
