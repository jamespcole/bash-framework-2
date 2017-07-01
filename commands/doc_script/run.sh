# This line is required and is used to locate and load the project bootstrap which
# is needed for setting up functionality which is common to all commands.
source $(bash_bootstrap $(dirname $(readlink -f ${BASH_SOURCE}) ) ) || exit 1

# Uses a modified version of the script found here:
# https://github.com/reconquest/shdoc

import.require 'template'
import.require 'params'
import.require 'args'
import.require 'logger'
import.require 'provision.gawk'
import.require 'reflection'
import.require 'script'
vendor.wrap 'mo/mo' 'vendor.include.mo'

doc_script.init() {
    doc_script.__init() {
        import.useModule 'template'
        import.useModule 'params'
        import.useModule 'args'
        import.useModule 'logger'
        import.useModule 'provision.gawk'
        import.useModule 'script'
        import.useModule 'reflection'
        vendor.include.mo
        doc_script.args
    }
    doc_script.args() {
        args.add --key 'input_file' \
            --name 'Input File' \
            --alias '-i' \
            --alias '--input-file' \
            --desc 'The input template file' \
            --has-value 'y' \
            --required-unless 'module_name' \
            --required-unless 'input_file' \
            --required-unless 'doc_command' \
            --excludes 'doc_command' \
            --excludes 'module_name'

        args.add --key 'module_name' \
            --name 'Module Name' \
            --alias '-m' \
            --alias '--module' \
            --desc 'The name of the module to document' \
            --has-value 'y' \
            --excludes 'doc_command' \
            --excludes 'input_file'

        args.add --key 'save_file' \
            --name 'Save File' \
            --alias '-s' \
            --alias '--save' \
            --desc 'Automatically save the docs file' \
            --type 'switch' \
            --default '0' \
            --has-value 'n'

        args.add --key 'doc_script_style' \
            --name 'Doc Style' \
            --alias '--style' \
            --desc 'Select the output style' \
            --type 'enum' \
            --default 'md' \
            --enum-value 'md' \
            --enum-value 'info' \
            --has-value 'y'

        args.add --key 'doc_command' \
            --name 'Command Name' \
            --alias '-c' \
            --alias '--command' \
            --desc 'The name of the command to document' \
            --has-value 'y' \
            --excludes 'module_name' \
            --excludes 'input_file'
    }
    doc_script.main() {
        if [ "${__args_VALS['module_name>>specified']}" == '1' ]; then
            doc_script.documentModule
        elif [ "${__args_VALS['doc_command>>specified']}" == '1' ]; then
            doc_script.documentCommand
        fi
    }
    doc_script.documentCommand() {
        local __cmd_name="${__args_VALS['doc_command']}"
        local __cmd_path
        __cmd_path=$(which "${__cmd_name}")
        if [ -z "${__cmd_path}" ]; then
            script.exitWithError "Could not find the command \"${__cmd_name}\""
        fi
        __cmd_path=$(readlink -f "${__cmd_path}")
        if [ ! -f "${__cmd_path}" ]; then
            script.exitWithError "Could not find the command at \"${__cmd_path}\""
        fi
        local __cmd_dir
        __cmd_dir=$(dirname "${__cmd_path}")

        local __docs_path="${__cmd_dir}/docs"
        local __readme_path="${__cmd_dir}/docs/README.mo.md"
        if [ ! -f "${__readme_path}" ]; then
            script.exitWithError \
                "Could not find the command readme template at \"${__readme_path}\""
        fi

        local __readme_out_path="${__cmd_dir}/docs/README.md"

        local  __all_dependencies
        __all_dependencies=$(reflection.printInfoForFile \
            --file-path "$__cmd_path" \
            | grep '.__init' \
            | grep -v '_base.__init' \
            | sed 's/.__init$//')

        # The template variables
        local __CMD_PATH__
        __CMD_PATH__="${__cmd_path}"
        local __CMD_NAME__="${__cmd_name}"
        __CMD_PATH__="${__cmd_path}"
        cat "${__readme_path}" | mo > "${__readme_out_path}"
    }
    doc_script.documentModule() {
        provision.require 'gawk' || {
            script.exitWithError "Gawk requirement no met."
        }
        logger.info --message "Documenting module ${__args_VALS['module_name']}"
        local __input_path
        import.getModulePath __input_path "${__args_VALS['module_name']}"

        if [ "${__args_VALS['doc_script_style']}" == 'md' ]; then

            local __shdoc_path
            vendor.getPath __shdoc_path 'shdoc/shdoc'
            echo "${__shdoc_path}"
            echo "${__input_path}"
            local __tmp_file="$(mktemp)"
            sed -e 's/^[ \t]*//' "${__input_path}" > "${__tmp_file}"

            local __doc_md=$("${__shdoc_path}" < "${__tmp_file}")
            if [ "${__args_VALS['save_file']}" == '1' ]; then
                local __doc_script_op="$(dirname "$__input_path")/docs"
                mkdir -p "${__doc_script_op}"
                local __doc_func_of="${__doc_script_op}/functions.md"
                echo "$__doc_md" > "${__doc_func_of}"
            else
                # "${__shdoc_path}" < "${__tmp_file}"
                echo "$__doc_md"
            fi
        else
            reflection.printDependencies --file-path "${__input_path}"

            reflection_base.printInfoForFile --file-path "${__input_path}"

        fi



        return 0
    }
    doc_script.insertAuthors() {
        local __content="$1"
        local __file
        __file=$(echo "${__content}" | mo)
        git log "$__file" \
            | grep "Author:" \
            | uniq  -c \
            | sed "s/Author: //" \
            | awk '{ print "+ " $2" ("$1" commits)" }'
    }
    doc_script.insertChangelog() {
        local __content="$1"
        local __file
        __file=$(echo "${__content}" | mo)
        git log --pretty=format:'* %s%n    * <small>%aD - %aN</small>' "$__file"
    }
    doc_script.insertArguments() {
        local __content="$1"
        local __cmd
        __cmd=$(echo "${__content}" | mo)
        echo '```'
        $__cmd --help -M -D 2 | sed "s|e*.${END}\[[0-9;]*[m|K]||g" | sed "s|(B||g"
        echo '```'
    }
    doc_script.insertModuleDependencies() {
        echo "$__all_dependencies" \
            | grep -v 'provision.' \
            | grep -v 'vendor.' \
            | awk '{ print "* " $0 } END { if ( NR == 0 ) { print "None"; } }'
    }
    doc_script.insertSystemDependencies() {

        echo "$__all_dependencies" \
            | grep 'provision.' \
            | awk '{ print "* " $0 } END { if ( NR == 0 ) { print "None"; } }'
    }
    doc_script.insertVendorDependencies() {
        echo "$__all_dependencies" \
            | grep 'vendor.' \
            | awk '{ print "* " $0 } END { if ( NR == 0 ) { print "None"; } }'
    }
    doc_script.insertAllDependencies() {
        local __content="$1"
        local __file
        __file=$(echo "${__content}" | mo)

        reflection.printInfoForFile \
            --file-path "$__file" \
        | grep '.__init' \
        | grep -v '_base.__init' \
        | sed 's/.__init$//'
    }
}

# If sourced, load all functions.
# If executed, perform the actions as expected.
if [[ "$0" == "$BASH_SOURCE" ]] || ! [[ -n "$BASH_SOURCE" ]]; then
    import.useModule 'bootstrap'
    bootstrap.run 'doc_script' "$@"
fi
