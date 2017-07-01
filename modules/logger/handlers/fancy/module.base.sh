#!/usr/bin/env bash
import.require 'params'
import.require 'textprint'

logger.handlers.fancy_base.init() {
	logger.handlers.fancy_base.__init() {
		import.useModule 'params'
        import.useModule 'textprint'
        declare -A -g __logger_fancy_SETTINGS
        __logger_fancy_SETTINGS['width']=140
        __logger_fancy_SETTINGS['divider']=$(echo -en "${__chars_BOX['THIN_NS']} ")

        local __s="$(echo -en ${__chars_BOX['THIN_EW']})"
        local __step_line="$(echo -en ${__chars_BOX['THIN_NE']})${__s}${__s}${__s}${__s}${__s}${__s}${__s}${__s}${__s}$(echo -en ${__chars_FIG['TRI_THIN_RIGHT']})"
        __logger_fancy_SETTINGS['step_line']="$__step_line"
		# Pre caching these make output a lot faster, so the moustache templates are pre-compiled here
        __logger_fancy_SETTINGS['INFO_prefix']=$(textprint.print --text "{{#textprint.info}}$(echo -en ${__chars_FIG['INFO_ROUND']}) INFO{{/textprint.info}}      ")
        __logger_fancy_SETTINGS['ERROR_prefix']=$(textprint.print --text "{{#textprint.danger}}$(echo -en ${__chars_FIG['SKULL']}) ERROR{{/textprint.danger}}     ")
        __logger_fancy_SETTINGS['WARNING_prefix']=$(textprint.print --text "{{#textprint.warning}}$(echo -en ${__chars_FIG['WARN']}) WARNING{{/textprint.warning}}   ")
        __logger_fancy_SETTINGS['SUCCESS_prefix']=$(textprint.print --text "{{#textprint.success}}$(echo -en ${__chars_FIG['TICK']}) SUCCESS{{/textprint.success}}   ")
        __logger_fancy_SETTINGS['DEBUG_prefix']=$(textprint.print --text "{{#textprint.debug}}$(echo -en ${__chars_FIG['POINT_RIGHT']}) DEBUG{{/textprint.debug}}     ")
        __logger_fancy_SETTINGS['LOADING_prefix']=$(textprint.print --text "{{#textprint.loading}}$(echo -en ${__chars_FIG['CLOCK']}) WORKING{{/textprint.loading}}   ")
        __logger_fancy_SETTINGS['TASK_prefix']=$(textprint.print --text "{{#textprint.info}}$(echo -en ${__chars_FIG['STAR']}) TASK{{/textprint.info}}      ")
        __logger_fancy_SETTINGS['STEP_prefix']=$(textprint.print --text "{{#textprint.info}}${__step_line} {{/textprint.info}}")

        __logger_fancy_SETTINGS['LOADING_char']=$(echo -en "${__chars_FIG['SMALL_CIRCLE']}")
	}
    logger.handlers.fancy_base.create() {
		local -A __params
		params.get "$@"
        local __key="${__params['id']}>>"
        local __param
		for __param in "${!__params[@]}"; do
            local __p_key="${__key}${__param}"
            __logger_fancy_SETTINGS["${__p_key}"]="${__params[$__param]}"
		done
    }
    logger.handlers.fancy_base.processStartupArgs() {
        if [ "${__args_VALS['logger_monochrome>>specified']}" == '1' ]; then
            local __s="$(echo -en ${__chars_BOX['THIN_EW']})"
            __logger_fancy_SETTINGS['INFO_prefix']=$(textprint.print --text "$(echo -en ${__chars_FIG['INFO_ROUND']}) INFO      ")
            __logger_fancy_SETTINGS['ERROR_prefix']=$(textprint.print --text "$(echo -en ${__chars_FIG['SKULL']}) ERROR     ")
            __logger_fancy_SETTINGS['WARNING_prefix']=$(textprint.print --text "$(echo -en ${__chars_FIG['WARN']}) WARNING   ")
            __logger_fancy_SETTINGS['SUCCESS_prefix']=$(textprint.print --text "$(echo -en ${__chars_FIG['TICK']}) SUCCESS   ")
            __logger_fancy_SETTINGS['DEBUG_prefix']=$(textprint.print --text "$(echo -en ${__chars_FIG['POINT_RIGHT']}) DEBUG     ")
            __logger_fancy_SETTINGS['LOADING_prefix']=$(textprint.print --text "$(echo -en ${__chars_FIG['CLOCK']}) WORKING   ")
            __logger_fancy_SETTINGS['TASK_prefix']=$(textprint.print --text "$(echo -en ${__chars_FIG['STAR']}) TASK      ")
            __logger_fancy_SETTINGS['STEP_prefix']=$(textprint.print --text "${__logger_fancy_SETTINGS['step_line']} ")
        fi
        
        if [ "${__logger_SETTINGS['decor']}" -gt 1 ] || [ "${__logger_SETTINGS['hide-prefix']}" == '1' ]; then
            __logger_fancy_SETTINGS['INFO_prefix']=''
            __logger_fancy_SETTINGS['ERROR_prefix']=''
            __logger_fancy_SETTINGS['WARNING_prefix']=''
            __logger_fancy_SETTINGS['SUCCESS_prefix']=''
            __logger_fancy_SETTINGS['DEBUG_prefix']=''
            __logger_fancy_SETTINGS['LOADING_prefix']=''
            __logger_fancy_SETTINGS['TASK_prefix']=''
            __logger_fancy_SETTINGS['STEP_prefix']=''
        fi

    }
    logger.handlers.fancy_base.printCommandStart() {
        local __top_line
        string.padding __top_line "${__chars_BOX['DBL_EW']}" "${__logger_fancy_SETTINGS['width']}"
        __top_line="{{#textprint.border}}${__top_line}{{/textprint.border}}"
        logger.handlers.fancy_base.print \
            --message "${__top_line}"
        logger.handlers.fancy_base.print \
            --message "{{#textprint.info}}{{#textprint.b}}${0##*/}{{/textprint.b}}{{/textprint.info}}"
        logger.handlers.fancy_base.print \
            --message "${__top_line}"
    }
    logger.handlers.fancy_base.printCommandEnd() {
        local -A __params
		__params['exit-status']=''
		params.get "$@"
        local __top_line
        string.padding __top_line "${__chars_BOX['THIN_EW']}" "${__logger_fancy_SETTINGS['width']}"

        __top_line="{{#textprint.border}}${__top_line}{{/textprint.border}}"

        logger.handlers.fancy_base.print \
            --message "${__top_line}"

        local __end_time=$(date +%s%3N)
        local __ex_time_ms=$(($__end_time - ${__bootstrap_SETTINGS['script-start-ms']}))

        logger.handlers.fancy.info \
            --message "Completed in ${__ex_time_ms}ms"

        if [ "${__params['exit-status']}" == '0' ]; then
            logger.handlers.fancy.success \
                --message "Finished"
        else
            logger.handlers.fancy.error \
                --message "{{#textprint.danger}}Finished with errors!{{/textprint.danger}}"
        fi

        logger.handlers.fancy_base.print \
            --message "${__top_line}"
    }
    logger.handlers.fancy_base.debug() {
		local -A __params
		__params['message']=''
		params.get "$@"
		logger.handlers.fancy_base.print --message "${__params['message']}" \
			--prefix 'DEBUG'
	}
	logger.handlers.fancy_base.info() {
		local -A __params
		__params['message']=''
		params.get "$@"
		logger.handlers.fancy_base.print --message "${__params['message']}" \
			--prefix 'INFO' \
            --icon 'icon_info' \
            --wrap 'info'
	}
	logger.handlers.fancy_base.success() {
		local -A __params
		__params['message']=''
		params.get "$@"
		logger.handlers.fancy_base.print --message "${__params['message']}" \
			--prefix 'SUCCESS' \
            --wrap 'success' \
            --icon 'icon_success'
	}
	logger.handlers.fancy_base.warning() {
		local -A __params
		__params['message']=''
		params.get "$@"
		logger.handlers.fancy_base.print --message "${__params['message']}" \
			--prefix 'WARNING' \
            --wrap 'warning' \
            --icon 'icon_warning'
	}
	logger.handlers.fancy_base.error() {
		local -A __params
		__params['message']=''
		params.get "$@"
        if [ "${__logger_fancy_SETTINGS['is_loading']}" == '1' ]; then
            textprint.print --text \
                "{{#textprint.danger}}$(echo -en ${__chars_FIG['SKLL_N_CB']}){{/textprint.danger}}"
            __logger_fancy_SETTINGS['is_loading']=0
            echo ""
        fi
		logger.handlers.fancy_base.print --message "${__params['message']}" \
			--prefix 'ERROR'
	}
    logger.handlers.fancy_base.beginTask() {
        local -A __params
		__params['message']=''
        __params['title']=''
		params.get "$@"

        logger.handlers.fancy_base.print \
            --prefix 'TASK' \
            --message \
            "{{#textprint.info}}{{#textprint.b}}BEGIN ${__params['title']}{{/textprint.b}} - ${__params['message']}{{/textprint.info}}"

	}
    logger.handlers.fancy_base.endTask() {
        local -A __params
		__params['message']=''
        __params['title']=''
        __params['success']=''
		params.get "$@"

        logger.handlers.fancy_base.print \
            --prefix 'TASK' \
            --message \
            "{{#textprint.info}}{{#textprint.b}}END ${__params['title']}{{/textprint.b}} - ${__params['message']}{{/textprint.info}}"

	}
    logger.handlers.fancy_base.step() {
        local -A __params
		__params['message']=''
        __params['number']=0
        __params['total']=0
		params.get "$@"
        local __s="$(echo -en ${__chars_BOX['THIN_EW']})"
        logger.handlers.fancy_base.print \
            --prefix 'STEP' \
            --message "{{#textprint.info}}{{#textprint.b}}STEP ${__params['number']}/${__params['total']}{{/textprint.b}} - ${__params['message']}{{/textprint.info}}"
	}
    logger.handlers.fancy_base.printLoop() {
        __logger_SETTINGS['in-loop']='1'
        local __line
        local __is_loading='0'
        __logger_fancy_SETTINGS['is_loading']='0'
        while read __line; do

            local __msg="$__line"
            local __passed_pfx=''
            local __msg_type=''
            if [ "${__line::2}" == '@!' ]; then
                __msg=${__line##*!@}
                local __parm=${__line%!@*}
                __msg_type=${__line%@!*}
                __msg_type=${__msg_type/!@/}
                __msg_type=${__msg_type/@!/}
                __passed_pfx=${__parm##*@!}
            fi

            if [ "$__msg_type" == '' ]; then
                if [ "${__args_VALS['logger_verbose>>specified']}" == '1' ] \
					|| [ "${__logger_SETTINGS['force-verbose']}" == '1' ]; then
                    logger.handlers.fancy.print --message \
                        "${__line}" \
                        --from-loop 1 \
                        --prefix "LOADING"
                else
                    if [ "$__is_loading" == '0' ]; then
                        logger.handlers.fancy.print --message \
                            "${__logger_fancy_SETTINGS['LOADING_char']} " \
                            --from-loop 1 \
                            --prefix "LOADING" \
                            --newline 0
                    fi
                    __is_loading='1'
                    __logger_fancy_SETTINGS['is_loading']='1'

                    echo -n "${__logger_fancy_SETTINGS['LOADING_char']} "
                fi
            else
                if [ "$__is_loading" == '1' ]; then
                    textprint.print --text \
                        "{{#textprint.success}}$(echo -en ${__chars_FIG['TICK']}){{/textprint.success}}"
                    __is_loading='0'
                    __logger_fancy_SETTINGS['is_loading']='0'
                    echo ""
                fi
                logger.handlers.fancy.print --message \
                    "${__msg}" \
                    --from-loop 1 \
                    --full-prefix "$__passed_pfx"

            fi
        done
        local __return_value="$?"
        if [ "${__logger_fancy_SETTINGS['is_loading']}" == '1' ]; then
            echo ""
        fi
        __logger_SETTINGS['in-loop']='0'
        return "$__return_value"
    }
    logger.handlers.fancy_base.print() {
		local -A __params
		__params['message']=''
		__params['prefix']=''
        __params['from-loop']='0'
        __params['full-prefix']=''
        __params['newline']='1'
		params.get "$@"

        local __print_pref='1'
        if [ "${__logger_SETTINGS['in-loop']}" == '1' ] \
            && [ "${__params['from-loop']}" == '0' ];
        then
            __print_pref='0'
        fi

        local __text="${__params['message']}"
        local __coloured=$(textprint.printLine --text "${__text}")

        local __full_prefix="${__wrap_start}${__icon}${__padded_prefix}${__wrap_end}${__divider}"
        if [ "${__params['full-prefix']}" != '' ]; then
            __full_prefix="${__params['full-prefix']}"
        fi

        if [ "${__print_pref}" == '1' ]; then
            if [[ "${__logger_fancy_SETTINGS[${__params['prefix']}_prefix]+exists}" ]]; then
                echo -n "${__logger_fancy_SETTINGS[${__params['prefix']}_prefix]}"
            else
                textprint.print --text \
                    "${__full_prefix}"
            fi
        else
            echo -n "@!${__params['prefix']}!@ @!${__logger_fancy_SETTINGS[${__params['prefix']}_prefix]}!@"
        fi

        if [ "${__params['newline']}" == '1' ]; then
            # echo -n " ${#__coloured} "
            # local __test=$( echo -n "${__coloured}" | sed "s|e*.${END}\[[0-9;]*[m|K]||g" )
            #
            # echo -n " ${#__test} "

            echo "${__coloured}"
        else
            echo -n "${__coloured}"
        fi

        # This is a gold sed, it removes all print chars
        # logger_demo | sed "s|e*.${END}\[[0-9;]*[m|K]||g"

        # sed s/\\[[:cntrl:]]/\\033[\\e/g

	}
    logger.handlers.fancy_base.supportsMarkup() {
        # Remember 0 means success in bash
        return 0
    }
}
