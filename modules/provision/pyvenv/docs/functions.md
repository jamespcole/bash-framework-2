
* [provision.pyvenv.init()](#provisionpyvenvinit)
* [provision.pyvenv.require()](#provisionpyvenvrequire)


## provision.pyvenv.init()

The provision.pyvenv namespace
Installs pyvenv and sets up a virtual environment for python 3+ with pip.
Optionally it will add the activation to your .bashrc for so it will be
activate automatically on login.

#### Example

```bash
   import.require 'provision.pyvenv'

   some_other_module.init() {
       some_other_module.__init() {
           import.useModule 'provision.pyvenv'
       }
       some_other_module.someFunction() {
           provision.require 'pyvenv' --env-name p3 --add-to-bashrc 1 || {
               echo 'Requirement "pyvenv" not met.'
          }
       }
   }

```

#### See also

* [provision.pyvenv.require()](#provision.pyvenv.require())

## provision.pyvenv.require()

Require the system component "pyvenv".
Check to see if "pyvenv" is installed and attempt installation if not currently available.
Set up a virtual environment with python 3+ and pip.
Add to .bashrc option.

#### Example

```bash
   provision.require 'pyvenv' --env-name 'my-new-env' --add-to-bashrc 0

```

### Arguments

* --env-name The name of the virtual environment to be created, defaults to py3
* --add-to-bashrc Pass 1 to have activation of this environment added to your .bashrc, default 0

### Exit codes

* **0**:  If component is available.
* &gt;**0**:  If component is unavailable and installation failed.
