#!/usr/bin/env bash
import.require 'os>base'
# @description The os namespace
# Provides os specific functions and the global associative array "__OS" which
# contains details about the current operating system.
#
# @example
#   import.require 'os'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'os'
#      }
#      some_other_module.someFunction() {
#           if os.is 'Name' 'Ubuntu'; then
#              echo 'Is Ubuntu'
#           fi
#      }
#   }
#
# @see os.is()
os.init() {
    os.__init() {
        import.useModule 'os_base'
    }
    # @description Check OS property
    # Will check if the specified OS property is equal to the passed value
    #
    # @example
    #   if os.is 'FAMILY' 'Linux'; then
    #       echo 'Is Linux'
    #   fi
    #
    # @arg $1 Property A key in the "__OS" array
    # @arg $2 Value The value to compare
    os.is() {
        os_base.is "$@"
    }
}
