#!/usr/bin/env bash
import.require 'provision'
provision.update_motd_base.init() {
    provision.update_motd_base.__init() {
          import.useModule 'provision'
    }
    provision.update_motd_base.require() {
        if ! provision.isInstalled 'update_motd'; then
          sudo apt-get install -y update_motd
          return $?
        fi
        return 0
    }
}
