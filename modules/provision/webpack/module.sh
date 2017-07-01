#!/usr/bin/env bash
import.require 'provision.webpack>base'
# @description The provision.webpack namespace
# Installs webpack
#
# @example
#   import.require 'provision.webpack'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.webpack'
#       }
#       some_other_module.someFunction() {
#           provision.require 'webpack' || {
#               echo 'Requirement "webpack" not met.'
#          }
#       }
#   }
#
# @see provision.webpack.require()
provision.webpack.init() {
    provision.webpack.__init() {
        import.useModule 'provision.webpack_base'
    }
    # @description Require the system component "webpack".
    # Check to see if "webpack" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'webpack'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.webpack.require() {
        provision.webpack_base.require "$@"
    }
}
