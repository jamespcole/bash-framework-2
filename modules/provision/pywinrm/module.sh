#!/usr/bin/env bash
import.require 'provision.pywinrm>base'
# @description The provision.pywinrm namespace
# Installs pywinrm
#
# @example
#   import.require 'provision.pywinrm'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.pywinrm'
#       }
#       some_other_module.someFunction() {
#           provision.require 'pywinrm' || {
#               echo 'Requirement "pywinrm" not met.'
#          }
#       }
#   }
#
# @see provision.pywinrm.require()
provision.pywinrm.init() {
    provision.pywinrm.__init() {
        import.useModule 'provision.pywinrm_base'
    }
    # @description Require the system component "pywinrm".
    # Check to see if "pywinrm" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'pywinrm'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.pywinrm.require() {
        provision.pywinrm_base.require "$@"
    }
}
