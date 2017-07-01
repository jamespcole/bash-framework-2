import.require 'provision.unrar>base'
provision.unrar.init() {
	provision.unrar.__init() {
  		import.useModule 'provision.unrar_base'
	}
	provision.unrar.require() {
    	provision.unrar_base.require "$@"
    	return $?
	}
}
