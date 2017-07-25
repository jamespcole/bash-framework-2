#!/usr/bin/env bash
import.require 'provision'
import.require 'os.updates'
import.require 'params'
import.require 'provision.curl'
import.require 'provision.expect'
import.require 'provision.software-properties-common'

provision.mssql_base.init() {
    provision.mssql_base.__init() {
          import.useModule 'provision'
          import.useModule 'params'
          import.useModule 'os.updates'
          import.useModule 'provision.curl'
          import.useModule 'provision.expect'
          import.useModule 'provision.software-properties-common'
    }
    provision.mssql_base.require() {

        if [ ! -f '/etc/systemd/system/multi-user.target.wants/mssql-server.service' ]; then
            provision.mssql.addPpa

             export DEBIAN_FRONTEND=noninteractive \
                && sudo apt-get install -y mssql-server \
            || {
                logger.error --message \
                    'Failed to install SQL Server'
                return 1
            }
            return $?
        fi
        return 0
    }

    provision.mssql_base.configure() {
        declare -A __params
        __params['sa-pwd']=''
        __params['accept-eula']='Y'
        __params['edition']='3' # 3 is Express edition
        params.get "$@"

        # if [ -f '/lib/systemd/system/mssql-server.service' ]; then
        #     logger.info --message \
        #         'mssql server has already been configured...'
        #     return 0
        # fi

        sudo systemctl status mssql-server | grep -q 'Active: active (running)' && {
            logger.info --message \
                'mssql server has already been configured...'
            return 0
        }

        provision.require 'expect' || {
            logger.error --message \
                'Could not install expect'
            return 1
        }

        expect -c "
        spawn sudo /opt/mssql/bin/mssql-conf setup
        expect \"Do you accept the license terms?\"
        send \"${__params['accept-eula']}\r\"
        expect \"Enter your edition\"
        send \"${__params['edition']}\r\"
        expect \"Enter the SQL Server system administrator password:\"
        send \"${__params['sa-pwd']}\r\"
        expect \"Confirm the SQL Server system administrator password:\"
        send \"${__params['sa-pwd']}\r\"
        expect eof" || {
            logger.error --message \
                'Failed to configure SQL Server'
            return 1
        }

    }

    provision.mssql_base.addPpa() {
        provision.require 'software-properties-common'  || {
            logger.error --message \
                'Failed to apt utilis software-properties-common'
                return 1
        }
        provision.isPpaInstalled 'mssql-server' && {
            return 0
        }

        provision.require 'curl' || {
            logger.error --message \
                'Failed to install curl'
                return 1
        }
        export DEBIAN_FRONTEND=noninteractive && \
            curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - && \
            sudo add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server.list)" \
        || {
            logger.error --message \
                'Failed to add SQL Server ppa'
            return 1
        }

        sudo apt-get update || {
            logger.error --message \
                'Failed update apt-cache'
            return 1
        }
        return 0
    }
}
