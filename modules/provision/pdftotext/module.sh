#!/usr/bin/env bash
import.require 'provision.pdftotext>base'
# @description The provision.pdftotext namespace
# Installs pdftotext
#
# @example
#   import.require 'provision.pdftotext'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.pdftotext'
#       }
#       some_other_module.someFunction() {
#           provision.require 'pdftotext' || {
#               echo 'Requirement "pdftotext" not met.'
#          }
#       }
#   }
#
# @see provision.pdftotext.require()
provision.pdftotext.init() {
    provision.pdftotext.__init() {
        import.useModule 'provision.pdftotext_base'
    }
    # @description Require the system component "pdftotext".
    # Check to see if "pdftotext" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'pdftotext'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.pdftotext.require() {
        provision.pdftotext_base.require "$@"
    }
}
