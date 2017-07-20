#!/usr/bin/env bash
import.require 'provision'
import.require 'os.updates'
import.require 'provision.software-properties-common'
provision.mosquitto_base.init() {
	provision.mosquitto_base.__init() {
		  import.useModule 'provision'
	}
	provision.mosquitto_base.require() {
		if ! provision.isInstalled 'mosquitto'; then
			provision.mosquitto_base.addPPA || {
				return 1
			}

			sudo apt-get -y install mosquitto || {
				return 1
			}


			return $?
		fi
		return 0
	}

	provision.mosquitto_base.requireClients() {
		if ! provision.isInstalled 'mosquitto-clients'; then
			provision.mosquitto_base.addPPA || {
				return 1
			}

			sudo apt-get -y install mosquitto-clients || {
				return 1
			}


			return $?
		fi
		return 0
	}

	provision.mosquitto_base.addPPA() {
		provision.isPpaInstalled 'mosquitto' && {
			return 0
		}

		provision.require 'software-properties-common' || {
			logger.error --message \
				'Failed to install software-properties-common required for adding mosquitto PPA'
			return 1
		}

		sudo apt-add-repository -y ppa:mosquitto-dev/mosquitto-ppa || {
			logger.error --message \
				'Failed to add mosquitto PPA'
			return 1
		}
		script.tryCommand --command 'os.updates.check' --retries 4 || {
			logger.error --message \
				'Failed to update apt sources after adding mosquitto PPA'
			return 1
		}

		return "$?"
	}
}
