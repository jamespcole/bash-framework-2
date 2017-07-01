
* [provision.awscli.init()](#provisionawscliinit)
* [provision.awscli.require()](#provisionawsclirequire)


## provision.awscli.init()

The provision.awscli namespace
Installs awscli

#### Example

```bash
   import.require 'provision.awscli'

   some_other_module.init() {
       some_other_module.__init() {
           import.useModule 'provision.awscli'
       }
       some_other_module.someFunction() {
           provision.require 'awscli' || {
               echo 'Requirement "awscli" not met.'
          }
       }
   }

```

#### See also

* [provision.awscli.require()](#provision.awscli.require())

## provision.awscli.require()

Require the system component "awscli".
Check to see if "awscli" is installed and attempt installation if not currently available.

#### Example

```bash
   provision.require 'awscli'

```

### Arguments

* --source The source to install from, either "pip" or "apt", defaults to "pip"

### Exit codes

* **0**:  If component is available.
* &gt;**0**:  If component is unavailable and installation failed.
