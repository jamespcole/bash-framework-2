import.require 'provision'
import.require 'params'
import.require 'group'
# from https://docs.docker.com/engine/installation/linux/ubuntulinux/
provision.docker_base.init() {
	provision.docker_base.__init() {
		import.useModule 'provision'
		import.useModule 'params'
		import.useModule 'group'
	}
	provision.docker_base.require() {
		local -A __params
		__params['ppa']='docker' # or system
		params.get "$@"
		if ! provision.isInstalled 'docker'; then
			if [ "${__params['ppa']}" == 'system' ]; then
				sudo apt-get install -y docker.io || {
	                return $?
	            }
			else
				provision.docker.installFromDockerPPA "$@" || {
					return $?
				}
				group.require --name 'docker' && group.addUser --name 'docker' --user "$USER"
			fi
			provision.docker.startDaemon || {
				return $?
			}
		fi
		return 0
	}
	provision.docker_base.installFromDockerPPA() {
		sudo apt-get update || {
			return $?
		}
		sudo apt-get install -y apt-transport-https ca-certificates || {
			return $?
		}
		sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D || {
			return $?
		}
		sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list' || {
			return $?
		}
		sudo apt-get update || {
			return $?
		}
		sudo apt-get install -y linux-image-extra-$(uname -r) || {
			return $?
		}

		sudo apt-get install -y docker-engine || {
			return $?
		}

		return $?
	}
    provision.docker_base.startDaemon() {
        sudo service docker start || {
            return $?
        }
    }
}
