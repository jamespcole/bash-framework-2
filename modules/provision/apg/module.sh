#!/usr/bin/env bash
import.require 'provision.apg>base'
# @description The provision.apg namespace
# Installs apg
#
# @example
#   import.require 'provision.apg'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.apg'
#       }
#       some_other_module.someFunction() {
#           provision.require 'apg' || {
#               echo 'Requirement "apg" not met.'
#          }
#       }
#   }
#
# @see provision.apg.require()
provision.apg.init() {
    provision.apg.__init() {
        import.useModule 'provision.apg_base'
    }
    # @description Require the system component "apg".
    # Check to see if "apg" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'apg'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.apg.require() {
        provision.apg_base.require "$@"
    }
}
