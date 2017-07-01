import.require 'provision'
provision.gawk_base.init() {
	provision.gawk_base.__init() {
  		import.useModule 'provision'
	}
	provision.gawk_base.require() {
	    if ! provision.isInstalled 'gawk'; then
	      sudo apt-get install -y gawk
	      return $?
	    fi
	    return 0
	}
}
