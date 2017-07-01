#!/usr/bin/env bash
import.require 'rpi.config>base'
# @description The rpi.config namespace system configuration updates
# that are specific to the Raspberry pi
#
# @example
#   import.require 'rpi.config'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'rpi.config'
#      }
#      some_other_module.someFunction() {
#         rpi.config.disableIpV6
#      }
#   }
#
# @see rpi.config.disableIpV6()
rpi.config.init() {
    rpi.config.__init() {
        import.useModule 'rpi.config_base'
    }
    # @description This disables ipv6 in the dhcpd to stop the syslog filling with
    # "dhcpcd[699]: eth0: Router Advertisement from ...." messages
    #
    # @example
    #   rpi.config.disableIpV6
    #
    #
    # @noargs
    rpi.config.disableIpV6() {
        rpi.config_base.disableIpV6 "$@"
    }
    rpi.config.isRaspberryPi() {
        rpi.config_base.isRaspberryPi "$@"
    }
    rpi.config.installKedeiLcd() {
        rpi.config_base.installKedeiLcd "$@"
    }
    rpi.config.setAutomaticUiLogin() {
        rpi.config_base.setAutomaticUiLogin "$@"
    }
    rpi.config.enableBootToBrowser() {
        rpi.config_base.enableBootToBrowser "$@"
    }
    rpi.config.disableBootToBrowser() {
        rpi.config_base.disableBootToBrowser "$@"
    }
}
