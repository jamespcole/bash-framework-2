#!/usr/bin/env bash
import.require 'provision.mssql.sqlcmd>base'

provision.mssql.sqlcmd.init() {
    provision.mssql.sqlcmd.__init() {
        import.useModule 'provision.mssql.sqlcmd_base'
    }
    provision.mssql.sqlcmd.require() {
        provision.mssql.sqlcmd_base.require "$@"
    }
    provision.mssql.sqlcmd.addToBashRc() {
        provision.mssql.sqlcmd_base.addToBashRc "$@"
    }
    provision.mssql.sqlcmd.addPpa() {
        provision.mssql.sqlcmd_base.addPpa "$@"
    }
}
