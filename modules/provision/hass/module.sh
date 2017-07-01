#!/usr/bin/env bash
import.require 'provision.hass>base'
# @description The provision.hass namespace
# Installs hass
#
# @example
#   import.require 'provision.hass'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.hass'
#       }
#       some_other_module.someFunction() {
#           provision.require 'hass' || {
#               echo 'Requirement "hass" not met.'
#          }
#       }
#   }
#
# @see provision.hass.require()
provision.hass.init() {
    provision.hass.__init() {
        import.useModule 'provision.hass_base'
    }
    # @description Require the system component "hass".
    # Check to see if "hass" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'hass'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.hass.require() {
        provision.hass_base.require "$@"
    }
}
