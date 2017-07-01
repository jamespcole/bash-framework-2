import.require 'provision.atom>base'
# @description The provision.atom namespace provides functions for installing the Atom editor.
#
# @example
#   import.require 'provision.atom'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'provision.atom'
#      }
#      some_other_module.someFunction() {
#         provision.require 'atom'
#      }
#   }
#
# @see provision.atom.require()
provision.atom.init() {
	provision.atom.__init() {
		import.useModule 'provision.atom_base'
	}
	# @description Checks to see if Atom is installed and then installs it if not.
	#
	# @example
	#   provision.require 'atom'
	#
	provision.atom.require() {
		provision.atom_base.require "$@"
	}
}
