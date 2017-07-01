import.require 'provision.ruby>base'
provision.ruby.init() {
	provision.ruby.__init() {
    	import.useModule 'provision.ruby_base'
	}
    provision.ruby.require() {
        provision.ruby_base.require "$@"
        return $?
    }
	provision.ruby.installRbenv() {
		provision.ruby_base.installRbenv "$@"
	}
}
