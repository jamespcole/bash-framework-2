import.require 'provision.docker>base'
provision.docker.init() {
	provision.docker.__init() {
  		import.useModule 'provision.docker_base'
	}
	provision.docker.require() {
    	provision.docker_base.require "$@"
    	return $?
	}
	provision.docker.installFromDockerPPA() {
		provision.docker_base.installFromDockerPPA "$@"
    	return $?
	}
	provision.docker.startDaemon() {
		provision.docker_base.startDaemon "$@"
		return "$?"
	}
}
