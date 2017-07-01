#!/usr/bin/env bash
import.require 'provision.pyvenv>base'
# @description The provision.pyvenv namespace
# Installs pyvenv and sets up a virtual environment for python 3+ with pip.
# Optionally it will add the activation to your .bashrc for so it will be
# activate automatically on login.
#
# @example
#   import.require 'provision.pyvenv'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.pyvenv'
#       }
#       some_other_module.someFunction() {
#           provision.require 'pyvenv' --env-name p3 --add-to-bashrc 1 || {
#               echo 'Requirement "pyvenv" not met.'
#          }
#       }
#   }
#
# @see provision.pyvenv.require()
provision.pyvenv.init() {
    provision.pyvenv.__init() {
        import.useModule 'provision.pyvenv_base'
    }
    # @description Require the system component "pyvenv".
    # Check to see if "pyvenv" is installed and attempt installation if not currently available.
    # Set up a virtual environment with python 3+ and pip.
    # Add to .bashrc option.
    #
    # @example
    #   provision.require 'pyvenv' --env-name 'my-new-env' --add-to-bashrc 0
    #
    # @arg --env-name The name of the virtual environment to be created, defaults to py3
    # @arg --add-to-bashrc Pass 1 to have activation of this environment added to your .bashrc, default 0
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.pyvenv.require() {
        provision.pyvenv_base.require "$@"
    }
}
