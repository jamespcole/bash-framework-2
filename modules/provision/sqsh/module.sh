#!/usr/bin/env bash
import.require 'provision.sqsh>base'
# @description The provision.sqsh namespace
# Installs sqsh
#
# @example
#   import.require 'provision.sqsh'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.sqsh'
#       }
#       some_other_module.someFunction() {
#           provision.require 'sqsh' || {
#               echo 'Requirement "sqsh" not met.'
#          }
#       }
#   }
#
# @see provision.sqsh.require()
provision.sqsh.init() {
    provision.sqsh.__init() {
        import.useModule 'provision.sqsh_base'
    }
    # @description Require the system component "sqsh".
    # Check to see if "sqsh" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'sqsh'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.sqsh.require() {
        provision.sqsh_base.require "$@"
    }
}
