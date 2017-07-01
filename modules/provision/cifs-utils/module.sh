#!/usr/bin/env bash
import.require 'provision.cifs-utils>base'
# @description The provision.cifs-utils namespace
# Installs cifs-utils
#
# @example
#   import.require 'provision.cifs-utils'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.cifs-utils'
#       }
#       some_other_module.someFunction() {
#           provision.require 'cifs-utils' || {
#               echo 'Requirement "cifs-utils" not met.'
#          }
#       }
#   }
#
# @see provision.cifs-utils.require()
provision.cifs-utils.init() {
    provision.cifs-utils.__init() {
        import.useModule 'provision.cifs-utils_base'
    }
    # @description Require the system component "cifs-utils".
    # Check to see if "cifs-utils" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'cifs-utils'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.cifs-utils.require() {
        provision.cifs-utils_base.require "$@"
    }
}
