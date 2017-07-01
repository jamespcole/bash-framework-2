import.require 'provision'
import.require 'provision.java'
import.require 'provision.unrar'
import.require 'gnome3.shortcuts'
provision.datagrip_base.init() {
	provision.datagrip_base.__init() {
  		import.useModule 'provision'
		import.useModule 'gnome3.shortcuts'
		import.useModule 'provision.java'
	}
	provision.datagrip_base.require() {
		if ! provision.isInstalled 'datagrip'; then
			provision.require 'java' || {
				return 1
			}
			local __dg_install_path="/home/$USER/Apps/DataGrip"

			logger.info --message \
				"Installing DataGrip to \"${__dg_install_path}\""

			mkdir -p "${__dg_install_path}"
			cd "${__dg_install_path}"
			wget \
				https://download.jetbrains.com/datagrip/datagrip-2016.1.1.tar.gz \
			|| {
					return 1
			}
			tar xfz datagrip-*.tar.gz || {
					return 1
			}
			local __datagrip_dir=$(ls -1 -d DataGrip* | head -n 1)
			if [ -z "$__datagrip_dir" ]; then
				return 1
			fi
			cd "$__datagrip_dir"
			bin/datagrip.sh || {
					return 1
			}

	        gnome3.shortcuts.createAppMenuIcon \
				--name 'DataGrip' \
				--cmd "${__dg_install_path}/${__datagrip_dir}/bin/datagrip.sh" \
				--icon "${__dg_install_path}/${__datagrip_dir}/bin/product.png" \
				--categories 'Categories;'
		fi
		return 0
	}
}
