import.require 'provision.supervisor>base'
# @description The provision.supervisor namespace
# Installs supervisor
#
# @example
#   import.require 'provision.supervisor'
#
#   some_other_module.init() {
#       some_other_module.__init() {
#           import.useModule 'provision.supervisor'
#       }
#       some_other_module.someFunction() {
#           provision.require 'supervisor' || {
#               echo 'Requirement "supervisor" not met.'
#          }
#       }
#   }
#
# @see provision.supervisor.require()
provision.supervisor.init() {
    provision.supervisor.__init() {
        import.useModule 'provision.supervisor_base'
    }
    # @description Require the system component "supervisor".
    # Check to see if "supervisor" is installed and attempt installation if not currently available.
    #
    # @example
    #   provision.require 'supervisor'
    #
    # @noargs
    #
    # @exitcode 0  If component is available.
    # @exitcode >0  If component is unavailable and installation failed.
    provision.supervisor.require() {
        provision.supervisor_base.require "$@"
    }
    provision.supervisor.addService() {
        provision.supervisor_base.addService "$@"
    }
    provision.supervisor.restart() {
        provision.supervisor_base.restart "$@"
    }
}
