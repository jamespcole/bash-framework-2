#!/usr/bin/env bash
# This is an example of inclduing the params module.
# Place require module calls at the top of the file.
# import.require 'params'
os.updates_base.init() {
    # Uncomment __init and put the declaration of any globals your module uses here.
    # Also initiliase any required modules.  If not required you can remove it.
    # os.updates_base.__init() {
    #     declare -g -A __my_global_arr
    #     import.useModule 'params'
    # }
    os.updates_base.check() {
        sudo apt-get update || {
            return 1
        }
        return 0
    }

    os.updates_base.install() {
        sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y || {
            return 1
        }
        return 0
    }

    os.updates_base.upgrade() {
        sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y || {
            return 1
        }
        return 0
    }
}
