import.require 'config>base'
config.init() {
	config.__init() {
		import.useModule 'config_base'
	}
	config.readValue() {
		config_base.readValue "$@"
	}
}
