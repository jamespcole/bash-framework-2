#!/usr/bin/env bash
import.require 'provision'
provision.php-curl_base.init() {
    provision.php-curl_base.__init() {
          import.useModule 'provision'
    }
    provision.php-curl_base.require() {
        if ! provision.isInstalled 'php-curl'; then
          sudo apt-get install -y php-curl
          return $?
        fi
        return 0
    }
}
