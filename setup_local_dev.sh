source 'modules/import.sh'
import.init
import.require 'script'
import.require 'provision.vagrant'
import.require 'provision.git'
import.require 'provision.virtualbox'

setup_local_dev.main() {
    import.useModule 'script'
    import.useModule 'provision.vagrant'
    import.useModule 'provision.git'
    import.useModule 'provision.virtualbox'

    provision.vagrant.require || {
        script.exitWithError "Vagrant requirement not met"
    }

    provision.require 'virtualbox' || {
        script.exitWithError "virtualbox requirement not met"
    }
}

setup_local_dev.main
