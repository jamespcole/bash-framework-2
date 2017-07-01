#!/usr/bin/env bash
import.require 'provision.node_env>base'
# @description The provision.node_env namespace
# Installs node_env
#
# @example
#   import.require 'provision.node_env'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.node_env'
#       }
#       some_other_module.someFunction() {
#           provision.require 'node_env' || {
#               echo 'Requirement "node_env" not met.'
#          }
#       }
#   }
#
# @see provision.node_env.require()
provision.node_env.init() {
    provision.node_env.__init() {
        import.useModule 'provision.node_env_base'
    }
    # @description Require the system component "node_env".
    # Check to see if "node_env" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'node_env' \
    #     --nvm-dir "/home/${USER}/nvmtest" \
    #     --node-version '6' \
    #   || {
    #     script.exitWithError "node_env requirement no met."
    #   }
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.node_env.require() {
        provision.node_env_base.require "$@"
    }

    provision.node_env.ensureEnv() {
        provision.node_env_base.ensureEnv "$@"
    }
}
