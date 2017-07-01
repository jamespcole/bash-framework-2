import.require 'provision'
provision.unrar_base.init() {
	provision.unrar_base.__init() {
  		import.useModule 'provision'
	}
	provision.unrar_base.require() {
	    if ! provision.isInstalled 'unrar'; then
	      sudo apt-get install -y unrar
	      return $?
	    fi
	    return 0
	}
}
