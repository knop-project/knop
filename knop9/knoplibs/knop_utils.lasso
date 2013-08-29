<?Lasso
//log_critical('loading knop_utils from LassoApp')
/*
	CHANGE NOTES

	2013-08-19	JC	Slightly more effektive version of knop_affected_count
	2013-05-02	JC	date -> knop_format. Faster date formatting without backwards compatibility with Lasso pre 9. Code from Ke Carlton
	2012-11-03	JC	Cleaned up code for knop_crypthash making sure it can take bytes as input for string value and made it look better
	2012-06-25	JC	Added knop_response_filepath
	2012-06-24	JC	Enhancing knop_stripbackticks to deal with more than strings
	2012-06-11	JC	knop_math_hexToDec; changed iterate to loop to speed it up
	2011-09-05	JC	Added knop_encodesql_full
	2011-05-16	JC	Removed the unneeded if(web_request) on knop_client_params
	2011-01-27	JC	knop_unique9 Adjusted version running faster than the original but also returning longer unique values. Can take an optional prefix that will be added to the id
	2011-01-27	JC	Added knop_affected_count Adding a affected_count method pending a native implementation in Lasso 9. Used in sql updates, deletes etc returning number of rows affected by the change
	2010-11-13	JC	Added knop_trim
	2010-11-11	JC	Yet a rewrite of knop_client_params. This time based on same code as action_params drawing content from the web_request object but without the inline sensing parts
	2010-10-24	JC	adding methods knop_encrypt, knop_crypthash, knop_blowfish, knop_math_hexToDec and knop_math_decToHex. To begin with used within knop_user
	2010-10-23	TT	More compact version of knop_client_params. Added knop_normalize_slashes
	2010-10-22	JC	adding knop_client_params and knop_client_param methods
	2010-10-09	JC	Removed a lot of semicolons
	2010-09-17	JC 	removed knop_removeall since regular removeall now works the same in Lasso 9 as in Lasso 8.5
	2010-09-05	TT	added knop_debug placeholder
	2010-08-03	JC	knop_foundrows now uses Lasso 9 style regexps
	2009-12-13	JC	Added knop_removeall as a replacement of array -> removeall to fix Lasso nine handling of pairs in arrays
	2009-11-26	JC	knop_foundrows for Lasso version 9 started. Not done yet pending bug fixes for string_replaceregexp.
	2009-11-26	JC	knop_timer for Lasso version 9 finished.
	2009-11-25	JC	knop_IDcrypt created. Probably not compatible with encrypted material created with Lasso pre 9 due to differences in Blowfish.
	2009-11-25	JC	knop_seed for Lasso version 9 created. Not finished pending how to replace __lassoservice_ip__
	2009-11-25	JC	knop_stripbackticks for Lasso version 9 created
	2009-11-25	JC	Knop_unique for Lasso version 9 created

*/
/*
//knop_debug placeholder if external debug not loaded.
define debugnull => type{
	public oncreate(...) =>{
		log_critical('debug: ' + params)
	}

	public _unknowntag(...) => string

	public onconvert(...) => string

	public asString() => string

}

if(!tag_exists('debug')) => {
	define debug(...) => {
		givenblock->isNotA(::void) ? return givenblock()
		return debugnull
	}
}


if(!tag_exists('knop_debug')) => {
	define knop_debug(...) => {
		givenblock->isNotA(::void) ? return givenblock()
		return debugnull
	}
}

*/

