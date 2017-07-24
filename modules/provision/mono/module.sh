#!/usr/bin/env bash
import.require 'provision.mono>base'

provision.mono.init() {
    provision.mono.__init() {
        import.useModule 'provision.mono_base'
    }

    provision.mono.require() {
        provision.mono_base.require "$@"
    }

    provision.mono.xsp() {
        provision.mono_base.xsp "$@"
    }

    provision.mono.addPpa() {
        provision.mono_base.addPpa "$@"
    }
}
