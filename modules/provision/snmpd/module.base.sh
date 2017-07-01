#!/usr/bin/env bash
import.require 'provision'
import.require 'params'
provision.snmpd_base.init() {
    provision.snmpd_base.__init() {
          import.useModule 'provision'
          import.useModule 'params'
    }
    provision.snmpd_base.args() {
        local __configured="$(provision.snmpd_base.isConfigured; echo "$?")"
        args.add --key 'provision_snmpd_location' \
            --name 'SNMP Device Location' \
            --alias '--snmp-loc' \
            --desc 'The text to be configured as the SNMP lcoation.' \
            --required "$__configured" \
            --has-value 'y'

        args.add --key 'provision_snmpd_contact' \
            --name 'SNMP Contact' \
            --alias '--snmp-contact' \
            --desc 'The text to be configured as the SNMP contact.' \
            --required "$__configured" \
            --has-value 'y'
    }
    provision.snmpd_base.require() {
        if ! provision.isPackageInstalled 'snmpd'; then
          sudo apt-get install -y snmpd
          return $?
        fi
        if ! provision.isInstalled 'download-mibs'; then
            sudo apt-get install -y snmp-mibs-downloader || {
                logger.error --message \
                    'Could not install SNMP mibs downloader'
                return 1
            }
            sudo download-mibs || {
                logger.error --message \
                    'Could not download SNMP mibs'
                return 1
            }
        fi
        return 0
    }
    provision.snmpd_base.configure() {
        local -A __params
        __params['location']="${__args_VALS['provision_snmpd_location']}"
        __params['contact']="${__args_VALS['provision_snmpd_contact']}"
        params.get "$@"

        local __need_snmpd_restart='0'

        logger.warning --message \
            'This automated configuraion of snmpd is not hardened for security'

        logger.warning --message \
            'It should only be used inside secure and trusted networks'

        if [ ! -f /etc/snmp/snmpd.conf.bf2.orig ]; then
            sudo mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bf2.orig || {
                logger.error 'Failed to move existing snmpd configuration'
                return 1
            }
            echo "rocommunity  public" | sudo tee -a /etc/snmp/snmpd.conf
            echo "syslocation  ${__params['location']}" | sudo tee -a /etc/snmp/snmpd.conf
            echo "syscontact  ${__params['contact']}" | sudo tee -a /etc/snmp/snmpd.conf
            __need_snmpd_restart='1'
        fi

        local __conf_line="SNMPDOPTS='-Lsd -Lf /dev/null -u snmp -I -smux -p /var/run/snmpd.pid -c /etc/snmp/snmpd.conf'"
        if [ "$(grep "\"$__conf_line\"" /etc/default/snmpd | wc -l)" == '0' ]; then
            sudo sed -i 's/^SNMPDOPTS=.*/# &/' /etc/default/snmpd
            echo "${__conf_line}" | sudo tee -a /etc/snmp/snmpd.conf || {
                logger.error 'Failed to set config in "/etc/default/snmpd"'
                return 1
            }
            __need_snmpd_restart='1'
        fi

        if [ "$__need_snmpd_restart" == '1' ]; then
            sudo systemctl restart snmpd || {
                logger.error 'Failed restart snmpd'
                return 1
            }
        fi
        return 0
    }
    provision.snmpd_base.isConfigured() {
        if [ ! -f /etc/snmp/snmpd.conf.bf2.orig ]; then
            return 1
        fi
        local __conf_line="SNMPDOPTS='-Lsd -Lf /dev/null -u snmp -I -smux -p /var/run/snmpd.pid -c /etc/snmp/snmpd.conf'"
        if [ "$(grep "\"$__conf_line\"" /etc/default/snmpd | wc -l)" == '0' ]; then
            return 1
        fi
        return 0
    }
}
