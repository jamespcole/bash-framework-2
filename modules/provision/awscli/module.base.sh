#!/usr/bin/env bash
import.require 'provision'
provision.awscli_base.init() {
    provision.awscli_base.__init() {
          import.useModule 'provision'
    }
    provision.awscli_base.require() {
        local -A __params
        __params['source']='pip' # pip, apt

        if [ "${__params['source']}" == 'pip' ]; then
            if ! provision.isInstalled 'aws'; then
                pip install awscli
                return $?
            fi
        elif [ "${__params['source']}" == 'apt' ]; then
            if ! provision.isInstalled 'aws'; then
                sudo apt-get install -y awscli
            fi
        else
            logger.error --message \
                "Unknown souce \"${__params['source']}\"for awscli installation"
        fi
        return 0
    }
}
