provision_base.init() {
    provision_base.isInstalled() {
        if [ $(which "$1" | wc -l) == '0' ]; then
            logger.info --message \
                "Command \"${1}\" is not installed" \
                --verbosity 2
            return 1
        fi
        # logger.info --message \
        #     "Command \"${1}\" is already installed" \
        #     --verbosity 2
        return 0
    }
    provision_base.require() {
        local __item_name="$1"
        shift;
        "provision.${__item_name}.require" "$@"
    }
    provision_base.isPackageInstalled() {
        if [ $(apt-cache policy "$1" | grep 'Installed: (none)' | wc -l) != '0' ]; then
            logger.info --message \
                "Package \"${1}\" is not installed" \
                --verbosity 2
            return 1
        fi
        logger.info --message \
            "Package \"${1}\" is already installed" \
            --verbosity 2
        return 0
    }
}
