#!/usr/bin/env bash
import.require 'web>base'
# @description The web namespace provides ....
# Descibe your module here
#
# @example
#   import.require 'web'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'web'
#      }
#      some_other_module.someFunction() {
#         web.sayHello
#      }
#   }
#
# @see web.sayHello()
web.init() {
    web.__init() {
        import.useModule 'web_base'
    }
    # @description A function that prints "Hello World!".  This description
    # will appear in the generated documentation for this function
    #
    # @example
    #   web.sayHello
    #
    #   prints 'Hello World' to std out
    #
    # @arg $1 A description of the first argument
    # @arg $2 A description of the second argument
    web.login() {
        web_base.login "$@"
    }
    web.parseUrl() {
        web_base.parseUrl "$@"
    }

}
