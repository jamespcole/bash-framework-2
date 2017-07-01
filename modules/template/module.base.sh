import.require 'params'
import.require 'string'
vendor.wrap 'mo/mo' 'vendor.include.mo'

template_base.init() {
    template_base.__init() {
        import.useModule 'string'
        import.useModule 'params'
        vendor.include.mo
    }
    template_base.includeFile() {
        local __file_path=$(echo -e "${1}" | mo)
		echo -e "$(cat ${__file_path})"
        local -A __params
		__params['filepath']='' # Full path to the template file
        __params['name']='' # The name of the template variable
        __params['return']='' # The return variable from the caller
        __params['default']= # Value returned if the template variable is empty
		__params['fail_if_empty']='1' # Fail if the var is empty
        # The path to begin the search from, defaults to the path of the caller
        __params['from']="$(dirname $(readlink -f "${BASH_SOURCE[2]}"))"
		params.get "$@"
	}
    template_base.insertOutput() {
        local __content="$1"
        local __cmd
        __cmd=$(echo "${__content}" | mo)
        echo "command = $__cmd"
        local __cmd_output
        __cmd_output=$(eval "$__cmd")
        echo "$__cmd_output"
    }
    template_base.stripNonPrintable() {
        echo "$1" | sed "s|e*.${END}\[[0-9;]*[m|K]||g" | sed "s|(B||g"
    }
}
