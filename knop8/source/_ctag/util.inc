<?LassoScript

/*

2009-09-04	JS	Added content_body tag for compatibility with pre 8.5
2009-05-07	JS	Added timestamp to knop_cachestore and -maxage parameter to knop_cachefetch
2009-05-07	JS	Corrected construction of cache_name internally in the knop_cache tags so it will work correctly at the site root
2008-11-04	JS	Added dummy knop_debug ctype to be able to work transparently with or without L-Debug
2008-09-24	JS	Added knop_stripbackticks
2008-01-28	JS	Cache tags: -name is now used also when using session storage
2007-12-12	JS	Added knop_cachedelete
2007-12-11	JS	Created knop_cachestore and knop_cachefetch
2007-12-03	JS	Corrected knop_foundrows condition for returning normal found_count

*/

// For compatibility with pre Lasso 8.5 
if(!lasso_tagexists('content_body'));
	define_tag('content_body', -namespace='_global_');
		return(@$__html_reply__);
	/define_tag;
/if;

if(!lasso_tagexists('knop_debug'));
	define_type('debug',
		-namespace='knop_');
		define_tag('_unknowntag');/define_tag;
		define_tag('onconvert');/define_tag;
	/define_type;
/if;

define_tag('stripbackticks', -description='Remove backticks (`) from a string to make it safe for MySQL object names',
	-namespace='knop_',
	-priority='replace',
	-required='input');
	local('output'=string(#input));
	#output = #output -> split('`') -> first;
	return(@#output);
/define_tag;

define_tag: 'unique', -description='Returns a very unique but still rather short random string',
	-namespace='knop_',
	-priority='replace';

	// Johan Sölve 2006-09-20 
	
	local: 'output'=string,
		'seed'=integer,
		'charlist'='abcdefghijklmnopqrstuvwxyz0123456789';
	local: 'base'=(#charlist -> size);
	// start with the current date and time in a mixed up format as seed
	#seed = integer: (date -> (format: '%S%y%m%d%H%M'));
	// convert this integer to a string using base conversion
	while: #seed>0;
		#output = #charlist -> (get: (#seed % #base)+1) + #output;
		#seed = #seed / #base;
	/while;
	// start over with a new chunk as seed
	#seed = string: 1000+(date->millisecond);
	#seed = #seed + string: (math_random: -lower=1000, -upper=9999);
	#seed = integer: #seed;
	// convert this integer to a string using base conversion
	while: #seed>0;
		#output = #charlist -> (get: (#seed % #base)+1) + #output;
		#seed = #seed / #base;
	/while;
	return: #output;
/define_tag;


define_tag: 'seed', 
	-namespace='knop_',
	-priority='replace';
	
	local: 'seed'= (string: $__lassoservice_ip__) + response_localpath;
	#seed -> removetrailing(response_filepath);
	return:	 #seed;
/define_tag;

define_tag: 'foundrows', // http://tagswap.net/found_rows
	-namespace='knop_',
	-priority='replace';
	local: 'sql'= action_statement;
	if: (string_findregexp: #sql, -find= '\\sLIMIT\\s', -ignorecase) -> size == 0;
		// || found_count < maxrecords_value; (this condition is inaccurate)
		// found_count must be accurate
		return: found_count;
	/if;
	if: (string_findregexp: #sql, -find= '\\s(GROUP\\s+BY|HAVING)\\s', -ignorecase) -> size == 0;
		// Default method, usually the fastest. Can not be used with GROUP BY for example. 
		// First normalize whitespace around FROM in the expression
		#sql = (string_replaceregexp: #sql, -find= '\\sFROM\\s', -replace=' FROM ', -ignorecase, -ReplaceOnlyOne);
		#sql = 'SELECT COUNT(*) AS found_rows ' + #sql -> (substring: (#sql -> (find: ' FROM ')) + 1) ;
		#sql = (string_replaceregexp: #sql, -find='\\sLIMIT\\s+[0-9,]+', -replace='');
		if: (string_findregexp: #sql, -find= '\\sORDER\\s+BY\\s', -ignorecase) -> size;
			// remove ORDER BY statement since it causes problems with field aliases
			// first normalize the expression so we can find it with simple string expression later
			#sql = (string_replaceregexp: #sql, -find= '\\sORDER\\s+BY\\s', -replace=' ORDER BY ', -ignorecase);
			#sql = #sql -> (substring: 1, (#sql -> (find: ' ORDER BY ')) -1);
		/if;
	else; // query contains GROUP BY so use SQL_CALC_FOUND_ROWS which can be much slower, see http://bugs.mysql.com/bug.php?id=18454
		#sql -> (removeleading: 'SELECT');
		#sql = 'SELECT SQL_CALC_FOUND_ROWS ' + #sql + ';SELECT FOUND_ROWS() AS found_rows';
		#sql = (string_replaceregexp: #sql, -find='\\sLIMIT\\s+[0-9,]+', -replace=' LIMIT 1', -ignorecase);
	/if;
	inline: -sql=#sql;
		if: (field: 'found_rows') > 0;
			return: integer: (field: 'found_rows'); // exit here normally
		/if;
	/inline;
	// fallback
	return: found_count;
/define_tag;	

define_tag:'IDcrypt', -description='Encrypts or Decrypts integer values',
	-namespace='knop_',
	-required='value',
	-optional='seed',
	-priority='replace';
/*

[IDcrypt]
Encrypts or Decrypts integer values

Author: Pier Kuipers
Last Modified: Jan. 29, 2007
License: Public Domain

Description:
This tag was written to deal with "scraping" attacks where bots keep 
requesting the same page with incremental id parameters, corresponding to 
mysql id columns. Rather than introducing a new column with a unique id, this 
tag will "intelligently" blowfish encrypt or decrypt existing id values.


Sample Usage:
[local('myID' = (action_param('id')))]
[IDcrypt(#myID)]

[IDcrypt('35446')] -> j4b50f315238d68df

[IDcrypt('j4b50f315238d68df')] -> 35446



Downloaded from tagSwap.net on Feb. 07, 2007.
Latest version available from <http://tagSwap.net/IDcrypt>.

*/
// if id values need to be retrieved from bookmarked urls, the tag's built-in seed value must be used,
// or the seed value used must be guaranteed to be the same as when the value was encrypted!		

	local('cryptvalue' = string);
	!local_defined('seed') ? local('seed' = knop_seed);
	Local('RandChars' = 'AaBbCcDdEeFfGgHhiJjKkLmNnoPpQqRrSsTtUuVvWwXxYyZz');
	Local('anyChar' = (#RandChars -> (Get:(Math_Random: -Min=1, -Max=(#RandChars->Size)))));
// taken from Bil Corry's [lp_string_getNumeric]
	local('numericValue' = (string_findregexp((string: #value), -find='\\d')->(join:'')));
	
	if(
		(#numericValue == (integer(#value))) 
		&& 
		(((string(#value))->length) == ((string(#numericValue)) -> length))
	);
// alpha character is inserted at beginning of encrypted string in case value needs to be
// cast to a javascript variable, which cannot start with a number		
		#cryptvalue = (#anyChar + (Encrypt_Blowfish(#value, -seed=#seed)));
	else(
		((((string(#value))->length) - 1) % 2 == 0)
		&&
		(((string(#value))->length) > 16)
	);
		#cryptvalue = (decrypt_blowfish((String_Remove: #value, -StartPosition=1, -EndPosition=1),-Seed=#seed));
	else;
		#cryptvalue = 0;
	/if;
	
	if(String_IsAlphaNumeric(#cryptvalue));
		return(#cryptvalue);
	else;
// successfully decrypted values resulting in lots of strange characters are probably
// the result of someone guessing a value		
		return(0);
	/if;

/define_tag;



define_type: 'timer', -description='Utility type to provide a simple timer',
	-namespace='knop_';
	/*
	
	CHANGE NOTES
	2007-06-17	JS	Created the type
	
	*/

	local: 't'=integer;
	define_tag: 'oncreate';
		(self -> 't') = _date_msec;
	/define_tag;
	define_tag: 'onconvert';
		return: _date_msec - (self -> 't');
	/define_tag;
	
/define_type;

define_tag: 'cachestore', -description='Stores all instances of page variables of the specified type in a cache object. Caches are stored \
		in a global variable named by host name and document root to isolate the storage of different hosts. \n\
		Parameters:\n\
		-type (required string) Page variables of the specified type will be stored in cache. Data types can be specified with or without namespace.\n\
		-expires (optional integer) The number of seconds that the cached data should be valid. Defaults to 600 (10 minutes)\n\
		-session (optional string) The name of an existing session to use for cache storage instead of the global storage\n\
		-name (optional string) Extra name parameter to be able to isolate the cache storage from other sites on the same virtual hosts, or caches for different uses. ',
	-namespace='knop_',
	-required='type', -type='string',
	-optional='expires', -type='integer', // seconds
	-optional='session', -type='string',
	-optional='name', -type='string';

	local: 'data'=map;
	!(local_defined: 'expires') ? local: 'expires'=600; // default seconds
	// store all page vars of the specified type
	iterate: vars -> keys, local: 'item';
		if: (var: #item) -> isa(#type);
			#data -> insert(#item = (var: #item));
		/if;
	/iterate;
	if: (local_defined: 'session');
		//fail_if: (session_id: -name=#session) -> size == 0, -1, 'Cachestore with -session requires that the specified session is started';
		local: 'cache_name' = '_knop_cache_' + (local: 'name');
		session_addvar: -name=#session, #cache_name;
		!((var: #cache_name) -> isa('map')) ? var: #cache_name = map;
		(var: #cache_name) -> insert(#type = (map: 
			'content'=#data, 
			'timestamp'=date, 
			'expires'=(date + (duration: -second=#expires))));
	else;
		local: 'cache_name'='knop_' + (local: 'name') + '_' + server_name + response_localpath;
		#cache_name -> removetrailing(response_filepath);
		// initiate thread RW lock
		!(global: 'rwlock_' + #cache_name) -> isa('rwlock') ? global: 'rwlock_' + #cache_name=Thread_RWLock;
		// create a reference to the lock
		local: 'lock'=@(global: 'rwlock_' + #cache_name);
		// lock for writing
		#lock -> writelock;
		// check and initiate the cache storage
		!((global: #cache_name) -> isa('map')) ? global: #cache_name = map;
		(global: #cache_name) -> insert(#type = (map: 
			'content'=#data, 
			'timestamp'=date, 
			'expires'=(date + (duration: -second=#expires))));
		// unlock
		#lock -> writeunlock;
	/if;
/define_tag;

define_tag: 'cachefetch', -description='Recreates page variables from previously cached instances of the specified type, returns true if successful or false if there was no valid \
		existing cache for the specified type. Caches are stored in a global variable named by host name and document root to isolate the storage of different hosts. \n\
		Parameters:\n\
		-type (required string) Page variables of the specified type will be stored in cache. \n\
		-session (optional string) The name of an existing session to use for cache storage instead of the global storage\n\
		-name (optional string) Extra name parameter to be able to isolate the cache storage from other sites on the same virtual hosts. \n\
		-maxage (optional date) Cache data older than the date/time specified in -maxage will not be used.',
	-namespace='knop_',
	-required='type', -type='string',
	-optional='session', -type='string',
	-optional='name', -type='string',
	-optional='maxage', -type='date';
	
	
	local: 'data'=null;
	if: (local_defined: 'session');
		//fail_if: (session_id: -name=#session) -> size == 0, -1, 'Cachefetch with -session requires that the specified session is started';
		local: 'cache_name' = '_knop_cache_' + (local: 'name');
		if: (var: #cache_name) -> isa('map') 
			&& (var: #cache_name) >> #type 
			&& (var: #cache_name) -> find(#type) -> find('expires') > date;
			if(local_defined('maxage') 
				&& var(#cache_name) -> find(#type) -> find('timestamp') < #maxage);
				// cached data too old
			else;
				#data = (var: #cache_name) -> find(#type) -> find('content');
			/if;
		/if;
	else;
		local: 'cache_name'='knop_' + (local: 'name') + '_' + server_name + response_localpath;
		#cache_name -> removetrailing(response_filepath);
		// initiate thread RW lock
		!(global: 'rwlock_' + #cache_name) -> isa('rwlock') ? global: 'rwlock_' + #cache_name=Thread_RWLock;
		// create a reference to the lock
		local: 'lock'=@(global: 'rwlock_' + #cache_name);
		// lock for reading
		#lock -> readlock;
		if: (global: #cache_name) -> isa('map') 
			&& (global: #cache_name) >> #type 
			&& (global: #cache_name) -> find(#type) -> find('expires') > date;
			if(local_defined('maxage') 
				&& global(#cache_name) -> find(#type) -> find('timestamp') < #maxage);
				// cached data too old
			else;
				#data = (global: #cache_name) -> find(#type) -> find('content');
			/if;
		/if;
		// unlock
		#lock -> readunlock;
	/if;
	if: #data -> isa('map');
		iterate: #data, local: 'item';
			var: (#item -> name) = #item -> value;
		/iterate;
		return: true;
	else;
		return: false;
	/if;
/define_tag;


define_tag: 'cachedelete', -description='Deletes the cache for the specified name (and optionally name). \n\
		Parameters:\n\
		-type (required string) Page variables of the specified type will be stored in cache. \n\
		-session (optional string) The name of an existing session to use for cache storage instead of the global storage\n\
		-name (optional string) Extra name parameter to be able to isolate the cache storage from other sites on the same virtual hosts. ',
	-namespace='knop_',
	-required='type', -type='string',
	-optional='session', -type='string',
	-optional='name', -type='string'; // ignored for session
	if: (local_defined: 'session');
		//fail_if: (session_id: -name=#session) -> size == 0, -1, 'Cachestore with -session requires that the specified session is started';
		local: 'cache_name' = '_knop_cache_' + (local: 'name');
		session_addvar: -name=#session, #cache_name;
		!((var: #cache_name) -> isa('map')) ? var: #cache_name = map;
		(var: #cache_name) -> remove(#type);
	else;
		local: 'cache_name'='knop_' + (local: 'name') + '_' + server_name + response_localpath;
		#cache_name -> removetrailing(response_filepath);
		// initiate thread RW lock
		!(global: 'rwlock_' + #cache_name) -> isa('rwlock') ? global: 'rwlock_' + #cache_name=Thread_RWLock;
		// create a reference to the lock
		local: 'lock'=@(global: 'rwlock_' + #cache_name);
		// lock for writing
		#lock -> writelock;
		// check and initiate the cache storage
		!((global: #cache_name) -> isa('map')) ? global: #cache_name = map;
		(global: #cache_name) -> remove(#type);
		// unlock
		#lock -> writeunlock;
	/if;

/define_tag;


?>
