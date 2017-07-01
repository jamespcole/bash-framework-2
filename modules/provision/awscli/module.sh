#!/usr/bin/env bash
import.require 'provision.awscli>base'
# @description The provision.awscli namespace
# Installs awscli
#
# @example
#   import.require 'provision.awscli'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.awscli'
#       }
#       some_other_module.someFunction() {
#           provision.require 'awscli' || {
#               echo 'Requirement "awscli" not met.'
#          }
#       }
#   }
#
# @see provision.awscli.require()
provision.awscli.init() {
    provision.awscli.__init() {
        import.useModule 'provision.awscli_base'
    }
    # @description Require the system component "awscli".
    # Check to see if "awscli" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'awscli'
    #
    # @arg --source The source to install from, either "pip" or "apt", defaults to "pip"
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.awscli.require() {
        provision.awscli_base.require "$@"
    }
}
