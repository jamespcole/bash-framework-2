import.require 'string>base'
# @description The string namespace provides common string functions and
# utilties
#
# @example
#   import.require 'string'
#
# @see string.return_value()
string.init() {
	string.__init() {
		import.useModule 'string_base'
	}
	# @description A helper for returning string from a function and working
	# around bash's string scoping.  It will populate the var passed as the
	# first parameter(which is in the caller's scope) with the value from the
	# second one(which is in local scope)
	#
	# @example
	#   callingFunction() {
	#		local __my_str
	#		calledFunction __my_str 'some other param'
	#		echo "${__my_str}"
	#	}
	#   calledFunction() {
	#		local __return_var=$1
	#		local __other_param="$2"
	#
	#		local __a_new_var='created in this function'
	#		string.return_value "$__a_new_var" $__return_var
	#	}
	#
	# @arg $1 The return variable that will be populated after the call
	# @arg $2 The value that will be returned
	string.return_value() {
		string_base.return_value "$@"
	}
    string.padding() {
        string_base.padding "$@"
    }
    string.pad() {
        string_base.pad "$@"
    }
    string.endsWith() {
        string_base.endsWith "$@"
    }
    string.startsWith() {
        string_base.startsWith "$@"
    }
    string.removePrefix() {
        string_base.removePrefix "$@"
    }
    string.removeSuffix() {
        string_base.removeSuffix "$@"
    }
    string.countChar() {
        string_base.countChar "$@"
    }
    string.toUpper() {
        string_base.toUpper "$@"
    }
    string.toLower() {
        string_base.toLower "$@"
    }
    string.contains() {
        string_base.contains "$@"
    }
    string.replace() {
        string_base.replace "$@"
    }
}
