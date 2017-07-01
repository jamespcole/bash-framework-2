import.require 'provision'
provision.java_base.init() {
	provision.java_base.__init() {
  		import.useModule 'provision'
	}
	provision.java_base.require() {
		if ! provision.isInstalled 'java'; then
			sudo add-apt-repository -y ppa:webupd8team/java || {
					return 1
			}
			sudo apt-get update || {
					return 1
			}
			echo oracle-java8-installer \
				shared/accepted-oracle-license-v1-1 \
				select true | sudo /usr/bin/debconf-set-selections \
			|| {
					return 1
			}
			sudo apt-get install oracle-java8-installer || {
				return 1
			}
			return $?
		fi
		return 0
	}
}
