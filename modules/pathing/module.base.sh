import.require 'params'
import.require 'string'

pathing_base.init() {
    pathing_base.__init() {
        import.useModule 'string'
        import.useModule 'params'
    }
    pathing_base.closestParentFile() {
        local -A __params
		__params['filename']='' # Filename to search for
        __params['return']='' # The return variable from the caller
        # The path to begin the search from, defaults to the path of the caller
        __params['from']="$(dirname $(readlink -f "${BASH_SOURCE[2]}"))"
		params.get "$@"

        local __pathing_cur_dir="${__params['from']}"
        while [[ "$__pathing_cur_dir" != / ]] ; do
            local __pathing_search_res=$(find "$__pathing_cur_dir"/ \
                -maxdepth 1 \
                -name "${__params['filename']}")
            if [ ! "$__pathing_search_res" == "" ]; then
            	string.return_value "$__pathing_cur_dir" ${__params['return']}
                return 0
            fi
            __pathing_cur_dir=$(readlink -f "${__pathing_cur_dir}/..")
        done
        return 1
	}
}
