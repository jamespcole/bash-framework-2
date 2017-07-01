#!/usr/bin/env bash
import.require 'provision.nginx>base'
# @description The provision.nginx namespace
# Installs nginx
#
# @example
#   import.require 'provision.nginx'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.nginx'
#       }
#       some_other_module.someFunction() {
#           provision.require 'nginx' || {
#               echo 'Requirement "nginx" not met.'
#          }
#       }
#   }
#
# @see provision.nginx.require()
provision.nginx.init() {
    provision.nginx.__init() {
        import.useModule 'provision.nginx_base'
    }
    # @description Require the system component "nginx".
    # Check to see if "nginx" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'nginx'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.nginx.require() {
        provision.nginx_base.require "$@"
    }

    # @description Require the system component "nginx".
    # Check to see if "nginx" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'nginx'
    #
    # @arg --port The port number to run the site on(defaults to "80")
    # @arg --path The path of the site root directory(defaults to "/var/www/html")
    # @arg --site-name The name of the site(defaults to "site-name")
    #
    # @exitcode 0  If component is available.
    # @exitcode &gt;0  If component is unavailable and installation failed.
    provision.nginx.createSite() {
        provision.nginx_base.createSite "$@"
    }

    provision.nginx.restart() {
        provision.nginx_base.restart "$@"
    }

    provision.nginx.clearAllSites() {
        provision.nginx_base.clearAllSites "$@"
    }

    provision.nginx.disableSendFile() {
        provision.nginx_base.disableSendFile "$@"
    }

    provision.nginx.createLaravelSite() {
        provision.nginx_base.createLaravelSite "$@"
    }

    provision.nginx.getGzipSettings() {
        provision.nginx_base.getGzipSettings "$@"
    }

    provision.nginx.createNonDefaultSiteConfig() {
        provision.nginx_base.createNonDefaultSiteConfig "$@"
    }
}
