#!/usr/bin/env bash
import.require 'provision'
import.require 'provision.git'

provision.rpi.wiringpi_base.init() {
    provision.rpi.wiringpi_base.__init() {
          import.useModule 'provision'
          import.useModule 'provision.git'
    }
    provision.rpi.wiringpi_base.require() {
        provision.require 'git' || {
            logger.error --message \
                'git dependency for "wiringpi" not met'
            return 1
        }
        if ! provision.isInstalled 'gpio'; then
            local __tmp_dir
            __tmp_dir="$(mktemp -d)"
            git clone git://git.drogon.net/wiringPi "$__tmp_dir"
            {
                cd "$__tmp_dir";
                git pull origin;
                ./build;
            } || {
                logger.error --message \
                    'Failed to install wiringPi'
                return 1
            }
        fi
        return 0
    }
}
