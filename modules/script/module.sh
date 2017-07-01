#!/usr/bin/env bash
import.require 'script>base'
script.init() {
	script.__init() {
		import.useModule 'script_base'
	}
	script.exitWithError() {
		script_base.exitWithError "$@"
	}
	script.exitWithWarning() {
		script_base.exitWithWarning "$@"
	}
    script.exitSuccess() {
		script_base.exitSuccess "$@"
	}
	script.tryCommand() {
		script_base.tryCommand "$@"
	}
}
