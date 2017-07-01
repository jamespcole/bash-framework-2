import.require 'provision'
provision.virtualbox_base.init() {
	provision.virtualbox_base.__init() {
  		import.useModule 'provision'
	}
	provision.virtualbox_base.require() {
	    if ! provision.isInstalled 'virtualbox'; then
            pushd
            cd "$(mktemp -d)"
			wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc || {
                return 1
            }
            sudo apt-key add oracle_vbox_2016.asc || {
                return 1
            }
            popd
            sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -c -s) non-free contrib" >> /etc/apt/sources.list.d/virtualbox.org.list' || {
                return 1
            }
            sudo apt-get update || {
                return 1
            }
            sudo apt-get install -y virtualbox-5.0 || {
                return 1
            }
	    fi
        if ! provision.isPackageInstalled 'virtualbox-dkms'; then
            sudo apt-get install -y virtualbox-dkms || {
                return 1
            }
        fi
	    return 0
	}
}
