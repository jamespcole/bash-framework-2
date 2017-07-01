#!/usr/bin/env bash
import.require 'provision.tightvncserver>base'
# @description The provision.tightvncserver namespace
# Installs tightvncserver
#
# @example
#   import.require 'provision.tightvncserver'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.tightvncserver'
#       }
#       some_other_module.someFunction() {
#           provision.require 'tightvncserver' || {
#               echo 'Requirement "tightvncserver" not met.'
#          }
#       }
#   }
#
# @see provision.tightvncserver.require()
provision.tightvncserver.init() {
    provision.tightvncserver.__init() {
        import.useModule 'provision.tightvncserver_base'
    }
    # @description Require the system component "tightvncserver".
    # Check to see if "tightvncserver" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'tightvncserver'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.tightvncserver.require() {
        provision.tightvncserver_base.require "$@"
    }
    provision.tightvncserver.startAtBootConfigured() {
        provision.tightvncserver_base.startAtBootConfigured "$@"
    }
    provision.tightvncserver.startAtBoot() {
        provision.tightvncserver_base.startAtBoot "$@"
    }
    provision.tightvncserver.setPassword() {
        provision.tightvncserver_base.setPassword "$@"
    }
    provision.tightvncserver.setPasswordConfigured() {
        provision.tightvncserver_base.setPasswordConfigured "$@"
    }
}
