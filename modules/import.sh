# Public: Initialise the import module.
#
# Loads and initilaises the functions exposed by the import module.  Unlike
# most modules this also automatically calls its own __init() function in
# order to bootstrap the functions required for importing other modules.
# Because it is used to import other modules it needs to be "sourced" to
# make it available.  After this all other modules should be included using
# this module.  NOTE: this module should have no dependencies on other modules,
# therefore convenience functions from other modules cannot be used.
#
# Examples
#
#   source 'modules/import.sh'
#   import.init
#
# Returns the exit code of the last command which would most likely always be 0
# as it is simply loading the module functions in to the global scope
import.init() {
	import.__init() {
		declare -A -g __import_LOADED
		declare -A -g __import_INITED
		local -a __import_tmp_paths
		declare -a -g __import_PATHS

		import.loadAppPaths
		import.require 'vendor'
		import.useModule 'vendor'
		import.require 'resource'
		import.useModule 'resource'
	}
	import.require() {
		local __im_req_mod_name="$1"
		local __require_file=${2:-module}

		if [[ ${__import_LOADED["${__im_req_mod_name}"]+exists} ]]; then
			return
		fi

		local __mod_file
		import.getModulePath __mod_file "$__im_req_mod_name" "$__require_file"

		source "${__mod_file}"

		__import_LOADED["${__im_req_mod_name}"]='1'
	}
	import.getModulePath() {
		local __returnvar=$1
		local __im_req_mod_name="$2"
		local __require_file="${3:-module}"

		if [[ "$__im_req_mod_name" == *"."* ]]; then
		  __im_req_mod_name="${__im_req_mod_name/.//}"
		fi

		if [[ "$__im_req_mod_name" == *">"* ]]; then
		  local __im_req_sub=${__im_req_mod_name##*>}
		  __im_req_mod_name=${__im_req_mod_name%%>*}
		  __require_file="${__require_file}.${__im_req_sub}"
		fi

		local __path=$(dirname $(readlink -f ${BASH_SOURCE[0]}))

		local __mod_file_path="${__path}/${__im_req_mod_name//.//}/${__require_file}.sh"

		# Check if there is an environment override for this module.
		local __env_path="${BF2_ENV}/modules/${__im_req_mod_name//.//}/${__require_file}.sh"
		if [ -f "${__env_path}" ]; then
			__mod_file_path="${__env_path}"
		fi

		if [[ "$__returnvar" ]]; then
			eval $__returnvar="$(echo -e '$__mod_file_path')"
		else
			echo "$__mod_file_path"
		fi
	}
	import.initModule() {
		local __import_modName="$1"
		"${__import_modName}.init"
		if import.functionExists "${__import_modName}.__init"; then
			"${__import_modName}.__init"
		fi
		__import_INITED["${__import_modName}"]='1'
	}
	import.useModule() {
		local __import_modName="$1"
		if [[ ! ${__import_INITED["${__import_modName}"]+exists} ]]; then
			import.initModule "$__import_modName"
		else
			"${__import_modName}.init"
		fi
	}
	import.useModules() {
		local __module
		for __module in "${!__import_LOADED[@]}"
		do
			# Replace > with underscore to access namespace
			import.useModule "${__module//>/_}"
		done
	}
	import.functionExists() {
		declare -f -F $1 > /dev/null
		return $?
	}
	import.loadAppPaths() {
		local -a __import_tmp_paths
		local __ifs_tmp="$IFS"
		IFS=':' read -r -a __import_tmp_paths <<< "$BF2_PATH"
		IFS="$__ifs_tmp"
		local __import_script_path="$(dirname $(readlink -f "${BASH_SOURCE}"))"
		__import_script_path="$(readlink -f "${__import_script_path}/..")"
		local __import_path_var
		local -a __import_tmp_paths_clean
		local __import_include_current_path=1
		for __import_path_var in "${__import_tmp_paths[@]}"
		do
			if [ "$__import_path_var" != '' ]; then
				__import_tmp_paths_clean+=("$__import_path_var")
			fi
			if [ "$__import_path_var" == "$__import_script_path" ]; then
				__import_include_current_path=0
			fi
		done

		if [ $__import_include_current_path -eq 1 ]; then
			__import_tmp_paths_clean+=("$__import_script_path")
		fi

		local __import_path_count=${#__import_tmp_paths_clean[@]}
		let __import_path_count=__import_path_count-1

		for __import_path_var in "${__import_tmp_paths_clean[@]}"
		do
			__import_PATHS["${__import_path_count}"]="$__import_path_var"
			let __import_path_count=__import_path_count-1
		done
	}

	import.extension() {
		local __extension="$1"
		local __caller_path="$(dirname $(readlink -f "${BASH_SOURCE[1]}"))"
		local __filename="${__extension##*.}.sh"
		local __extension_path="${__caller_path}/extensions/${__filename}"
		source "$__extension_path"
	}

	import.useExtension() {
		local __extension_namespace="$1"
		"${__extension_namespace}.init"
		if import.functionExists "${__extension_namespace}.__init"; then
			"${__extension_namespace}.__init"
		fi

	}
	# This is here because the init module is only loaded once
	# normally modules should not do this
	import.__init
	return $?
}
