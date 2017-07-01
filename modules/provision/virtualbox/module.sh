import.require 'provision.virtualbox>base'
provision.virtualbox.init() {
	provision.virtualbox.__init() {
  		import.useModule 'provision.virtualbox_base'
	}
	provision.virtualbox.require() {
    	provision.virtualbox_base.require "$@"
    	return $?
	}
}
