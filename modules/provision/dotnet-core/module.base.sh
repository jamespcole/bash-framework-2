#!/usr/bin/env bash
import.require 'provision'
provision.dotnet-core_base.init() {
    provision.dotnet-core_base.__init() {
          import.useModule 'provision'
    }
    provision.dotnet-core_base.require() {
        if ! provision.isInstalled 'dotnet'; then
          sudo sh -c \
            'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" \
             > /etc/apt/sources.list.d/dotnetdev.list' || {
               return 1
             }
          sudo apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893 || {
            return 1
          }
          sudo apt-get update || {
            return 1
          }
          sudo apt-get install -y dotnet-dev-1.0.0-preview2-003121 || {
            return 1
          }
        fi
        return 0
    }
}
