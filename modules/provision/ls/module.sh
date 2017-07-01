#!/usr/bin/env bash
import.require 'provision.ls>base'
# @description The provision.ls namespace
# This is just for example purposes.  If you're running bash ls should be available.
#
# @example
#   import.require 'provision.ls'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.ls'
#       }
#       some_other_module.someFunction() {
#           provision.require 'ls' || {
#               echo 'Requirement "ls" not met.'
#          }
#       }
#   }
#
# @see provision.ls.require()
provision.ls.init() {
    provision.ls.__init() {
        import.useModule 'provision.ls_base'
    }
    # @description Require the system component "ls".
    # Check to see if "ls" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'ls'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode >0  If component is unavailable and installation failed.
    provision.ls.require() {
        provision.ls_base.require "$@"
    }
}
