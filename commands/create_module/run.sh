#!/usr/bin/env bash
# This line is required and is used to locate and load the project bootstrap which
# is needed for setting up functionality which is common to all commands.
source $(bash_bootstrap $(dirname $(readlink -f ${BASH_SOURCE}) ) ) || exit 1

import.require 'script'
import.require 'logger'
import.require 'params'
import.require 'string'
import.require 'textprint'
vendor.wrap 'mo/mo' 'vendor.include.mo'

create_module.init() {
    create_module.__init() {
        import.useModule 'script'
        import.useModule 'logger'
        import.useModule 'params'
        import.useModule 'string'
        import.useModule 'textprint'

        vendor.include.mo
        create_module.args
    }
    create_module.args() {
        args.add --key 'module_name' \
            --name 'Module Name' \
            --alias '-n' \
            --alias '--name' \
            --desc 'The full namespace of the module' \
            --required '1' \
            --has-value 'y'

        args.add --key 'module_type' \
            --name 'Module Type' \
            --alias '-t' \
            --alias '--type' \
            --desc 'The type of module to create' \
            --default 'default' \
            --has-value 'y' \
            --type 'enum' \
            --enum-value 'default' \
            --enum-value 'provision'

        args.add --key 'module_stdout' \
            --name 'Print to Stdout' \
            --alias '--print' \
            --desc 'If set the modules will be printed to stdout instead of being saved to disk' \
            --type 'switch' \
            --has-value 'n'

        args.add --key 'create_cmd_env' \
            --name 'Module Environment' \
            --alias '--framework-mod' \
            --desc 'If set will create module in the current framework command directory. Otherwise create command in the current directory.' \
            --has-value 'n' \
            --type 'switch'
    }
    create_module.main() {
        local __module_full_name="${__args_VALS['module_name']}"
        if [ "${__args_VALS['module_type']}" == 'provision' ]; then
            if ! string.startsWith 'provision.' "$__module_full_name"; then
                __module_full_name="provision.${__module_full_name}"
            fi
        fi

        logger.info \
            --message "Creating module ${__module_full_name}"
        local __new_mod_file

        # This bit determines whether or not to create the module in the
        # framework directory or in the local environment
        local __out_dir
        if [ -z "$BF2_ENV" ]; then
          __out_dir="${BF2_FW_PATH}/modules/${__module_full_name//.//}"
        elif [ "${__args_VALS['create_cmd_env']}" == '1' ]; then
          __out_dir="${BF2_FW_PATH}/modules/${__module_full_name//.//}"
        else
          __out_dir="${BF2_ENV}/modules/${__module_full_name//.//}"
        fi

        local __new_mod_file="${__out_dir}/module.sh"

        local __new_mod_dir=$(dirname "$__new_mod_file")
        local __module_base_file="${__new_mod_dir}/module.base.sh"

        if [ -f "$__new_mod_file" ] \
            && [ "${__args_VALS['module_stdout']}" != '1' ];
        then
            script.exitWithError \
                "Module \"${__module_full_name}\" already exists at \"${__new_mod_file}\""
        fi

        if [ -f "$__module_base_file" ] \
            && [ "${__args_VALS['module_stdout']}" != '1' ];
        then
            script.exitWithError \
                "Module \"${__module_full_name}\" already exists at \"${__module_base_file}\""
        fi

        mkdir -p "$__new_mod_dir"
        local __mod_text=$(create_module.template \
            --module-name "${__module_full_name}") || {
                script.exitWithError \
                    "Failed to create module file \"${__new_mod_file}\""
            }
        local __mod_base_text=$(create_module.templateBase \
            --module-name "${__module_full_name}") || {
                script.exitWithError \
                    "Failed to create base module file \"${__module_base_file}\""
            }

        if [ "${__args_VALS['module_stdout']}" == '1' ]; then
            echo "${__mod_text}"
            echo "${__mod_base_text}"
            exit 1
        else
            echo "${__mod_text}" > "$__new_mod_file" || {
                script.exitWithError \
                    "Failed to create module file \"${__new_mod_file}\""
            }
            echo "${__mod_base_text}" > "$__module_base_file" || {
                script.exitWithError \
                    "Failed to create module file \"${__module_base_file}\""
            }
        fi

        # create_module.template --module-name "${__args_VALS['module_name']}" > "$__new_mod_file" || {
        #     script.exitWithError \
        #         "Failed to create module file \"${__new_mod_file}\""
        # }
        # create_module.templateBase  --module-name "${__args_VALS['module_name']}" > "$__module_base_file" || {
        #     script.exitWithError \
        #         "Failed to create module file \"${__module_base_file}\""
        # }

        logger.success \
            --message "Module \"${__module_full_name}\" created."
        logger.success \
            --message "New module file located at \"${__new_mod_file}\""
        logger.success \
            --message "New base module file located at \"${__module_base_file}\""

        logger.info \
            --message "You can generate the docs for this module by running: doc_script -m ${__module_full_name} -s"

        return 0
    }
    create_module.template() {
        if [ "${__args_VALS['module_type']}" == 'provision' ]; then
            create_module.provisionTemplate "$@"
        else
            create_module.defaultTemplate "$@"
        fi
    }
    create_module.templateBase() {
        if [ "${__args_VALS['module_type']}" == 'provision' ]; then
            create_module.provisionTemplateBase "$@"
        else
            create_module.defaultTemplateBase "$@"
        fi
    }
    create_module.defaultTemplate() {
        local -A __params
        __params['module-name']=
        params.get "$@"
        local __module_name="${__params['module-name']}"
cat << EOF | mo
#!/usr/bin/env bash
import.require '{{__module_name}}>base'
# @description The {{__module_name}} namespace provides ....
# Descibe your module here
#
# @example
#   import.require '{{__module_name}}'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule '{{__module_name}}'
#      }
#      some_other_module.someFunction() {
#         {{__module_name}}.sayHello
#      }
#   }
#
# @see {{__module_name}}.sayHello()
{{__module_name}}.init() {
    {{__module_name}}.__init() {
        import.useModule '{{__module_name}}_base'
    }
    # @description A function that prints "Hello World!".  This description
    # will appear in the generated documentation for this function
    #
    # @example
    #   {{__module_name}}.sayHello
    #
    #   prints 'Hello World' to std out
    #
    # @arg \$1 A description of the first argument
    # @arg \$2 A description of the second argument
    {{__module_name}}.sayHello() {
        {{__module_name}}_base.sayHello "\$@"
    }
}
EOF
    }
create_module.defaultTemplateBase() {
    local -A __params
    __params['module-name']= # or ppa
    params.get "$@"
    local __module_name="${__params['module-name']}"
cat << EOF | mo
#!/usr/bin/env bash
# This is an example of inclduing the params module.
# Place require module calls at the top of the file.
# import.require 'params'
{{__module_name}}_base.init() {
    # Uncomment __init and put the declaration of any globals your module uses here.
    # Also initiliase any required modules.  If not required you can remove it.
    # {{__module_name}}_base.__init() {
    #     declare -g -A __my_global_arr
    #     import.useModule 'params'
    # }
    {{__module_name}}_base.sayHello() {
        echo "Hello World!"
    }
}
EOF
    }
}

