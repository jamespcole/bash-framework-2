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

# If the BF2 path is set already we are presumably changing environments
# so we should remove the existing location from the system PATH environment var
if [ ! -z BF2_FW_PATH ]; then
    export PATH=$(syspath.removePath "$PATH" "${BF2_FW_PATH}/install_hooks")
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
