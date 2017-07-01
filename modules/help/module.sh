import.require 'help>base'
# @description The help namespace provides ....
# Descibe your module here
#
# @example
#   import.require 'help'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'help'
#      }
#      some_other_module.someFunction() {
#         help.printHelp
#      }
#   }
#
# @see help.sayHello()
help.init() {
    help.__init() {
        import.useModule 'help_base'
    }
    # @description A function that prints command help.
    # This function is called when --help is passed to a command.
    #
    # @example
    #   help.printHelp
    #
    #   prints help info for the current command
    #
    # @norgs
    help.printHelp() {
        help_base.printHelp "$@"
    }
    help.printHeading() {
        help_base.printHeading "$@"
    }
    help.printDescription() {
        help_base.printDescription "$@"
    }
    help.printArgs() {
        help_base.printArgs "$@"
    }
}
