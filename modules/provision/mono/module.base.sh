#!/usr/bin/env bash
import.require 'provision'
provision.mono_base.init() {
    provision.mono_base.__init() {
          import.useModule 'provision'
    }
    provision.mono_base.require() {
        if ! provision.isInstalled 'mono'; then
          sudo apt-get install -y mono
          return $?
        fi
        return 0
    }
}
