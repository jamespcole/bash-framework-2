#!/usr/bin/env bash
import.require 'provision.dukto>base'
# @description The provision.dukto namespace
# Installs dukto
#
# @example
#   import.require 'provision.dukto'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.dukto'
#       }
#       some_other_module.someFunction() {
#           provision.require 'dukto' || {
#               echo 'Requirement "dukto" not met.'
#          }
#       }
#   }
#
# @see provision.dukto.require()
provision.dukto.init() {
    provision.dukto.__init() {
        import.useModule 'provision.dukto_base'
    }
    # @description Require the system component "dukto".
    # Check to see if "dukto" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'dukto'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode >0  If component is unavailable and installation failed.
    provision.dukto.require() {
        provision.dukto_base.require "$@"
    }
}
