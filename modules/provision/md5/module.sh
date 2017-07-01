import.require 'provision.md5>base'
# @description The provision.md5 namespace
# Installs md5
#
# @example
#   import.require 'provision.md5'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.md5'
#       }
#       some_other_module.someFunction() {
#           provision.require 'md5' || {
#               echo 'Requirement "md5" not met.'
#          }
#       }
#   }
#
# @see provision.md5.require()
provision.md5.init() {
    provision.md5.__init() {
        import.useModule 'provision.md5_base'
    }
    # @description Require the system component "md5".
    # Check to see if "md5" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'md5'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode >0  If component is unavailable and installation failed.
    provision.md5.require() {
        provision.md5_base.require "$@"
    }
}
