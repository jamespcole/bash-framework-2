#!/usr/bin/env bash
import.require 'provision'
import.require 'provision.nvm'
provision.webpack_base.init() {
    provision.webpack_base.__init() {
          import.useModule 'provision'
          import.useModule 'provision.nvm'
    }
    provision.webpack_base.require() {

        if ! provision.isInstalled 'node'; then
            provision.require 'nvm' || {
                logger.error --message \
                    'Failed to install nvm'
                return 1
            }
            if ! test "$NVM_DIR"; then
                . ~/.nvm/nvm.sh
            fi

            if ! provision.isInstalled 'node'; then
                nvm install 6 || {
                    logger.error --message \
                        'Failed to install node'
                    return 1
                }
                nvm use 6 || {
                    return 1
                }
            fi
        else
            provision.require 'nvm' || {
                logger.error --message \
                    'Failed to install nvm'
                return 1
            }
            nvm use 6 || {
                nvm install 6 || {
                    logger.error --message \
                        'Failed to install node'
                    return 1
                }
                nvm use 6 || {
                    return 1
                }
            }
        fi

        if ! provision.isInstalled 'webpack'; then
        #   npm install -g webpack
            # npm install -g webpack@2.1.0-beta.20
            npm install -g webpack@1.13.2
            return $?
        fi
        return 0
    }
}
