#!/usr/bin/env bash
import.require 'provision'
import.require 'params'
provision.postgres_base.init() {
    provision.postgres_base.__init() {
          import.useModule 'provision'
          import.useModule 'params'
    }
    provision.postgres_base.require() {
        if ! provision.isPackageInstalled 'postgresql'; then
          sudo apt-get install -y postgresql postgresql-contrib
          return $?
        fi
        return 0
    }
    provision.postgres_base.addUser() {
        declare -A __params
        __params['username']="$USER"
        __params['pwd']=''
        params.get "$@"

        local __new_uname="${__params['username']}"

        if provision.postgres.userExists "${__new_uname}"; then
            logger.warning --message \
                "The postgres db user \"${__new_uname}\" already exists."
            return 0
        fi
        sudo -u postgres \
            psql -c \
            "CREATE USER ${__new_uname} WITH PASSWORD '${__params['pwd']}';" \
        || {
            logger.error --message \
                "Could not create postgres db user \"${__new_uname}\"."
            return 1
        }
        logger.info --message \
            "Created postgres db user \"${__new_uname}\"."
        return 0
    }

    provision.postgres_base.userExists() {
        local __username="$1"
        local __userExists=''
        __userExists=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${__username}'")
        if [ "${__userExists}" == '1' ]; then
            return 0
        fi
        return 1
    }

    provision.postgres_base.requireDb() {
        declare -A __params
        __params['owner']="$USER"
        __params['db-name']=''
        params.get "$@"

        local __dbname="${__params['db-name']}"
        local __dbowner="${__params['owner']}"
        logger.info --message \
            "Creating postgres db \"${__dbname}\" with owner \"${__dbowner}\"."

        sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname = '${__dbname}'" \
            | grep -q 1 \
            || sudo -u postgres createdb -O "${__dbowner}" "${__dbname}"
            # psql -c "CREATE DATABASE ${__dbname}"

        return "$?"
    }

    provision.postgres_base.dbExists() {
        declare -A __params
        __params['owner']="$USER"
        __params['db-name']=''
        params.get "$@"

        local __dbname="${__params['db-name']}"
        local __dbowner="${__params['owner']}"
        logger.info --message \
            "Checking if postgres db \"${__dbname}\" exists."

        sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname = '${__dbname}'" \
            | grep -q 1 \

        return "$?"
    }

    provision.postgres_base.enableQueryLog() {
        logger.info \
            --message 'Enabling verbose dev mode logging for postgres...'

        local __pgres_conf='/etc/postgresql/9.5/main/postgresql.conf'
        sudo sed -i 's/#logging_collector = off/logging_collector = on/' "${__pgres_conf}"
        sudo sed -i 's/#log_directory = /log_directory = /' "${__pgres_conf}"
        sudo sed -i "s/#log_filename = .*/log_filename = 'postgresql.log'/" "${__pgres_conf}"
        sudo sed -i "s/#log_statement = 'none'/log_statement = 'all'/" "${__pgres_conf}"
        sudo sed -i "s/#logging_collector = off/logging_collector = on/" "${__pgres_conf}"
        sudo sed -i "s/#log_file_mode = 0600/log_file_mode = 0666/" "${__pgres_conf}"
        sudo sed -i "s/#log_rotation_age = /log_rotation_age = /" "${__pgres_conf}"

        sudo systemctl try-restart postgresql.service
        # The log will be here /var/lib/postgresql/9.5/main/pg_log
    }
}
