# This is an example of inclduing the params module"
# Place require module calls at the top of the file.
import.require 'params'
import.require 'string'
import.require 'colour'
import.require 'chars'
import.require 'provision.figlet'
vendor.wrap 'mo/mo' 'vendor.include.mo'
textprint_base.init() {
    textprint_base.__init() {
        declare -g -A __textprint_STATE
        __textprint_STATE['bold']=0
        __textprint_STATE['underline']=0
        __textprint_STATE['emphasis']=0
        __textprint_STATE['remove_nl']=0
        __textprint_STATE['nl_to_tab']=0
        __textprint_STATE['remove_tab']=0
        __textprint_STATE['fg_colour']=
        __textprint_STATE['bg_colour']=

        declare -g -A __textprint_SETTINGS
        __textprint_SETTINGS['props_changed']='0'

        declare -g -A __textprint_TAGS
        __textprint_TAGS['h1']='textprint.heading1'
        __textprint_TAGS['b']='textprint.bold'
        __textprint_TAGS['u']='textprint.underline'
        __textprint_TAGS['d']='textprint.dim'
        __textprint_TAGS['hr']='textprint.hr'
        __textprint_TAGS['danger']='textprint.red'
        __textprint_TAGS['info']='textprint.blue'
        __textprint_TAGS['warning']='textprint.orange'
        __textprint_TAGS['success']='textprint.green'
        __textprint_TAGS['icon_danger']='textprint.iconDanger'
        __textprint_TAGS['icon_info']='textprint.iconInfo'
        __textprint_TAGS['icon_warning']='textprint.iconWarning'
        __textprint_TAGS['icon_success']='textprint.iconSuccess'
        __textprint_TAGS['border']='textprint.border'
        __textprint_TAGS['in']='textprint.indent'
        __textprint_TAGS['ul']='textprint.list'
        __textprint_TAGS['li']='textprint.listItem'
        __textprint_TAGS['box']='textprint.box'
        __textprint_TAGS['figlet']='textprint.figlet'

        declare -g -A __textprint_THEMES
        # Force the chars module to load first
        import.useModule 'chars'
        vendor.include.mo
        textprint_base.defaultTheme
    }
    textprint_base.indent() {
        echo "$1" | sed 's/^/    &/'
    }
    textprint_base.list() {
        echo "$1" | sed 's/^./    &/'
    }
    textprint_base.listItem() {
        echo "$(echo -en ${__chars_FIG['SMALL_CIRCLE']}) $1"
    }
    textprint_base.box() {
        # Start the box on a new line
        echo ""

        local __longest
        # Get length without tags
        __longest=$(echo "$1" | sed -e 's/{{[^}}]*}}//g' | wc -L)
        local __div_width
        let __div_width=__longest+2
        local __top_line
        string.padding __top_line "${__chars_BOX['DBL_EW']}" "$__div_width"
        echo "$(echo -e ${__chars_BOX['DBL_SE']})${__top_line}$(echo -e ${__chars_BOX['DBL_SW']})"
        local __line_count
        __line_count=$(echo "$1" | wc -l)
        local __count=0
        local __txt_line
        while read -r __txt_line; do
            local __pdded
            local __no_tags
            __no_tags=$(echo "$__txt_line" | sed -e 's/{{[^}}]*}}//g')
            local __no_tags_len=${#__no_tags}
            local __padstr_len
            let __padstr_len=__longest-__no_tags_len

            string.padding __pdded ' ' "$__padstr_len"

            let __count=__count+1
            if [ "$__count" == "$__line_count" ] \
                && [ "$__txt_line" == '' ]
            then
                break;
            else
                echo "$(echo -e ${__chars_BOX['DBL_NS']}) ${__txt_line}${__pdded} $(echo -e ${__chars_BOX['DBL_NS']})"
            fi

        done <<< "$1"
        echo "$(echo -e ${__chars_BOX['DBL_NE']})${__top_line}$(echo -e ${__chars_BOX['DBL_NW']})"
    }
    textprint_base.heading1() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'bold' --state 1
        textprint_base.setProp --prop 'underline' --state 1
        textprint_base.setProp --prop 'fg_colour' --state 'blue'
        textprint_base.printLine --text "$1"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.heading2() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'bold' --state 1
        textprint_base.setProp --prop 'fg_colour' --state 'blue'
        textprint_base.printLine --text "$1"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.heading3() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'underline' --state 1
        textprint_base.setProp --prop 'fg_colour' --state 'blue'
        textprint_base.printLine --text "$1"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.figlet() {
        provision.require 'figlet' || {
            logger.warning 'Provision dependency "figlet" is not available in textprint'
        } > /dev/null
        figlet "$1"
    }
    textprint_base.dim() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'dim' --state 1
        textprint_base.print --text "$1"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.border() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'dim' --state 1
        textprint_base.print --text "$1"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.bold() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'bold' --state 1
        textprint_base.print --text "${1}"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.underline() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'underline' --state 1
        textprint_base.print --text "$1"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.emphasis() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'emphasis' --state 1
        textprint_base.print --text "${1}"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.red() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'fg_colour' --state 'red'
        textprint_base.print --text "$1"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.blue() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'fg_colour' --state 'blue'
        textprint_base.print --text "$1"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.lightBlue() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'fg_colour' --state 'light-blue'
        textprint_base.print --text "$1"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.cyan() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'fg_colour' --state 'cyan'
        textprint_base.print --text "$1"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.yellow() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'fg_colour' --state 'yellow'
        textprint_base.print --text "$1"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.green() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'fg_colour' --state 'green'
        textprint_base.print --text "$1"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.orange() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'fg_colour' --state 'orange'
        textprint_base.print --text "$1"
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.hr() {
        local __hr
        string.padding __hr '-' 80
        textprint_base.printLine --text "${__hr}"
    }
    textprint_base.fmt() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'remove_nl' --state 1
        textprint_base.setProp --prop 'remove_tab' --state 1

        textprint_base.print --text "$1"
        textprint_base.restoreState "${__prev_state}"

    }
    textprint_base.horiz() {
        local __hText=${1//$'\n'/$'\t'}
        __hText="$(echo "${__hText}" | sed -e 's/\t\+/\t/g')"
        textprint_base.print --text "${__hText}"
    }
    textprint_base.br() {
        local __prev_state
        textprint_base.getState __prev_state
        textprint_base.setProp --prop 'remove_nl' --state '0'
        textprint_base.print --text "" --nl 1
        textprint_base.restoreState "${__prev_state}"
    }
    textprint_base.iconDanger() {
        echo -en \
            "${__textprint_THEMES["default>>icon_danger"]}"
    }
    textprint_base.iconInfo() {
        echo -en \
            "${__textprint_THEMES["default>>icon_info"]}"
    }
    textprint_base.iconWarning() {
        echo -en \
            "${__textprint_THEMES["default>>icon_warning"]}"
    }
    textprint_base.iconSuccess() {
        echo -en \
            "${__textprint_THEMES["default>>icon_success"]}"
    }
    textprint_base.setProp() {
        local -A __params
        __params['prop']=
        __params['state']=
        params.get "$@"
        if [ "${__textprint_STATE[${__params['prop']}]}" == "${__params['state']}" ]; then
            return
        fi
        __textprint_STATE["${__params['prop']}"]="${__params['state']}"
        __textprint_SETTINGS['props_changed']='1'
    }
    textprint_base.setState() {
        __textprint_SETTINGS['props_changed']='0'

        if [ "${__args_VALS['logger_monochrome>>specified']}" == '1' ]; then
            return 0
        fi

        local __tkey='default>>'
        tput sgr0
        if [ "${__textprint_STATE['bold']}" == '1' ]; then
            tput bold
        fi
        if [ "${__textprint_STATE['dim']}" == '1' ]; then
            tput dim
        fi
        if [ "${__textprint_STATE['underline']}" == '1' ]; then
            tput smul
        else
            tput rmul
        fi
        if [ "${__textprint_STATE['emphasis']}" == '1' ]; then
            tput smso
        else
            tput rmso
        fi

        if [ "${__textprint_STATE['fg_colour']}" == 'red' ]; then
            tput setaf "${__textprint_THEMES[${__tkey}red]}"
        elif [ "${__textprint_STATE['fg_colour']}" == 'blue' ]; then
            tput setaf "${__textprint_THEMES[${__tkey}blue]}"
        elif [ "${__textprint_STATE['fg_colour']}" == 'yellow' ]; then
            tput setaf "${__textprint_THEMES[${__tkey}yellow]}"
        elif [ "${__textprint_STATE['fg_colour']}" == 'green' ]; then
            tput setaf "${__textprint_THEMES[${__tkey}green]}"
        elif [ "${__textprint_STATE['fg_colour']}" == 'orange' ]; then
            tput setaf "${__textprint_THEMES[${__tkey}orange]}"
        elif [ "${__textprint_STATE['fg_colour']}" == 'light-blue' ]; then
            tput setaf "${__textprint_THEMES[${__tkey}light-blue]}"
        elif [ "${__textprint_STATE['fg_colour']}" == 'cyan' ]; then
            tput setaf "${__textprint_THEMES[${__tkey}cyan]}"
        elif [ "${__textprint_STATE['fg_colour']}" == 'default' ]; then
            tput setaf "${__textprint_THEMES[${__tkey}default]}"
        fi
    }
    textprint_base.print() {
        local -A __params
        __params['text']=
        __params['nl']=0
        __params['block']=0
        params.get "$@"



        if [ "${__textprint_SETTINGS['props_changed']}" == '1' ]; then
            textprint.setState
        fi
        local __textp
        __textp="${__params['text']}"

        if [ "${__textprint_STATE['remove_nl']}" == '1' ] \
            && [ "${__params['block']}" != '1' ]
        then
            __textp=${__textp//$'\n'/}
        fi

        if [ "${__textprint_STATE['remove_tab']}" == '1' ]; then
            __textp=${__textp//$'\t'/}
        fi

        # if [ "${__textprint_STATE['nl_to_tab']}" == '1' ]; then
        #     __textp=${__textp//$'\n'/$'\t'}
        #     __textp="$(echo "${__textp}" | sed -e 's/\t\+/\t/g')"
        # fi

        if [ "${__params['block']}" == '1' ]; then
            echo ""
        fi

        textprint_base.moPrint "${__textp}"

        if [ "${__params['block']}" == '1' ]; then
            echo ""
        fi

        if [ "${__params['nl']}" == '1' ]; then
            echo ""
        fi
    }
    textprint_base.printLine() {
        textprint_base.print "$@" --nl 1
    }
    textprint_base.moPrint() {
        local IFS=$' \n\t'
        moParse "$1" "" false
    }
    textprint_base.moGetContent() {
        local content filename target
        target=$1
        local "$target" && moIndirect "$target" "$content"
    }
    textprint_base.getState() {
        local __ret_var=$1
        local __prev_state_data=$(declare -p __textprint_STATE)
        __prev_state_data=${__prev_state_data/-A/-A -g}
        string.return_value "$__prev_state_data" $__ret_var
    }
    textprint_base.restoreState() {
        eval "$1"
        textprint_base.setState
    }
    textprint_base.stripTags() {
        local __ret_var=$1
        local __text="$2"
        __text=$(echo "$__text" | sed -e 's/{{[^}}]*}}//g')
        string.return_value "$__text" $__ret_var
    }
    # textprint_base.preProcess() {
    #     local __ret_var=$1
    #     local __text="$2"

    #     if string.contains '{{#' "$__text" \
    #         || string.contains '{{/' "$__text" \
    #         || string.contains '}}' "$__text"
    #     then
    #         local __tag
    #         # local __not_empty=0
    #         for __tag in "${!__textprint_TAGS[@]}"; do
    #         # for __tag in "${__textprint_TAGS_ORDER[@]}"; do
    #             local __replacement="${__textprint_TAGS[$__tag]}"
    #             __text="${__text//\{\{\#"${__tag}"\}\}/\{|\{\#${__replacement}\}|\}}"
    #             __text="${__text//\{\{\/${__tag}\}\}/\{|\{\/${__replacement}\}|\}}"
    #             __text="${__text//\{\{${__tag}\}\}/\{|\{${__replacement}\}|\}}"

    #             if ! string.contains "{{" "${__text}"; then
    #                 if ! string.contains '}}' "$__text"; then
    #                     break;
    #                 fi
    #             fi
    # 		done
    #         __text="${__text//\{|\{/\{\{}"
    #         __text="${__text//\}\|\}/\}\}}"
    #     fi
    #     # echo "$__text"
    #     string.return_value "$__text" $__ret_var
    # }
    textprint_base.defaultTheme() {
        local __tkey='default>>'
        __textprint_THEMES["${__tkey}icon_danger"]="${__chars_FIG['SKULL']} "
        __textprint_THEMES["${__tkey}icon_info"]="${__chars_FIG['INFO_ROUND']} "
        __textprint_THEMES["${__tkey}icon_warning"]="${__chars_FIG['WARN']} "
        __textprint_THEMES["${__tkey}icon_success"]="${__chars_FIG['TICK']} "

        local __rgb_val
        __textprint_THEMES["${__tkey}red"]='167'
        __textprint_THEMES["${__tkey}purple"]='67'
        __textprint_THEMES["${__tkey}blue"]='24'
        __textprint_THEMES["${__tkey}light-blue"]='109'
        __textprint_THEMES["${__tkey}yellow"]='100'
        __textprint_THEMES["${__tkey}green"]='47'
        __textprint_THEMES["${__tkey}orange"]='173'
        __textprint_THEMES["${__tkey}cyan"]='66'
        __textprint_THEMES["${__tkey}default"]='249'
        textprint_base.setProp --prop 'fg_colour' --state 'default'
    }
}
