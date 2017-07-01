#!/usr/bin/env bash
# This line is required and is used to locate and load the project bootstrap which
# is needed for setting up functionality which is common to all commands.
source $(bash_bootstrap $(dirname $(readlink -f ${BASH_SOURCE}) ) ) || exit 1

import.require 'script'
vendor.wrap 'mo/mo' 'vendor.include.mo'

bf2_env.init() {
    bf2_env.__init() {
        import.useModule 'script'
        vendor.include.mo
        bf2_env.args
    }
    bf2_env.args() {
        args.add --key 'bf2_env_dir' \
            --name 'Environment Directory' \
            --alias '-p' \
            --alias '--path' \
            --desc 'The location of the new environment' \
            --required '0' \
            --includes 'bf2_env_create' \
            --default "$(pwd)" \
            --has-value 'y'

        args.add --key 'bf2_env_create' \
            --name 'Create a new Environment' \
            --alias '-c' \
            --alias '--create' \
            --desc 'Create a new bf2 enviroment' \
            --required-unless 'bf2_env_info' \
            --excludes 'bf2_env_info' \
            --default '0' \
            --has-value 'n' \
            --type 'switch'

        args.add --key 'bf2_env_info' \
            --name 'Environment Info' \
            --alias '-i' \
            --alias '--info' \
            --desc 'Print info about the current environment.' \
            --required-unless 'bf2_env_create' \
            --excludes 'bf2_env_create' \
            --default '0' \
            --has-value 'n' \
            --type 'switch'
    }
    bf2_env.main() {
        local __env_path="${__args_VALS[bf2_env_dir]}"

        if [ "${__args_VALS[bf2_env_create]}" == '1' ]; then
            bf2_env.createEnv
        elif [ "${__args_VALS[bf2_env_info]}" == '1' ]; then
            bf2_env.envInfo
        fi

        script.exitSuccess "Done"
    }
    bf2_env.createEnv() {
        if [ -f "${__env_path}/activate_env.sh" ]; then
            script.exitWithError \
                "An environment already exists in the location \"${__env_path}\""
        fi

        bf2_env.createActivationFile > "${__env_path}/activate_env.sh"

        bf2_env.createBootstrapFile > "${__env_path}/bootstrap.sh"

        logger.info --message \
            "Creating environment structure..."

        bf2_env.createEnvDirectory 'commands'
        bf2_env.createEnvDirectory 'modules'
        bf2_env.createEnvDirectory 'install_hooks'
        bf2_env.createEnvDirectory 'vendor'

        logger.info --message \
            'Your new environment has been created.'

        logger.info --message \
            "To start using your new environment run \"source ${__env_path}/activate_env.sh\""
    }
    bf2_env.envInfo() {
        if [ -z "$BF2_ENV" ]; then
            logger.info --message \
                "Current Env: NOT SET"
        else
            logger.info --message \
                "Current Env: ${BF2_ENV}"
        fi

        if [ -z "$BF2_FW_PATH" ]; then
            logger.info --message \
                "Framework Dir: NOT SET"
        else
            logger.info --message \
                "Framework Dir: ${BF2_FW_PATH}"
        fi
    }
    bf2_env.createEnvDirectory() {
        local __directory="$1"

        logger.info --message \
            "Creating the \"${__directory}\" directory..."

        local __path="${__env_path}/${__directory}"
        mkdir -p "${__env_path}/${__directory}"
        touch "${__env_path}/${__directory}/.gitkeep"
    }
    bf2_env.createActivationFile() {
        cat << EOF | mo
#!/usr/bin/env bash
unset BF2_ENV
export BF2_ENV="\$(dirname \$(readlink -f "\${BASH_SOURCE}"))"
if [ \$(echo "\$BF2_PATH" | grep \$(dirname \$(readlink -f "\${BASH_SOURCE}")) | wc -l) == '0' ]; then
	export BF2_PATH="\${BF2_PATH}:\$(dirname \$(readlink -f "\${BASH_SOURCE}"))"
fi
if [ \$(echo "\$PATH" | grep ":\$(dirname \$(readlink -f "\${BASH_SOURCE}"))/install_hooks" | wc -l) == '0' ]; then
	export PATH="\${PATH}:\$(dirname \$(readlink -f "\${BASH_SOURCE}"))/install_hooks"
fi

EOF
    }
    bf2_env.createBootstrapFile() {
        cat << EOF | mo
#!/usr/bin/env bash
source "\${BF2_FW_PATH}/bootstrap.sh"
EOF
    }
}


# If sourced, load all functions.
# If executed, perform the actions as expected.
if [[ "$0" == "$BASH_SOURCE" ]] || ! [[ -n "$BASH_SOURCE" ]]; then
    import.useModule 'bootstrap'
    bootstrap.run 'bf2_env' "$@"
fi
