import.require 'provision.shellcheck>base'
# @description The provision.shellcheck namespace
# Installs shellcheck
#
# @example
#   import.require 'provision.shellcheck'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.shellcheck'
#       }
#       some_other_module.someFunction() {
#           provision.require 'shellcheck' || {
#               echo 'Requirement "shellcheck" not met.'
#          }
#       }
#   }
#
# @see provision.shellcheck.require()
provision.shellcheck.init() {
    provision.shellcheck.__init() {
        import.useModule 'provision.shellcheck_base'
    }
    # @description Require the system component "shellcheck".
    # Check to see if "shellcheck" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'shellcheck'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode >0  If component is unavailable and installation failed.
    provision.shellcheck.require() {
        provision.shellcheck_base.require "$@"
    }
}
