import.require 'string'

resource_base.init() {
    resource_base.__init() {
        import.useModule 'string'
    }
    resource_base.includeFile() {
        local __file_path="$1"
        local __wrap_function="$2"

        local __wrapped_function
        if [ ! -f "$__file_path" ]; then
            echo "Failed to include file \"${__file_path}\""
            return 1
        fi
        __wrapped_function="${__wrap_function}() {\ncat << 'EOF'\n$(cat ${__file_path})\nEOF\n}"
        eval "$(echo -e "${__wrapped_function}")"
    }
    resource_base.relative() {
        local __file_path="$1"
        # local __wrap_function="$2"
        local __find='/'
        local __rep=':-:'
        local __wrap_function="resource.${__file_path//$__find/$__rep}"

        local __caller_dir
        __caller_dir="$(dirname $(readlink -f ${BASH_SOURCE[2]}) )"
        resource.includeFile "${__caller_dir}/${__file_path}" "${__wrap_function}"
    }

    resource_base.get() {
        local __file_path="$1"
        # local __wrap_function="$2"
        local __find='/'
        local __rep=':-:'
        local __wrap_function="resource.${__file_path//$__find/$__rep}"
        $__wrap_function
    }

}
