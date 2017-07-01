import.require 'textprint>base'
# @description The textprint namespace provides ....
# Descibe your module here
#
# @example
#   import.require 'textprint'
#
#   some_other_module.init() {
#      some_other_module.__init() {
#         import.useModule 'textprint'
#      }
#      some_other_module.someFunction() {
#         textprint.sayHello
#      }
#   }
#
# @see textprint.sayHello()
textprint.init() {
    textprint.__init() {
        import.useModule 'textprint_base'
    }
    # @description A function that prints "Hello World!".  This description
    # will appear in the generated documentation for this function
    #
    # @example
    #   textprint.sayHello
    #
    #   prints 'Hello World' to std out
    #
    # @arg $1 A description of the first argument
    # @arg $2 A description of the second argument
    textprint.indent() {
        textprint_base.indent "$@"
    }
    textprint.list() {
        textprint_base.list "$@"
    }
    textprint.listItem() {
        textprint_base.listItem "$@"
    }
    textprint.box() {
        textprint_base.box "$@"
    }
    textprint.dim() {
        textprint_base.dim "$@"
    }
    textprint.border() {
        textprint_base.border "$@"
    }
    textprint.bold() {
        textprint_base.bold "$@"
    }
    textprint.underline() {
        textprint_base.underline "$@"
    }
    textprint.emphasis() {
        textprint_base.emphasis "$@"
    }
    textprint.setProp() {
        textprint_base.setProp "$@"
    }
    textprint.setState() {
        textprint_base.setState "$@"
    }
    textprint.print() {
        textprint_base.print "$@"
    }
    textprint.printLine() {
        textprint_base.printLine "$@"
    }
    textprint.red() {
        textprint_base.red "$@"
    }
    textprint.blue() {
        textprint_base.blue "$@"
    }
    textprint.lightBlue() {
        textprint_base.lightBlue "$@"
    }
    textprint.cyan() {
        textprint_base.cyan "$@"
    }
    textprint.yellow() {
        textprint_base.yellow "$@"
    }
    textprint.orange() {
        textprint_base.orange "$@"
    }
    textprint.green() {
        textprint_base.green "$@"
    }
    textprint.iconDanger() {
        textprint_base.iconDanger "$@"
    }
    textprint.iconInfo() {
        textprint_base.iconInfo "$@"
    }
    textprint.iconWarning() {
        textprint_base.iconWarning "$@"
    }
    textprint.iconSuccess() {
        textprint_base.iconSuccess "$@"
    }
    textprint.hr() {
        textprint_base.hr "$@"
    }
    textprint.br() {
        textprint_base.br "$@"
    }
    textprint.preProcess() {
        textprint_base.preProcess "$@"
    }

    textprint.h1() {
        textprint.heading1 "$@";
    }
    textprint.heading1() {
        textprint_base.heading1 "$@";
    }
    textprint.h2() {
        textprint.heading2 "$@";
    }
    textprint.heading2() {
        textprint_base.heading2 "$@";
    }
    textprint.h3() {
        textprint.heading3 "$@";
    }
    textprint.heading3() {
        textprint_base.heading3 "$@";
    }
    textprint.icon_warning() { textprint.iconWarning "$@"; }
    textprint.b() { textprint.bold "$@"; }
    textprint.icon_danger() {
        textprint.iconDanger "$@";
    }
    textprint.warning() { textprint.orange "$@"; }
    textprint.d() { textprint.dim "$@"; }
    textprint.in() { textprint.indent "$@"; }
    textprint.success() { textprint.green "$@"; }
    textprint.danger() { textprint.red "$@"; }
    textprint.info() { textprint.blue "$@"; }
    textprint.debug() { textprint.cyan "$@"; }
    textprint.loading() { textprint.lightBlue "$@"; }
    textprint.u() { textprint.underline "$@"; }
    textprint.icon_info() { textprint.iconInfo "$@"; }
    textprint.icon_success() { textprint.iconSuccess "$@"; }
    textprint.figlet() { textprint_base.figlet "$@"; }

    textprint.stripTags() { textprint_base.stripTags "$@"; }
}
