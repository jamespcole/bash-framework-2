import.require 'provision.motd>base'
# @description The provision.motd namespace
# Installs motd
#
# @example
#   import.require 'provision.motd'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.motd'
#       }
#       some_other_module.someFunction() {
#           provision.require 'motd' || {
#               echo 'Requirement "motd" not met.'
#          }
#       }
#   }
#
# @see provision.motd.require()
provision.motd.init() {
    provision.motd.__init() {
        import.useModule 'provision.motd_base'
    }
    # @description Require the system component "motd".
    # Check to see if "motd" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'motd'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode >0  If component is unavailable and installation failed.
    provision.motd.require() {
        provision.motd_base.require "$@"
    }
}
