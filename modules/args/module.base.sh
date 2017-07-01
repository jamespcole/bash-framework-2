import.require 'params'
import.require 'string'
import.require 'logger'

args_base.init() {
	args_base.__init() {
		import.useModule 'string'
		import.useModule 'params'
		import.useModule 'logger'
		# Holds the args definitions, name, key, required etc.
		declare -A -g __args_DEFS
		# Holds the values of the arguments after parsing
		declare -A -g __args_VALS
		# Maps the switches, eg -n --new, to a particular argument key
		declare -A -g __args_SWITCHES
		# A list of all the registered arguument keys
		declare -a -g __args_KEYS
		# A list of all the argument validation errors encountered
		declare -a -g __args_ERRORS
	}
	args_base.add() {
		local __key_sep='>>'
		local -A __params
		__params['key']= # The unique key for this arg
		__params['name']='' # The name of the arg variable
		# __params['alias']='' # The alias, eg: --yourname or -x
		__params['desc']= # A description of the argument
		__params['required']='0' # If the arg is required
		# The arg type, value, switch, enum, file_exists, dir_exists
		# file, dir
		__params['type']='value'
		# Specifies if a value is expected, not expected or either.
		# y = Must have a value
		# n = Must not have a value
		# m = Maybe has a value
		__params['has-value']='m'
		# If == 1 this arguments callback function will be called before
		# failed validations are printed.
		__params['priority']='0'
		# The function that will be called when this argument is used.
		__params['callback']=
		params.get "$@"

		local -a __arr_types=('alias' 'excludes' 'includes' 'required-unless')
		__arr_types+=('enum-value')

		__args_KEYS+=("${__params['key']}")
		local __arg_pre="${__params['key']}${__key_sep}"
		local __param_key="${__params['key']}"
		for __p_key in "${!__params[@]}"; do
			if ! args_base.arrContains __arr_types[@] "${__p_key}"; then
				__args_DEFS["${__arg_pre}${__p_key}"]="${__params[$__p_key]}"
			fi
		done

		__args_VALS["${__params['key']}"]=
		# Indicates whether or not the arg was specified, defaul to 0 here
		# and then set to one when parsing if it is found
		__args_VALS["${__params['key']}${__key_sep}specified"]=0

		local __pargs="$@"
		local __arr_name
		for __arr_name in "${__arr_types[@]}"; do
			__args_DEFS["${__arg_pre}${__arr_name}_list"]=""
			__args_DEFS["${__arg_pre}${__arr_name}__count"]=0
			args_base.parseArrayTypes "$__arr_name" "$@"
		done

		__args_VALS["${__param_key}"]="${__args_DEFS[${__arg_pre}default]}"

		# echo "-------------- arg defs -----------------"
		# for __arg in "${!__args_DEFS[@]}"; do
		# 	echo "key  : ${__arg}"
		# 	echo "value: ${__args_DEFS[$__arg]}"
		# done
		# echo "-----------------------------------------"

	}
	args_base.parseArrayTypes() {
		local __var_name="$1"
		shift;
		local __var
		local __is_val=0
		local __sep=''
		local __num_name
		for __var in "${@}"
		do

			if [ $__is_val -eq 1 ]; then
				__is_val=0
				if [ "$__var_name" == 'alias' ]; then
					__args_SWITCHES["$__var"]="${__param_key}"
				fi
				__args_DEFS["${__arg_pre}${__var_name}_list"]="${__args_DEFS["${__arg_pre}${__var_name}_list"]}${__sep}${__var}"
				__args_DEFS["${__arg_pre}${__num_name}"]="${__var}"
				__sep=','
			elif [ "${__var}" == "--${__var_name}" ]; then
				__is_val=1
				local __len_count="${__args_DEFS["${__arg_pre}${__var_name}__count"]}"
				__num_name="${__var_name}<${__len_count}>"
				let __args_DEFS["${__arg_pre}${__var_name}__count"]=__len_count+1
			fi
		done
	}
	args_base.parse() {
		local __key_sep='>>'
		local __var
		local __val_key
		local __is_val=0
		for __var in "${@}"
		do
			if [ "${__var::1}" == "-" ]; then
				__is_val=1
				__val_key="${__var}"
				if [[ ! "${__args_SWITCHES["${__val_key}"]+exists}" ]]; then
					__args_ERRORS+=("Unknown argument \"${__val_key}\"")
				fi
				local __arg_key=${__args_SWITCHES[$__val_key]}
				__spec_key="${__arg_key}${__key_sep}specified"
				__args_VALS["${__spec_key}"]=1
			elif [ $__is_val -eq 1 ]; then
				__is_val=0
				if [[ ! "${__args_SWITCHES["${__val_key}"]+exists}" ]]; then
					__args_ERRORS+=("Unknown argument \"${__val_key}\" passed a value of \"${__var}\"")
				else
					__args_VALS["${__args_SWITCHES[$__val_key]}"]="$__var"
				fi
				__val_key=''
			fi
		done
	}
	# Called pbefore any other args processing for args
	# with a priority of 2
	args_base.processCallbacks() {
		local __key_sep='>>'
		local __arg_key
		for __arg_key in "${__args_KEYS[@]}"; do
			local __key_prefix="${__arg_key}${__key_sep}"
			local __arg_specified="${__args_VALS[${__key_prefix}specified]}"
			local __arg_priority="${__args_DEFS[${__key_prefix}priority]}"
			local __arg_priority="${__args_DEFS[${__key_prefix}priority]}"
			if [ "$__arg_priority" == '2' ] \
				&& [ "$__arg_specified" == '1' ]
			then
				local __arg_callbabck="${__args_DEFS[${__key_prefix}callback]}"
				if [ ! -z "$__arg_callbabck" ]; then
					"$__arg_callbabck"
				fi
			fi
		done
	}
	args_base.validate() {

		# args_base.parse "$@"
		local __key_sep='>>'
		local __arg_key
		for __arg_key in "${__args_KEYS[@]}"; do
			args_base.validateArg "${__arg_key}"
		done

		if [ "${#__args_ERRORS[@]}" -gt 0 ]; then
			for __arg_err in "${__args_ERRORS[@]}"; do
				logger.error --message "$__arg_err"
			done
			exit 1
		fi
		# echo "-------------- arg vals -----------------"
		# for __arg in "${!__args_VALS[@]}"; do
		# 	echo "key  : ${__arg}"
		# 	echo "value: ${__args_VALS[$__arg]}"
		# done
		# echo "-----------------------------------------"
	}

	args_base.validateArg() {
		local __arg_key="$1"
		local __key_sep='>>'

		local __key_prefix="${__arg_key}${__key_sep}"
		local __has_value=${__args_DEFS[${__key_prefix}has-value]}
		local __req_name="${__args_DEFS[${__key_prefix}name]}"
		local __req_alias_list="${__args_DEFS[${__key_prefix}alias_list]}"
		local __type_key="${__arg_key}${__key_sep}type"
		local __arg_type=${__args_DEFS[${__type_key}]}
		local __arg_specified="${__args_VALS[${__key_prefix}specified]}"
		local __arg_required="${__args_DEFS[${__key_prefix}required]}"
		local __arg_default="${__args_DEFS[${__key_prefix}default]}"

		local __arg_priority="${__args_DEFS[${__key_prefix}priority]}"
		if [ "$__arg_priority" == '1' ] \
			&& [ "$__arg_specified" == '1' ]
		then
			local __arg_callbabck="${__args_DEFS[${__key_prefix}callback]}"
			if [ ! -z "$__arg_callbabck" ]; then
				"$__arg_callbabck"
			fi
		fi

		# Checks that the required arg was passed
		if [ "${__arg_specified}" != '1' ] \
			&& [ "${__arg_required}" == '1' ]
		then
			__args_ERRORS+=("The argument \"${__req_name}(${__req_alias_list})\" is required")
		fi

		if [ "$__has_value" == 'y' ] \
			&& [ -z "${__args_VALS[$__arg_key]}" ] \
			&& [ "${__arg_required}" == '1' ]
		then # Checks that args that require values when used have one
			__args_ERRORS+=("The argument \"${__req_name}(${__req_alias_list})\" requires a value")
		elif [ "$__has_value" == 'n' ] \
			&& [ ! -z "${__args_DEFS[$__arg_key]}" ]
		then # Checks that args that cannot have a value are empty
			__args_ERRORS+=("The argument \"${__req_name}(${__req_alias_list})\" can not have a value")
		elif [ "$__has_value" == 'y' ] \
			&& [ -z "${__args_VALS[$__arg_key]}" ] \
			&& [ "${__arg_specified}" == '1' ]
		then
			__args_ERRORS+=("The argument \"${__req_name}(${__req_alias_list})\" requires a value")
		fi

		# Check for argument exclusions
		if [ "${__arg_specified}" == '1' ]; then
			local __loop_count=0
			local __arr_len="${__args_DEFS[${__key_prefix}excludes__count]}"
			while [ $__loop_count -lt $__arr_len ]; do
				local __ex_name="${__args_DEFS[${__key_prefix}excludes<${__loop_count}>]}"
				if [ "${__args_VALS[${__ex_name}${__key_sep}specified]}" == '1' ]; then
					local __ex_aliases="${__args_DEFS[${__ex_name}${__key_sep}alias_list]}"
					__args_ERRORS+=("The argument \"${__req_name}(${__req_alias_list})\" can not be used with \"${__ex_name}(${__ex_aliases})\"")
				fi
				let __loop_count=__loop_count+1
			done
		fi

		# Check for include argument requirements
		if [ "${__arg_specified}" == '1' ]; then
			local __loop_count=0
			local __arr_len="${__args_DEFS[${__key_prefix}includes__count]}"
			while [ $__loop_count -lt $__arr_len ]; do
				local __ex_name="${__args_DEFS[${__key_prefix}includes<${__loop_count}>]}"
				if [ "${__args_VALS[${__ex_name}${__key_sep}specified]}" == '0' ]; then
					local __ex_aliases="${__args_DEFS[${__ex_name}${__key_sep}alias_list]}"
					__args_ERRORS+=("The argument \"${__ex_name}(${__ex_aliases})\" must also be specified when using \"${__req_name}(${__req_alias_list})\"")
				fi
				let __loop_count=__loop_count+1
			done
		fi

		# Check for required unless
		local __arr_len="${__args_DEFS[${__key_prefix}required-unless__count]}"
		if [ "${__arg_specified}" != '1' ] \
				&& [ "$__arr_len" -gt 0 ]
		then
			local __loop_count=0
			local -a __req_unless_errs
			local __invalid=1

			while [ $__loop_count -lt $__arr_len ]; do
				local __ex_name="${__args_DEFS[${__key_prefix}required-unless<${__loop_count}>]}"
				if [ "${__args_VALS[${__ex_name}${__key_sep}specified]}" != '1' ]; then
					local __ex_aliases="${__args_DEFS[${__ex_name}${__key_sep}alias_list]}"
					__req_unless_errs+=("The argument \"${__req_name}(${__req_alias_list})\" is required unless \"${__ex_name}(${__ex_aliases})\" is specified.")
				else
					__invalid=0
				fi
				let __loop_count=__loop_count+1
			done

			if [ "$__invalid" == '1' ]; then
				for __req_unless_err in "${__req_unless_errs[@]}"; do
					__args_ERRORS+=("$__req_unless_err")
				done
			fi
		fi

		# If it's a switch and it is passed set the value to 1
		if [ "${__arg_type}" == "switch" ] \
			&& [ "${__arg_specified}" == '1' ]
		then
			__args_VALS[$__arg_key]=1
		fi

		if [ "${__arg_type}" == "file_exists" ] \
			&& [ "${__arg_specified}" == '1' ] \
			&& [ ! -f "${__args_VALS[$__arg_key]}" ];
		then
			__args_ERRORS+=("The file \"${__args_VALS[$__arg_key]}\" specified for argument \"${__req_name}(${__req_alias_list})\" could not be found.")
		fi

		if [ "${__arg_type}" == "dir_exists" ] \
			&& [ "${__arg_specified}" == '1' ] \
			&& [ ! -d "${__args_VALS[$__arg_key]}" ];
		then
			__args_ERRORS+=("The directory \"${__args_VALS[$__arg_key]}\" specified for argument \"${__req_name}(${__req_alias_list})\" could not be found.")
		fi

		# If it's a enum and it is passed check that it is in the list
		if [ "${__arg_type}" == "enum" ] \
			&& [ "${__arg_specified}" == '1' ]
		then
			local __enum_count=0
			local __arr_len="${__args_DEFS[${__key_prefix}enum-value__count]}"
			local __enum_found=0
			while [ $__enum_count -lt $__arr_len ]; do
				local __enum_val="${__args_DEFS[${__key_prefix}enum-value<${__enum_count}>]}"
				if [ "${__enum_val}" == "${__args_VALS[$__arg_key]}" ]; then
					__enum_found=1
					break;
				fi
				let __enum_count=__enum_count+1
			done
			if [ "${__enum_found}" == '0' ]; then
				local __enum_vals="${__args_DEFS[${__key_prefix}enum-value_list]}"
				__args_ERRORS+=("The argument \"${__req_name}(${__req_alias_list})\" must be one of these values: \"${__enum_vals}\"")
			fi
		fi

		if [ "${__arg_specified}" != '1' ] \
				&& [ ! -z "$__arg_default" ]
		then
			__args_VALS["$__arg_key"]="$__arg_default"
		fi
	}
	args_base.isSpecified() {

		local -A __params
		__params['key']=
		params.get "$@"
		local __arg_key="${__params['key']}"
		local __key_sep='>>'
		local __key_prefix="${__arg_key}${__key_sep}"

		if [ "${__args_VALS[${__key_prefix}specified]}" == '1' ]; then
			return 0
		fi
		return 1
	}
	args_base.arrContains() {
		local haystack=${!1}
		local needle="$2"
		printf "%s\n" ${haystack[@]} | grep -q "^$needle$"
	}
}
