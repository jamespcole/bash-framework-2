import.require 'provision'
provision.md5_base.init() {
    provision.md5_base.__init() {
          import.useModule 'provision'
    }
    provision.md5_base.require() {
        if ! provision.isInstalled 'md5sum'; then
          sudo apt-get install -y md5sum
          return $?
        fi
        return 0
    }
}
