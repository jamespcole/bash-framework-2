#!/usr/bin/env bash
import.require 'provision'
provision.xmlstarlet_base.init() {
    provision.xmlstarlet_base.__init() {
          import.useModule 'provision'
    }
    provision.xmlstarlet_base.require() {
        if ! provision.isInstalled 'xmlstarlet'; then
          sudo apt-get install -y xmlstarlet
          return $?
        fi
        return 0
    }
}
