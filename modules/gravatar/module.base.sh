import.require 'params'
import.require 'string'
import.require 'provision.md5'
gravatar_base.init() {
	gravatar_base.__init() {
		declare -g -A __my_global_arr
		import.useModule 'params'
		import.useModule 'string'
        import.useModule 'provision.md5'
	}
	gravatar_base.downloadImage() {
		local -A __params
		__params['email']=
		__params['size']='512'
		__params['destination']='.'
		params.get "$@"

		local __hash_val
		gravatar_base.hashEmail \
			--email "${__params['email']}" \
			--return __hash_val

        logger.info --message \
            "Downloading gravatar image for \"${__params['email']}\"" \
            --verbosity 2
		wget "http://www.gravatar.com/avatar/${__hash_val}?size=${__params['size']}" \
			 -O "${__params['destination']}" \
		|| {
			 return 1
		}
		return 0
	}
	gravatar_base.hashEmail() {
		local -A __params
		__params['email']=
		__params['return']=
        params.get "$@"
        provision.require 'md5'
    	local __grav_hash=$(echo -n "${__params['email']}" \
            | tr '[A-Z]' '[a-z]' \
            | md5sum \
            | awk '{ print $1}')
		string.return_value "${__grav_hash}" ${__params['return']}
    }
}
