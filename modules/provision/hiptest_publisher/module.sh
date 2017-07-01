import.require 'provision.hiptest_publisher>base'
provision.hiptest_publisher.init() {
	provision.hiptest_publisher.__init() {
  		import.useModule 'provision.hiptest_publisher_base'
	}
	provision.hiptest_publisher.require() {
    	provision.hiptest_publisher_base.require "$@"
    	return $?
	}
}
