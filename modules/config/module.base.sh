import.require 'params'
import.require 'string'

config_base.init() {
    config_base.__init() {
        import.useModule 'string'
        import.useModule 'params'
    }
    config_base.readValue() {
        local -A __params
		__params['filepath']='' # Full path to the config file
        __params['name']='' # The name of the config variable
        __params['return']='' # The return variable from the caller
        __params['default']= # Value returned if the config variable is empty
		__params['fail_if_empty']='1' # Fail if the var is empty
        # The path to begin the search from, defaults to the path of the caller
        __params['from']="$(dirname $(readlink -f "${BASH_SOURCE[2]}"))"
		params.get "$@"

        if [ ! -f "${__params['filepath']}" ]; then
            echo "Could not find the config file at \"${__params['filepath']}\""
            return 1
        fi

		# Read the config file, excluding lines that begin with a #
        local __config_val=$(grep -v '^#' "${__params['filepath']}" \
            | grep "^${__params['name']}=" \
            | head -n 1 \
			| sed "s/^${__params['name']}=//")

		# Fail if there is no default set and the variable was not found
		if [ -z "${__params['default']}" ] \
				&& [ -z "${__config_val}" ] \
				&& [ "${__params['fail_if_empty']}" == '1' ]; then
			return 1
		fi

		if [ -z "${__config_val}" ]; then
			__config_val="${__params['default']}"
		fi

		string.return_value "${__config_val}" ${__params['return']}
        return 0
	}
}
