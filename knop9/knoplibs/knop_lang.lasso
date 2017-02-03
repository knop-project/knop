<?Lasso
//log_critical('loading knop_lang from LassoApp')

/**!
knop_lang for Lasso 9
A knop_lang object holds all language strings for all supported languages. Strings are stored under a unique text key, but the same key is of course used for the different language versions of the same string.
Strings can be separated into different variables if it helps managing them for different contexts.
When the language of a string object is set, that language is used for all subsequent requests for strings until another language is set. All other instances on the same page that don't have a language set will also use the same language.
If no language is set, knop_lang uses the browser's preferred language if it's available in the knop_lang object, otherwise it defaults to the first language (unless a default language has been set for the instance).
**/
define knop_lang => type {

	/*

	CHANGE NOTES
	2016-06-08	JS	Changed onconvert to asString
	2016-06-08	JS	Added back oncreate signature for named keyword (thanks to Ke)
	2014-01-09	JC	Removed the keyword signatur oncreate since it collided with Lasso 9.2.7
	2013-04-02	JC	Add log_critical for keys that wasn't found and if the -always flag is set
	2013-01-29	JC	Minor cleanup. Should mean an ever so small speed gain.
	2012-11-04	JC	Added param always to getstring. Will always return a value. If the key is not found will return the keyvalue itself
	2012-06-10	JC	Changed all iterate to query expr or loop. Removed all semicolons. Changed all old style if to code blocks.
	2012-05-18	JC	Added additional signature for unknowntag to support keyword calls
	2012-05-14	JC	Reactivated unknowntag
	2012-05-14	JC	Added set to allowed params for getstring -replace
	2011-06-18	JC	Making addlanguage -strings optional
	2011-05-30	JC	Fixed bug in regards to using integers as getstring key
	2010-10-19	JC	Adding public validlanguage(void) => false
	2010-10-09	JC	Adding alternative calls for getstring and validlanguage
	2009-11-25	JC	Caching object in place. No changes to the lang type but it benefits from the caching
	2009-11-23	JC	First version all functions in place. Still lacks debug and timer functions. And caching
	2009-11-22	JC	Started on first version written directly for for Lasso 9

	*/

	data public strings::map = map
	data public fallback::boolean
	data public defaultlanguage::string
	data public currentlanguage::string = string
	data public keys = null

	/**!
	onCreate
	Creates a new instance of knop_lang.
	Parameters:
	-default (optional) Default language.
	-fallback (optional) If specified, falls back to default language if key is missing.
	**/

    // Primary signature with named keywords
    public onCreate(
        -default::string = string,
        -fallback::boolean = false
    ) => {

		.defaultlanguage = #default
		.fallback = #fallback

	}

    // Secondary signature with unnamed parameters
    public onCreate(
        default::string,
        fallback::boolean
    ) => .oncreate(
        -default = #default,
        -fallback = #fallback
    )


	public asString() => (self -> listmethods)

	/**!
	_unknowntag
	Returns the language string for the specified text key
		= shortcut for getstring.
	Parameters:
		-language (optional)  see getstring( -language).
		-replace (optional) see getstring( -replace).
	**/
	public _unknowntag(
		language::any = string,
		replace::any = string
	) => {
		local(name = string(currentCapture->calledName))
		return .keys >> #name ? .getstring(string(#name), string(#language), #replace)
	}
	public _unknowntag(
		-language::any = string,
		-replace::any = string
	) => {
		local(name = string(currentCapture->calledName))
		return .keys >> #name ? .getstring(string(#name), string(#language), #replace)
	}

	/**!
	addlanguage
	Adds a map with language strings for an entire language. Replaces all existing language strings for that language.
	Parameters:
	-language (required) The language to add.
	-strings (required) Complete map of key = value for the entire language.
	**/
	public addlanguage(
		language::string,
		strings::map = map
	) => {

		.'keys' = null
		.'strings' -> insert( #language = #strings)
	}
	public addlanguage(
		-language::string,
		-strings::map = map
	) => { .addlanguage(#language, #strings)}

	/**!
	insert
	Adds an individual language string.
	Parameters:
		-language (required) The language for the string.
		-key (required) Textkey to store the string under. Replaces any existing key for the same language.
		-value (required) The actual string (can also be compound expression). Can contain replacement tokens #1#, #2# etc.
	**/
	public insert(
		language::string,
		key::string,
		value::string
	) => {
		.'keys' = null
		.'strings' !>> #language ? .'strings' -> insert( #language = map)

		(.'strings' -> find( #language)) -> insert( #key = #value)

	}

	/**!
	getstring
	Returns a specific text string in the language that has previously been set for the instance.If no language has been set, the browser's preferred language will be used unless another instance on the same page has a language set using ->setlanguage.
	If the string is not available in the chosen language and -fallback was specified, the string for the language that was first specified for that key will be returned.
	Parameters:
	-key (required) textkey to return the string for.
	-language (optional) to return a string for a specified language (temporary override).
	-replace (optional) single value or array of values that will be used as substitutions for placeholders #1#, #2# etc in the returned string, in the order they appear. Replacements can be compund expressions, which will be executed. Can also be map or pair array, and in that case the left hand element of the map/array will be replaced by the right hand element.
	**/
	public getstring(
		key::any,
		language::string = string,
		replace = string,
		always::boolean = false
	) => {

		#language = #language -> ascopy
		#replace = #replace -> ascopy

		if(not var_defined('_knop_data')) => {
			// page level caching
			var(_knop_data = map)
		}

		local(output = string)

		if(#language -> size == 0 || !(.validlanguage( #language))) => {
			#language = .'currentlanguage'
			if(#language -> size == 0) => {
				local(currentlanguage) = $_knop_data -> find( 'currentlanguage')
				if(.validlanguage( #currentlanguage)) => {
					// fall back to page level language
					#language = #currentlanguage
				else
					// fall back to the browser's preferred language
					#language = .browserlanguage
				}
			}
			if(#language -> size == 0 && .validlanguage( .defaultlanguage)) => {
				// still no matching language, fall back to defaultlanguage
				#language = .defaultlanguage
			else(#language -> size == 0)
				// still no matching language, fall back to the first language
				#language = .'strings' -> keys -> first
			}
			if(.'strings' !>> #language
				|| (.'strings' >> #language
					&& .'strings' -> find( #language) !>> #key
					&& .fallback)) => {
				// key is not found in current language, switch to default language
				if(.validlanguage( .defaultlanguage)) => {
					// still no matching language, fall back to defaultlanguage
					#language = .defaultlanguage
				else
					// no default language to fall back to
				}
			}
		}
		if(.'strings' >> #language) => {
			if(.'strings' -> find(#language) !>> #key) => {
				/* pending a debugging feature
				(self -> 'debug_trace') -> insert('Error: ' + #key + ' not found')
				self -> 'tagtime_tagname' = tag_name
				self -> 'tagtime' = integer(#timer) // cast to integer to trigger onconvert and to "stop timer"
				(self -> 'debug')
					? return('*' + tag_name + '*')
					| return
				*/
				if(#always) => {
					log_critical('lang called with key that wasn\'t found. Key: ' + #key)
					return #key
				else
					return string
				}
			}
			#output = .'strings' -> find( #language) -> find( #key)

			if(#output -> isa(::tag)) => {
				// execute compund expression
				#output = #output -> run
			}
			if(#output -> size > 0 && #replace -> size > 0) => {
				// replace placeholders with real values
				if(!(#replace -> isa(::array)) && !(#replace -> isa(::map)) && !(#replace -> isa(::set))) => {
					#replace = array( #replace)
				}
				local(loopcount = 0)
				with replacement in #replace do => {
					#loopcount += 1
					// make sure we have a pair
					if(!(#replacement -> isa(::pair))) => {
						#replacement = pair( '#' + #loopcount + '#' = #replacement)
					}
					// if we have a compund expression as replacement, execute the replacement first
					if((#replacement -> value -> isa(::tag))) => {
						(#replacement -> value) = #replacement -> value -> run
					}
					#output -> replace( #replacement -> name, #replacement -> value)
				}
			}
		}

		return #output

	}

	public getstring(
		key::any,
		-language::string = string,
		-replace = string,
		-always::boolean = false
	) => .getstring(#key, #language, #replace, #always)

	public getstring(
		-key::any,
		-language::string = string,
		-replace = string,
		-always::boolean = false
	) => .getstring(#key, #language, #replace, #always)

	/**!
	setlanguage
	Sets the current language for the string object. Also affects other instances on the same page that do not have an explicit language set.
	**/
	public setlanguage(
		language::string
	) => {

		if(not var_defined('_knop_data')) => {
			// page level caching
			var(_knop_data = map)
		}
		if(.validlanguage( #language)) => {
			.'currentlanguage' = #language
			// save page level language
			$_knop_data -> insert('currentlanguage' = #language)
		else
//			(self -> 'debug_trace') -> insert( tag_name + '### Could not set current language to ' + #language + ' since it does not exist in the lang object')
		}
	}

	/**!
	validlanguage
	Checks if a specified language exists in the string object, returns true or false.
	**/
	public validlanguage(language::string) => .'strings' -> keys >> #language

//	public validlanguage(-language::string) => .validlanguage(#language)
	public validlanguage(-language::string) => .'strings' -> keys >> #language
	public validlanguage(void) => false

	/**!
	browserlanguage
	Autodetects and returns the most preferred language out of all available languages as specified by the browser's accept-language q-value.
	**/
	public browserlanguage() => {
		local(browserlanguage = string)

		if(not var_defined('_knop_data')) => {
			// page level caching
			var(_knop_data = map)
		}

		if($_knop_data >> 'browserlanguage') => {
			// use page cache
			#browserlanguage = $_knop_data -> find('browserlanguage')

		else
			local(acceptlanguage = web_request -> httpacceptlanguage)
			local(browserlanguages = array)

			#acceptlanguage -> trim // NOTE needed?
//			(self -> 'debug_trace') -> insert( tag_name + '### Accept-Language: ' + #acceptlanguage)
			#acceptlanguage = #acceptlanguage -> split( ',')
			with language in #acceptlanguage do => {
				#language = #language -> split( ';')
				if(#language -> size == 1) => {
					// no q value specified, use default 1.0
					#language -> insert( 'q=1.0')
				}
				(#language -> first) -> trim
				if(#language -> size >= 2 && #language -> first -> size > 0) => {
					(#language -> get(2)) = (#language -> second) -> split( '=') -> last
					(#language -> second) -> trim
					#browserlanguages -> insert( decimal( (#language -> second)) = (#language -> first) )
				}
			}
			#browserlanguages -> sort( true)

			// find the most preferred language
//			(self -> 'debug_trace') -> insert( tag_name + '### looking for matching languages ')
			local(languagetmp)
			loop(#browserlanguages -> size) => {
				#languagetmp = #browserlanguages -> get(loop_count)
				if(.validlanguage(#languagetmp -> second)) => {
					/// found a valid language
					#browserlanguage = #languagetmp -> second
//					(self -> 'debug_trace') -> insert( tag_name + '### found valid language ' + #browserlanguage)
					loop_abort
				}
			}
			if(#browserlanguage -> size == 0) => {
				// no matching language found, try again without locale
//				(self -> 'debug_trace') -> insert( tag_name + '### no valid language found, looking again without locale ' + #language)
				loop(#browserlanguages -> size) => {
					#languagetmp = #browserlanguages -> get(loop_count)
					(#languagetmp -> second) = (#languagetmp -> second) -> split( '-') -> first
					if(.validlanguage(#languagetmp -> second)) => {
						/// found a valid language
						#browserlanguage = #languagetmp -> second
//						(self -> 'debug_trace') -> insert( tag_name + '### found valid language ' + #browserlanguage)
						loop_abort
					}
				}
			}
			$_knop_data -> insert('browserlanguage' = #browserlanguage)
		}

//		self -> 'tagtime_tagname' = tag_name
//		self -> 'tagtime' = integer(#timer) // cast to integer to trigger onconvert and to "stop timer"
		return #browserlanguage
	}

	/**!
	languages
	Returns an array of all available languages in the string object (out of the languages in the -language array if specified).
	Parameters:
	-language (optional) string or array of strings.
	**/
	public languages(language = string) => {
		local(languages = .'strings' -> keys -> asarray)
		if(#language -> size > 0) => {

			#language = #language -> ascopy

			!(#language -> isa(::array)) ? #language = array(#language)

			#languages -> sort
			#language -> sort
			// get the languages that exist in both arrays
			#languages = #languages -> intersection( #language)
		}
		return #languages
	}

	/**!
	keys
	Returns array of all text keys in the string object.
	**/
	public keys() => {

		if(!.'keys' -> isa(::array)) => {
			local(keysarray = array)
//			local(keysmap = map) // NOTE not used?
			local(keysarray_new = array)
			// no cached result yet - create list of all keys
			with strings_language in .'strings' do => {
				#keysarray_new = #strings_language -> keys -> asarray
				#keysarray_new -> sort
				#keysarray -> sort
				// add the keys that are not already in #keysarray by using union
				#keysarray = #keysarray -> union( #keysarray_new)
			}
			.'keys' = #keysarray
		}
		return .'keys'

	}

}

//log_critical('loading knop_lang done')

?>
