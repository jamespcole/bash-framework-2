import.require 'provision'
provision.curl_base.init() {
	provision.curl_base.__init() {
  		import.useModule 'provision'
	}
	provision.curl_base.require() {
	    if ! provision.isInstalled 'curl'; then
	      sudo apt-get install -y curl
	      return $?
	    fi
	    return 0
	}
}
