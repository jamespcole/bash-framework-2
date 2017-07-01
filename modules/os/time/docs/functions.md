
* [os.time.init()](#ostimeinit)
* [os.time.timeZoneString()](#ostimetimeZoneString)
* [os.time.setTimeZoneString()](#ostimesetTimeZoneString)


## os.time.init()

The os.time namespace
Provides date and time functions

#### Example

```bash
   import.require 'os.time'

   some_other_module.init() {
      some_other_module.__init() {
         import.useModule 'os.time'
      }
      some_other_module.someFunction() {
         os.time.setTimeZoneString \
           --tz-string 'Australia/Melbourne'
      }
   }

```

#### See also

* [os.time.timeZoneString()](#os.time.timeZoneString())

#### See also

* [os.time.setTimeZoneString()](#os.time.setTimeZoneString())

## os.time.timeZoneString()

Returns the currently configured timezone
Returns a string representing the current timezone, for a list
of possible values run `timedatectl list-timezones`

#### Example

```bash
   local __tz
   os.time.timeZoneString --return __tz

   echo "The timezone is ${__tz}"

```

### Arguments

* --return The return variable

## os.time.setTimeZoneString()

Sets the system timezone
Set the system timezone to the passed timezone string.
To see possible values run `timedatectl list-timezones`

#### Example

```bash
   os.time.setTimeZoneString \
       --tz-string 'Australia/Melbourne'

```

### Arguments

* --tz-string The new timezone string
