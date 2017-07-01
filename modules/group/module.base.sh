import.require 'params'
group_base.init() {
	group_base.__init() {
		import.useModule 'params'
	}
	group_base.exists() {
		local -A __params
		__params['name']=''
		params.get "$@"
		if [ "$(compgen -g | grep "${__params['name']}" | wc -l)" != '1' ]; then
			return 1
		else
			return 0
		fi
	}
	group_base.isUserInGroup() {
		local -A __params
		__params['name']=''
		params.get "$@"
		if [ "$(groups | tr ' ' '\n' | grep "${__params['name']}" | wc -l)" != '1' ]; then
			return 1
		else
			return 0
		fi
	}
	group_base.create() {
		local -A __params
		__params['name']=''
		params.get "$@"
		sudo groupadd "${__params['name']}"
	}
	group_base.require() {
		local -A __params
		__params['name']=''
		params.get "$@"
		if ! group.exists --name "${__params['name']}"; then
			group_base.create --name "${__params['name']}" || {
				return $?
			}
		fi
		return 0
	}
	group_base.addUser() {
		local -A __params
		__params['name']=''
		__params['user']="$USER"
        __params['refresh']='1'
		params.get "$@"
		if ! group.isUserInGroup --name "${__params['name']}"; then
			sudo usermod -aG "${__params['name']}" "${__params['user']}"
			# exec sudo su -l $USER
			# reload user groups
            if [ "${__params['refresh']}" == '1' ]; then
			    newgrp "${__params['name']}"
            fi
		fi
	}
}
