#!/usr/bin/env bash
import.require 'provision'
provision.php-dom_base.init() {
    provision.php-dom_base.__init() {
          import.useModule 'provision'
    }
    provision.php-dom_base.require() {
        if ! provision.isInstalled 'php-dom'; then
          sudo apt-get install -y php-dom
          return $?
        fi
        return 0
    }
}
