#!/usr/bin/env bash
source "$(dirname $(readlink -f ${BASH_SOURCE}) )/modules/import.sh"
import.init
import.require 'args'
import.require 'help'
import.require 'script'
import.require 'logger'

# START: Log Hanlers:
# place log handler imports you wish to include in builds here
import.require 'logger.handlers.fancy'
import.require 'logger.handlers.formatted'
#END: Log Hanlers

bootstrap.init() {
    bootstrap.__init() {
        # The namespace fo the currently executing command
        declare -g __bf2_CMD_NS
        import.useModule 'logger'
        import.useModule 'args'
        import.useModule 'help'

        trap bootstrap.finish EXIT

        declare -A -g __bootstrap_SETTINGS
        # Timestamp in milliseconds
        __bootstrap_SETTINGS['script-start-ms']=$(date +%s%3N)
        # Whether or not to send all output via the logger
        __bootstrap_SETTINGS['cap-all-output']='1'

        # args depends on logger so we need to call this here
        logger.args

        # START: Log Hanlers:
        import.useModule 'logger.handlers.fancy'
        import.useModule 'logger.handlers.formatted'
        #END: Log Hanlers
    }
    bootstrap.run() {
        bootstrap.setupLoggers
        __bf2_CMD_NS="$1"
        # Remove the fist param which should be the command namespace
        shift;
        # Initialise the command namespace
        "${__bf2_CMD_NS}.init" "$@"

        # Set output capture to the ENV variable if set
        [ -z $BF2_CAP ] ||  __bootstrap_SETTINGS['cap-all-output']="${BF2_CAP}"

        # Actualise all included modules
        import.useModules

        # Initialise the command
        "${__bf2_CMD_NS}.__init" "$@"

        args.parse "$@"
        args.processCallbacks
        logger_base.processStartupArgs
        logger.printCommandStart
		args.validate "$@"

        # Run the command
        if [ "${__bootstrap_SETTINGS['cap-all-output']}" == '1' ]; then
            # Pipe all output via the logger for highly formatted output
            __logger_SETTINGS['in-loop']='1'
            "${__bf2_CMD_NS}.main" "$@" 2>&1 | logger.printLoop; test ${PIPESTATUS[0]} -eq 0
        else
            # Run without capturing all output for formatting
            "${__bf2_CMD_NS}.main" "$@"
        fi

    }
    bootstrap.setupLoggers() {
        logger.setConsoleLogHandler \
            --namespace 'logger.handlers.fancy' \
            --use-markup '1' \
            --width 80
        # logger.setConsoleLogHandler \
        #     --namespace 'logger.handlers.formatted' \
        #     --use-markup '1' \
        #     --width 80
    }
    bootstrap.setOutputCapture() {
        __bootstrap_SETTINGS['cap-all-output']="$1"
    }
    bootstrap.finish() {
        local __err_stat="$?"
        __logger_SETTINGS['in-loop']='0'
        if [ "${__logger_SETTINGS['in-loop']}" == '1' ]; then
            if [ "$__err_stat" != '0' ]; then
                logger.error \
                    --message "Script returned exit code \"${__err_stat}\""
            fi
        fi
        logger.printCommandEnd --exit-status "$__err_stat"
        exit "$__err_stat"
    }
}
# (bash -c 'source /vagrant/source_code/bash/bf2/modules/textprint/module.sh 2>&1 && declare -f') | grep -v "import.require" | sed "s/^    { $/dccc/g" | sed "/^    function *.*()/ s/$/\ntest/"
