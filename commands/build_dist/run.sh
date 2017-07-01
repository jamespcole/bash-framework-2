#!/usr/bin/env bash
# This line is required and is used to locate and load the project bootstrap which
# is needed for setting up functionality which is common to all commands.
source $(bash_bootstrap $(dirname $(readlink -f ${BASH_SOURCE}) ) ) || exit 1

# Uses a modified version of the script found here:
# https://github.com/reconquest/shdoc

import.require 'script'

build_dist.init() {
    build_dist.__init() {
        import.useModule 'script'
        build_dist.args
    }
    build_dist.args() {
        args.add --key 'build_name' \
            --name 'Command Name' \
            --alias '-n' \
            --alias '--name' \
            --desc 'The command to build in to a dist file.' \
            --has-value 'y' \
            --required-unless 'build_input_file'

        args.add --key 'build_input_file' \
            --name 'Script File' \
            --alias '-f' \
            --alias '--file' \
            --desc 'The path of the script file to build' \
            --has-value 'y' \
            --required-unless 'build_name' \
            --type 'file_exists'

        args.add --key 'build_no_ignore' \
            --name 'No GitIgnore' \
            --alias '--no-gitignore' \
            --desc 'If set a .gitignore file will not be created when the dist output directory is created.' \
            --has-value 'n' \
            --includes 'build_name' \
            --default '0' \
            --type 'switch'

        args.add --key 'build_output_path' \
            --name 'Output Path' \
            --alias '--out' \
            --desc 'Save the built file in this location.' \
            --has-value 'y' \
            --includes 'build_name' \
            --type 'value'

    }
    build_dist.main() {
        local __script_path
        local __cmd_name
        if [ "${__args_VALS['build_name']>>specified}" ]; then
            __cmd_name="${__args_VALS['build_name']}"
            __script_path=$(which "$__cmd_name")
            if [ "$__script_path" == '' ]; then
                script.exitWithError "Could not find the command \"${__cmd_name}\""
            fi
            __script_path=$(readlink -f "$__script_path")
            logger.info --message \
                "Building the command \"${__cmd_name}\" from the script \"${__script_path}\""
        else
            __script_path="${__args_VALS['build_input_file']}"
            logger.info --message \
                "Building the script \"${__script_path}\""
        fi

        local __script_dir=$(dirname "${__script_path}")

        if [ "${__args_VALS['build_input_file']>>specified}" ]; then
            __cmd_name=$(basename "${__script_dir}")
            logger.info --message \
                "Assuming output command name is \"${__cmd_name}\""
        fi


        local __output_path="${__script_dir}/dist"

        if [ "${__args_VALS['build_output_path']>>specified}" ]; then
            __output_path="${__args_VALS['build_output_path']}"
        fi
        mkdir -p "$__output_path"
        local __output_file="${__output_path}/${__cmd_name}"

        logger.info --message \
            "Building \"${__cmd_name}\" to \"${__output_file}\""

        local __main_func=$(grep 'bootstrap.run' "${__script_path}")
        logger.info --message \
            "Found script entry point of \"${__main_func}\"..."
        echo "#!/usr/bin/env bash" > "${__output_file}"
        (bash -c 'source '"${__script_path}"' && source '"$BF2_FW_PATH"'/bootstrap.sh && declare -f') >> "${__output_file}"
        cat "$BF2_FW_PATH/modules/import.shim.sh" >> "${__output_file}"
        echo "import.init" >> "${__output_file}"
        echo "import.useModule 'bootstrap'" >> "${__output_file}"
        echo "${__main_func}" >> "${__output_file}"
        chmod +x "${__output_file}"

        if [ "${__args_VALS['build_no_ignore']}" != '1' ]; then
            if [ ! -f "${__output_path}/.gitignore" ]; then
                echo -en "*\n!.gitignore" > "${__output_path}/.gitignore"
            fi
        fi

        script.exitSuccess "Build completed"
        return 0

    }
}

# If sourced, load all functions.
# If executed, perform the actions as expected.
if [[ "$0" == "$BASH_SOURCE" ]] || ! [[ -n "$BASH_SOURCE" ]]; then
    import.useModule 'bootstrap'
    bootstrap.run 'build_dist' "$@"
fi