/**!
date -> knop_format
Faster date format (removes backwards compatibility). Code from Ke Carlton on lasso talk 2013-05-02
**/
define date -> knop_format(
	format::string = .'format',
	-locale::locale = locale_default
) => {
	not #format ? #format = (string(var(__date_format__)) or 'yyyy-MM-dd HH:mm:ss')
	return ..format(#format, #locale)
}


/**!
knop_response_filepath
Safer than using Lasso 9 response_filepath when dealing with one-file systems on Apache
**/
define knop_response_filepath => web_request->fcgiReq->requestParams->find(::REQUEST_URI)->asString -> split('?') -> first

/**!
knop_affected_count
Adding a affected_count method pending a native implementation in Lasso 9
Used in sql updates, deletes etc returning number of rows affected by the change
**/
define knop_affected_count => integer(var('__updated_count__'))



/**!
knop_stripbackticks
Remove backticks (`) from a string to make it safe for MySQL object names
**/
define knop_stripbackticks(input::string) => #input -> split('`') -> first
define knop_stripbackticks(input::bytes) => #input -> split('`') -> first
define knop_stripbackticks(input::any) => knop_stripbackticks(string(#input))

/**!
knop_unique
Original version
Returns a very unique but still rather short random string. Can in most cases be replaced by the Lasso 9 version of lasso_unique since it's safer than the pre 9 version.
**/
define knop_unique => {
	/*
	2009-11-25	JC	First version directly for Lasso 9
	2006-09-20	JS 	First version
	*/
	local('output' = string)
	local('seed' = integer)
	local('charlist' = 'abcdefghijklmnopqrstuvwxyz0123456789')
	local('base' = #charlist -> size)

	// start with the current date and time in a mixed up format as seed
	#seed = integer(date -> knop_format(`ssyyMMddHHmm`))
	// convert this integer to a string using base conversion
	while(#seed > 0)
		#output = #charlist -> get( (#seed % #base) + 1) + #output
		#seed = #seed / #base
	/while
	// start over with a new chunk as seed
	#seed = string(1000 + (date -> millisecond))
	#seed = #seed + string(math_random( -lower=1000, -upper=9999))
	#seed = integer(#seed)

	// convert this integer to a string using base conversion
	while(#seed > 0)
		#output = #charlist -> get((#seed % #base) + 1) + #output
		#seed = #seed / #base
	/while

	return #output

}

define knop_unique9(pre::string = '') => {
	/*
	2011-01-27	JC	Adjusted version running faster than the original but also returning longer unique values. Can take an optional prefix that will be added to the id
	*/

	return #pre + lasso_uniqueid

}

define knop_unique9(-prefix::string = '') => knop_unique9(#prefix)

define knop_seed => {
	/*
	2009-11-25	JC	First version directly for Lasso 9. Not finished
	*/
//		local('seed'= string( $__lassoservice_ip__) + response_localpath)
	// Need to find out what Lasso 9 uses instead of __lassoservice_ip__
	local('seed'= string( server_ip) + string( server_name) + response_localpath)
	#seed -> removetrailing(response_filepath)
	return #seed
}

define knop_foundrows => { // Originally from http://tagswap.net/found_rows
	/*
	2011-02-18	JC	Fixing bugs in sql build that prevented the tag from returning a correct found_count
	2010-08-01	JC	Changing regular expressions to Lasso 9 style
	2009-11-25	JC	First version directly for Lasso 9. Not finished
	*/
	local('sql' = action_statement)
	local(reg_exp = regexp(`\sLIMIT\s`, 'replaceme', #sql, -ignorecase = true))

//		if(string_findregexp( #sql, -find = '\\sLIMIT\\s', -ignorecase) -> size == 0)
	if(#reg_exp -> findcount == 0)
		return found_count
	/if

	#reg_exp -> findpattern = `\s(GROUP\s+BY|HAVING)\s`

	if(#reg_exp -> findcount == 0)
		// Default method, usually the fastest. Can not be used with GROUP BY for example.
		// First normalize whitespace around FROM in the expression
		#reg_exp -> findpattern = `\sFROM\s`
		#reg_exp -> replacepattern = ' FROM '

		#sql = #reg_exp -> replacefirst
//			#sql = string_replaceregexp( #sql, -find = '\\sFROM\\s', -replace=' FROM ', -ignorecase, -ReplaceOnlyOne)
		#sql = 'SELECT COUNT(*) AS found_rows ' + #sql -> substring( (#sql -> find( ' FROM ')) + 1)

		#reg_exp -> findpattern = `\sLIMIT\s+[0-9,]+`
		#reg_exp -> replacepattern = ''
		#reg_exp -> input = #sql
		#sql = #reg_exp -> replaceall
//			#sql = string_replaceregexp( #sql, -find = '\\sLIMIT\\s+[0-9,]+', -replace='')

		#reg_exp -> findpattern = `\sORDER\s+BY\s`
		if(#reg_exp -> findcount)
			// remove ORDER BY statement since it causes problems with field aliases
			// first normalize the expression so we can find it with simple string expression later
			#reg_exp -> replacepattern = ' ORDER BY '
			#reg_exp -> input = #sql
			#sql = #reg_exp -> replaceall
//				#sql = string_replaceregexp( #sql, -find = '\\sORDER\\s+BY\\s', -replace = ' ORDER BY ', -ignorecase)
			#sql = #sql -> substring( 1, (#sql -> find(' ORDER BY ')) -1)
		/if


	else // query contains GROUP BY so use SQL_CALC_FOUND_ROWS which can be much slower, see http://bugs.mysql.com/bug.php?id=18454

		#sql -> trim
		#sql -> removeleading( 'SELECT')
		#sql -> removetrailing( ';')
		#sql = 'SELECT SQL_CALC_FOUND_ROWS ' + #sql + '; SELECT FOUND_ROWS() AS found_rows'
		#reg_exp -> findpattern = `\sLIMIT\s+[0-9,]+`
		#reg_exp -> replacepattern = ' LIMIT 1'
		#reg_exp -> input = #sql
		#sql = #reg_exp -> replaceall
//			#sql = string_replaceregexp( #sql, -find = '\\sLIMIT\\s+[0-9,]+', -replace = ' LIMIT 1', -ignorecase)
	/if
//	inline(action_params, -sql = #sql) => { probably not working with older Lasso versions
	inline(-sql = #sql) => {
		resultset(resultset_count) => {
			field( 'found_rows') > 0 ? return integer(field( 'found_rows')) // exit here normally
		}
	}
	// fallback
	return found_count
}

/**!
knop_IDcrypt
Encrypts or Decrypts integer values
**/
define knop_IDcrypt(
value::integer,
seed::string = ''
) => {
	/*
	TODO Replace string_findregexp with the more modern version

	2009-11-25	JC	First version directly for Lasso 9. Not finished
	*/
	/*
	Origin:
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

	local('cryptvalue' = string)
	#seed -> size == 0 ? #seed = knop_seed
	Local('RandChars' = 'AaBbCcDdEeFfGgHhiJjKkLmNnoPpQqRrSsTtUuVvWwXxYyZz')
	Local('anyChar' = (#RandChars -> Get(Math_Random( -lower = 1, -upper = (#RandChars -> Size)))))
	// taken from Bil Corry's [lp_string_getNumeric]
	local('numericValue' = (string_findregexp(string( #value), -find = `\d`) -> join('')))

	if(
		(integer(#numericValue) == integer(#value))
		&&
		((string(#value) -> length) == (string(#numericValue) -> length))
	)
		// alpha character is inserted at beginning of encrypted string in case value needs to be
		// cast to a javascript variable, which cannot start with a number
		#cryptvalue = (#anyChar + (encode_hex(encrypt_blowfish(#value, -seed = #seed))))
	else
		#cryptvalue = 0
	/if

	if(string_isalphanumeric(#cryptvalue))
		return #cryptvalue
	else
		// successfully decrypted values resulting in lots of strange characters are probably
		// the result of someone guessing a value
		return 0
	/if

}
define knop_IDcrypt(
value::string,
seed::string = ''
) => {
	local('cryptvalue' = string)
	#seed -> size == 0 ? #seed = knop_seed
	if(string(#value) -> length > 5)
		#cryptvalue = (decrypt_blowfish(decode_hex(string_remove(#value, -startposition = 1, -endposition = 1)),-seed = #seed))
	else
		#cryptvalue = 0
	/if

	if(string_isalphanumeric(#cryptvalue))
		return #cryptvalue
	else
		// successfully decrypted values resulting in lots of strange characters are probably
		// the result of someone guessing a value
		return 0
	/if
}

/**!
knop_timer
Utility type to provide a simple timer
Usage:
Initialise  var(timer = knop_timer)
Read        $timer
Math        100 + $timer or $timer + 100
		  100 - $timer or $timer - 100
For other integer handling wrap it in integer first
		  integer($timer)
**/
define knop_timer => type {

	/*

	CHANGE NOTES
	2009-11-27	JC	Experiment with using micros instead of _date_msec
	2009-11-26	JC	Finished with some help from Kyle on dealing with integer output
	2009-11-25	JC	Started on first version written directly for for Lasso 9

	*/

	data public version = '2009-11-27'

	data private timer::integer
	data private micros::boolean = false


	public onCreate => {
		//log_critical('new timer ms')
		.timer = _date_msec
	}

	public onCreate(micros::boolean) => {
		if(#micros)
			//log_critical('new timer micros')
			.micros = true
			.timer = micros
		else
			//log_critical('new timer ms')
			.timer = _date_msec
		/if

	}

	public onCreate(-micros::boolean) => {.onCreate(true)}
	public asString => { return .micros ? micros - .timer | _date_msec - .timer}
	public time => { return .micros ? micros - .timer | _date_msec - .timer}

	public resolution => { return .micros ? 'micros' | 'millis'}

	public +(rhs::integer) => (.micros ? micros - .timer | _date_msec - .timer) + #rhs
	public -(rhs::integer) => (.micros ? micros - .timer | _date_msec - .timer) - #rhs

}

define integer -> +(rhs::knop_timer) => self + #rhs -> time
define integer -> -(rhs::knop_timer) => self - #rhs -> time
define integer(f::knop_timer) => #f -> time

/**
knop_client_params
Returns a static array of GET/POST parameters passed from the client.
An optional param "method" can direct it to return only post or get params
Example usage:
knop_client_params;
knop_client_params('post');
knop_client_params(-method = 'get');

Based on same code as action_params but without the inline sensing parts.
*/
define knop_client_params(method::string = '') => {
	#method == 'get' ? return web_request -> queryParams
	#method == 'post' ? return web_request -> postParams
	return tie(web_request -> queryParams, web_request -> postParams) -> asStaticArray
	return staticarray
}

define knop_client_params(-method::string = '') => knop_client_params(#method)



/**
knop_client_param
Returns the value of a client GET/POST parameter

Example usage
knop_client_param('my');
knop_client_param('my', 2);
knop_client_param('my', 'get');
knop_client_param('my', 2, 'post');
knop_client_param('my', -count);
knop_client_param('my', 'get', -count);

Inspired by Bil Corrys lp_client_param
Lasso 9 version by Jolle Carlestam
*/
define knop_client_param(param::string, -count::boolean = false) => {
	return knop_client_param(#param, -1, '', -count=#count);
}
define knop_client_param(param::string, method::string, -count::boolean = false) => {
	return knop_client_param(#param, -1, #method, -count=#count);
}
define knop_client_param(param::string, index::integer, method::string = '', -count::boolean = false) => {

	local(output) = array;

	knop_client_params(#method) -> foreach => {
		(#1 -> type == 'pair' && #param == #1 -> name) ?
			#output -> insert(#1 -> value);
	}

	#count ? return #output -> size;

	#index <= 0 &&  #output -> size > 0 ? return #output -> join('\r');

	#index > 0 && #output -> size >= #index ? return #output -> get(#index);

	return string;
}

define knop_normalize_slashes(path::string) => {
// normalize slashes
	#path -> removeleading('/') & removetrailing('/')
	#path = '/' + #path + '/'
	#path -> replace('//', '/')
	return(#path)
}

/**!
Encrypts the input using digest encryption, optionally with salt.
**/
define knop_encrypt(
	data::any,
	salt::any = '',
	cipher::string = 'MD5' // Should the default be a more secure cipher even it it breaks backwards compatibility?
	) => {

	local(_data = string(#salt) + string(#data))

		if(cipher_list(-digest) !>> #cipher)
			// fall back to default digest cipher
			#cipher = 'MD5'
		/if
	return cipher_digest(#_data, -digest = #cipher, -hex)

}

define knop_encrypt(
	data::any,
	-salt::any = '',
	-cipher::string = 'MD5' // Should the default be a more secure cipher even it it breaks backwards compatibility?
	) => knop_encrypt(#data, #salt, #cipher)


/**!
knop_crypthash

**/
define knop_crypthash(
	string::any, // text to hash, or check hash against
	cost::integer = 20, // default is 20, can be any number between 1 and 2000
	saltLength::integer = -1, // default is a random length between 10 and 20, you can set it to a static size
	hash::string = '', // known hash to compare unknown hash against
	salt::any = '', // salt to use for hash
	cipher::string = 'SHA1', // cipher to use for hash
	map::boolean = false // this causes the tag to return a map of the hash, salt and cost.  default is to return a single string with them all embedded
	) => {
	/*
		Original tag from Amtac Professional Services, Rick Draper. In turn a minor modification of Bil Corrys lp_crypt_hash adding optional cypher handling

		based on code from Greg Willits and ideas from
			http://www.matasano.com/log/958/enough-with-the-rainbow-tables-what-you-need-to-know-about-secure-password-schemes/

		as configured, the largest size the hash returned will be 87 characters
	*/
	local(_string = string(#string))
	local(_cost = integer(#cost))
	local(_saltLength = integer(#saltLength))
	local(_hash = string(#hash))
	local(_salt = #salt -> ascopy)

	#_cost > 2000 ? #_cost = 2000


	// get hash, if possible
	if(#_hash != '' && #_salt == '') => {
			fail_if(#_hash -> size < 14, -1, 'hash size too small')
//			local(lassoVersion = #_hash -> substring(1, 6)) //not used
			local(costLength = integer(#_hash -> substring(7,1)))
			#_cost = integer(#_hash->substring(8, #costLength))
			#_saltLength = knop_math_hexToDec(#_hash -> substring(8 + #costLength, 4))
			#_salt = #_hash->substring(12 + #costLength, #_saltLength)
			#_hash = #_hash->substring(12 + #costLength + #_saltLength)
	else(#_salt == '')
		// code snippet from Bil Corrys lp_string_random
		local('alphanumeric' = 'abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ')

		#_saltLength < 1 ? #_saltLength = math_random(16, 32)
		loop(#_saltLength) => {
			#_salt += #alphanumeric -> get(math_random( -lower = 1, -upper = 62))
		}


	}

	(#_cost < 1) ? #_cost = 1

	loop(#_cost) => {
		#_string = string(cipher_digest((#_salt + #_string), -digest = #cipher, -hex))
	}

	if(#_hash != '') => {
		if(#_hash == #_string) => {
			return true
		else;
			return false
		}
	}

	if(#map) => {
		return(map('hash' = #_string, 'salt' = #_salt, 'cost' = #_cost, 'cipher' = #cipher))
	}

	local(edition = string(lasso_version(-lassoedition)) -> get(1))
	#edition ->append(string(lasso_version(-lassoplatform)) -> get(1))
	local(version = lasso_version(-lassoversion) -> split('.'))
	if(#version -> size < 4) => {
		loop(4 - #version -> size) => {
			#version -> insert('0')
		}
	}

	local(newsaltLength = knop_math_dectohex(#_salt->size))

	#newsaltLength = ('0' * (4 - #newsaltLength->size)) + #newsaltLength


	return #edition + (#version -> join('')) -> substring(1,6) + string(#_cost)->size + #_cost + #newsaltLength + #_salt + #_string

}

define knop_crypthash(
	string::any,
	-cost::integer = 20,
	-saltLength::integer = -1,
	-hash::string = '',
	-salt::any = '',
	-cipher::string = 'SHA1',
	-map::boolean = false
	) => knop_crypthash(#string, #cost, #saltLength, #hash, #salt, #cipher, #map)


/**!
knop_blowfish

**/
define knop_blowfish(
	string::string,
	mode::string,
	key::string = 'M64kplbg1C5QJqbl2i4K9EJOjhoxsCvZQNuw7fSuaAsBiHwouoGxmhTfUVnzuSPsz4RfFOS4a0g5hVn9JgQGuFBS4NK9Wb8tkWosE922MiClwIDGEvtVrL6t1WPMecOJ'
	) => {

// Original tag from Amtac Professional Services, Rick Draper.

	local('message_encr') = null
	local('message_decr') = null


	if(#key->length < 128 );
		return 'Error: Invalid Key Length - minimum of 1024 bits required'
	else
		local('key_a' = string_extract(#key, -startposition = 1, -endposition = 112))
		local('key_b' = string_extract(#key, -startposition = 113, -endposition = #key->length))

		if(#mode == 'E' || #mode == 'Encrypt')
			protect
				#message_encr = encode_base64(encrypt_blowfish(#string, -seed = #key_a))
				#message_encr = encode_base64(encrypt_blowfish(#message_encr, -seed = #key_b))
			/protect

			if(#message_encr == null)
				#message_encr = 'Encryption failed'
			/if;
			return #message_encr
		else(#mode == 'D' || #mode == 'Decrypt')
			protect
				#message_decr = decrypt_blowfish(decode_base64(#string), -seed = #key_b)
				#message_decr = decrypt_blowfish(decode_base64(#message_decr), -seed = #key_a)
			/protect

			if(#message_decr == null)
				#message_decr = 'Encryption failed'
			/if
			return #message_decr
		else
			return 'Error: Invalid Mode'
		/if
	/if
}

define knop_blowfish(
	string::string,
	-mode::string,
	-key::string
	) => knop_blowfish(#string, #mode, #key)

define knop_blowfish(
	-string::string,
	-mode::string,
	-key::string
	) => knop_blowfish(#string, #mode, #key)

define knop_blowfish(
	-string::string,
	-mode::string
	) => knop_blowfish(#string, #mode)


/**!
knop_math_hexToDec
Returns a base10 integer given a base16 string.
**/
define knop_math_hexToDec(
	base16::string
	) => {
 /* was lp_math_hexToDec by Bil Corry. Integrated in Knop for internal use
 	// http://www.danbbs.dk/~erikoest/hex.htm

	CHANGE NOTES
	2012-06-11	JC	Changed iterate to loop to speed it up
 */

	local(_base16 = string(#base16))

	local('base16_len' = #_base16->length)
	local('base10' = integer)
	local('hex_list'='123456789ABCDEF')

	loop(#_base16 -> size) => {
		#base10 += ((#hex_list -> find((#_base16 -> get(loop_count)))) * integer(16.0 -> pow(decimal(#base16_len - loop_count))))
	}

	// return base10 number
	return integer(#base10)

}

/**!
knop_math_decToHex
Returns a base16 string given a base10 integer.
**/
define knop_math_decToHex(
	base10::integer
	) => {
 /* was lp_math_decToHex by Bil Corry. Integrated in Knop for internal use
    // http://www.danbbs.dk/~erikoest/hex.htm
 */

	local('base16' = string)

	// hex chars
	local('hex_list' = '0123456789ABCDEF')

	local(_base10 = #base10)

	while(#_base10 > 0)
		#base16 = #hex_list->get((#_base10 % 16) + 1) + #base16
		#_base10 = math_floor((#_base10 / 16))
	/while

	// return base16 number
	return ('0' * (2 - string(#base16) -> size)) + #base16

}

define string -> knop_trim(trim::string) => {
	self -> removeleading(#trim) & removetrailing(#trim)
}

/**!
knop_encodesql_full
Alternative to encode_sql that also deals with escaping % and _ so that the resulting string can be safely used when creating sql queries with LIKE sections.
See Bil Corrys talk from LDC Chicago 2008

2011-08-31	JC	First version
**/
define string -> knop_encodesql_full()::string => {
	local(text = string(self))
	#text -> replace(regexp(`(["'\\])`), `\\\1`) & replace('\0', `\0`)
//" Keep this to help code coloring in Bbedit
	#text -> replace(`%`, `\%`)
	#text -> replace(`_`, `\_`)
	return #text
}

define knop_encodesql_full(text::string) => #text -> knop_encodesql_full


/*
Commented out in an effort to track why Lasso crashes. And since it's looks like it's not used
In dialog between Jolle and Tim 2011-03-10
define knop_trait_providesProperties => trait {
	provide properties() => {

		local(myMethods =
			(with method in .listMethods
			let stringed = #method->methodName->asString
			where !#stringed->endsWith('=') // strip out setters
			where #method->typeName == .type // get only methods defined in "me"
			select #stringed)->asStaticArray) // exe the query by getting sarray

		local(methMap = map, dataMap = map)

		with methodName in #myMethods
		where #methodName->get(1) == "'"
		let dataName = (string(#methodName)->removeLeading("'") &removeTrailing("'")&)
		do {
			if (#myMethods >> #dataName)
				#dataMap->insert(#dataName = self->\(tag(#dataName))->invoke)
			else
				#dataMap->insert(#dataName = null) // can not access
			/if
		}

		with methodname in #myMethods
		where !#methodName->beginsWith("'")
//		do #methMap->insert(#methodName = self->\(tag(#methodName))) //lookup & insert the method via ->\
		do #methMap->insert(#methodName) //lookup & insert the method via ->\

		return pair(#dataMap, #methMap)
	}
}
*/
//log_critical('loading knop_utils done')

?>