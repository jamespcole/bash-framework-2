#!/usr/bin/env bash
import.require 'provision.nvm>base'
# @description The provision.nvm namespace
# Installs nvm
#
# @example
#   import.require 'provision.nvm'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.nvm'
#       }
#       some_other_module.someFunction() {
#           provision.require 'nvm' || {
#               echo 'Requirement "nvm" not met.'
#          }
#       }
#   }
#
# @see provision.nvm.require()
provision.nvm.init() {
    provision.nvm.__init() {
        import.useModule 'provision.nvm_base'
    }
    # @description Require the system component "nvm".
    # Check to see if "nvm" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'nvm'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode >0  If component is unavailable and installation failed.
    provision.nvm.require() {
        provision.nvm_base.require "$@"
    }
}
