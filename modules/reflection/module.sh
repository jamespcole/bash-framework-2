import.require 'reflection>base'
reflection.init() {
	reflection.__init() {
		import.useModule 'reflection_base'
	}
	reflection.getModuleFunctions() {
		reflection_base.getModuleFunctions "$@"
	}
    reflection.timeFunctions() {
        reflection_base.timeFunctions "$@"
    }
    reflection.printInfoForFile() {
        reflection_base.printInfoForFile "$@"
    }
    reflection.printDependencies() {
        reflection_base.printDependencies "$@"
    }
    reflection.printCommandDependencies() {
        reflection_base.printCommandDependencies "$@"
    }
}
