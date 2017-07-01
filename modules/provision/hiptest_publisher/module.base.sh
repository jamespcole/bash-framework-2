import.require 'provision'
import.require 'provision.ruby'
import.require 'provision.docker'
import.require 'params'
provision.hiptest_publisher_base.init() {
	provision.hiptest_publisher_base.__init() {
  		import.useModule 'provision'
		import.useModule 'provision.ruby'
		import.useModule 'provision.docker'
		import.useModule 'params'
	}
	provision.hiptest_publisher_base.require() {
		local -A __params
		__params['installation']='local' # or local
		params.get "$@"
	    if ! provision.isInstalled 'hiptest-publisher'; then
			if [ "${__params['installation']}" == 'local' ]; then
				provision.hiptest_publisher_base.installLocal "$@" || {
					return $?
				}
			else
				provision.hiptest_publisher_base.installWithDocker "$@" || {
					return $?
				}
			fi
	    fi
	    return 0
	}
	provision.hiptest_publisher_base.installLocal() {
		provision.require 'ruby' || {
			return $?
		}
		# Set the ruby version
        rbenv local 2.3.0 || {
            script.exitWithError "Failed to set ruby version to 2.3.0"
        }

		gem install hiptest-publisher --no-ri --no-rdoc
		return $?
	}
	provision.hiptest_publisher_base.installWithDocker() {
		provision.require 'docker' || {
			return $?
		}

		cid=$(docker create hiptest/hiptest-publisher) &&
		docker cp $cid:/usr/src/app/bin/hiptest-publisher-docker hiptest-publisher &&
		docker rm $cid > /dev/null || {
			return $?
		}
		sudo ln -s $(readlink -f hiptest-publisher) /usr/local/bin/hiptest-publisher || {
			return $?
		}
	}
}
