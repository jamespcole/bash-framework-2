import.require 'template>base'
template.init() {
	template.__init() {
		import.useModule 'template_base'
	}
	template.includeFile() {
		template_base.includeFile "$@"
	}
    template.insertOutput() {
        template_base.insertOutput "$@"
    }
}
