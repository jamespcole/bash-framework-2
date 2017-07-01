#!/usr/bin/env bash
import.require 'provision'
provision.apg_base.init() {
    provision.apg_base.__init() {
          import.useModule 'provision'
    }
    provision.apg_base.require() {
        if ! provision.isInstalled 'apg'; then
          sudo apt-get install -y apg
          return $?
        fi
        return 0
    }
}
