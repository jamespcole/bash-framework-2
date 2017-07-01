#!/usr/bin/env bash
import.require 'provision'
provision.unzip_base.init() {
    provision.unzip_base.__init() {
          import.useModule 'provision'
    }
    provision.unzip_base.require() {
        if ! provision.isInstalled 'unzip'; then
          sudo apt-get install -y unzip
          return $?
        fi
        return 0
    }
}
