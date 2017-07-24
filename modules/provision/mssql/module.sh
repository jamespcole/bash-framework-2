#!/usr/bin/env bash
import.require 'provision.mssql>base'

provision.mssql.init() {
    provision.mssql.__init() {
        import.useModule 'provision.mssql_base'
    }
    provision.mssql.require() {
        provision.mssql_base.require "$@"
    }
    provision.mssql.configure() {
        provision.mssql_base.configure "$@"
    }
    provision.mssql.addPpa() {
        provision.mssql_base.addPpa "$@"
    }
}
