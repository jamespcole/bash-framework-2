#!/usr/bin/env bash
import.require 'provision.mssql>base'
# @description The provision.mssql namespace
# Installs mssql
#
# @example
#   import.require 'provision.mssql'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.mssql'
#       }
#       some_other_module.someFunction() {
#           provision.require 'mssql' || {
#               echo 'Requirement "mssql" not met.'
#          }
#       }
#   }
#
# @see provision.mssql.require()
provision.mssql.init() {
    provision.mssql.__init() {
        import.useModule 'provision.mssql_base'
    }
    # @description Require the system component "mssql".
    # Check to see if "mssql" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'mssql'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.mssql.require() {
        provision.mssql_base.require "$@"
    }
}
