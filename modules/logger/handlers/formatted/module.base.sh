import.require 'params'

logger.handlers.formatted_base.init() {
	logger.handlers.formatted_base.__init() {
        declare -A -g __logger_formatted_SETTINGS
        __logger_formatted_SETTINGS['print_prefix']='1'
		import.useModule 'params'
	}
    logger.handlers.formatted_base.create() {
        local -A __params
		params.get "$@"
        local __key="${__params['id']}>>"
        local __param
		for __param in "${!__params[@]}"; do
            local __p_key="${__key}${__param}"
            __logger_formatted_SETTINGS["${__p_key}"]="${__params[$__param]}"
		done
    }
    logger.handlers.formatted_base.processStartupArgs() {
        if [ "${__args_VALS['logger_decoration']}" -gt 1 ]; then
            __logger_formatted_SETTINGS['print_prefix']='0'
        fi
    }
    logger.handlers.formatted_base.printCommandStart() {
        logger.handlers.formatted_base.print \
            --message "Starting..." \
			--prefix 'SCRIPT'
    }
    logger.handlers.formatted_base.printCommandEnd() {
        logger.handlers.formatted_base.print \
            --message "Finished" \
			--prefix 'SCRIPT'
    }
    logger.handlers.formatted_base.debug() {
		local -A __params
		__params['message']=''
		params.get "$@"
		logger.handlers.formatted_base.print --message "${__params['message']}" \
			--prefix 'DEBUG'
	}
	logger.handlers.formatted_base.info() {
		local -A __params
		__params['message']=''
		params.get "$@"
		logger.handlers.formatted_base.print --message "${__params['message']}" \
			--prefix 'INFO'
	}
	logger.handlers.formatted_base.success() {
		local -A __params
		__params['message']=''
		params.get "$@"
		logger.handlers.formatted_base.print --message "${__params['message']}" \
			--prefix 'SUCCESS'
	}
	logger.handlers.formatted_base.warning() {
		local -A __params
		__params['message']=''
		params.get "$@"
		logger.handlers.formatted_base.print --message "${__params['message']}" \
			--prefix 'WARNING'
	}
	logger.handlers.formatted_base.error() {
		local -A __params
		__params['message']=''
		params.get "$@"
		logger.handlers.formatted_base.print --message "${__params['message']}" \
			--prefix 'ERROR'
	}
    logger.handlers.formatted_base.beginTask() {
        local -A __params
		__params['message']=''
        __params['title']=''
		params.get "$@"

        logger.handlers.formatted_base.print \
            --message \
            "BEGIN ${__params['title']} - ${__params['message']}" \
            --prefix 'TASK'
	}
    logger.handlers.formatted_base.endTask() {
        local -A __params
		__params['message']=''
        __params['title']=''
        __params['success']=''
		params.get "$@"

        logger.handlers.formatted_base.print \
            --message \
            "END ${__params['title']} - ${__params['message']}" \
            --prefix 'TASK'
	}
    logger.handlers.formatted_base.step() {
        local -A __params
		__params['message']=''
        __params['number']=0
        __params['total']=0
		params.get "$@"
        logger.handlers.formatted_base.print \
            --message "${__params['number']}/${__params['total']} - ${__params['message']}"
	}
    logger.handlers.formatted_base.printLoop() {
        # __logger_fancy_SETTINGS['in-loop']='1'
        local __line
        local __is_loading='0'
        while read __line; do
            echo "$__line"
        done
    }
	logger.handlers.formatted_base.print() {
		local -A __params
		__params['message']=''
		__params['prefix']=''
		params.get "$@"

		local __log_line
		echo -e "${__params['message']}" | fmt -w 120 -s | while read  __log_line; do
            if [ "${__logger_formatted_SETTINGS['print_prefix']}" == '0' ]; then
                echo -e "${__log_line}"
            else
                echo -e "${__params['prefix']}: ${__log_line}"
            fi
		done
	}
    logger.handlers.formatted_base.supportsMarkup() {
        return 1
    }
}
