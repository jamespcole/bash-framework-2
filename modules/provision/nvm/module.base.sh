#!/usr/bin/env bash
import.require 'provision'
provision.nvm_base.init() {
    provision.nvm_base.__init() {
          import.useModule 'provision'
    }
    provision.nvm_base.require() {
        if ! provision.isInstalled 'nvm'; then

            # If the file exists but nvm is not available it just needs to be sourced
            if [ -f "${HOME}/.nvm/nvm.sh" ]; then
                . "${HOME}/.nvm/nvm.sh"
            else
                # Download and run the installer
                wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash || {
                    return $?
                }
            fi

            # Add to the .bashrc so it loads on subsequent logins
            if [ $(grep 'NVM_DIR' "$HOME/.bashrc" | wc -l) == '0' ]; then
                echo -e "\nexport NVM_DIR=\"\$HOME/.nvm\"\n[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"\n" \
                    >> "$HOME/.bashrc"
            fi

            # If it's still not available export the NVM_DIR environment variable and source it again
            nvm > /dev/null 2>&1 || {
                export NVM_DIR="${HOME}/.nvm"
                . "${HOME}/.nvm/nvm.sh"
            }
        fi

        # If the command is still not available something went awry
        nvm > /dev/null 2>&1 || {
            return 1
        }

        return 0
    }
}
