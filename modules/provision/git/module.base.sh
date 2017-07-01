import.require 'provision'
import.require 'params'
provision.git_base.init() {
	provision.git_base.__init() {
		import.useModule 'provision'
		import.useModule 'params'
	}
	provision.git_base.require() {
		local -A __params
		__params['component']='git'
		params.get "$@"
		if ! provision.isInstalled 'git'; then
	      sudo apt-get install -y "${__params['component']}"
	      return $?
	    fi
	    return 0
	}
}
