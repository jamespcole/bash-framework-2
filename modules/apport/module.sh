#!/usr/bin/env bash
import.require 'apport>base'
# @description The apport namespace
# Disables apport to stop those irritating crash report popups
#
# @example
#   import.require 'apport'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'apport'
#      }
#      some_other_module.someFunction() {
#         apport.disable
#      }
#   }
#
# @see apport.disable()
apport.init() {
    apport.__init() {
        import.useModule 'apport_base'
    }
    # @description Disables apport in config file
    #
    # @example
    #   apport.disable
    #
    #   Disables apport on Ubuntu
    #
    # @noargs
    apport.disable() {
        apport_base.disable "$@"
    }
}
