#!/usr/bin/env bash
import.require 'provision'
provision.unclutter_base.init() {
    provision.unclutter_base.__init() {
          import.useModule 'provision'
    }
    provision.unclutter_base.require() {
        if ! provision.isPackageInstalled 'unclutter'; then
          sudo apt-get install -y unclutter
          return $?
        fi
        return 0
    }
}
