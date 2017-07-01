#!/usr/bin/env bash
import.require 'provision.phantomjs>base'
# @description The provision.phantomjs namespace
# Installs phantomjs
#
# @example
#   import.require 'provision.phantomjs'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.phantomjs'
#       }
#       some_other_module.someFunction() {
#           provision.require 'phantomjs' || {
#               echo 'Requirement "phantomjs" not met.'
#          }
#       }
#   }
#
# @see provision.phantomjs.require()
provision.phantomjs.init() {
    provision.phantomjs.__init() {
        import.useModule 'provision.phantomjs_base'
    }
    # @description Require the system component "phantomjs".
    # Check to see if "phantomjs" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'phantomjs'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.phantomjs.require() {
        provision.phantomjs_base.require "$@"
    }
}
