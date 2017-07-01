#!/usr/bin/env bash
import.require 'provision'
provision.iceweasel_base.init() {
    provision.iceweasel_base.__init() {
        import.useModule 'provision'
    }
    provision.iceweasel_base.require() {
        if ! provision.isInstalled 'iceweasel'; then
            sudo apt-get install -y \
                iceweasel \
                fonts-stix \
                otf-stix \
                fonts-lmodern \
                mozplugger \
                libgnomeui-0 \
            || {
                return 1
            }
        fi
        return 0
    }
}
