#!/usr/bin/env bash
import.require 'provision'
provision.ls_base.init() {
    provision.ls_base.__init() {
          import.useModule 'provision'
    }
    provision.ls_base.require() {
        if ! provision.isInstalled 'ls'; then
          sudo apt-get install -y ls
          return $?
        fi
        return 0
    }
}
