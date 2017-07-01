import.require 'string'
import.require 'params'
reflection_base.init() {
	reflection_base.__init() {
		import.useModule 'string'
        import.useModule 'params'
	}
	reflection_base.getModuleFunctions() {
		local __ret=$1
		local __ref_mod_name="$2"

		local __module_file_path
		import.getModulePath __module_file_path "$__ref_mod_name"
		local __function_list=$(bash -c "import.require() { echo 'foo' > /dev/null; }; . ${__module_file_path}; ${__ref_mod_name}.init; declare -F")
		__function_list=$(echo "${__function_list}" | sed 's/^declare -f //' | sed 's/^import.require$//' | sed '/^$/d')
		string.return_value "$__function_list" $__ret
	}
    reflection_base.printInfoForFile() {
        local -A __params
        __params['file-path']=
        params.get "$@"

        local __mod_file="${__params['file-path']}"

        local __functions=$( (bash -c 'source '"${__mod_file}"' 2>&1 && declare -f') \
            | grep -v 'import.require' \
            | grep -v 'vendor.require' \
            | grep '^    function *.* () $')

        echo "$__functions" | awk '{ print $2 }'
    }

    reflection_base.printDependencies() {
        local -A __params
        __params['file-path']=
        params.get "$@"

        local __mod_file="${__params['file-path']}"
        __mod_file=${__mod_file/.sh/.base.sh}

        local __modules=$(grep '^import.require' "$__mod_file" | awk '{ print $2 }' | sed "s/'//g")
        local __vendor=$(grep '^vendor.require' "$__mod_file" | awk '{ print $2 }' | sed "s/'//g")

        echo -e "${__modules}\n${__vendor}"
    }
    reflection_base.printCommandDependencies() {
        local -A __params
        __params['file-path']=
        __params['dep-type']='module' # module, system or vendor
        params.get "$@"

        local __cmd_file="${__params['file-path']}"

        if [ "${__params['dep-type']}" == 'module' ]; then
            grep '^import.require' "$__cmd_file" \
            | awk '{ print $2 }' \
            | sed "s/'//g" \
            | grep -v 'provision.'
        elif [ "${__params['dep-type']}" == 'vendor' ]; then
            grep '^vendor.require' "$__cmd_file" \
            | awk '{ print $2 }' \
            | sed "s/'//g"
        elif [ "${__params['dep-type']}" == 'system' ]; then
            grep '^import.require' "$__cmd_file" \
            | awk '{ print $2 }' \
            | sed "s/'//g" \
            | grep 'provision.'
        fi

        # echo -e "${__modules}\n${__vendor}"
    }

    reflection_base.timeFunctions() {
        # local __module_name="$1"
        local __mod_path="$1"
        # import.getModulePath __mod_path "$__module_name" "$2"
        echo "mod path ="
        # local __reqs="$(grep 'import.require' ${__mod_path})"
        # local __test=$(bash -c 'source "${__mod_path}" && declare -f 2>&1')
        # local __test2="$((bash -c 'source ${__mod_path} && declare -f 2>&1') \
        #     | grep -v 'import.require' \
        #     | grep -v 'vendor.require' \
        #     | sed 's/^    { $//g' \
        #     | sed '/^    function *.*() / s/$/{\n        local __start_ms=\$(date +%s%3N)/' \
        #     | sed 's/^    }/\n        echo \"\$(caller 1) - \$(( \$(date +%s%3N) - \$__start_ms ))\"\n    }/')"
        #
        # echo -e "${__reqs}\n\n${__test}" > /tmp/test3
    }
}
