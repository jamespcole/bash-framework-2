#!/usr/bin/env bash
import.require 'provision'
provision.firefox_base.init() {
    provision.firefox_base.__init() {
          import.useModule 'provision'
    }
    provision.firefox_base.require() {
        if ! provision.isInstalled 'firefox'; then
          sudo apt-get install -y firefox
          return $?
        fi
        return 0
    }
}
