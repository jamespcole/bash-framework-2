
provision.git_docs() {
	local -A __docs
	read -d '' __docs['provision.git_base.init'] <<"EOF"
	# Public: Execute commands in debug mode.
	#
	# Takes a single argument and evaluates it only when the test script is started
	# with --debug. This is primarily meant for use during the development of test
	# scripts.
	#
	# $1 - Commands to be executed.
	#
	# Examples
	#
	#   test_debug "cat some_log_file"
	#
	# Returns the exit code of the last command executed in debug mode or 0
	# otherwise.
EOF
}
