#!/usr/bin/env bash
import.require 'provision'
import.require 'provision.curl'
provision.mssql.sqlcmd_base.init() {
    provision.mssql.sqlcmd_base.__init() {
          import.useModule 'provision'
          import.useModule 'provision.curl'
    }
    provision.mssql.sqlcmd_base.require() {
        if provision.isInstalled 'sqlcmd'; then
            return 0
        fi
        provision.mssql.sqlcmd.addPpa  || {
            logger.error --message \
                'Failed to install sqlcmd'
            return 1
        }

        sudo ACCEPT_EULA='Y' apt-get install -y  mssql-tools unixodbc-dev \
        || {
            logger.error --message \
                'Failed to install sqlcmd'
            return 1
        }

        return 0
    }

    provision.mssql.sqlcmd_base.addToBashRc() {
        local showAddedInfo=false
        # [ -f "/home/${USER}/.bash_profile" ] && grep -q '^export PATH="$PATH:/opt/mssql-tools/bin"' "/home/${USER}/.bash_profile" || {
        #     echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> "/home/${USER}/.bash_profile"
        #     showAddedInfo=true
        # }

        [ -f "/home/${USER}/.bashrc" ] && grep -q '^export PATH="$PATH:/opt/mssql-tools/bin"' "/home/${USER}/.bashrc" || {
            echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> "/home/${USER}/.bashrc"
            showAddedInfo=true
        }

        "${showAddedInfo}" && {
            logger.warning --message \
                'sqlcmd has been added to your path but you will need to run "source ~/.bashrc" manually to use it within your current session'
        }
        return 0
    }

    provision.mssql.sqlcmd_base.addPpa() {
        provision.require 'software-properties-common'  || {
            logger.error --message \
                'Failed to apt utilis software-properties-common'
                return 1
        }
        provision.isPpaInstalled 'https://packages.microsoft.com/.*/prod' && {
            return 0
        }

        provision.require 'curl' || {
            logger.error --message \
                'Failed to install curl'
                return 1
        }

        curl 'https://packages.microsoft.com/keys/microsoft.asc' | sudo apt-key add - || {
            logger.error --message \
                'Failed to add key for sqlcmd ppa'
            return 1
        }

        sudo add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list)" || {
            logger.error --message \
                'Failed to add sqlcmd ppa'
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
