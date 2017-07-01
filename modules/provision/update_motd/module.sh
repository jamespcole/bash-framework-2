#!/usr/bin/env bash
import.require 'provision.update_motd>base'
# @description The provision.update_motd namespace
# Installs update_motd
#
# @example
#   import.require 'provision.update_motd'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.update_motd'
#       }
#       some_other_module.someFunction() {
#           provision.require 'update_motd' || {
#               echo 'Requirement "update_motd" not met.'
#          }
#       }
#   }
#
# @see provision.update_motd.require()
provision.update_motd.init() {
    provision.update_motd.__init() {
        import.useModule 'provision.update_motd_base'
    }
    # @description Require the system component "update_motd".
    # Check to see if "update_motd" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'update_motd'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode >0  If component is unavailable and installation failed.
    provision.update_motd.require() {
        provision.update_motd_base.require "$@"
    }
}
