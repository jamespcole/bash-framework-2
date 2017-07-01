#!/usr/bin/env bash
resource.relative 'help.bml'

login_message.help.init() {
    login_message.help.print() {
        resource.get 'help.bml'
    }
}