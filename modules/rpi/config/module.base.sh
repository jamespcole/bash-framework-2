#!/usr/bin/env bash
# This is an example of inclduing the params module.
# Place require module calls at the top of the file.
import.require 'params'
import.require 'provision.xautomation'
import.require 'provision.unclutter'
vendor.wrap 'mo/mo' 'vendor.include.mo'
rpi.config_base.init() {
    # Uncomment __init and put the declaration of any globals your module uses here.
    # Also initiliase any required modules.  If not required you can remove it.
    rpi.config_base.__init() {
        import.useModule 'params'
        import.useModule 'provision.xautomation'
        import.useModule 'provision.unclutter'
        vendor.include.mo
    }
    rpi.config_base.disableIpV6() {
        if [ "$(grep '^noipv6rs$' /etc/dhcpcd.conf | wc -l)" == '0' ]; then
            echo -e "\nnoipv6rs" | sudo tee -a /etc/dhcpcd.conf
            logger.info --verbosity 2 \
                --message 'Added "noipv6rs" to "/etc/dhcpcd.conf" to stop syslog flooding'
        else
            logger.info --verbosity 3 \
                --message '"noipv6rs" is already set in "/etc/dhcpcd.conf" to avoid syslog flooding'
        fi
    }
    rpi.config_base.isRaspberryPi() {
        grep -q BCM2708 /proc/cpuinfo
        return "$?"
    }
    rpi.config_base.installKedeiLcd() {
        # Find useful info about the kedei LCD at these URLs:
        # http://www.waveshare.com/wiki/3.5inch_RPi_LCD_(A)
        # http://kedei.net/raspberry/raspberry.html
        if rpi.config.isRaspberryPi; then
            local __bu_path="/home/${USER}/.kedeiLCD"
            if [ -f "${__bu_path}/backup/kernel.img" ]; then
                logger.error --message \
                    "Kedei LCD already installed, if you wish to resinstall delete the directory \"${__bu_path}\" and re-run this command."
                return 0
            fi
            local __tmp_location
            __tmp_location="$(mktemp -d)"

            cd "${__tmp_location}"
            wget -nv https://www.dropbox.com/s/lfwv8ro1ysbvrre/LCD_show_v6_1_2.tar.gz?dl=0 -O "${__tmp_location}/LCD_show_v6_1_2.tar.gz" || {
                logger.error --message \
                    'Failed to download Kedei LCD files'
                return 1
            }
            tar -xvzf "${__tmp_location}/LCD_show_v6_1_2.tar.gz" || {
                logger.error --message \
                    'Failed extract Kedei LCD files'
                return 1
            }
            chmod +x "${__tmp_location}/LCD_show_v6_1_2/LCD_backup"
            chmod +x "${__tmp_location}/LCD_show_v6_1_2/LCD35_v"

            cd "${__tmp_location}/LCD_show_v6_1_2"
            logger.info 'Backing up current kernel...'
            ./LCD_backup || {
                logger.error --message \
                    'Failed backup kernel files'
                return 1
            }
            mkdir -p "$__bu_path"
            cp -r backup "$__bu_path" || {
                logger.error --message \
                    'Failed copy backup of kernel files'
                return 1
            }
            logger.info 'Installing Kedei kernel...'
            ./LCD35_v || {
                logger.error --message \
                    'Failed install kernel files'
                return 1
            }

        else
            logger.warning --message \
                'Kedei LCD could not be installed because this machine does not seem to be a Raspberry pi'
        fi
        return 0
    }
    rpi.config_base.setAutomaticUiLogin() {
        local -A __params
        __params['user']="$USER"
        params.get "$@"

        grep -q "^autologin-user=${__params['user']}" /etc/lightdm/lightdm.conf && {
            logger.info --message \
                "The user \"${__params['user']}\" is already set to auto login"
            return 0
        }

        if [ ! -e /etc/init.d/lightdm ]; then
            logger.error --message \
                'lightdm must be installed to configure automatic UI login'
            return 1
        fi
        id -u "${__params['user']}" > /dev/null 2>&1 || {
            logger.error --message \
                "The user \"${__params['user']}\" could not be found"
            return 1
        }
        local __systemd=0
        if command -v systemctl > /dev/null && sudo systemctl | grep -q '\-\.mount'; then
            __systemd=1
        fi

        if [ $__systemd -eq 1 ]; then
            sudo systemctl set-default graphical.target
            sudo ln -fs /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
        else
            sudo update-rc.d lightdm enable 2
        fi

        sudo sed /etc/lightdm/lightdm.conf -i -e 's/^#\(autologin-user=.*\)/\1/'
        sudo sed /etc/lightdm/lightdm.conf -i -e "s/^autologin-user=.*/autologin-user=${__params['user']}/"
        # disable_raspi_config_at_boot

    }
    rpi.config_base.enableBootToBrowser() {
        local -A __params
        __params['user']="$USER"
        params.get "$@"

        local __kiosk_dir="/home/${__params['user']}/kiosk"
        mkdir -p "${__kiosk_dir}"

        provision.require 'xautomation' || {
            return 1
        }

        provision.require 'unclutter' || {
            return 1
        }

        rpi.config_base.writeAutoLoginFile \
            --user "${__params['user']}"

        sudo systemctl set-default multi-user.target
        if [ "$(readlink -f /etc/systemd/system/getty.target.wants/getty@tty1.service)" != "/etc/systemd/system/user_autologin@.service" ]; then
            logger.info --message \
                'Boot to browser(kiosk) mode already enabled'

            sudo ln -fs /etc/systemd/system/user_autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
        fi

        mkdir -p "${__kiosk_dir}"
        cat <<\EOF > "${__kiosk_dir}/openbox_rc.xml"
<?xml version="1.0" encoding="UTF-8"?>
<openbox_config xmlns="http://openbox.org/3.4/rc"
    xmlns:xi="http://www.w3.org/2001/XInclude">
<applications>
  <application name="squeak" type="normal">
    <focus>yes</focus>
    <fullscreen>yes</fullscreen>
  </application>
</applications>
</openbox_config>
EOF

        echo "#!/bin/sh" > "${__kiosk_dir}/kiosk.sh"
        echo "openbox --config-file ${__kiosk_dir}/openbox_rc.xml --startup '${__kiosk_dir}/fs_web.sh'" \
             >> "${__kiosk_dir}/kiosk.sh"

        chmod a+x "${__kiosk_dir}/kiosk.sh"

        echo "#!/bin/sh" > "${__kiosk_dir}/fs_web.sh"
        echo "epiphany -a -i --profile /home/${__params['user']}/.config 'http://www.google.com' &" \
            >> "${__kiosk_dir}/fs_web.sh"
        echo "sleep 15s;" \
            >> "${__kiosk_dir}/fs_web.sh"
        echo 'xte "key F11"' \
            >> "${__kiosk_dir}/fs_web.sh"

        chmod a+x "${__kiosk_dir}/fs_web.sh"

        rpi.config_base.writeLocalRc --user "${__params['user']}"
    }

    rpi.config_base.disableBootToBrowser() {
        echo 'Not implemented "rpi.config_base.disableBootToBrowser"'
    }

    rpi.config_base.writeLocalRc() {
        local -A __params
        __params['user']="$USER"
        params.get "$@"

        local __auto_login_user="${__params['user']}"

        local __tmp_file="$(mktemp)"

        cat << EOF | mo > "${__tmp_file}"
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# Print the IP address
_IP=\$(hostname -I) || true
if [ "\$_IP" ]; then
  printf "My IP address is %s\n" "\$_IP"
fi

sleep 15
su -l {{__auto_login_user}} -c "sudo xinit /home/{{__auto_login_user}}/kiosk/kiosk.sh -- -nocursor"

exit 0
EOF

        sudo cp "${__tmp_file}" /etc/rc.local
        sudo chmod +x /etc/rc.local
    }


    rpi.config_base.writeAutoLoginFile() {
        local -A __params
        __params['user']="$USER"
        params.get "$@"

        local __auto_login_user="${__params['user']}"
        # if [ ! -e ]
        # sudo cat <<\EOF > /etc/profile.d/boottoscratch.sh
        # sudo cat <<EOF > /tmp/boottoscratch.sh
        if [ -f /etc/systemd/system/user_autologin@.service ]; then
            return
        fi
        local __tmp_file="$(mktemp)"

        cat <<EOF | mo > "${__tmp_file}"
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

[Unit]
Description=Getty on %I
Documentation=man:agetty(8) man:systemd-getty-generator(8)
Documentation=http://0pointer.de/blog/projects/serial-console.html
After=systemd-user-sessions.service plymouth-quit-wait.service
After=rc-local.service

# If additional gettys are spawned during boot then we should make
# sure that this is synchronized before getty.target, even though
# getty.target didn't actually pull it in.
Before=getty.target
IgnoreOnIsolate=yes

# On systems without virtual consoles, don't start any getty. Note
# that serial gettys are covered by serial-getty@.service, not this
# unit.
ConditionPathExists=/dev/tty0

[Service]
# the VT is cleared by TTYVTDisallocate
ExecStart=-/sbin/agetty --autologin {{__auto_login_user}} --noclear %I \$TERM
Type=idle
Restart=always
RestartSec=0
UtmpIdentifier=%I
TTYPath=/dev/%I
TTYReset=yes
TTYVHangup=yes
TTYVTDisallocate=yes
KillMode=process
IgnoreSIGPIPE=no
SendSIGHUP=yes

# Unset locale for the console getty since the console has problems
# displaying some internationalized messages.
Environment=LANG= LANGUAGE= LC_CTYPE= LC_NUMERIC= LC_TIME= LC_COLLATE= LC_MONETARY= LC_MESSAGES= LC_PAPER= LC_NAME= LC_ADDRESS= LC_TELEPHONE= LC_MEASUREMENT= LC_IDENTIFICATION=

[Install]
WantedBy=getty.target
DefaultInstance=tty1
EOF
        sudo cp "$__tmp_file" /etc/systemd/system/user_autologin@.service
    }
}
