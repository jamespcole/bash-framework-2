#!/usr/bin/env bash
# This is an example of inclduing the params module.
# Place require module calls at the top of the file.
import.require 'params'
os.time_base.init() {
    os.time_base.__init() {
        import.useModule 'params'
    }
    os.time_base.timeZoneString() {
        local -A __params
        __params['return']='' # The return variable from the caller
        params.get "$@"
        local __tz_str
        __tz_str="$(cat /etc/timezone)"
        string.return_value "${__tz_str}" ${__params['return']}
    }
    os.time_base.setTimeZoneString() {
        local -A __params
        __params['tz-string']=''
        params.get "$@"

        local __new_tz="${__params['tz-string']}"

        if [ "$(timedatectl list-timezones --no-pager | grep "${__params['tz-string']}" | wc -l)" == '0' ]; then
            logger.error --message \
                "The timezone \"${__new_tz}\" does not exist, run \"timedatectl list-timezones\" to see available values."
            return 1
        fi

        local __current_tz
        os.time.timeZoneString \
            --return __current_tz

        if [ "$__current_tz" == "$__new_tz" ]; then
            logger.info --verbosity 3 \
                --message "The current timezone is already \"${__new_tz}\""
            return 0
        fi
        logger.info --message \
            "Setting the current timezone to \"${__new_tz}\""

        sudo timedatectl set-timezone "${__new_tz}"
    }
}
