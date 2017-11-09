#!/usr/bin/env bash
import.require 'provision.ansible>base'
# @description The provision.ansible namespace
# Installs ansible
#
# @example
#   import.require 'provision.ansible'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.ansible'
#       }
#       some_other_module.someFunction() {
#           provision.require 'ansible' || {
#               echo 'Requirement "ansible" not met.'
#          }
#       }
#   }
#
# @see provision.ansible.require()
provision.ansible.init() {
    provision.ansible.__init() {
        import.useModule 'provision.ansible_base'
    }
    # @description Require the system component "ansible".
    # Check to see if "ansible" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'ansible'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.ansible.require() {
        provision.ansible_base.require "$@"
    }
}
