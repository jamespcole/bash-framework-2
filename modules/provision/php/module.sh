#!/usr/bin/env bash
import.require 'provision.php>base'
# @description The provision.php namespace
# Installs php
#
# @example
#   import.require 'provision.php'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.php'
#       }
#       some_other_module.someFunction() {
#           provision.require 'php' || {
#               echo 'Requirement "php" not met.'
#          }
#       }
#   }
#
# @see provision.php.require()
provision.php.init() {
    provision.php.__init() {
        import.useModule 'provision.php_base'
    }
    # @description Require the system component "php".
    # Check to see if "php" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'php'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.php.require() {
        provision.php_base.require "$@"
    }

    provision.php.requireWithExtensions() {
        provision.php_base.requireWithExtensions "$@"
    }

    # @description Enable reloading of php-fpm by a specific user.
    # Creates a sudoers file entry allowing the specified user to restart the service.
    #
    # @example
    #   provision.php.enableFpmReload \
    #        --username 'someuser'
    #
    # @arg --username - The user account to enable, defaults to the current "$USER" value
    #
    # @exitcode 0  The user was added or alreadyu had suffiecient permissions.
    # @exitcode &gt;0  The operation failed.
    provision.php.enableFpmReload() {
        provision.php_base.enableFpmReload "$@"
    }

    provision.php.fpmReload() {
        provision.php_base.fpmReload "$@"
    }
    provision.php.installPhp7PPA() {
        provision.php_base.installPhp7PPA "$@"
    }
}
