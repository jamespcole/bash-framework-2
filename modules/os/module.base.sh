#!/usr/bin/env bash
# This is an example of inclduing the params module.
# Place require module calls at the top of the file.
import.require 'params'
os_base.init() {
    # Uncomment __init and put the declaration of any globals your module uses here.
    # Also initiliase any required modules.  If not required you can remove it.
    os_base.__init() {
        declare -g -A __OS
        __OS['FAMILY']="$(uname -s)"
        if [ -e /etc/os-release ]; then
            eval $(sed "s/^/__OS['&/" /etc/os-release | sed "s/=/']=/")
        fi

        import.useModule 'params'
    }
    os_base.is() {
        local __prop="$1"
        local __prop_val="$2"
        if [[ ${__OS["${__prop}"]+exists} ]]; then
            if [ "${__OS[${__prop}]}" == "$__prop_val" ]; then
                return 0
            else
                return 1
            fi
        else
            return 2
        fi
    }
    os_base.family() {
        local -A __params
        __params['return']='' # The return variable from the caller
        params.get "$@"
        local __os_family
        __os_family="$(uname -s)"
        string.return_value "${__os_family}" ${__params['return']}
    }
}
