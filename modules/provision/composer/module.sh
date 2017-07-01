import.require 'provision.composer>base'
provision.composer.init() {
	provision.composer.__init() {
    	import.useModule 'provision.composer_base'
	}
    provision.composer.require() {
        provision.composer_base.require "$@"
        return $?
    }
}
