# This line is required and is used to locate and load the project bootstrap which
# is needed for setting up functionality which is common to all commands.
source $(bash_bootstrap $(dirname $(readlink -f ${BASH_SOURCE}) ) ) || exit 1

import.require 'script'

logger_demo.init() {
    logger_demo.__init() {
        import.useModule 'script'
    }
    logger_demo.main() {

        # logger.printCommandStart

        logger.beginTask --title 'Logger examples' \
            --message 'Run logger example calls'


        logger.step --number 1 \
            --total 2 \
            --message 'Run logger example calls'

        logger.info --message \
            'This is an info message'

        logger.warning --message \
            'This is a warning message'

        logger.success --message \
            'This is a success message'

        logger.error --message \
            'This is an error message'

        logger.debug --message \
            'This is a debug message'

        logger.info --message \
            'This is an {{#textprint.danger}}ex{{#textprint.u}}ample{{/textprint.u}} of{{/textprint.danger}} {{#textprint.b}}markup{{/textprint.b}}'

        logger.step --number 2 \
            --total 2 \
            --message 'Run loading example calls'

        logger.info --message \
            'This is loading text...'

        ping -c 5 google.com

        logger.info --message \
            'This is loading text with an error...'

        ping -c 5 google.com

        logger.endTask --title 'Logger examples' \
            --message 'Completed loggger examples'

        return 1
        # ping -c 5 google.com && {
        #     script.exitWithError "An error occurred"
        # }


        # logger.warning --message \
        #     'This line will wrap.  {{#danger}}{{#u}}Lorem ipsum dolor sit amet{{/u}}{{/danger}}, consectetur adipi scing elit. Nunc lobortis leo enim, ut commodo sapien pharetra id. Ut semper, metus in fermentum lacinia, eros mauris gravida massa, vitae porttitor turpis mauris vel dui. Mauris ac urna dapibus, dictum nisi eget, semper velit. Quisque et massa nec odio sodales congue et nec nisi. Fusce dictum turpis quis arcu eleifend consectetur. Sed aliquet enim vitae magna commodo, at congue elit dignissim. Ut sagittis augue non massa convallis viverra.'

        # logger.printCommandEnd
    }

}

# If sourced, load all functions.
# If executed, perform the actions as expected.
if [[ "$0" == "$BASH_SOURCE" ]] || ! [[ -n "$BASH_SOURCE" ]]; then
    import.useModule 'bootstrap'
    bootstrap.run 'logger_demo' "$@"
fi
