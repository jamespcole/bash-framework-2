import.require 'pathing>base'
pathing.init() {
	pathing.__init() {
		import.useModule 'pathing_base'
	}
	pathing.closestParentFile() {
		pathing_base.closestParentFile "$@"
	}
}
