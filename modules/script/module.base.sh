#!/usr/bin/env bash
import.require 'params'
script_base.init() {
    script_base.__init() {
		import.useModule 'params'
	}
    script_base.exitWithError() {
        logger.error --message \
            "An error occurred:"
        if [ ! -z "$1" ]; then
            logger.error --message \
                "$1"
        fi
        exit 1
	}
    script_base.exitWithWarning() {
        logger.warning --message \
            "Warning:"
        if [ ! -z "$1" ]; then
            logger.warning --message \
                "$1"
        fi
        exit 0
    }
    script_base.exitSuccess() {
        logger.success --message \
            "Finished:"
        if [ ! -z "$1" ]; then
            logger.success --message \
                "$1"
        fi
        exit 0
    }
    script_base.tryCommand() {
        local -A __params
        __params['command']=
        __params['retries']=1
        params.get "$@"
        local __try_count=0
        while [ "$__try_count" -lt "${__params['retries']}" ]; do
            ${__params['command']} && {
                return "$?"
            }
            logger.warning --message \
                "Running command \"${__params['command']}\" failed, retrying..."
            let __try_count=__try_count+1
        done
        return 1
    }
}
