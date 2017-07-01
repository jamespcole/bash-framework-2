#!/usr/bin/env bash
apport_base.init() {
    apport_base.disable() {
        logger.info --message \
            'Disabling apport...' \
            --verbosity 3
        if [ ! -f '/etc/default/apport' ]; then
            logger.warning --message \
                'Did not find an apport config at "/etc/default/apport"'
            return 0
        fi
        if [ "$(grep '^enabled=1$' '/etc/default/apport' | wc -l)" == '1' ]; then
            sudo sed -i 's/^enabled=1$/enabled=0/' '/etc/default/apport' || {
                logger.error --message \
                    'Failed to disable apport'
                    return 1
            }
            return 0
        else
            logger.info --message \
                'Apport already disabled' \
                --verbosity 3
                return 0
        fi
    }
}
