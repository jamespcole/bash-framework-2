import.require 'gnome3.shortcuts>base'
# @description The gnome3.shortcuts namespace provides functions for managing \
# Gnome 3 application menu shortcuts
#
# @example
#   import.require 'gnome3.shortcuts'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'gnome3.shortcuts'
#      }
#      some_other_module.someFunction() {
#            gnome3.shortcuts.createAppMenuIcon \
#                  --name 'My App' \
#                  --cmd '/usr/bin/myapp' \
#                  --icon '/path/to/png' \
#                  --categories 'Categories;Productivity;'
#      }
#   }
#
# @see gnome3.shortcuts.createAppMenuIcon()
gnome3.shortcuts.init() {
	gnome3.shortcuts.__init() {
		import.useModule 'gnome3.shortcuts_base'
	}
	# @description Creates a Gnome 3 app menu icon with the specified values
	#
	# @example
	#   gnome3.shortcuts.createAppMenuIcon \	
	#      --name 'My App' \
	#      --cmd '/usr/bin/myapp' \
	#      --icon '/path/to/png' \
	#      --categories 'Development;Productivity;'
	#
	#
	# @arg name The name of the app
	# @arg cmd The command to run
	# @arg icon The path to a png to use as an icon
	# @arg categories A semi-colon delimited list of categories
	gnome3.shortcuts.createAppMenuIcon() {
		gnome3.shortcuts_base.createAppMenuIcon "$@"
	}
}
