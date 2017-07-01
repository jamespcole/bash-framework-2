#!/usr/bin/env bash
import.require 'provision'
provision.software-properties-common_base.init() {
    provision.software-properties-common_base.__init() {
          import.useModule 'provision'
    }
    provision.software-properties-common_base.require() {
        if ! provision.isPackageInstalled 'software-properties-common'; then
          sudo apt-get install -y software-properties-common
          return $?
        fi
        return 0
    }
}
