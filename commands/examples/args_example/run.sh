#!/usr/bin/env bash
# This line is required and is used to locate and load the project bootstrap which
# is needed for setting up functionality which is common to all commands.
source $(bash_bootstrap $(dirname $(readlink -f ${BASH_SOURCE}) ) ) || exit 1

import.require 'script'

args_example.init() {
    args_example.__init() {
        import.useModule 'script'
        args_example.args
    }
    args_example.args() {
        args.add --key 'args_example_req_param' \
            --name 'Required Parameter' \
            --alias '-r' \
            --alias '--req' \
            --desc 'This is a required parameter which requires a value.' \
            --required '1' \
            --has-value 'y'

        args.add --key 'args_example_switch_param' \
            --name 'Switch Parameter' \
            --alias '-s' \
            --alias '--switch' \
            --desc 'This is an optional switch parameter.' \
            --required '0' \
            --type 'switch' \
            --has-value 'n'

        args.add --key 'args_example_maybe_param' \
            --name 'Maybe Parameter' \
            --alias '--maybe' \
            --desc 'This is an optional parameter which may or may not have a value.' \
            --required '0' \
            --has-value 'm'

        args.add --key 'args_example_enum_param' \
            --name 'Enum Parameter' \
            --alias '-e' \
            --alias '--enum' \
            --desc 'This is an optional enum parameter which must have one of the values passed to "--enum-value".' \
            --required '0' \
            --type 'enum' \
            --enum-value 'val_1' \
            --enum-value 'val_2' \
            --enum-value 'example' \
            --enum-value 'val_4'

        args.add --key 'args_example_deps_param' \
            --name 'Dependency Parameter' \
            --alias '-d' \
            --alias '--dep' \
            --desc 'This is an optional switch parameter that requires "-s, --switch" ' \
                + 'parameter to also be specified if it is passed to the command.' \
            --includes 'args_example_switch_param' \
            --required '0' \
            --type 'switch' \
            --has-value 'n'

        args.add --key 'args_example_req_unless' \
            --name 'Req Unless Parameter' \
            --alias '-u' \
            --alias '--req-unless' \
            --desc 'This is an required unless the "Dependency Parameter"' \
                + ' is specified.' \
            --required-unless 'args_example_deps_param' \
            --type 'switch' \
            --has-value 'n'

        args.add --key 'args_example_excludes' \
            --name 'Exlcudes Parameter' \
            --alias '-e' \
            --alias '--ex' \
            --desc 'This is parameter means excludes the use of the "Switch Parameter".' \
            --excludes 'args_example_switch_param' \
            --type 'switch' \
            --has-value 'n'
    }
    args_example.main() {
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
    bootstrap.run 'args_example' "$@"
fi
