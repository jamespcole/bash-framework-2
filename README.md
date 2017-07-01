# Bash Framework 2

The aim of this framework is to bring some sort of order, tidiness and reusability to bash.

## Why?

Bash is awesome, it's portable, reliable, fast, versatile and a powerful tool for provisioning and management.  

The downside is that scripts are often "quick and dirty" and are not very structured or designed for code reuse.

It doesn't have to be though, and this project aims to provide a set of utilities and conventions to help solve some of these problems.

## Installation

You can install bf2 as a standalone app by simply cloning this repository.  However given that your scripts for provisioning and automation are usually part of a larger project you will most likely want to add bf2 as a submodule so that you can use the bf2 framework for all the scripts related to a specific project.

To add as a submodule(to the `scripts/bf2` directory in this example) run the following:

`git submodule add git@bitbucket.org:inoutput/bf2.git scripts/bf2`

To install bf2 simply run the following from the root of the bf2 directory:

`./setup.sh`

This will add the `BF2_PATH` and `BF2_FW_PATH` environment variables to your path automatically.

To start using bf2 commands immediately you will need to manually call:

`source activate_env.sh`

This is only required to avoid a logging in and logging out again as the previous setup command has added this to you `.bashrc` and will activate every time you log in.

### Creating an Environment

In most cases you will want to create a new bf2 environment within your project.  This means that you can create project specific commands and modules that live in your project's own repo while still including modules and running commands that live in the core of bf2.  

Fortunately this is super simple to do, once you have bf2 installed simply cd to the directory you want as the root of your own bf2 project and run the following:

`bf2_env --create`

To activate your new environment run:

`source activate_env.sh`


Once your environment is created and activated any commands or modules you create will be added in your project's environment directories by default. Any commands, module imports or vendor includes will check in the active environment before looking in the actual core framework directories.  This allows you to keep your project specific functionality separate from the bf2 core, or have a single framework used by multiple environments.  It also means that you can override core modules and commands on a per environment basis.  Of course if you create a module or command that you think will be useful for someone else you can create it in the core bf2 framework and issue a pull request.

You can view the info about your current environment by running;

`bf2_env --info`

## Key Concepts

These are some of the fundamental concepts and paradigms of the project.

Let's start with an example before we get in to the specifics.

### Example Command

```bash
#!/usr/bin/env bash
# This line is required and is used to locate and load the project bootstrap which
# is needed for setting up functionality which is common to all commands.
source $(bash_bootstrap $(dirname $(readlink -f ${BASH_SOURCE}) ) ) || exit 1

import.require 'provision.ls'

example1.init() {
    example1.__init() {
        example1.args
    }
    example1.args() {
        args.add --key 'example1_param1' \
            --name 'Example Parameter' \
            --alias '-p' \
            --alias '--param' \
            --desc 'An example of a required parameter' \
            --required '1' \
            --has-value 'y'
    }
    example1.main() {
        # This requires the ls command
        provision.require 'ls' || {
            script.exitWithError "ls requirement no met."
        }

        # --->  Put your implementation here  <----

        logger.info --message \
            "This is how you log messages"

        script.exitSuccess "Your script has exited successfully!"
    }
}

# If sourced, load all functions.
# If executed, perform the actions as expected.
if [[ "$0" == "$BASH_SOURCE" ]] || ! [[ -n "$BASH_SOURCE" ]]; then
    import.useModule 'bootstrap'
    bootstrap.run 'example1' "$@"
fi
```

### Creating a new Command

To create a new command run:
```
create_cmd -n <Your new command name>
```

This will scaffold and install your new command.  The output will show the path of the new command. You can now add your implementation to the run.sh file.

### The Structure of Command Files

Commands live in a subfolder of the `commands` directory, which is located in the root of your bf2 environment.  The implmentation of command is in a file named `run.sh` and the name of the directory that `run.sh` is located in is used as the default name for your command.  So that you can easily run commands the directory called `install_hooks` in the root of your bf2 environment is added to your path when you activate a bf2 environment and contains symlinks to all your command `run.sh` files.  

