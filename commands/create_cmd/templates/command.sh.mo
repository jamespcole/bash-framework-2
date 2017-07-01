#!/usr/bin/env bash
# This line is required and is used to locate and load the project bootstrap which
# is needed for setting up functionality which is common to all commands.
source $(bash_bootstrap $(dirname $(readlink -f ${BASH_SOURCE}) ) ) || exit 1

# EXAMPLE START
# An example of including a provisioning module, this would include the
# module for installing the "ls" command
import.require 'provision.ls'
# EXAMPLE END

{{__cmd_name}}.init() {
    {{__cmd_name}}.__init() {
        {{__cmd_name}}.args
    }
    {{__cmd_name}}.args() {
        args.add --key '{{__cmd_name}}_param1' \
            --name 'Example Parameter' \
            --alias '-p' \
            --alias '--param' \
            --desc 'An example of a required parameter' \
            --required '1' \
            --has-value 'y'
    }
    {{__cmd_name}}.main() {

        # EXAMPLE START
        # This begins the installation of the "ls" command
        provision.require 'ls' || {
            script.exitWithError "ls requirement no met."
        }
        # EXAMPLE END


        # Put your implementation here

        logger.info --message \
            "This is how you log messages"

        script.exitSuccess "Your script has exited successfully!"
    }
}

# If sourced, load all functions.
# If executed, perform the actions as expected.
if [[ "$0" == "$BASH_SOURCE" ]] || ! [[ -n "$BASH_SOURCE" ]]; then
    import.useModule 'bootstrap'
    bootstrap.run '{{__cmd_name}}' "$@"
fi
