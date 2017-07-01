#!/usr/bin/env bash

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
