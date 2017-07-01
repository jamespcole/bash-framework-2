#!/usr/bin/env bash
import.require 'provision.postgres>base'
# @description The provision.postgres namespace
# Installs postgres
#
# @example
#   import.require 'provision.postgres'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.postgres'
#       }
#       some_other_module.someFunction() {
#           provision.require 'postgres' || {
#               echo 'Requirement "postgres" not met.'
#          }
#       }
#   }
#
# @see provision.postgres.require()
provision.postgres.init() {
    provision.postgres.__init() {
        import.useModule 'provision.postgres_base'
    }
    # @description Require the system component "postgres".
    # Check to see if "postgres" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'postgres'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.postgres.require() {
        provision.postgres_base.require "$@"
    }

    provision.postgres.userExists() {
        provision.postgres_base.userExists "$@"
    }

    provision.postgres.addUser() {
        provision.postgres_base.addUser "$@"
    }

    provision.postgres.requireDb() {
        provision.postgres_base.requireDb "$@"
    }

    provision.postgres.enableQueryLog() {
        provision.postgres_base.enableQueryLog "$@"
    }

    provision.postgres.dbExists() {
        provision.postgres_base.dbExists "$@"
    }
}
