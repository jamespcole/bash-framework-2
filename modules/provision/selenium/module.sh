#!/usr/bin/env bash
import.require 'provision.selenium>base'
# @description The provision.selenium namespace
# Installs selenium
#
# @example
#   import.require 'provision.selenium'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.selenium'
#       }
#       some_other_module.someFunction() {
#           provision.require 'selenium' || {
#               echo 'Requirement "selenium" not met.'
#          }
#       }
#   }
#
# @see provision.selenium.require()
provision.selenium.init() {
    provision.selenium.__init() {
        import.useModule 'provision.selenium_base'
    }
    # @description Require the system component "selenium".
    # Check to see if "selenium" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'selenium'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.selenium.require() {
        provision.selenium_base.require "$@"
    }
}
