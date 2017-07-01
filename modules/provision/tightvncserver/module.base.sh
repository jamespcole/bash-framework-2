#!/usr/bin/env bash
import.require 'provision'
import.require 'params'
provision.tightvncserver_base.init() {
    provision.tightvncserver_base.__init() {
          import.useModule 'provision'
          import.useModule 'params'
    }
    provision.tightvncserver_base.require() {
        if ! provision.isPackageInstalled 'tightvncserver'; then
          sudo apt-get install -y tightvncserver
          return $?
        fi
        return 0
    }
    provision.tightvncserver_base.setPassword() {
        logger.info --message \
            'Setting tight vnc server password...'
        local -A __params
        __params['pwd']=''
        params.get "$@"
        mkdir -p "/home/${USER}/.vnc"
        echo "${__params['pwd']}" | vncpasswd -f > "/home/${USER}/.vnc/passwd"
        chmod 0600 "/home/${USER}/.vnc/passwd"
    }
    provision.tightvncserver_base.setPasswordConfigured() {
        if [ ! -f "/home/${USER}/.vnc/passwd" ]; then
            return 1
        fi
        return 0
    }
    provision.tightvncserver_base.startAtBoot() {
        logger.info --message \
            'Setting tight vnc server to start at boot...'
        mkdir -p "/home/${USER}/.config/autostart"
        echo -e \
            "[Desktop Entry]\nType=Application\nName=TightVNC\nExec=vncserver\nStartupNotify=false" \
            > "/home/${USER}/.config/autostart/tightvnc.desktop"
    }
    provision.tightvncserver_base.startAtBootConfigured() {
        if [ ! -f "/home/${USER}/.config/autostart/tightvnc.desktop" ]; then
            return 1
        fi
        return 0
    }
}
