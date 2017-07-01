#!/usr/bin/env bash
# This line is required and is used to locate and load the project bootstrap which
# is needed for setting up functionality which is common to all commands.
source $(bash_bootstrap $(dirname $(readlink -f ${BASH_SOURCE}) ) ) || exit 1

vendor.wrap 'mo/mo' 'vendor.include.mo'
resource.relative 'templates/command.sh.mo'

create_cmd.init() {
    create_cmd.__init() {
		vendor.include.mo
        create_cmd.args
    }
    create_cmd.args() {
        args.add --key 'create_cmd_name' \
            --name 'Command Name' \
            --alias '-n' \
            --alias '--cmd-name' \
            --desc 'The name of the new command' \
            --has-value 'y' \
            --required '1'

        args.add --key 'create_cmd_env' \
            --name 'Command Environment' \
            --alias '--framework-cmd' \
            --desc 'If set will create command in the current framework command directory. Otherwise create command in the current directory.' \
            --has-value 'n' \
            --type 'switch'
    }
    create_cmd.main() {
        local __cmd_name="${__args_VALS['create_cmd_name']}"
        logger.info --message \
            "Creating new command ${__cmd_name}..."

        local __out_dir
        if [ -z "$BF2_ENV" ]; then
          __out_dir="${BF2_FW_PATH}/commands/${__cmd_name}"
        elif [ "${__args_VALS['create_cmd_env']}" == '1' ]; then
          __out_dir="${BF2_FW_PATH}/commands/${__cmd_name}"
        else
          __out_dir="${BF2_ENV}/commands/${__cmd_name}"
        fi

        if [ -d "${__out_dir}" ]; then
            logger.warning --message \
                "The directory \"${__out_dir}\" already exists"
        fi
        local __output_file="${__out_dir}/run.sh"
        if [ -f "${__output_file}" ]; then
            script.exitWithError "The file \"${__output_file}\" already exists"
        fi

        mkdir -p "${__out_dir}"

        # Run the command template through moustache and save to file
        resource.get 'templates/command.sh.mo' | mo > "${__output_file}"

        chmod +x "${__output_file}"
        logger.info --message \
            "Installing the new command..."
        install_commands || {
            script.exitWithError \
                "Failed to install commands"
        }
        logger.info --message \
            "Created new command \"${__cmd_name}\" at \""${__output_file}"\""
        logger.info --message \
            "You can now execute your new command by running \"${__cmd_name}\""
        script.exitSuccess "Command created."
    }
}
# If sourced, load all functions.
# If executed, perform the actions as expected.
if [[ "$0" == "$BASH_SOURCE" ]] || ! [[ -n "$BASH_SOURCE" ]]; then
    import.useModule 'bootstrap'
    bootstrap.run 'create_cmd' "$@"
fi
