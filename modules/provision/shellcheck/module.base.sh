import.require 'provision'
provision.shellcheck_base.init() {
    provision.shellcheck_base.__init() {
          import.useModule 'provision'
    }
    provision.shellcheck_base.require() {
        if ! provision.isInstalled 'shellcheck'; then
          sudo apt-get install -y shellcheck
          return $?
        fi
        return 0
    }
}
