#!/usr/bin/env bash
import.require 'provision.mailcatcher>base'
# @description The provision.mailcatcher namespace
# Installs mailcatcher
#
# @example
#   import.require 'provision.mailcatcher'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.mailcatcher'
#       }
#       some_other_module.someFunction() {
#           provision.require 'mailcatcher' || {
#               echo 'Requirement "mailcatcher" not met.'
#          }
#       }
#   }
#
# @see provision.mailcatcher.require()
provision.mailcatcher.init() {
    provision.mailcatcher.__init() {
        import.useModule 'provision.mailcatcher_base'
    }
    # @description Require the system component "mailcatcher".
    # Check to see if "mailcatcher" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'mailcatcher'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.mailcatcher.require() {
        provision.mailcatcher_base.require "$@"
    }

    provision.mailcatcher.startOnBoot() {
        provision.mailcatcher_base.startOnBoot "$@"
    }

    provision.mailcatcher.makePhpUseMailCatcher() {
        provision.mailcatcher_base.makePhpUseMailCatcher "$@"
    }

    provision.mailcatcher.startMailCatcher() {
        provision.mailcatcher_base.startMailCatcher "$@"
    }
}
