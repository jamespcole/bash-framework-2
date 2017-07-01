import.require 'group>base'
group.init() {
	group.__init() {
		import.useModule 'group_base'
	}
	group.exists() {
		group_base.exists "$@"
	}
	group.create() {
		group_base.create "$@"
	}
	group.require() {
		group_base.require "$@"
	}
	group.isUserInGroup() {
		group_base.isUserInGroup "$@"
	}
	group.addUser() {
		group_base.addUser "$@"
	}
}
