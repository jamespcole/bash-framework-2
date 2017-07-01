#!/usr/bin/env bash
import.require 'provision'
provision.phantomjs_base.init() {
    provision.phantomjs_base.__init() {
          import.useModule 'provision'
    }
    provision.phantomjs_base.require() {
        if ! provision.isInstalled 'phantomjs'; then
        #   sudo apt-get install -y phantomjs
            npm install -g phantomjs-prebuilt
            return $?
        fi
        # if ! provision.isInstalled 'phantomjs'; then
        #   sudo apt-get install xvfb -y
        #   return $?
        # fi
        return 0
    }
    provision.phantomjs_base.startWebdriver() {
        # xvfb-run phantomjs --webdriver=4444
        phantomjs --webdriver=4444
    }
}
