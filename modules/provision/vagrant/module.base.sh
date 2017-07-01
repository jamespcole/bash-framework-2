import.require 'provision'
provision.vagrant_base.init() {
	provision.vagrant_base.__init() {
  		import.useModule 'provision'
	}
	provision.vagrant_base.require() {
	    if ! provision.isInstalled 'vagrant'; then
			pushd
			cd "$(mktemp -d)"
			wget https://releases.hashicorp.com/vagrant/1.8.4/vagrant_1.8.4_x86_64.deb || return $?
			sudo dpkg -i vagrant_*.deb
			popd
			sudo apt-get install -y nfs-common nfs-kernel-server || {
				return $?
			}
			return $?
	    fi
	    return 0
	}
}
