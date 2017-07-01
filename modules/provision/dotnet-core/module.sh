#!/usr/bin/env bash
import.require 'provision.dotnet-core>base'
# @description The provision.dotnet-core namespace
# Installs dotnet-core
#
# @example
#   import.require 'provision.dotnet-core'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.dotnet-core'
#       }
#       some_other_module.someFunction() {
#           provision.require 'dotnet-core' || {
#               echo 'Requirement "dotnet-core" not met.'
#          }
#       }
#   }
#
# @see provision.dotnet-core.require()
provision.dotnet-core.init() {
    provision.dotnet-core.__init() {
        import.useModule 'provision.dotnet-core_base'
    }
    # @description Require the system component "dotnet-core".
    # Check to see if "dotnet-core" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'dotnet-core'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.dotnet-core.require() {
        provision.dotnet-core_base.require "$@"
    }
}
