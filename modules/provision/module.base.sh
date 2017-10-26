provision_base.init() {
	provision_base.isInstalled() {
		if [ $(which "$1" | wc -l) == '0' ]; then
			logger.info --message \
				"Command \"${1}\" is not installed" \
				--verbosity 2
			return 1
		fi
		return 0
	}
	provision_base.require() {
		local __item_name="$1"
		shift;
		if ! import.functionExists "provision.${__item_name}.require"; then
			logger.error --message \
				"The function 'provision.${__item_name}.require' was not found, did you forget to import the namespace 'provision.${__item_name}'?"
			return 1
		fi
		"provision.${__item_name}.require" "$@"
	}
	provision_base.isPackageInstalled() {
		if [ $(apt-cache policy "$1" | grep 'Installed: (none)' | wc -l) != '0' ]; then
			logger.info --message \
				"Package \"${1}\" is not installed" \
				--verbosity 2
			return 1
		fi
		logger.info --message \
			"Package \"${1}\" is already installed" \
			--verbosity 2
		return 0
	}

	provision_base.isPpaInstalled() {
		local __name="${1}"

		if [ ! -d /etc/apt/sources.list.d ]; then
			grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -q "${__name}" && {
				return 0
			}
		else
			grep ^ /etc/apt/sources.list | grep -q "${__name}" && {
				return 0
			}
		fi

		return 1
	}
}
