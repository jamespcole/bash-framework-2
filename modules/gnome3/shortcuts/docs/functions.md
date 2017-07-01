
* [gnome3.shortcuts.init()](#gnome3shortcutsinit)
* [gnome3.shortcuts.createAppMenuIcon()](#gnome3shortcutscreateAppMenuIcon)


## gnome3.shortcuts.init()

The gnome3.shortcuts namespace provides functions for managing \
Gnome 3 application menu shortcuts

#### Example

```bash
   import.require 'gnome3.shortcuts'

   some_other_module.init() {
      some_other_module.__init() {
         import.useModule 'gnome3.shortcuts'
      }
      some_other_module.someFunction() {
            gnome3.shortcuts.createAppMenuIcon \
                  --name 'My App' \
                  --cmd '/usr/bin/myapp' \
                  --icon '/path/to/png' \
                  --categories 'Categories;Productivity;'
      }
   }

```

#### See also

* [gnome3.shortcuts.createAppMenuIcon()](#gnome3.shortcuts.createAppMenuIcon())

## gnome3.shortcuts.createAppMenuIcon()

Creates a Gnome 3 app menu icon with the specified values

#### Example

```bash
   gnome3.shortcuts.createAppMenuIcon \
      --name 'My App' \
      --cmd '/usr/bin/myapp' \
      --icon '/path/to/png' \
      --categories 'Categories;Productivity;'


```

### Arguments

* name The name of the app
* cmd The command to run
* icon The path to a png to use as an icon
* categories A semi-colon delimited list of categories
