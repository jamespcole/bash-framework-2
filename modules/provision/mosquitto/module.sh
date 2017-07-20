#!/usr/bin/env bash
import.require 'provision.mosquitto>base'
# @description The provision.mosquitto namespace
# Installs mosquitto
#
# @example
#   import.require 'provision.mosquitto'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.mosquitto'
#       }
#       some_other_module.someFunction() {
#           provision.require 'mosquitto' || {
#               echo 'Requirement "mosquitto" not met.'
#          }
#       }
#   }
#
# @see provision.mosquitto.require()
provision.mosquitto.init() {
    provision.mosquitto.__init() {
        import.useModule 'provision.mosquitto_base'
    }
    # @description Require the system component "mosquitto".
    # Check to see if "mosquitto" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'mosquitto'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.mosquitto.require() {
        provision.mosquitto_base.require "$@"
    }

    provision.mosquittorequireClients() {
    	provision.mosquitto_base.requireClients	"$@"
    }
}
