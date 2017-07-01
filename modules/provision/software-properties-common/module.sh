#!/usr/bin/env bash
import.require 'provision.software-properties-common>base'
# @description The provision.software-properties-common namespace
# Installs software-properties-common
#
# @example
#   import.require 'provision.software-properties-common'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.software-properties-common'
#       }
#       some_other_module.someFunction() {
#           provision.require 'software-properties-common' || {
#               echo 'Requirement "software-properties-common" not met.'
#          }
#       }
#   }
#
# @see provision.software-properties-common.require()
provision.software-properties-common.init() {
    provision.software-properties-common.__init() {
        import.useModule 'provision.software-properties-common_base'
    }
    # @description Require the system component "software-properties-common".
    # Check to see if "software-properties-common" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'software-properties-common'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.software-properties-common.require() {
        provision.software-properties-common_base.require "$@"
    }
}
