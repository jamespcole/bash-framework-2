#!/usr/bin/env bash
import.require 'provision'
import.require 'provision.ruby'
provision.mailcatcher_base.init() {
    provision.mailcatcher_base.__init() {
          import.useModule 'provision'
          import.useModule 'provision.ruby'
    }
    provision.mailcatcher_base.require() {
        if ! provision.isInstalled 'mailcatcher'; then
            provision.require 'ruby' || {
                logger.error --message \
                    'Failed to install ruby requirement for mailcatcher'
                    return 1
            }
            gem install mailcatcher
            return $?
        fi
        return 0
    }

    provision.mailcatcher_base.startOnBoot() {
        sudo bash -c 'echo "@reboot root $(which mailcatcher) --ip=0.0.0.0" >> /etc/crontab'
        sudo update-rc.d cron defaults
        return "$?"
    }

    provision.mailcatcher_base.makePhpUseMailCatcher() {
        sudo bash -c 'echo "sendmail_path = /usr/bin/env catchmail -f www-data@localhost" >> /etc/php/7.0/mods-available/mailcatcher.ini'
        sudo phpenmod mailcatcher
        return "$?"
    }

    provision.mailcatcher_base.startMailCatcher() {
        logger.info \
            --message 'Starting mailcatcher...' \
        sudo service nginx restart
        /usr/bin/env $(which mailcatcher) --ip=0.0.0.0

        return "$?"
    }
}
