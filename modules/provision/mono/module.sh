#!/usr/bin/env bash
import.require 'provision.mono>base'
# @description The provision.mono namespace
# Installs mono
#
# @example
#   import.require 'provision.mono'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.mono'
#       }
#       some_other_module.someFunction() {
#           provision.require 'mono' || {
#               echo 'Requirement "mono" not met.'
#          }
#       }
#   }
#
# @see provision.mono.require()
provision.mono.init() {
    provision.mono.__init() {
        import.useModule 'provision.mono_base'
    }
    # @description Require the system component "mono".
    # Check to see if "mono" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'mono'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.mono.require() {
        provision.mono_base.require "$@"
    }
}
