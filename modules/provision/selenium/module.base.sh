#!/usr/bin/env bash
import.require 'provision'
provision.selenium_base.init() {
    provision.selenium_base.__init() {
          import.useModule 'provision'
    }
    provision.selenium_base.require() {
        local __install_dir="/home/${USER}/.selenium"
        mkdir -p "${__install_dir}"
        if [ ! -f "${__install_dir}/selenium.jar" ]; then
            wget https://goo.gl/s4o9Vx -O "${__install_dir}/selenium.jar" || {
                logger.error --message \
                    'Failed to download selenium jar file'
                return 1
            }
        fi
        if [ ! -f "${__install_dir}/geckodriver" ]; then
            cd "${__install_dir}"
            wget https://github.com/mozilla/geckodriver/releases/download/v0.16.1/geckodriver-v0.16.1-linux64.tar.gz\
                -O "${__install_dir}/geckodriver.tar.gz" || {
                logger.error --message \
                    'Failed to download gecko driver'
                return 1
            }
            tar -xvzf geckodriver*.tar.gz

            chmod +x "${__install_dir}/geckodriver"
        fi
        if ! provision.isInstalled 'java'; then
            sudo apt-get install -y openjdk-9-jre-headless || {
                logger.error --message \
                    'Failed to install java'
                return 1
            }
        fi
        if ! provision.isInstalled 'xvfb-run'; then
            sudo apt-get install -y xvfb || {
                logger.error --message \
                    'Failed to instal xvfb'
            }
        fi
        return 0
    }
    provision.selenium_base.startWebdriver() {
        local __install_dir="/home/${USER}/.selenium"
        java -jar \
            -Dwebdriver.gecko.driver="${__install_dir}/geckodriver" \
            "${__install_dir}/selenium.jar"
    }
}
