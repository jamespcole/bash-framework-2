import.require 'provision'
import.require 'params'
import.require 'provision.composer'
provision.laravel_base.init() {
	provision.laravel_base.__init() {
		import.useModule 'provision'
		import.useModule 'params'
        import.useModule 'provision.composer'
	}
	provision.laravel_base.require() {
		local -A __params
		__params['component']='laravel'
		params.get "$@"
		if ! provision.isInstalled 'laravel'; then
            provision.composer.require || {
                script.exitWithError "Composer requirement not met"
            }
            composer global require "laravel/installer"
            return $?
	    fi
	    return 0
	}
}
