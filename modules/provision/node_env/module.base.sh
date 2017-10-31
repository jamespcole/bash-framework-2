#!/usr/bin/env bash
import.require 'provision'
import.require 'params'
import.require 'provision.git'
provision.node_env_base.init() {
	provision.node_env_base.__init() {
		import.useModule 'provision'
		import.useModule 'params'
	}
	provision.node_env_base.require() {
		provision.node_env.ensureEnv "$@" || {
		logger.error --message \
			"Failed to install nodejs environment"
		return 1
		}
		return 0
	}

	provision.node_env_base.ensureEnv() {
		local -A __params
		__params['nvm-dir']="$(pwd)/.nvm"
		__params['node-version']='6'
		__params['add-to-bashrc']=false
		params.get "$@"

		local __nvm_dir="${__params['nvm-dir']}"
		local __node_ver="${__params['node-version']}"
		local __add_to_bashrc="${__params['add-to-bashrc']}"
		if [ ! -f "${__nvm_dir}/nvm.sh" ]; then

			mkdir -p "${__nvm_dir}"

			provision.require 'git' || {
				logger.error \
					--message "git requirement not met while installing nvm"
				return 1
			}

			export NVM_DIR="${__nvm_dir}" && (
				git clone https://github.com/creationix/nvm.git "$NVM_DIR"
				cd "$NVM_DIR"
				git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
			) && . "$NVM_DIR/nvm.sh"

			if ! test "$NVM_DIR"; then
				. "${__nvm_dir}/nvm.sh"
			fi

			# If it's still not available export the NVM_DIR environment variable and source it again
			nvm > /dev/null 2>&1 || {
				export NVM_DIR="${__nvm_dir}"
				. "${__nvm_dir}/nvm.sh"
			}


			nvm install "${__node_ver}" || {
				logger.error --message \
					'Failed to install node'
				return 1
			}
			nvm use "${__node_ver}" || {
				return 1
			}

		else
			export NVM_DIR="${__nvm_dir}"
			. "${__nvm_dir}/nvm.sh"
			nvm use "${__node_ver}" || {
				nvm install "${__node_ver}" || {
					logger.error --message \
						'Failed to install node'
					return 1
				}
				nvm use "${__node_ver}" || {
					return 1
				}
			}
		fi

		if [[ "${__add_to_bashrc}" == true ]] \
			&& [ $(grep 'NVM_DIR' "$HOME/.bashrc" | wc -l) == '0' ]
		then
			echo -e \
				"\nexport NVM_DIR=\"${__nvm_dir}\"\n[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"\n" \
				>> "$HOME/.bashrc"
		fi

		return 0
	}
}
