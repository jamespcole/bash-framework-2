import.require 'provision.gawk>base'
# @description The provision.gawk namespace
# Installs gawk (a GNU implementation of awk)
#
# @example
#   import.require 'provision.gawk'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'provision.gawk'
#      }
#      some_other_module.someFunction() {
#         provision.require 'gawk'
#      }
#   }
#
# @see provision.gawk.require()
provision.gawk.init() {
	provision.gawk.__init() {
		import.useModule 'provision.gawk_base'
	}
	# @description Checks to see if gawk is installed and then installs it if not.
	#
	# @example
	#   provision.require 'gawk'
	#
	provision.gawk.require() {
		provision.gawk_base.require "$@"
	}
}
