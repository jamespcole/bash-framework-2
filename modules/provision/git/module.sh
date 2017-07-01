import.require 'provision.git>base'
provision.git.init() {
	provision.git.__init() {
  		import.useModule 'provision.git_base'
	}
	provision.git.require() {
    	provision.git_base.require "$@"
    	return $?
	}
}
