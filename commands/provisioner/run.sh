# This line is required and is used to locate and load the project bootstrap which
# is needed for setting up functionality which is common to all commands.
source $(bash_bootstrap $(dirname $(readlink -f ${BASH_SOURCE}) ) ) || exit 1

import.require 'provision'
import.require 'args'
import.require 'logger'
import.require 'script'

provisioner.init() {
    provisioner.__init() {
		import.useModule 'args'
        import.useModule 'provision'
        import.useModule 'logger'
		import.useModule 'script'
		provisioner.args
    }
	provisioner.args() {
		args.add --key 'install' \
			--name 'Install Component' \
			--alias '--i' \
            --alias '--install' \
			--desc 'The the component to install' \
			--required '1' \
            --has-value 'y'
	}
    provisioner.main() {
		local -A __args
		args.validate "$@"

        logger.info --message "Installing ${__args_VALS['install']}"
		local __prvsnr_namespace="provision.${__args_VALS['install']}"
		logger.info --message "Attempting import of namespace \"${__prvsnr_namespace}\""
        import.require "${__prvsnr_namespace}" || {
			script.exitWithError "Could not find namespace \"${__prvsnr_namespace}\""
		}
        import.useModule "provision.${__args_VALS['install']}"
        provision.require "${__args_VALS['install']}" || {
			script.exitWithError \
				"Failed to install \"${__args_VALS['install']}\""
		}

    }
}

# If sourced, load all functions.
# If executed, perform the actions as expected.
if [[ "$0" == "$BASH_SOURCE" ]] || ! [[ -n "$BASH_SOURCE" ]]; then
    import.useModule 'bootstrap'
    bootstrap.run 'provisioner' "$@"
fi
