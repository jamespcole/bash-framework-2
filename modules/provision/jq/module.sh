import.require 'provision.jq>base'
# @description The provision.jq namespace
# Installs jq
#
# @example
#   import.require 'provision.jq'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.jq'
#       }
#       some_other_module.someFunction() {
#           provision.require 'jq' || {
#               echo 'Requirement "jq" not met.'
#          }
#       }
#   }
#
# @see provision.jq.require()
provision.jq.init() {
    provision.jq.__init() {
        import.useModule 'provision.jq_base'
    }
    # @description Require the system component "jq".
    # Check to see if "jq" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'jq'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode >0  If component is unavailable and installation failed.
    provision.jq.require() {
        provision.jq_base.require "$@"
    }
}
