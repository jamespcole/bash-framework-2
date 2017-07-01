import.require 'provision'
import.require 'provision.ruby'
provision.bundler_base.init() {
	provision.bundler_base.__init() {
		import.useModule 'provision'
		import.useModule 'provision.ruby'
	}
	provision.bundler_base.require() {
		provision.require 'ruby' || {
			return $?
		}
		# Set the ruby version
        rbenv local 2.3.0 || {
            return 1
        }
		gem install bundler || {
            return 1
        }
		rbenv rehash || {
            return 1
        }
		return 0
	}
}
