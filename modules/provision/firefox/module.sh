#!/usr/bin/env bash
import.require 'provision.firefox>base'
# @description The provision.firefox namespace
# Installs firefox
#
# @example
#   import.require 'provision.firefox'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.firefox'
#       }
#       some_other_module.someFunction() {
#           provision.require 'firefox' || {
#               echo 'Requirement "firefox" not met.'
#          }
#       }
#   }
#
# @see provision.firefox.require()
provision.firefox.init() {
    provision.firefox.__init() {
        import.useModule 'provision.firefox_base'
    }
    # @description Require the system component "firefox".
    # Check to see if "firefox" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'firefox'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.firefox.require() {
        provision.firefox_base.require "$@"
    }
}
