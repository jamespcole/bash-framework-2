#!/usr/bin/env bash
import.require 'provision'
provision.figlet_base.init() {
    provision.figlet_base.__init() {
          import.useModule 'provision'
    }
    provision.figlet_base.require() {
        if ! provision.isInstalled 'figlet'; then
          sudo apt-get install -y figlet
          return $?
        fi
        return 0
    }
}
