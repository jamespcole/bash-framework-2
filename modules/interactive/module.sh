#!/usr/bin/env bash
import.require 'interactive>base'
# @description The interactive namespace provides ....
# Descibe your module here
#
# @example
#   import.require 'interactive'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'interactive'
#      }
#      some_other_module.someFunction() {
#         interactive.sayHello
#      }
#   }
#
# @see interactive.sayHello()
interactive.init() {
    interactive.__init() {
        import.useModule 'interactive_base'
    }
    # @description A function that prints "Hello World!".  This description
    # will appear in the generated documentation for this function
    #
    # @example
    #   local __answer
    #   interactive.askQuestion \
    #       --return __answer \
    #       --question "Please enter your response:"
    #
    #
    # @arg --return The variable that will be populated with the response
    # @arg --question The question ask the user
    interactive.askQuestion() {
        interactive_base.askQuestion "$@"
    }

    interactive.tell() {
        interactive_base.tell "$@"
    }

    interactive.choose() {
        interactive_base.choose "$@"
    }

    interactive.clear() {
        interactive_base.clear "$@"
    }

    interactive.pause() {
        interactive_base.pause "$@"
    }

    interactive.fillParam() {
        interactive_base.fillParam "$@"
    }
}
