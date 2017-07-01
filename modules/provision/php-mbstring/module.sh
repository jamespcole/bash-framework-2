#!/usr/bin/env bash
import.require 'provision.php-mbstring>base'
# @description The provision.php-mbstring namespace
# Installs php-mbstring
#
# @example
#   import.require 'provision.php-mbstring'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.php-mbstring'
#       }
#       some_other_module.someFunction() {
#           provision.require 'php-mbstring' || {
#               echo 'Requirement "php-mbstring" not met.'
#          }
#       }
#   }
#
# @see provision.php-mbstring.require()
provision.php-mbstring.init() {
    provision.php-mbstring.__init() {
        import.useModule 'provision.php-mbstring_base'
    }
    # @description Require the system component "php-mbstring".
    # Check to see if "php-mbstring" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'php-mbstring'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.php-mbstring.require() {
        provision.php-mbstring_base.require "$@"
    }
}
