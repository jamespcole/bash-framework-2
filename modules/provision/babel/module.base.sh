#!/usr/bin/env bash
import.require 'provision'
provision.babel_base.init() {
    provision.babel_base.__init() {
          import.useModule 'provision'
    }
    provision.babel_base.require() {
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
        if ! provision.isInstalled 'babel'; then
            npm install -g babel-core babel-loader \
                babel-preset-es2015 \
                babel-polyfill \
                babel-runtime \
                babel-plugin-transform-runtime \
                webpack \
            || {
                return 1
            }
        fi
        return 0
    }
}
