string_base.init() {
	# USAGE: string.return_value  "my cool string" $__return_val
	string_base.return_value() {
		local __value="$1"
		local __returnvar=$2
		if [[ "$__returnvar" ]]; then
	        eval $__returnvar="$(echo -e '$__value')"
	    else
	        echo "$__value"
	    fi
	}
    string_base.padding() {
        local __return=$1
        local __pad_chars="$2"
        local __length="$3"

        if [ "$__pad_chars" == ' ' ]; then
            __pad_chars="@:space:@"
        fi
        local __pad_str=$(echo -e "$__pad_chars" \
            | awk -v r="$__length" '{ for(i=0;i<r;i++) printf $1; } END { printf "\n" }')
        __pad_str="${__pad_str//@:space:@/ }"
        string_base.return_value "$__pad_str" $__return
    }
    string_base.pad() {
        local __return=$1
        local __in_str="$2"
        local __pad_chars="$3"
        local __length="$4"
        local __in_len=${#__in_str}
        local __to_pad
        let __to_pad=__length-__in_len
        if [ "$__to_pad" -gt 0 ]; then
            if [ "$__pad_chars" == ' ' ]; then
                __pad_chars="@:space:@"
            fi
            local __pad_str=$(echo -e "$__pad_chars" \
                | awk -v r="$__to_pad" '{ for(i=0;i<r;i++) printf $1; } END { printf "\n" }')
            __pad_str="${__pad_str//@:space:@/ }"
        fi
        string_base.return_value "${__in_str}${__pad_str}" $__return
    }
    string_base.endsWith() {
    	local __needle="$1"
    	local __haystack="$2"

    	local __needle_len="${#__needle}"
    	local __start=$(( ${#__haystack} - ${__needle_len} ))
    	if [ $__start -lt 0 ]; then
    		return 1
    	fi

    	if [ "${__haystack:$__start:$__needle_len}" == "$__needle" ]; then
    		return 0
    	else
    		return 1
    	fi
    }
    string_base.startsWith() {
    	local __needle="$1"
    	local __haystack="$2"

    	local __needle_len="${#__needle}"
    	local __start=0
    	if [ $__start -lt 0 ]; then
    		return 1
    	fi

    	if [ "${__haystack:$__start:$__needle_len}" == "$__needle" ]; then
    		return 0
    	else
    		return 1
    	fi
    }
    string_base.removePrefix() {
    	local __returnvar=$1
    	local __needle="$2"
    	local __haystack="$3"

    	local __needle_len="${#__needle}"
    	local __start=0
    	if ! string.startsWith "$__needle" "$__haystack"; then

    	    if [[ "$__returnvar" ]]; then
    	        eval $__returnvar="$(echo -e '$__haystack')"
    	    else
    	        echo "$return_var"
    	    fi
    	    return 1
    	else
    		local __new_val=${__haystack/#$__needle/}

    		if [[ "$__returnvar" ]]; then
    	        eval $__returnvar="$(echo -e '$__new_val')"
    	    else
    	        echo "$return_var"
    	    fi
    		return 0
    	fi

    }
    string_base.removeSuffix() {
    	local __returnvar="$1"
    	local __needle="$2"
    	local __haystack="$3"

    	local __needle_len="${#__needle}"
    	local __start=0
    	if ! string.endsWith "$__needle" "$__haystack"; then

    	    if [[ "$__returnvar" ]]; then
    	        eval $__returnvar="$(echo -e '$__haystack')"
    	    else
    	        echo "$return_var"
    	    fi
    	    return 1
    	else
    		local __new_val=${__haystack/%$__needle/}

    		if [[ "$__returnvar" ]]; then
    	        eval $__returnvar="$(echo -e '$__new_val')"
    	    else
    	        echo "$return_var"
    	    fi
    		return 0
    	fi
    }
    string_base.countChar() {
    	local __return_val=$1
    	local __needle="$2"
    	local __haystack="$3"
    	local __temp_str=${__haystack/${__needle}/}
    	local __char_num=$(( ${#__haystack} - ${#__temp_str} ))

    	eval $__return_val="$(echo -e '$__char_num')"
    }
    string_base.toUpper() {
    	local __return_val=$1
    	local __str="$2"

    	local __ret=${__str^^}
    	string.return_value "$__ret" $__return_val
    }
    string_base.toLower() {
    	local __return_val=$1
    	local __str="$2"

    	local __ret=${__str,,}
    	string.return_value  "$__ret" $__return_val
    }
    string_base.contains() {
    	local __needle="$1"
    	local __haystack="$2"

    	if [[ "$__haystack" == *"$__needle"* ]]; then
    		return 0
    	else
    		return 1
    	fi
    }
    string_base.replace() {
    	local __return_val=$1
    	local __needle="$2"
    	local __replace="$3"
    	local __haystack="$4"

    	local __ret=${__haystack/$__needle/$__replace}
    	string.return_value "$__ret" $__return_val
    }

}
