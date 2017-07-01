#!/usr/bin/env bash
import.require 'provision.unclutter>base'
# @description The provision.unclutter namespace
# Installs unclutter
#
# @example
#   import.require 'provision.unclutter'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.unclutter'
#       }
#       some_other_module.someFunction() {
#           provision.require 'unclutter' || {
#               echo 'Requirement "unclutter" not met.'
#          }
#       }
#   }
#
# @see provision.unclutter.require()
provision.unclutter.init() {
    provision.unclutter.__init() {
        import.useModule 'provision.unclutter_base'
    }
    # @description Require the system component "unclutter".
    # Check to see if "unclutter" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'unclutter'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.unclutter.require() {
        provision.unclutter_base.require "$@"
    }
}
