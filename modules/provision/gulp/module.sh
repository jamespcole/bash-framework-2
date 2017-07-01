import.require 'provision.gulp>base'
provision.gulp.init() {
	provision.gulp.__init() {
    	import.useModule 'provision.gulp_base'
	}
    provision.gulp.require() {
        provision.gulp_base.require "$@"
        return $?
    }
}
