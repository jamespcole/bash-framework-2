#!/usr/bin/env bash
import.require 'provision.snmpd>base'
# @description The provision.snmpd namespace
# Installs snmpd
#
# @example
#   import.require 'provision.snmpd'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.snmpd'
#       }
#       some_other_module.someFunction() {
#           provision.require 'snmpd' || {
#               echo 'Requirement "snmpd" not met.'
#          }
#       }
#   }
#
# @see provision.snmpd.require()
provision.snmpd.init() {
    provision.snmpd.__init() {
        import.useModule 'provision.snmpd_base'
    }
    # @description Require the system component "snmpd".
    # Check to see if "snmpd" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'snmpd'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.snmpd.require() {
        provision.snmpd_base.require "$@"
    }

    # @description Configure the system component "snmpd".
    # Create a basic configuration for snmp.
    # NOTE: the configuration is not security hardened and should only be
    # used on secure and trusted networks.
    #
    # @example
    #   provision.snmpd.configure \
    #       --location 'some place' \
    #       --contact 'admin@email.com'
    #
    # @arg --location This is the location string that will be returned in SNMP responses
    # @arg --contact This is the contact string that will be returned in SNMP responses
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.snmpd.configure() {
        provision.snmpd_base.configure "$@"
    }
    provision.snmpd.isConfigured() {
        provision.snmpd_base.isConfigured "$@"
    }
    provision.snmpd.args() {
        provision.snmpd_base.args "$@"
    }
}
