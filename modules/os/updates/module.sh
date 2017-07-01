#!/usr/bin/env bash
import.require 'os.updates>base'
# @description The os.updates namespace provides ....
# Descibe your module here
#
# @example
#   import.require 'os.updates'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'os.updates'
#      }
#      some_other_module.someFunction() {
#         os.updates.sayHello
#      }
#   }
#
# @see os.updates.sayHello()
os.updates.init() {
    os.updates.__init() {
        import.useModule 'os.updates_base'
    }
    # @description A function that prints "Hello World!".  This description
    # will appear in the generated documentation for this function
    #
    # @example
    #   os.updates.sayHello
    #
    #   prints 'Hello World' to std out
    #
    # @arg $1 A description of the first argument
    # @arg $2 A description of the second argument
    os.updates.check() {
        os.updates_base.check "$@"
    }
    os.updates.install() {
        os.updates_base.install "$@"
    }
    os.updates.upgrade() {
        os.updates_base.upgrade "$@"
    }
}
