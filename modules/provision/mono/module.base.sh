#!/usr/bin/env bash
import.require 'provision'
provision.mono_base.init() {
    provision.mono_base.__init() {
          import.useModule 'provision'
    }
    provision.mono_base.require() {
        if provision.isInstalled 'mono'; then
            return 0
        fi
        provision.mono.addPpa || {
            logger.error --message \
                'Failed to ad mono ppa'
            return 1
        }

        sudo apt-get install -y mono-complete || {
            logger.error --message \
                'Failed to install mono-complete'
            return 1
        }

        sudo apt-get install -y mono-xsp4 || {
            logger.error --message \
                'Failed to install mono-xsp4'
            return 1
        }

        return 0
    }

    provision.mono_base.xsp() {

        provision.mono.addPpa || {
            logger.error --message \
                'Failed to ad mono ppa'
            return 1
        }

        sudo apt-get install -y mono-xsp4 || {
            logger.error --message \
                'Failed to install mono-xsp4'
            return 1
        }

        return 0
    }

    provision.mono_base.addPpa() {
        if [ -f '/etc/apt/sources.list.d/mono-official.list' ]; then
            return 0
        fi

        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
            --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
        || {
            logger.error --message \
                'Failed update add mono ppa'
            return 1
        }
        echo "deb http://download.mono-project.com/repo/ubuntu xenial main" \
            | sudo tee /etc/apt/sources.list.d/mono-official.list

        sudo apt-get update || {
            logger.error --message \
                'Failed update apt-cache'
            return 1
        }
        return 0
    }
}
