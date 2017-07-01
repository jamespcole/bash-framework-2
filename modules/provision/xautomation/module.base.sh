#!/usr/bin/env bash
import.require 'provision'
provision.xautomation_base.init() {
    provision.xautomation_base.__init() {
          import.useModule 'provision'
    }
    provision.xautomation_base.require() {
        if ! provision.isPackageInstalled 'xautomation'; then
          sudo apt-get install -y xautomation
          return $?
        fi
        return 0
    }
}
