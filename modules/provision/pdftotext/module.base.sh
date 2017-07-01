#!/usr/bin/env bash
import.require 'provision'
provision.pdftotext_base.init() {
    provision.pdftotext_base.__init() {
          import.useModule 'provision'
    }
    provision.pdftotext_base.require() {
        if ! provision.isInstalled 'pdftotext'; then
          sudo apt-get install -y pdftotext
          return $?
        fi
        return 0
    }
}