create_module.provisionTemplate() {
    local -A __params
    __params['module-name']=
    params.get "$@"

    local __module_name
    string.removePrefix __module_name 'provision.' "${__params['module-name']}"

    cat << EOF | mo
#!/usr/bin/env bash
import.require 'provision.{{__module_name}}>base'
# @description The provision.{{__module_name}} namespace
# Installs {{__module_name}}
#
# @example
#   import.require 'provision.{{__module_name}}'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.{{__module_name}}'
#       }
#       some_other_module.someFunction() {
#           provision.require '{{__module_name}}' || {
#               echo 'Requirement "{{__module_name}}" not met.'
#          }
#       }
#   }
#
# @see provision.{{__module_name}}.require()
provision.{{__module_name}}.init() {
    provision.{{__module_name}}.__init() {
        import.useModule 'provision.{{__module_name}}_base'
    }
    # @description Require the system component "{{__module_name}}".
    # Check to see if "{{__module_name}}" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require '{{__module_name}}'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.{{__module_name}}.require() {
        provision.{{__module_name}}_base.require "\$@"
    }
}
EOF

}
    create_module.provisionTemplateBase() {
        local -A __params
        __params['module-name']=
        params.get "$@"
        local __module_name
        string.removePrefix __module_name 'provision.' "${__params['module-name']}"

        cat << EOF | mo
#!/usr/bin/env bash
import.require 'provision'
provision.{{__module_name}}_base.init() {
    provision.{{__module_name}}_base.__init() {
          import.useModule 'provision'
    }
    provision.{{__module_name}}_base.require() {
        if ! provision.isInstalled '{{__module_name}}'; then
          sudo apt-get install -y {{__module_name}}
          return \$?
        fi
        return 0
    }
}
EOF

}

# If sourced, load all functions.
# If executed, perform the actions as expected.
if [[ "$0" == "$BASH_SOURCE" ]] || ! [[ -n "$BASH_SOURCE" ]]; then
    import.useModule 'bootstrap'
    bootstrap.run 'create_module' "$@"
fi
