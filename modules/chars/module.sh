import.require 'chars>base'
# @description The chars namespace provides ....
# Descibe your module here
#
# @example
#   import.require 'chars'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'chars'
#      }
#      some_other_module.someFunction() {
#         chars.sayHello
#      }
#   }
#
# @see chars.sayHello()
chars.init() {
    chars.__init() {
        import.useModule 'chars_base'
    }
    # @description A function that prints "Hello World!".  This description
    # will appear in the generated documentation for this function
    #
    # @example
    #   chars.sayHello
    #
    #   prints 'Hello World' to std out
    #
    # @arg $1 A description of the first argument
    # @arg $2 A description of the second argument
    chars.sayHello() {
        chars_base.sayHello "$@"
    }
}
