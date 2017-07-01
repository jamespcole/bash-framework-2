#!/usr/bin/env bash
import.require 'provision.xmlstarlet>base'
# @description The provision.xmlstarlet namespace
# Installs xmlstarlet
#
# @example
#   import.require 'provision.xmlstarlet'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.xmlstarlet'
#       }
#       some_other_module.someFunction() {
#           provision.require 'xmlstarlet' || {
#               echo 'Requirement "xmlstarlet" not met.'
#          }
#       }
#   }
#
# @see provision.xmlstarlet.require()
provision.xmlstarlet.init() {
    provision.xmlstarlet.__init() {
        import.useModule 'provision.xmlstarlet_base'
    }
    # @description Require the system component "xmlstarlet".
    # Check to see if "xmlstarlet" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'xmlstarlet'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.xmlstarlet.require() {
        provision.xmlstarlet_base.require "$@"
    }
}
