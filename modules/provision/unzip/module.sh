#!/usr/bin/env bash
import.require 'provision.unzip>base'
# @description The provision.unzip namespace
# Installs unzip
#
# @example
#   import.require 'provision.unzip'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.unzip'
#       }
#       some_other_module.someFunction() {
#           provision.require 'unzip' || {
#               echo 'Requirement "unzip" not met.'
#          }
#       }
#   }
#
# @see provision.unzip.require()
provision.unzip.init() {
    provision.unzip.__init() {
        import.useModule 'provision.unzip_base'
    }
    # @description Require the system component "unzip".
    # Check to see if "unzip" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'unzip'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.unzip.require() {
        provision.unzip_base.require "$@"
    }
}
