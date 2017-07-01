#!/usr/bin/env bash
import.require 'provision.iceweasel>base'
# @description The provision.iceweasel namespace
# Installs iceweasel
#
# @example
#   import.require 'provision.iceweasel'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.iceweasel'
#       }
#       some_other_module.someFunction() {
#           provision.require 'iceweasel' || {
#               echo 'Requirement "iceweasel" not met.'
#          }
#       }
#   }
#
# @see provision.iceweasel.require()
provision.iceweasel.init() {
    provision.iceweasel.__init() {
        import.useModule 'provision.iceweasel_base'
    }
    # @description Require the system component "iceweasel".
    # Check to see if "iceweasel" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'iceweasel'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.iceweasel.require() {
        provision.iceweasel_base.require "$@"
    }
}
