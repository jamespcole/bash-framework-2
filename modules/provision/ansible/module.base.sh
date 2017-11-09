#!/usr/bin/env bash
import.require 'provision'
import.require 'provision.software-properties-common'

provision.ansible_base.init() {
    provision.ansible_base.__init() {
          import.useModule 'provision'
          import.useModule 'provision.software-properties-common'
    }
    provision.ansible_base.require() {
        if ! provision.isInstalled 'ansible'; then
           provision.require 'software-properties-common' || {
               return "?"
           }
           sudo apt-add-repository -y -u ppa:ansible/ansible || {
               logger.error --message \
                'Failed to install ansible ppa...'
               return "?"
           }
           sudo apt-get install -y ansible
           return $?
        fi
        return 0
    }
}
