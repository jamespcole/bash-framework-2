# This is an example of inclduing the params module.
# Place require module calls at the top of the file.
import.require 'params'
import.require 'string'
colour_base.init() {
    # Uncomment __init and put the declaration of any globals your module uses here.
    # Also initiliase any required modules.  If not required you can remove it.
    colour_base.__init() {
        declare -g -A __my_global_arr
        import.useModule 'params'
        import.useModule 'string'
    }
    colour_base.fromHex() {
        local -A __params
        __params['hex-val']=
        __params['return']='' # The return variable from the caller
		params.get "$@"
        # Source:
        # http://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes
        local __passed_hex="${__params['hex-val']}"
        local __tput_val
        local hex=${__passed_hex#"#"}
        local r=$(printf '0x%0.2s' "$hex")
        local g=$(printf '0x%0.2s' ${hex#??})
        local b=$(printf '0x%0.2s' ${hex#????})
        __tput_val=$(printf '%03d' "$(( (r<75?0:(r-35)/40)*6*6 +
                           (g<75?0:(g-35)/40)*6   +
                           (b<75?0:(b-35)/40)     + 16 ))")
        if [ "${__tput_val::1}" == '0' ]; then
            __tput_val="${__tput_val:1}"
        fi
        string.return_value "${__tput_val}" ${__params['return']}
    }
}
