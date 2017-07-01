import.require 'colour>base'
# @description The colour namespace provides ....
# Descibe your module here
#
# @example
#   import.require 'colour'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'colour'
#      }
#      some_other_module.someFunction() {
#           local __rgb_val
#           colour.fromHex \
#               --hex-val 00fc7b \
#               --return __rgb_val
#
#           echo "${__rgb_val}"
#      }
#   }
#
# @see colour.fromHex()
colour.init() {
    colour.__init() {
        import.useModule 'colour_base'
    }
    # @description Converts hex colour values to 256 RGB value
    # Useful for convrting hex colours for use with tput
    #
    # @example
    #   local __rgb_val
    #   colour.fromHex \
    #       --hex-val 00fc7b \
    #       --return __rgb_val
    #
    #   echo "${__rgb_val}"
    #
    #   prints 048
    #
    # @arg $1 A description of the first argument
    # @arg $2 A description of the second argument
    colour.fromHex() {
        colour_base.fromHex "$@"
    }
}
