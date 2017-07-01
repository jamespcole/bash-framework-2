#!/usr/bin/env bash
import.require 'provision.xautomation>base'
# @description The provision.xautomation namespace
# Installs xautomation
#
# @example
#   import.require 'provision.xautomation'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.xautomation'
#       }
#       some_other_module.someFunction() {
#           provision.require 'xautomation' || {
#               echo 'Requirement "xautomation" not met.'
#          }
#       }
#   }
#
# @see provision.xautomation.require()
provision.xautomation.init() {
    provision.xautomation.__init() {
        import.useModule 'provision.xautomation_base'
    }
    # @description Require the system component "xautomation".
    # Check to see if "xautomation" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'xautomation'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.xautomation.require() {
        provision.xautomation_base.require "$@"
    }
}
