#!/usr/bin/env bash
import.require 'provision.expect>base'
# @description The provision.expect namespace
# Installs expect
#
# @example
#   import.require 'provision.expect'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.expect'
#       }
#       some_other_module.someFunction() {
#           provision.require 'expect' || {
#               echo 'Requirement "expect" not met.'
#          }
#       }
#   }
#
# @see provision.expect.require()
provision.expect.init() {
    provision.expect.__init() {
        import.useModule 'provision.expect_base'
    }
    # @description Require the system component "expect".
    # Check to see if "expect" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'expect'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.expect.require() {
        provision.expect_base.require "$@"
    }
}
