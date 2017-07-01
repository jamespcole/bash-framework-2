#!/usr/bin/env bash
# This is an example of inclduing the params module.
# Place require module calls at the top of the file.
import.require 'textprint'

bml_tags_base.init() {
    bml_tags_base.__init() {
        import.useModule 'textprint'
    }
    b:u() {
        textprint.underline "$@"
    }
    b:b() {
        textprint.bold "$@"
    }
    b:d() {
        textprint.dim "$@"
    }
    b:list() {
        textprint.list "$@"
    }
    b:li() {
        textprint.listItem "$@"
    }
    b:in() {
        textprint.indent "$@"
    }
    b:h1() {
        textprint.heading1 "$@"
    }
    b:h2() {
        textprint.heading2 "$@"
    }
    b:h3() {
        textprint.heading3 "$@"
    }
    b:hr() {
        textprint.hr "$@"
    }
    b:box() {
        textprint.box "$@"
    }
    b:fmt() {
        textprint_base.fmt "$@"
    }
    b:horiz() {
        textprint_base.horiz "$@"
    }
    b:br() {
        textprint.br "$@"
    }
    b:em() {
        textprint.emphasis "$@"
    }
    b:success() {
        textprint.success "$@"
    }
    b:danger() {
        textprint.danger "$@"
    }
    b:info() {
        textprint.info "$@"
    }
    b:warning() {
        textprint.warning "$@"
    }
    b:figlet() {
        textprint.figlet "$@"
    }
}
