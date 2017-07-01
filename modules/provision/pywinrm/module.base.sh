#!/usr/bin/env bash
import.require 'provision'
provision.pywinrm_base.init() {
    provision.pywinrm_base.__init() {
          import.useModule 'provision'
    }
    provision.pywinrm_base.require() {
        if [ $(which "pip" | wc -l) -eq 0 ];then
            sudo apt-get install -y python-pip
        fi

        if [[ $(pip list) != *"pywinrm"* ]]
        then
          pip install pywinrm
          pip install --upgrade pip
          return $?
        fi
        return 0
    }
}
