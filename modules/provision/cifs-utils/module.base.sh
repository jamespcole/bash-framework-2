#!/usr/bin/env bash
import.require 'provision'
provision.cifs-utils_base.init() {
    provision.cifs-utils_base.__init() {
          import.useModule 'provision'
    }
    provision.cifs-utils_base.require() {
        if ! provision.isInstalled 'cifs-utils'; then
          sudo apt-get install -y cifs-utils
          return $?
        fi
        return 0
    }
}
