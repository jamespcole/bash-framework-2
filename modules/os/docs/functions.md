
* [os.init()](#osinit)
* [os.is()](#osis)


## os.init()

The os namespace
Provides os specific functions and the global associative array "__OS" which
contains details about the current operating system.

#### Example

```bash
   import.require 'os'

   some_other_module.init() {
      some_other_module.__init() {
         import.useModule 'os'
      }
      some_other_module.someFunction() {
           if os.is 'Name' 'Ubuntu'; then
              echo 'Is Ubuntu'
           fi
      }
   }

```

#### See also

* [os.is()](#os.is())

## os.is()

Check OS property
Will check if the specified OS property is equal to the passed value

#### Example

```bash
   if os.is 'FAMILY' 'Linux'; then
       echo 'Is Linux'
   fi

```

### Arguments

* **$1** (Property): A key in the __OS array
* **$2** (Value): The value to compare
