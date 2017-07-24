#!/usr/bin/env bash
import.require 'provision'
provision.expect_base.init() {
    provision.expect_base.__init() {
          import.useModule 'provision'
    }
    provision.expect_base.require() {
        if ! provision.isInstalled 'expect'; then
          sudo apt-get install -y expect
          return $?
        fi
        return 0
    }
}
