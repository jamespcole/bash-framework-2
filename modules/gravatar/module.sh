import.require 'gravatar>base'
# @description The gravatar namespace provides ....
# Descibe your module here
#
# @example
#   import.require 'gravatar'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'gravatar'
#      }
#      some_other_module.someFunction() {
#         gravatar.sayHello
#      }
#   }
#
# @see gravatar.sayHello()
gravatar.init() {
	gravatar.__init() {
		import.useModule 'gravatar_base'
	}
	# @description A function that prints "Hello World!".  This description
	# will appear in the generated documentation for this function
	#
	# @example
	#   gravatar.sayHello
	#
	#   prints 'Hello World' to std out
	#
	# @arg $1 A description of the first argument
	# @arg $2 A description of the second argument
	gravatar.downloadImage() {
		gravatar_base.downloadImage "$@"
	}
}
