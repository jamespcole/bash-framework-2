#!/usr/bin/env bash
import.require 'provision.memcached>base'
# @description The provision.memcached namespace
# Installs memcached
#
# @example
#   import.require 'provision.memcached'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.memcached'
#       }
#       some_other_module.someFunction() {
#           provision.require 'memcached' || {
#               echo 'Requirement "memcached" not met.'
#          }
#       }
#   }
#
# @see provision.memcached.require()
provision.memcached.init() {
    provision.memcached.__init() {
        import.useModule 'provision.memcached_base'
    }
    # @description Require the system component "memcached".
    # Check to see if "memcached" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'memcached'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.memcached.require() {
        provision.memcached_base.require "$@"
    }
}
