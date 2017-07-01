#!/usr/bin/env bash
import.require 'os.time>base'
# @description The os.time namespace
# Provides date and time functions
#
# @example
#   import.require 'os.time'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'os.time'
#      }
#      some_other_module.someFunction() {
#         os.time.setTimeZoneString \
#           --tz-string 'Australia/Melbourne'
#      }
#   }
#
# @see os.time.timeZoneString()
# @see os.time.setTimeZoneString()
os.time.init() {
    os.time.__init() {
        import.useModule 'os.time_base'
    }
    # @description Returns the currently configured timezone
    # Returns a string representing the current timezone, for a list
    # of possible values run `timedatectl list-timezones`
    #
    # @example
    #   local __tz
    #   os.time.timeZoneString --return __tz
    #
    #   echo "The timezone is ${__tz}"
    #
    # @arg --return The return variable
    os.time.timeZoneString() {
        os.time_base.timeZoneString "$@"
    }
    # @description Sets the system timezone
    # Set the system timezone to the passed timezone string.
    # To see possible values run `timedatectl list-timezones`
    #
    # @example
    #   os.time.setTimeZoneString \
    #       --tz-string 'Australia/Melbourne'
    #
    # @arg --tz-string The new timezone string
    os.time.setTimeZoneString() {
        os.time_base.setTimeZoneString "$@"
    }
}
