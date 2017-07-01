#!/usr/bin/env bash
import.require 'provision'
provision.hass_base.init() {
    provision.hass_base.__init() {
          import.useModule 'provision'
    }
    provision.hass_base.require() {
        if ! provision.isInstalled 'hass'; then
          pip install homeassistant
          return $?
        fi
        return 0
    }
}
