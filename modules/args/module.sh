import.require 'args>base'
args.init() {
	args.__init() {
		import.useModule 'args_base'
	}
	args.add() {
		args_base.add "$@"
	}
	args.validate() {
		args_base.validate "$@"
	}
    args.parse() {
		args_base.parse "$@"
	}
    args.isSpecified() {
        args_base.isSpecified "$@"
    }
    args.processCallbacks() {
        args_base.processCallbacks "$@"
    }
}
