import.require 'resource>base'
resource.init() {
    resource.__init() {
        import.useModule 'resource_base'
    }
    resource.includeFile() {
        resource_base.includeFile "$@"
    }
    resource.relative() {
        resource_base.relative "$@"
    }
    resource.get() {
        resource_base.get "$@"
    }
}
