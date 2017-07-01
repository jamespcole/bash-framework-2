# This line is required and is used to locate and load the project bootstrap which
# is needed for setting up functionality which is common to all commands.
source $(bash_bootstrap $(dirname $(readlink -f ${BASH_SOURCE}) ) ) || exit 1

# Uses a modified version of the script found here:
# https://github.com/reconquest/shdoc

import.require 'args'

args_example2.init() {
    args_example2.__init() {
		import.useModule 'args'
		args_example2.args
    }
	args_example2.args() {
		args.add --key 'input_file' \
			--name 'Input File' \
			--alias '-i' \
            --alias '--input-file' \
			--desc 'The input template file' \
			--required '0' \
			--has-value 'y' \
			--excludes 'module_name'

		args.add --key 'save_file' \
			--name 'Save File' \
			--alias '-s' \
            --alias '--save' \
			--desc 'Automatically save the docs file' \
			--type 'switch' \
			--default '0' \
			--has-value 'n'

		args.add --key 'includes_test' \
			--name 'Include Test' \
			--alias '-t' \
            --alias '--test' \
			--desc 'Test including another param' \
			--type 'switch' \
			--default '0' \
			--has-value 'n' \
			--includes 'save_file'

		args.add --key 'required_unless_test' \
			--name 'Required Unless Test' \
			--alias '-r' \
			--alias '--req-u' \
			--desc 'Test requiring unless another param' \
			--type 'switch' \
			--default '0' \
			--has-value 'n' \
			--required-unless 'save_file'
	}
    args_example2.main() {
		echo "Hello World"
    }
}

if [[ "$0" == "$BASH_SOURCE" ]] || ! [[ -n "$BASH_SOURCE" ]]; then
    import.useModule 'bootstrap'
    bootstrap.run 'args_example2' "$@"
fi

