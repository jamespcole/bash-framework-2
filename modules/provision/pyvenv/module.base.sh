import.require 'provision'
import.require 'provision.curl'
import.require 'params'
import.require 'os'

provision.pyvenv_base.init() {
    provision.pyvenv_base.__init() {
          import.useModule 'provision'
          import.useModule 'params'
          import.useModule 'provision.curl'
          import.useModule 'os'
    }
    provision.pyvenv_base.require() {
        local -A __params
        __params['env-name']='py3'
        __params['add-to-bashrc']='0'
        params.get "$@"
        provision.require 'curl' || {
            logger.error \
                --message 'Installation of curl failed...'
            return 1
        }

        if [ "${__OS['ID']}" == 'raspbian' ] && [ "${__OS['VERSION_ID']}" == '8' ]; then
            if ! provision.isPackageInstalled 'python3.4-venv'; then
              sudo apt-get install -y python3.4-venv || {
                  return $?
              }
            fi
        else
            if ! provision.isPackageInstalled 'python3.5-venv'; then
              sudo apt-get install -y python3.5-venv || {
                  return $?
              }
            fi
        fi
        if ! provision.isPackageInstalled 'libffi-dev'; then
            sudo apt-get install -y libffi-dev || {
                return $?
            }
        fi
        if ! provision.isPackageInstalled 'libssl-dev'; then
            sudo apt-get install -y libssl-dev || {
                return $?
            }
        fi

        local __env="${__params['env-name']}"
        local __install_dir="/home/${USER}/.pyvenv"
        mkdir -p "${__install_dir}"
        local __pyvenv_dir="${__install_dir}/${__env}"
        if [ ! -f "${__pyvenv_dir}/bin/activate" ]; then
            pushd "$__install_dir"
            if [ $(which pyvenv-3.5 | wc -l) != '0' ]; then
                pyvenv-3.5 "${__env}" --without-pip || {
                    return 1
                }
            elif [ $(which pyvenv-3.4 | wc -l) != '0' ]; then
                pyvenv-3.4 "${__env}" --without-pip || {
                    return 1
                }
            else
                pyvenv "${__env}" --without-pip || {
                    return 1
                }
            fi
            popd
        fi

        if [ ! -f "${__pyvenv_dir}/bin/pip" ]; then
            source "${__pyvenv_dir}/bin/activate"
            curl https://bootstrap.pypa.io/get-pip.py | python || {
                return 1
            }
        fi

        if [ "${__params['add-to-bashrc']}" == '1' ]; then
            if grep -q "${__pyvenv_dir}/bin/activate" "/home/${USER}/.bashrc"; then
                logger.info --message \
                    "Python env \"${__env}\" already added to bashrc" \
                    --verbosity 2
            else
                logger.info --message \
                    "Adding python env \"${__env}\" to bashrc" \
                    --verbosity 2
                echo "# The python virtual environment that will be loaded on login" \
                    >> "/home/${USER}/.bashrc"
                echo "source ${__pyvenv_dir}/bin/activate" >> "/home/${USER}/.bashrc"
            fi
        fi

        return 0
    }
}
