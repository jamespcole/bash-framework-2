#!/usr/bin/env bash
import.require 'provision'
provision.memcached_base.init() {
    provision.memcached_base.__init() {
          import.useModule 'provision'
    }
    provision.memcached_base.require() {
        if ! provision.isInstalled 'memcached'; then
          sudo apt-get install -y memcached
          return $?
        fi
        return 0
    }
}
