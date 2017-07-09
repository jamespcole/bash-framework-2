#!/usr/bin/env bash
import.require 'provision.nsq>base'
# @description The provision.nsq namespace
# Installs nsq
#
# @example
#   import.require 'provision.nsq'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.nsq'
#       }
#       some_other_module.someFunction() {
#           provision.require 'nsq' || {
#               echo 'Requirement "nsq" not met.'
#          }
#       }
#   }
#
# @see provision.nsq.require()
provision.nsq.init() {
    provision.nsq.__init() {
        import.useModule 'provision.nsq_base'
    }
    # @description Require the system component "nsq".
    # Check to see if "nsq" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'nsq'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.nsq.require() {
        provision.nsq_base.require "$@"
    }
}
