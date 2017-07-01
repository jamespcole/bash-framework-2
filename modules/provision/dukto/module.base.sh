#!/usr/bin/env bash
import.require 'provision'
provision.dukto_base.init() {
    provision.dukto_base.__init() {
          import.useModule 'provision'
    }
    provision.dukto_base.require() {
        if ! provision.isInstalled 'dukto'; then
            local __tmp_key_path
            __tmp_key_path=$(mktemp)
            wget -O "$__tmp_key_path" \
                http://download.opensuse.org/repositories/home:colomboem/xUbuntu_16.04/Release.key \
                || {
                return 1
            }
            sudo apt-key add - < "$__tmp_key_path" || {
                return 1
            }
            sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/colomboem/xUbuntu_16.04/ /' \
                >> /etc/apt/sources.list.d/dukto.list" || {
                return 1
            }
            sudo apt-get update || {
                return 1
            }
            sudo apt-get install -y dukto || {
                return 1
            }
        fi
        return 0
    }
}
