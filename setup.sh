setup.main() {
    local __setup_path="$(dirname $(readlink -f ${BASH_SOURCE}) )"
    source "${__setup_path}/activate_env.sh"
    "${__setup_path}/framework/install_bootstrap.sh"
    "${__setup_path}/framework/install_commands.sh"
}

setup.main
