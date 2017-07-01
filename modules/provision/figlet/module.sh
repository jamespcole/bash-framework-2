#!/usr/bin/env bash
import.require 'provision.figlet>base'
# @description The provision.figlet namespace
# Installs figlet
#
# @example
#   import.require 'provision.figlet'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.figlet'
#       }
#       some_other_module.someFunction() {
#           provision.require 'figlet' || {
#               echo 'Requirement "figlet" not met.'
#          }
#       }
#   }
#
# @see provision.figlet.require()
provision.figlet.init() {
    provision.figlet.__init() {
        import.useModule 'provision.figlet_base'
    }
    # @description Require the system component "figlet".
    # Check to see if "figlet" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'figlet'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.figlet.require() {
        provision.figlet_base.require "$@"
    }
}
