#!/usr/bin/env bash
import.require 'provision.babel>base'
# @description The provision.babel namespace
# Installs babel
#
# @example
#   import.require 'provision.babel'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.babel'
#       }
#       some_other_module.someFunction() {
#           provision.require 'babel' || {
#               echo 'Requirement "babel" not met.'
#          }
#       }
#   }
#
# @see provision.babel.require()
provision.babel.init() {
    provision.babel.__init() {
        import.useModule 'provision.babel_base'
    }
    # @description Require the system component "babel".
    # Check to see if "babel" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'babel'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.babel.require() {
        provision.babel_base.require "$@"
    }
}
