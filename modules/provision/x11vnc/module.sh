#!/usr/bin/env bash
import.require 'provision.x11vnc>base'
# @description The provision.x11vnc namespace
# Installs x11vnc
#
# @example
#   import.require 'provision.x11vnc'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.x11vnc'
#       }
#       some_other_module.someFunction() {
#           provision.require 'x11vnc' || {
#               echo 'Requirement "x11vnc" not met.'
#          }
#       }
#   }
#
# @see provision.x11vnc.require()
provision.x11vnc.init() {
    provision.x11vnc.__init() {
        import.useModule 'provision.x11vnc_base'
    }
    # @description Require the system component "x11vnc".
    # Check to see if "x11vnc" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'x11vnc'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.x11vnc.require() {
        provision.x11vnc_base.require "$@"
    }
    provision.x11vnc.startAtBootConfigured() {
        provision.x11vnc_base.startAtBootConfigured "$@"
    }
    provision.x11vnc.startAtBoot() {
        provision.x11vnc_base.startAtBoot "$@"
    }
    provision.x11vnc.setPassword() {
        provision.x11vnc_base.setPassword "$@"
    }
    provision.x11vnc.setPasswordConfigured() {
        provision.x11vnc_base.setPasswordConfigured "$@"
    }
}
