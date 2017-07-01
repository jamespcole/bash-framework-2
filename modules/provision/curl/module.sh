import.require 'provision.curl>base'
provision.curl.init() {
	provision.curl.__init() {
  		import.useModule 'provision.curl_base'
	}
	provision.curl.require() {
    	provision.curl_base.require "$@"
    	return $?
	}
}
