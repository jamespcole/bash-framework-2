#!/usr/bin/env bash
# This line is required and is used to locate and load the project bootstrap which
# is needed for setting up functionality which is common to all commands.
source $(bash_bootstrap $(dirname $(readlink -f ${BASH_SOURCE}) ) ) || exit 1

import.require 'textprint'
import.require 'bml_tags'

bml.init() {
    bml.__init() {
        bml.args
    }
    bml.args() {
        args.add --key 'bml_out_file' \
            --name 'Example Parameter' \
            --alias '-o' \
            --alias '--out' \
            --desc 'An example of a required parameter' \
            --required '0' \
            --has-value 'y'

        args.add --key 'bml_in_file' \
            --name 'Input File' \
            --alias '-i' \
            --alias '--input-file' \
            --desc 'An example of a required parameter' \
            --required '0' \
            --has-value 'y' \
            --type 'file_exists'
    }
    bml.main() {
        if [ "${__args_VALS['bml_in_file>>specified']}" == '1' ]; then
            bml.processFile
        else
            bml.processIncoming "$@"
        fi
    }
    bml.processIncoming() {
        while read __line; do
            textprint.printLine --text "${__line}"
        done
    }
    bml.processFile() {
        local __bml
        __bml=$(cat "${__args_VALS['bml_in_file']}")
        textprint.print --text "${__bml}" --block 1

    }
}

# If sourced, load all functions.
# If executed, perform the actions as expected.
if [[ "$0" == "$BASH_SOURCE" ]] || ! [[ -n "$BASH_SOURCE" ]]; then
    import.useModule 'bootstrap'
    bootstrap.setOutputCapture '0' && bootstrap.run 'bml' "$@"
fi
