import.require 'provision'
provision.motd_base.init() {
    provision.motd_base.__init() {
          import.useModule 'provision'
    }
    provision.motd_base.require() {
        if ! provision.isInstalled 'update-motd'; then
          sudo apt-get install -y update-motd
          return $?
        fi
        return 0
    }
}
