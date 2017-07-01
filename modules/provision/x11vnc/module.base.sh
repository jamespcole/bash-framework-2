#!/usr/bin/env bash
import.require 'provision'
import.require 'params'
provision.x11vnc_base.init() {
    provision.x11vnc_base.__init() {
          import.useModule 'provision'
          import.useModule 'params'
    }
    provision.x11vnc_base.require() {
        if ! provision.isPackageInstalled 'x11vnc'; then
          sudo apt-get install -y x11vnc
          return $?
        fi
        return 0
    }
    provision.x11vnc_base.setPassword() {
        logger.info --message \
            'Setting x11 vnc server password...'
        local -A __params
        __params['pwd']=''
        params.get "$@"
        mkdir -p "/home/${USER}/.vnc"
        echo "${__params['pwd']}" | vncpasswd -f > "/home/${USER}/.vnc/passwd"
        chmod 0600 "/home/${USER}/.vnc/passwd"
    }
    provision.x11vnc_base.setPasswordConfigured() {
        if [ ! -f "/home/${USER}/.vnc/passwd" ]; then
            logger.info --verbosity 2 \
                --message \
                'x11vnc password is not configured'
            return 1
        fi
        logger.info --verbosity 2 \
            --message \
            'x11vnc password is already configured'
        return 0
    }
    provision.x11vnc_base.startAtBoot() {
        local -A __params
        __params['kiosk']='0'
        params.get "$@"
        logger.info --message \
            'Setting x11 vnc server to start at boot...'
        if [ "${__params['kiosk']}" == '0' ]; then
            mkdir -p "/home/${USER}/.config/autostart"
            echo -e \
                "[Desktop Entry]\nType=Application\nName=x11VNC\nExec=x11vnc -forever -usepw -display :0\nStartupNotify=false" \
                > "/home/${USER}/.config/autostart/x11vnc.desktop"
        else
            logger.info --verbosity 2 \
                --message \
                'x11vnc is being configured for kiosk mode'
            echo "/home/${USER}/kiosk/fs_web.sh"
            echo "x11vnc -forever -usepw -listen 0.0.0.0 -display :0" >> "/home/${USER}/kiosk/fs_web.sh"
        fi
    }
    provision.x11vnc_base.startAtBootConfigured() {
        local -A __params
        __params['kiosk']='0'
        params.get "$@"

        if [ "${__params['kiosk']}" == '0' ]; then
            if [ ! -f "/home/${USER}/.config/autostart/x11vnc.desktop" ]; then
                return 1
            fi
            return 0
        else
            grep -q '^x11vnc.*' "/home/${USER}/kiosk/fs_web.sh" || {
                logger.info --verbosity 2 \
                    --message \
                    'x11vnc is not currently configured to start at boot'
                return 1
            }
            logger.info --verbosity 2 \
                --message \
                'x11vnc is already configured to start at boot'
            return 0
        fi
    }
}
