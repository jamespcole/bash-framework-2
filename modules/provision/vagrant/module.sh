import.require 'provision.vagrant>base'
provision.vagrant.init() {
	provision.vagrant.__init() {
  		import.useModule 'provision.vagrant_base'
	}
	provision.vagrant.require() {
    	provision.vagrant_base.require "$@"
    	return $?
	}
}
