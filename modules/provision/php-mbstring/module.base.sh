#!/usr/bin/env bash
import.require 'provision'
provision.php-mbstring_base.init() {
    provision.php-mbstring_base.__init() {
          import.useModule 'provision'
    }
    provision.php-mbstring_base.require() {
        if ! provision.isInstalled 'php-mbstring'; then
          sudo apt-get install -y php-mbstring
          return $?
        fi
        return 0
    }
}
