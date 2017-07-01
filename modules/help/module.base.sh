import.require 'bml_tags'
help_base.init() {
    help_base.__init() {
        help_base.args
    }
    help_base.args() {
        args.add --key 'show_help' \
            --name 'Show Help' \
            --alias '--help' \
            --desc 'Print help for the command.' \
            --has-value 'm' \
            --priority '2' \
            --callback 'help.printHelp'
    }
    help_base.printHelp() {
        logger.forceHidePrefix "1"
        logger.forceDecoration "4"
        local __use_markup=false
        if logger.supportsMarkup; then
            __use_markup=true
        fi

        help.printHeading

        help.printDescription

        help.printArgs

        exit
    }

    help_base.printArgs() {

        if "$__use_markup"; then
            logger.info \
                --message ""
            logger.info \
                --message "{{#b:h2}}Arguments{{/b:h2}}"
            logger.info \
                --message ""
        else
            logger.info \
                --message ""
            logger.info \
                --message "Arguments"
            logger.info \
                --message ""
        fi

        for __arg_key in "${__args_KEYS[@]}"; do
            local __key_pfx="${__arg_key}>>"
            local __aliases="${__args_DEFS[${__key_pfx}alias_list]}"
            local __name="${__args_DEFS[${__key_pfx}name]}"
            local __desc="${__args_DEFS[${__key_pfx}desc]}"

            if "$__use_markup"; then
                logger.info --message \
                    "{{#b:b}}${__aliases}{{/b:b}}, {{#b:u}}${__name}{{/b:u}}"

                logger.info --message \
                    "{{b:in}}{{#b:d}}${__desc}{{/b:d}}"

                logger.info --message \
                    ""
            else
                logger.info --message \
                    "${__aliases}, ${__name}"

                logger.info --message \
                    "*\t\t${__desc}"

                logger.info --message \
                    ""
            fi
        done
    }

    help_base.printDescription() {
        if import.functionExists "${__bf2_CMD_NS}.help.print"; then
            local __help_text
            __help_text="$(${__bf2_CMD_NS}.help.print --part 'desc')"

            if "$__use_markup"; then
                # This is hacky, needs to be fixed in the logger
                local -a __options_arr
                readarray __options_arr < <(echo "$__help_text")
                local __option
                for __option in "${__options_arr[@]}"; do
                    logger.info --message \
                        "$__option"
                done
            else
                logger.info --message \
                    "$(echo "$__help_text" | sed -e 's/{{[^}}]*}}//g')"
            fi

            logger.info --message ' '

        fi
    }

    help_base.printHeading() {
        if [ "${__args_VALS['logger_decoration']}" -gt 3 ]; then
            return
        fi
        if "$__use_markup"; then
            logger.info \
                --message "{{b:hr}}{{b:br}}"
            logger.info \
                --message "{{#b:h1}}${0##*/}{{/b:h1}}"
            logger.info \
                --message "{{b:hr}}{{b:br}}"
        else
            logger.info \
                --message "${0##*/}"
        fi
    }
}
