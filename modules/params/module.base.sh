params_base.init() {
	params_base.get() {
		local __params_count=0
		local __pos_count=0
		local __is_val=0
		local __val_key=''
		local __var
		for __var in "${@}"
	    do
			if [ $__is_val -eq 1 ]; then
				__is_val=0
				__params["$__val_key"]="$__var"
				__val_key=''
			elif [ "${__var::2}" == "--" ]; then
				__is_val=1
				__val_key="${__var:2}"
				# echo "val key == $__val_key"
				# if [[ "${__params[$__val_key]+exists}" ]]; then
				# 	local __arg_key_idx=1
				# 	if [[ "${__params["__${__val_key}__count"]+exists}" ]]; then
				# 		__arg_key_idx="${__params[__${__val_key}__count]}"
				# 	fi
				# 	__val_key="${__val_key}${__arg_key_idx}"
				# 	let __arg_key_idx=__arg_key_idx+1
				# 	__params["__${__val_key}__count"]="$__arg_key_idx"
				# fi
				# echo "val key == $__val_key"
				__params["$__val_key"]=''
			else
				__params["pos[${__pos_count}]"]="$__var"
				let __pos_count=__pos_count+1
			fi
			let __params_count=__params_count+1
	    done
	}
}
