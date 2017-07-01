#!/usr/bin/env bash
import.require 'params'
import.require 'string'

interactive_base.init() {
    interactive_base.__init() {
        import.useModule 'params'
        import.useModule 'string'
    }
    interactive_base.askQuestion() {
        local -A __params
        __params['question']=''
        __params['return']=''
		params.get "$@"
        echo "${__params['question']}"
        local __response
        read __response
        string.return_value "$__response" ${__params['return']}
    }
    interactive_base.tell() {
        local -A __params
        __params['message']=''
        params.get "$@"
        echo "${__params['message']}"
    }
    interactive_base.clear() {
        clear
    }
    interactive_base.pause() {
        echo "Hit [Enter] to continue..."
        read
    }
    interactive_base.fillParam() {
        local -A __params
        __params['arg-key']=''
        __params['return']=''
        params.get "$@"
        local __p_arg_key="${__params['arg-key']}"
        if [ "${__args_VALS[${__p_arg_key}>>specified]}" == '1' ]; then
            string.return_value "${__args_VALS[$__p_arg_key]}" ${__params['return']}
            return 0
        else
            return 1
        fi
    }
    interactive_base.choose() {
        local -A __params
        __params['options']=''
        __params['return']=''
        params.get "$@"
        local __options_arr
        readarray __options_arr < <(echo "${__params['options']}")
        local __count=1
        local __option
        for __option in "${__options_arr[@]}"; do
            echo -n "${__count}. ${__option}"
            let __count=__count+1
        done
        echo "Enter option number:"

        local __response
        read __response
        local __idx=$(( $__response - 1 ))
        __response=$(echo -n "${__options_arr[$__idx]}")
        string.return_value "$__response" ${__params['return']}
    }
}
