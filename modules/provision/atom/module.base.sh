import.require 'provision'
provision.atom_base.init() {
	provision.atom_base.__init() {
  		import.useModule 'provision'
	}
	provision.atom_base.require() {
	    if ! provision.isInstalled 'atom'; then
	        local __tmp_path=$(mktemp -d)
		wget https://atom.io/download/deb -O "${__tmp_path}/atom.deb" || {
			return 1
		}
		sudo dpkg -i "${__tmp_path}/atom.deb" || {
			return 1
		}
	        return $?
	    fi
	    return 0
	}
}
