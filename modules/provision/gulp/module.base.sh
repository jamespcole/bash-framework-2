import.require 'provision'
provision.gulp_base.init() {
    provision.gulp_base.__init() {
        import.useModule 'provision'
    }
    provision.gulp_base.require() {
        if ! provision.isInstalled 'gulp'; then
            npm install -g gulp
            return $?
        fi
        return 0
    }
}
