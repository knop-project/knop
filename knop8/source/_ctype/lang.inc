<?LassoScript

define_type: 'lang',
	'knop_base',
	-namespace='knop_';
//	-prototype;

	local: 'version'='2010-12-29',
			'description'='A knop_lang object holds all language strings for all supported languages. Strings are \
				stored under a unique text key, but the same key is of course used for the different language \
				versions of the same string. \n\
				Strings can be separated into different variables if it helps managing them for different contexts. \n\
				When the language of a string object is set, that language is used for all subsequent requests \
				for strings until another language is set. All other instances on the same page that don\'t have a \
				language set will also use the same language.  \n\
				If no language is set, knop_lang uses the browser\'s preferred language if it\'s available in \
				the knop_lang object, otherwise it defaults to the first language (unless a default language \
				has been set for the instance).';

/*

CHANGE NOTES
2010-12-29	JS	->getstring: make sure we only try to do replacement in strings or bytes
2010-05-27	JS	getstring now works also with empty -replace value
2010-04-20	JS	getstring debug output corrected for missing string. 
2009-09-16	JS	Syntax adjustments for Lasso 9
2009-06-26	JS	->addstring: clarified deprecation warning
2009-04-08	JS	Added -debug flag to oncreate (when creating a lang object) to make undefined language keys appear as *key*.
2009-03-24	JS	->getstring prevents replacements if there is no language string found, to prevent null->replace error
2008-11-12	JS	Added ->insert instead of ->addstring for better consistency with other Lasso data types. ->addstring will remain functional for backwards compatibility. 
2008-09-11	JS	->_unknowntag: added missing support for -language
2008-01-22	JS	->getstring: corrected the fallback behavior when a current language has been set 
2008-01-07	JS	Removed instance variable browserlanguage due to problems with transient storage. The browserlanguage is cached on page level so it's no loss in reality. 
2007-12-12	JS	Added page level storage of currentlanguage, so all knop_lang instances defaults to the same language once one of them have set a language explicitly, but only if the other knop_lang instances don't have a language set explicitly. 
2007-12-12	JS	Added page level caching of browser language (stores the value in $_knop_data map)
2007-12-06	JS	Moved -> help to knop_base
2007-12-06	JS	Added ->description to all member tags. 
2007-12-03	JS	Finished first complete version
2007-06-18	JS	Added tag timer to most member tags
2007-06-13	JS	added inheritance from knop_base
2007-06-13	JS	Renamed to knop_lang (formerly knop_strings)
2007-04-04	JS	Created the data type and started coding

TODO:
Provide methods to handle formatting of dates, numbers, currency etc for different languages/locales. 
Weekday names, month names etc. 
Member tag to return the current language
Member tag to set default output encoding unless it follows encode_set. 

Examples
	var: 'lang_messages'=(knop_lang: -default='en');
	$lang_messages -> (insert: -key='welcome', -value='Welcome to the home page', -language='en');
	$lang_messages -> (insert: -key='welcome', -value='Välkommen till hemsidan', -language='sv');
	$lang_messages -> (insert: -key='loggedin', -value='You are logged in as #1# #2#', -language='en');
	$lang_messages -> (insert: -key='loggedin', -value='Du är inloggad som #1# #2#', -language='sv');

	// proper call, defaults to the browser's preferred language
	$lang_messages -> (getstring: 'welcome');
	// shorthand call
	$lang_messages -> welcome;

	// change language
	$lang_messages -> (setlanguage: 'sv');
	$lang_messages -> welcome;

	// proper call with replacements
	$lang_messages -> (getstring: -key='loggedin': -replace=(array: (field: 'firstname'), (field: 'lastname')));

	// shorthand call with replacements
	$lang_messages -> (loggedin: -replace=(array: (field: 'firstname'), (field: 'lastname')));


*/

	// instance variables
	local: 'strings'=map,		// map: language=(map: key=value, key=value), language=...
		'defaultlanguage'=string,
		'fallback'=false,
		'currentlanguage'=null,	// the currently set language
		'keys'=null,			// cached keys array
		'debug'=false;

	define_tag: 'oncreate', -description='Creates a new instance of knop_lang. \n\
			Parameters: \n\
			-default (optional) Default language. \n\
			-fallback (optional) If specified, falls back to default language if key is missing. \n\
			-debug (optional flag) If specified, missing strings will be output using the key surrounded by asterisks',
		-optional='default',	
		-optional='fallback',
		-optional='debug';
		local: 'timer'=knop_timer; 
		
		if(local_defined('default') && #default -> size);
			(self -> 'defaultlanguage') = #default;
		/if;
		(self -> 'fallback') = ((local_defined: 'fallback') && #fallback != false);
		(self -> 'debug') = ((local_defined: 'debug') && #debug != false);
		
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;
	
	define_tag: 'onconvert', -description='Returns raw dump of the instance for debugging';
		return: (self -> dump);
	/define_tag;

	define_tag: '_unknowntag', -description='Returns the language string for the specified text key \
			= shortcut for getstring. \n\Parameters: \n\
			-language (optional)  see getstring: -language.\n\ 
			-replace (optional) see getstring: -replace. ',
		-optional='language',
		-optional='replace';
		!(local_defined: 'replace') ? local: 'replace'=string;
		!(local_defined: 'language') ? local: 'language'=string;
		if: self -> keys >> tag_name;
			return: @(self -> (getstring: -key=Tag_name, -language=#language, -replace=#replace));
		else;
			(self -> 'debug_trace') -> insert('Error: ' + tag_name + ' not found');
			(self -> 'debug') ? return('*' + tag_name + '*');
		/if;
	/define_tag;
	

	define_tag: 'addlanguage', -description='Adds a map with language strings for an entire language. Replaces all existing language strings for that language. \n\
			Parameters: \n\
			-language (required) The language to add. \n\
			-strings (required) Complete map of key=value for the entire language.',
		-required='language',
		-required='strings', -type='map';
		local: 'timer'=knop_timer; 
		(self -> 'keys') = null;
		(self -> 'strings') -> (insert: #language = #strings);

		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;


	define_tag('addstring', -description='Deprecated synonym for ->insert',
		-required='language',
		-required='key',
		-required='value');
		(self -> 'debug_trace') -> insert('*** DEPRECATION WARNING *** ' + tag_name + ' is deprecated, use ->insert instead');
		self -> insert(-language=#language, -key=#key, -value=#value);
	/define_tag;
	
	define_tag: 'insert',-description='Adds an individual language string. \n\
			Parameters:\n\
			-language (required) The language for the string. \n\
			-key (required) Textkey to store the string under. Replaces any existing key for the same language. \n\
			-value (required) The actual string (can also be compound expression). Can contain replacement tokens #1#, #2# etc. ',
		-required='language',
		-required='key',
		-required='value';
		local: 'timer'=knop_timer; 
		(self -> 'keys') = null;
		if: (self -> 'strings') !>> #language;
			(self -> 'strings') -> (insert: #language = map);
		/if;
		((self -> 'strings') -> (find: #language)) -> (insert: #key = #value);

		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;

	define_tag: 'getstring',	-description='Returns a specific text string in the language that has previously been set for the instance.\
				If no language has been set, the browser\'s preferred language will be used unless another instance on the same page \
				has a language set using ->setlanguage. \n\
				If the string is not available in the chosen language and -fallback was specified, \
				the string for the language that was first specified for that key will be returned. \n\
				Parameters: \n\
				-key (required) textkey to return the string for. \n\
				-language (optional) to return a string for a specified language (temporary override). \n\
				-replace (optional) single value or array of values that will be used as substitutions for placeholders #1#, #2# etc in the returned string, in the order they appear. Replacements can be compound expressions, which will be executed.  Can also be map or pair array, and in that case the left hand element of the map/array will be replaced by the right hand element. ',
		-required='key',
		-optional='language', -copy,
		-optional='replace', -copy;
										
		if: (var: '_knop_data') -> type != 'map';
			// page level caching
			$_knop_data = map;
		/if;

		!(local_defined: 'language') ? local: 'language'=string;

		local: 'timer'=knop_timer; 
		local: 'output'=string;
		if: #language -> size == 0 || !(self -> (validlanguage: #language));
			#language=(self -> 'currentlanguage');
			if: #language -> size == 0;
				if: $_knop_data >> 'currentlanguage' && self -> (validlanguage: ($_knop_data -> (find: 'currentlanguage')));
					// fall back to page level language
					#language = $_knop_data -> find('currentlanguage');
				else;
					// fall back to the browser's preferred language
					#language=(self -> browserlanguage);
				/if;
			/if;
			if: #language -> size == 0 && self -> (validlanguage: (self -> 'defaultlanguage'));
				// still no matching language, fall back to defaultlanguage
				#language = (self -> 'defaultlanguage');
			else: #language -> size == 0;
				// still no matching language, fall back to the first language
				#language = (self -> 'strings') -> keys -> first;
			/if;
			if: (self -> 'strings') !>> #language
				|| ((self -> 'strings') >> #language
					&& (self -> 'strings') -> (find: #language) !>> #key
					&& (self -> 'fallback'));
				// key is not found in current language, switch to default language
				if: self -> (validlanguage: (self -> 'defaultlanguage'));
					// still no matching language, fall back to defaultlanguage
					#language = (self -> 'defaultlanguage');
				else;
					// no default language to fall back to
				/if;
			/if;
		/if;
		if: (self -> 'strings') >> #language;
			if((self -> 'strings') -> find(#language) !>> #key);
				(self -> 'debug_trace') -> insert('Error: ' + #key + ' not found');
				self -> 'tagtime_tagname'=tag_name;
				self -> 'tagtime'=integer(#timer); // cast to integer to trigger onconvert and to "stop timer"
				(self -> 'debug') 
					? return('*' + #key + '*') 
					| return;
			/if;
			#output = (self -> 'strings') -> (find: #language) -> (find: #key);
			//(self -> 'debug_trace') -> (insert: tag_name + ': found string "' + (encode_html: #output) + '" for key "' + #key + '" and language ' + #language);
			
			if: #output -> (isa: 'tag');
				// execute compound expression
				#output = #output -> run;
			/if;
			if((#output -> isa('string') || #output -> isa('bytes')) 
				&& #output -> size && (local_defined: 'replace'));
				// replace placeholders with real values
				if: !(#replace -> (isa: 'array')) && !(#replace -> (isa: 'map'));
					#replace = (array: #replace);
				/if;
				iterate: #replace, local: 'replacement';
					// make sure we have a pair
					if: !(#replacement -> (isa: 'pair'));
						#replacement = (pair: '#' + loop_count + '#' = #replacement);
					/if;
					// if we have a compound expression as replacement, execute the replacement first
					if: (#replacement -> value -> (isa: 'tag'));
						(#replacement -> value) = #replacement -> value -> run;
					/if;
					#output -> (replace: #replacement -> name, #replacement -> value);
				/iterate;
			/if;
		/if;
		
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: #output;
		
	/define_tag;
	
	define_tag: 'setlanguage', -description='Sets the current language for the string object. Also affects other instances on the same page that do not have an explicit language set. ',
		-required='language';
		local: 'timer'=knop_timer; 
		if: (var: '_knop_data') -> type != 'map';
			// page level caching
			$_knop_data = map;
		/if;
		if: self -> (validlanguage: #language);
			(self -> 'debug_trace') -> (insert: tag_name + ': Setting language to ' + #language);
			(self -> 'currentlanguage') = #language;
			// save page level language
			$_knop_data -> insert('currentlanguage' = #language);
		else;
			(self -> 'debug_trace') -> (insert: tag_name + ': Could not set current language to ' + #language + ' since it does not exist in the lang object');
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;
	
	define_tag: 'validlanguage', -description='Checks if a specified language exists in the string object, \
		returns true or false.',
		-required='language';
		return: (self -> 'strings') -> keys >> #language;
	/define_tag;
	
	define_tag: 'browserlanguage', -description='Autodetects and returns the most preferred language \
			out of all available languages as specified by the browser\'s accept-language q-value. ';
		
		local: 'timer'=knop_timer; 

		local: 'browserlanguage'=string;

		if: (var: '_knop_data') -> type != 'map';
			// page level caching
			$_knop_data = map;
		/if;

		if: $_knop_data >> 'browserlanguage';
			// use page cache
			#browserlanguage = $_knop_data -> find('browserlanguage');

		else;
			local: 'requestheader'=client_headers -> (split: '\r\n'),
				'acceptlanguage'=string,
				'browserlanguages'=array;
			
			iterate: #requestheader, (local: 'headerfield'); 
				// strip IIS header prefix
				#headerfield -> (removeleading: 'HTTP_');
				
				if: #headerfield -> (beginswith: 'Accept-Language:'); 
					#acceptlanguage=#headerfield;
					loop_abort;
				/if;
			/iterate;
			#acceptlanguage -> (removeleading: 'Accept-Language:');
			#acceptlanguage -> trim;
			(self -> 'debug_trace') -> (insert: tag_name + ': Accept-Language: ' + #acceptlanguage);
			#acceptlanguage = #acceptlanguage -> (split: ',');
			iterate: #acceptlanguage, local: 'language';
				#language = #language -> (split: ';');
				if: #language -> size == 1;
					// no q value specified, use default 1.0
					#language -> (insert: 'q=1.0');
				/if;
				(#language -> first) -> trim; 
				if: #language -> size >= 2 && #language -> first -> size;
					(#language -> second) = (#language -> second) -> (split: '=') -> last;
					(#language -> second) -> trim; 
					#browserlanguages -> (insert: (decimal: (#language -> second)) = (#language -> first) );
				/if;
			/iterate;
			#browserlanguages -> (sort: -ascending=false);
	
			// find the most preferred language
			(self -> 'debug_trace') -> (insert: tag_name + ': looking for matching languages ');
			iterate: #browserlanguages, local: 'language';
				if: (self -> validlanguage: (#language -> second));
					/// found a valid language
					#browserlanguage=#language -> second;
					(self -> 'debug_trace') -> (insert: tag_name + ': found valid language ' + #browserlanguage);
					loop_abort;
				/if;
			/iterate;
			if: #browserlanguage -> size == 0;
				// no matching language found, try again without locale
				(self -> 'debug_trace') -> (insert: tag_name + ': no valid language found, looking again without locale ' + #language);
				iterate: #browserlanguages, local: 'language';
					(#language -> second) = (#language -> second) -> (split: '-') -> first;
					if: (self -> validlanguage: (#language -> second));
						/// found a valid language
						#browserlanguage=#language -> second;
						(self -> 'debug_trace') -> (insert: tag_name + ': found valid language ' + #browserlanguage);
						loop_abort;
					/if;
				/iterate;
			/if;
			$_knop_data -> insert('browserlanguage'=#browserlanguage);
		/if;
		
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: #browserlanguage;

	/define_tag;
	
	define_tag: 'languages', -description='Returns an array of all available languages in the string object \
			(out of the languages in the -language array if specified). \n\
			Parameters: \n\
			-language (optional) string or array of strings.',
		-optional='language', -copy;
		local: 'timer'=knop_timer; 

		local: 'languages'=(self -> 'strings') -> keys;
		if: (local_defined: 'language');
			if: !(#language -> (isa: 'array'));
				#language = array: #language;
			/if;
			#languages -> sort;
			#language -> sort;
			// get the languages that exist in both arrays
			#languages = #languages -> (intersection: #language);
		/if;

		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: #languages;
	/define_tag;
	
	define_tag: 'keys', -description='Returns array of all text keys in the string object. ';
		if: !((self -> 'keys') -> (isa: 'array'));
			local: 'keysarray'=array, 'keysmap'=map, 'keysarray_new'=array;
			// no cached result yet - create list of all keys
			iterate: (self -> 'strings'), local: 'strings_language';
				#keysarray_new = #strings_language -> value -> keys;
				#keysarray_new -> sort;
				#keysarray -> sort;
				// add the keys that are not already in #keysarray by using union
				#keysarray = #keysarray -> (union: #keysarray_new);
			/iterate;
			(self -> 'keys') = #keysarray;
		/if;
		return: (self -> 'keys');
	/define_tag;
	

/define_type;

?>