For example:

```
app
    |-- commands
    |    |-- your_command
    |        |-- extensions
    |             |-- help.sh
    |             |-- another_extension.sh
    |        |-- run.sh
    |
    |-- install_hooks
        |-- your_command  -- (symlink to) --> run.sh
```

This means that you can run `your_command` from anywhere and it will execute the correct `run.sh` file.

If you have commands that were not created on your machine, for example after pulling updates from git, you can run `install_commands` to refresh the links located in your `install_hooks` directory.  

NOTE: this is also useful when you have moved, renamed or just generally broken the command symlinks.  It does not not install anything in the system path or make any changes outside your bf2 environment and the symlinks are not checked in to source control so don't be afraid to run `install_commands` when needed.

#### Command extensions

Command extensions are intended to provide a simple way to break up the functionality of a command accross multiple files.  Extensions are optional and are really just provided to help with readability and to keep the amount of code in the `run.sh` file to a minimum so that the logic of the command can be easily understood.

A common usecase for extensions would be when your command requires large slabs of text for templates or docs/examples in heredoc strings and you don't want them cluttering up the rest of your code.

__NOTE__: extensions should only be used for a single command, if you have functionality you want to use in multiple commands consider using a `module` instead.

Here is an example of an extension that contains a description and information about a command:

```bash
#!/usr/bin/env bash
my_command.help.init() {
    my_command.help.print() {
        cat << EOF
This is some help that is stored in a heredoc string.
It makes the formatting of the code look gross so I moved it to
an extension.

Now  I don\'t have to look at it all the time.
EOF
    }
}
```

This file should live in at `extensions/help.sh` in the directory that contains the commands `run.sh` file.

To use this extension from your command you would do something like this:

```bash
# Import your extension
import.extension 'my_command.help'

my_command.init() {
    my_command.__init() {
        # Initialise the extension
        import.useExtension 'my_command.help'
    }
    my_command.main() {
        # Call an extension function
        my_command.help.print
    }
}
```

#### Including resources(files) in a command

Static resources such as text files can be included into your script and exposed via a function.  You can use this to include things like config files, mustache templates and documentation which directly in to your scripts.  This is particularly useful when using `build_dist`(see below) to compile your script and all its dependencies in to a single file as the included resources will be bundled into the resulting file.

This example shows a command which includes a file relative to the command's `run.sh` file and then accesses the content later in the the script.

```bash
# Include a mustache template file into the command
resource.relative 'templates/command.sh.mo'

my_command.init() {
    my_command.main() {
        # This will print the contents of the file, even if this command has
        # been built into a single file and this relative path does not actually exist.
        resource.get 'templates/command.sh.mo'
    }
}
```

### Building a Redistributable Command

You may wish to distribute your script as a single file with all the dependencies included.  This means that the user does not need to install bf2 on their machine in order to use your command.  To build your command you can use the `build_dist` command.

```
build_dist --name <The name of your command>
```

By default the build command will be create in the `dist` folder in the same directory as your commands `run.sh` file.  To see a full range of build options run `build_dist --help`.



### Modules

Modules are a reusabale set of functions that can be included as a dependency in another module or command.

#### Structure

#### Namespaces

#### Usage

#### Creating a Module



### Provisioning Modules

#### Creating a Provisioning Module

This is an example of creating a provisioning module that installs the "jq" command.

`create_module --name jq --type provision`

This will create a new module in `modules/provision/jq` using the provisioning module template.

__The base file__
```bash
import.require 'provision'
provision.jq_base.init() {
    provision.jq_base.__init() {
          import.useModule 'provision'
    }
    provision.jq_base.require() {
        if ! provision.isInstalled 'jq'; then
          sudo apt-get install -y jq
          return $?
        fi
        return 0
    }
}
```

__The module file__
```bash
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
```
