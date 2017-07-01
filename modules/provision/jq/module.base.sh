import.require 'provision'
provision.jq_base.init() {
    provision.jq_base.__init() {
          import.useModule 'provision'
    }
    provision.jq_base.require() {
        if ! provision.isInstalled 'jq'; then
          sudo apt-get install -y jq
          return $?
        fi
        return 0
    }
}
