import.require 'provision.bundler>base'
provision.bundler.init() {
	provision.bundler.__init() {
    	import.useModule 'provision.bundler_base'
	}
    provision.bundler.require() {
        provision.bundler_base.require "$@"
        return $?
    }
}
