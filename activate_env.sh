#!/usr/bin/env bash

syspath.removePath() {
    # PATH => /bin:/opt/a dir/bin:/sbin
    local pathStr=":$1:"
    local removePath="$2"

    # WORK => :/bin:/opt/a dir/bin:/sbin:
    pathStr=${pathStr/:$removePath:/:}
    # WORK => :/bin:/sbin:
    pathStr=${pathStr%:}
    pathStr=${pathStr#:}
    # export PATH="$pathStr"
    echo "$pathStr"
}

bf2.removePaths() {
    local __app_paths
    local IFS=':'
    read -r -a __app_paths <<< "${BF2_PATH}"
    local __app_path
    local __newPath="$PATH"
    for __app_path in "${__app_paths[@]}"
    do
        if [ "$__app_path" != '' ]; then
            __newPath=$(syspath.removePath "$__newPath" "${__app_path}/install_hooks")
        fi
    done
    echo "${__newPath}"
}

# If the BF2 path is set already we are presumably changing environments
# so we should remove the existing location from the system PATH environment var
if [ ! -z BF2_FW_PATH ]; then
    export PATH="$(bf2.removePaths)"
fi

# Remove the existing path from the BF2 path
if [ ! -z BF2_PATH ]; then
    export BF2_PATH=$(syspath.removePath "$BF2_PATH" "${BF2_FW_PATH}")
fi

if [ $(echo "$BF2_FW_PATH" | grep $(dirname $(readlink -f "${BASH_SOURCE}")) | wc -l) == '0' ]; then
    unset BF2_FW_PATH
    export BF2_FW_PATH="$(dirname $(readlink -f "${BASH_SOURCE}"))"
fi
if [ $(echo "$BF2_PATH" | grep $(dirname $(readlink -f "${BASH_SOURCE}")) | wc -l) == '0' ]; then
    export BF2_PATH="${BF2_PATH}:$(dirname $(readlink -f "${BASH_SOURCE}"))"
fi
if [ $(echo "$PATH" | grep "$(dirname $(readlink -f "${BASH_SOURCE}"))/install_hooks" | wc -l) == '0' ]; then
    export PATH="${PATH}:$(dirname $(readlink -f "${BASH_SOURCE}"))/install_hooks"
fi
