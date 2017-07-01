#!/usr/bin/env bash
import.require 'provision.nodejs>base'
# @description The provision.nodejs namespace
# Installs nodejs
#
# @example
#   import.require 'provision.nodejs'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.nodejs'
#       }
#       some_other_module.someFunction() {
#           provision.require 'nodejs' || {
#               echo 'Requirement "nodejs" not met.'
#          }
#       }
#   }
#
# @see provision.nodejs.require()
provision.nodejs.init() {
    provision.nodejs.__init() {
        import.useModule 'provision.nodejs_base'
    }
    # @description Require the system component "nodejs".
    # Check to see if "nodejs" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'nodejs'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.nodejs.require() {
        provision.nodejs_base.require "$@"
    }
}
