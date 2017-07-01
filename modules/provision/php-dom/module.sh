#!/usr/bin/env bash
import.require 'provision.php-dom>base'
# @description The provision.php-dom namespace
# Installs php-dom
#
# @example
#   import.require 'provision.php-dom'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.php-dom'
#       }
#       some_other_module.someFunction() {
#           provision.require 'php-dom' || {
#               echo 'Requirement "php-dom" not met.'
#          }
#       }
#   }
#
# @see provision.php-dom.require()
provision.php-dom.init() {
    provision.php-dom.__init() {
        import.useModule 'provision.php-dom_base'
    }
    # @description Require the system component "php-dom".
    # Check to see if "php-dom" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'php-dom'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.php-dom.require() {
        provision.php-dom_base.require "$@"
    }
}
