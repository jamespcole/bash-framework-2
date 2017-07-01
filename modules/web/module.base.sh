#!/usr/bin/env bash
# This is an example of inclduing the params module.
# Place require module calls at the top of the file.
import.require 'params'
web_base.init() {
    # Uncomment __init and put the declaration of any globals your module uses here.
    # Also initiliase any required modules.  If not required you can remove it.
    web_base.__init() {
        declare -g -A __web_COOKIES
        import.useModule 'params'
    }
    web_base.login() {
        local -A __params
        __params['username']=''
        __params['username-field']='username'
        __params['pwd']=''
        __params['pwd-field']='password'
        __params['url']=''
        params.get "$@"
        local __formdata="${__params['username-field']}=${__params['username']}"
	    __formdata="${__formdata}&${__params['pwd-field']}=${__params['pwd']}"

        local -A __url_bits
        web.parseUrl --url "${__params['url']}" \
            --return-arr __url_bits

        local __hostname="${__url_bits['host']}"
        web_base.initCookie --host "$__hostname"
        local __cookie_path="${__web_COOKIES["${__hostname}"]}"
        curl -s -L -k -b "$__cookie_path"  -c "$COOKIE_PATH" -X POST -d "$__formdata" "${__params['url']}" || return 1
    }
    web_base.initCookie() {
        local -A __params
        __params['host']=''
        params.get "$@"
        local __host="${__params['host']}"
        if [[ ! "${__web_COOKIES["${__host}"]+exists}" ]]; then
            __web_COOKIES["${__host}"]="$(mktemp)"
        fi
    }
    web_base.parseUrl() {
        local -A __params
        __params['url']=''
        __params['return-arr']=''
        params.get "$@"
        local -n __parts="${__params['return-arr']}"
        # extract the protocol
        __parts['proto']="`echo ${__params['url']} | grep '://' | sed -e's,^\(.*://\).*,\1,g'`"
        # remove the protocol
        __parts['url']=`echo ${__params['url']} | sed -e s,${__parts['proto']},,g`

        # extract the user and password (if any)
        __parts['userpass']="`echo "${__parts['url']}" | grep @ | cut -d@ -f1`"
        __parts['pass']=`echo ${__parts['userpass']} | grep : | cut -d: -f2`
        if [ -n "${__parts['pass']}" ]; then
            __parts['user']=`echo ${__parts['userpass']} | grep : | cut -d: -f1`
        else
            __parts['user']=${__parts['userpass']}
        fi

        # extract the host -- updated
        __parts['hostport']=`echo "${__parts['url']}" | sed -e s,${__parts['userpass']}@,,g | cut -d/ -f1`
        __parts['port']=`echo ${__parts['hostport']} | grep : | cut -d: -f2`
        if [ -n "${__parts['port']}" ]; then
            ${__parts['host']}=`echo ${__parts['port']} | grep : | cut -d: -f1`
        else
            __parts['host']=${__parts['hostport']}
        fi

        # extract the path (if any)
        __parts['path']="`echo "${__parts['url']}" | grep / | cut -d/ -f2-`"
    }
}
