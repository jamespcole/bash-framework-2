#!/usr/bin/env bash
import.require 'provision'
provision.sqsh_base.init() {
    provision.sqsh_base.__init() {
          import.useModule 'provision'
    }
    provision.sqsh_base.require() {
        if ! provision.isInstalled 'sqsh'; then
          sudo apt-get install -y sqsh
          return $?
        fi
        return 0
    }
}
