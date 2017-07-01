import.require 'provision.laravel>base'
provision.laravel.init() {
	provision.laravel.__init() {
  		import.useModule 'provision.laravel_base'
	}
	provision.laravel.require() {
    	provision.laravel_base.require "$@"
    	return $?
	}
}
