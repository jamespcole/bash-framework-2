#!/usr/bin/env bash
import.require 'provision.rpi.wiringpi>base'
# @description The provision.rpi.wiringpi namespace
# Installs rpi.wiringpi
#
# @example
#   import.require 'provision.rpi.wiringpi'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.rpi.wiringpi'
#       }
#       some_other_module.someFunction() {
#           provision.require 'rpi.wiringpi' || {
#               echo 'Requirement "rpi.wiringpi" not met.'
#          }
#       }
#   }
#
# @see provision.rpi.wiringpi.require()
provision.rpi.wiringpi.init() {
    provision.rpi.wiringpi.__init() {
        import.useModule 'provision.rpi.wiringpi_base'
    }
    # @description Require the system component "rpi.wiringpi".
    # Check to see if "rpi.wiringpi" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'rpi.wiringpi'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.rpi.wiringpi.require() {
        provision.rpi.wiringpi_base.require "$@"
    }
}
