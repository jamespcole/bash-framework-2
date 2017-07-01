#!/usr/bin/env bash
import.require 'provision.php-curl>base'
# @description The provision.php-curl namespace
# Installs php-curl
#
# @example
#   import.require 'provision.php-curl'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.php-curl'
#       }
#       some_other_module.someFunction() {
#           provision.require 'php-curl' || {
#               echo 'Requirement "php-curl" not met.'
#          }
#       }
#   }
#
# @see provision.php-curl.require()
provision.php-curl.init() {
    provision.php-curl.__init() {
        import.useModule 'provision.php-curl_base'
    }
    # @description Require the system component "php-curl".
    # Check to see if "php-curl" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'php-curl'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.php-curl.require() {
        provision.php-curl_base.require "$@"
    }
}
