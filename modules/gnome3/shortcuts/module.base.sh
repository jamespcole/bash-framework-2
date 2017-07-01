# This is an example of inclduing the params module.
# Place require module calls at the top of the file.
import.require 'params'
import.require 'logger'
vendor.wrap 'mo/mo' 'vendor.include.mo'

gnome3.shortcuts_base.init() {
	# Uncomment __init and put the declaration of any globals your module uses here.
	# Also initiliase any required modules.  If not required you can remove it.
	gnome3.shortcuts_base.__init() {
		import.useModule 'params'
		import.useModule 'logger'
		vendor.include.mo
	}
	gnome3.shortcuts_base.createAppMenuIcon() {
		local -A __params
		__params['name']=
		__params['cmd']=
		__params['icon']=
		__params['categories']='Development;'
		params.get "$@"
		local __gs_path="/home/${USER}/.local/share/applications/${__params['name']/ /_}.desktop"

		gnome3.shortcuts_base.templateShortcut > "$__gs_path" || {
			return 1
		}

		logger.info --message  \
			"Created new application shortcut at \"$__gs_path\""
	}

	gnome3.shortcuts_base.templateShortcut() {
cat << EOF | mo
[Desktop Entry]
Encoding=UTF-8
Name={{__params.name}}
Exec={{__params.cmd}}
Icon={{__params.icon}}
Type=Application
Categories={{__params.categories}}
EOF
	}
}
