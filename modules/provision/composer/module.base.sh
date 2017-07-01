import.require 'provision'
import.require 'provision.unzip'

provision.composer_base.init() {
    provision.composer_base.__init() {
        import.useModule 'provision'
        import.useModule 'provision.unzip'
    }
    provision.composer_base.require() {
        provision.require 'unzip' || {
          return 1
        }

        if ! provision.isInstalled 'composer'; then
            sudo apt-get install -y composer
            return $?
        fi
        return 0
    }
}
