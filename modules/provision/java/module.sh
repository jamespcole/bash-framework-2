import.require 'provision.java>base'
provision.java.init() {
	provision.java.__init() {
  		import.useModule 'provision.java_base'
	}
	provision.java.require() {
    	provision.java_base.require "$@"
    	return $?
	}
}
