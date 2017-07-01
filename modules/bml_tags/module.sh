#!/usr/bin/env bash
import.require 'bml_tags>base'
# @description The bml_tags namespace provides ....
# Descibe your module here
#
# @example
#   import.require 'bml_tags'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'bml_tags'
#      }
#      some_other_module.someFunction() {
#         bml_tags.sayHello
#      }
#   }
#
# @see bml_tags.sayHello()
bml_tags.init() {
    bml_tags.__init() {
        import.useModule 'bml_tags_base'
    }
    # @description A function that prints "Hello World!".  This description
    # will appear in the generated documentation for this function
    #
    # @example
    #   bml_tags.sayHello
    #
    #   prints 'Hello World' to std out
    #
    # @arg $1 A description of the first argument
    # @arg $2 A description of the second argument
    bml_tags.sayHello() {
        bml_tags_base.sayHello "$@"
    }
}
