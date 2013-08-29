<?Lasso
//log_critical('loading knop_cache from LassoApp')

/**!
knop_cache
A thread object acting as base to the different Knop cache methods.
Methods:
	add Stores a cache for the supplied name
	Parameters
		name type = required, string,
		content required, any kind of content,
		expires optional, integer. Defaults to 600 seconds

	get Retrieves a cached content
	Parameter
		name type = required, string

	getall Returns all cached content as a raw map. Useful for debugging

	remove Deletes a cached object
	Parameter
		name type = required, string

	clear Removes all cached content


**/
define knop_cache => thread {

	/*

	CHANGE NOTES
	2013-04-15	JC	Added debug to all method calls
	2012-06-11	JC	Replaced all iterate with query expr. Other minor code changes. Fixed misplaced curly brackets around named signature calls
	2010-08-04	JC	Minor code cleaning
	2009-11-25	JC	First experimental version with all functions in place. Still lacks debug and timer functions. Introduces the new thread object knop_cache instead of global vars

	*/

	data public version = '2013-04-15'

	data private caches = map
	data public purged

	public add(name::string, content::any, expires::integer = 600) => .'caches' -> insert(#name = map('content' = #content, 'timestamp' = date, 'expires' = (date + duration( -second = #expires))))

	public get(name::string) => .'caches' -> find(#name)

	public getall => .'caches'

	public remove(name::string) => {.'caches' -> remove(#name)}

	public clear => {.'caches' = map}

	public active_tick() => {
		with i in .'caches' -> eachPair do => {
			if(#i -> value -> find('expires') < date) => {
				.'caches' -> remove(#i -> name)
			}
		}
		.purged = date
		return 600
	}


}

/**
knop_cachestore
Stores all instances of page variables of the specified type in a cache object. Caches are stored in a global variable named by host name and document root to isolate the storage of different hosts.
Knop_cachestore calls the thread object knop_cache and can be replaced by direct calls to knop_cache if you don't want to store the cache in a session.
Parameters:
	-type (required string) Page variables of the specified type will be stored in cache. Data types can be specified with or without namespace.
	-expires (optional integer) The number of seconds that the cached data should be valid. Defaults to 600 (10 minutes).
	-session (optional string) The name of an existing session to use for cache storage instead of the global storage.
	-name (optional string) Extra name parameter to be able to isolate the cache storage from other sites on the same virtual hosts, or caches for different uses.
**/
define knop_cachestore(
	type::string,
	expires::integer = -1,
	session::string = '',
	name::string = ''
) => debug => {
//log_critical('knop_cachestore  called')

	local(data = map)
	#expires < 0 ? #expires = 600 // default seconds
	// store all page vars of the specified type
	local(loopvalue = string)
	// store all page vars of the specified type
	with keytmp in var_keys do => {
		#loopvalue = string(#keytmp)
		if(var(#loopvalue) -> isa(#type)) => {
			#data -> insert(#loopvalue = var( #loopvalue))
		}
	}
	if(#session -> size > 0) => {
		local(cache_name = '_knop_cache_' + #name)
		session_addvar(-name = #session, #cache_name)
		!(var(#cache_name) -> isa(::map)) ? var(#cache_name = map)
		var( #cache_name) -> insert(#type = map(
			'content' = #data,
			'timestamp' = date,
			'expires' = (date + duration( -second = #expires))))
	else;

		local('cache_name' = 'knop_' + #name + '_' + server_name + response_localpath)
		#cache_name -> removetrailing(response_filepath)
		#cache_name -> replace('/','')
		#cache_name += '_' + #type
		knop_cache -> add(#cache_name, #data, #expires)

	}

}

define knop_cachestore(
	-type::string,
	-expires::integer = -1,
	-session::string = '',
	-name::string = ''
) => knop_cachestore(#type, #expires,#session,#name)

/**
knop_cachefetch
Recreates page variables from previously cached instances of the specified type, returns true if successful or false if there was no valid existing cache for the specified type. Caches are stored in a global variable named by host name and document root to isolate the storage of different hosts.
Knop_cachefetch calls the thread object knop_cache and can be replaced by direct calls to knop_cache if you don't want to get cached objects from a session.
Parameters:
	-type (required string) Page variables of the specified type will be stored in cache.
	-session (optional string) The name of an existing session to use for cache storage instead of the global storage.
	-name (optional string) Extra name parameter to be able to isolate the cache storage from other sites on the same virtual hosts.
	-maxage (optional date) Cache data older than the date/time specified in -maxage will not be used.
**/
define knop_cachefetch(
	type::string,
	session::string = '',
	name::string = '',
	maxage::date = date('1970-01-01')
) => debug => {

	local(data = null)
	if(#session -> size > 0) => {
		//fail_if(session_id( -name=#session) -> size == 0, -1, 'Cachefetch with -session requires that the specified session is started')
		local(cache_name = '_knop_cache_' + #name)
		if(var(#cache_name) -> isa(::map)
			&& var(#cache_name) >> #type
			&& var(#cache_name) -> find(#type) -> find('expires') > date
			&& var(#cache_name) -> find(#type) -> find('timestamp') > #maxage) => {
			// cached data not too old
			#data = var(#cache_name) -> find(#type) -> find('content')
		}
	else
		local('cache_name' = 'knop_' + #name + '_' + server_name + response_localpath)
		#cache_name -> removetrailing(response_filepath)
		#cache_name -> replace('/','')
		#cache_name += '_' + #type
		local(content = knop_cache -> get(#cache_name))
		if(#content -> isa(::map)
			&& #content -> find('expires') > date
			&& #content -> find('timestamp') > #maxage) => {
			// cached data not too old
			#data = #content -> find('content');
		}
	}
	if(#data -> isa(::map)) => {

		with i in #data -> eachpair do => {
			var((#i -> name) = #i -> value)
		}
		return true
	else
		return false
	}

}

define knop_cachefetch(
	-type::string,
	-session::string = '',
	-name::string = '',
	-maxage::date = date('1970-01-01')
) => knop_cachefetch(#type, #session, #name, #maxage)

/**
knop_cachedelete
Deletes the cache for the specified type (and optionally name).
Parameters:
	-type (required string) Page variables of the specified type will be deleted from cache. \n\
	-session (optional string) The name of an existing session storing the cache to be deleted.
	-name (optional string) Extra name parameter used to isolate the cache storage from other sites on the same virtual hosts.
**/
define knop_cachedelete(
	type::string,
	session::string = '',
	name::string = ''
) => debug => {
	if(#session -> size > 0) => {
		//fail_if(session_id( -name=#session) -> size == 0, -1, 'Cachestore with -session requires that the specified session is started');
		local(cache_name = '_knop_cache_' + #name)
		session_addvar(-name = #session, #cache_name)
		!(var(#cache_name) -> isa(::map)) ? var(#cache_name = map)
		var(#cache_name) -> remove(#type)
	else
		local(cache_name = 'knop_' + #name + '_' + server_name + response_localpath)
		#cache_name -> removetrailing(response_filepath)
		#cache_name -> replace('/','')
		#cache_name += '_' + #type

		knop_cache -> remove(#cache_name)

	}

}

define knop_cachedelete(
	-type::string,
	-session::string = '',
	-name::string = ''
) => knop_cachedelete(#type, #session, #name)

//log_critical('loading knop_cache done')

?>