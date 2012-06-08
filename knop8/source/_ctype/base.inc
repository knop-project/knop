<?LassoScript

define_type('knoptype',
	-namespace='knop_');
	local('description'='All Knop custom types should have this type as parent type. This is to be able to identify all registered knop types. ');
	local('isknoptype'=true);
/define_type;

define_type: 'base',
	'knop_knoptype',
	-namespace='knop_';
//	-prototype;

	local: 'version'='2009-09-14',
		'description'='Base data type for Knop framework. Contains common member tags. Used as boilerplate when creating the other types. \
						All member tags and instance variables in this type are available in the other knop types as well. ';
/*


CHANGE NOTES
2009-09-14	JS	Syntax adjustments for Lasso 9
2009-09-04	JS	Changed $__html_reply__ to content_body
2009-04-07	JS	->error_msg: custom error numbers can now be added, even if the language already exists.
2008-01-10	JS	->error_msg: improved reporting of custom error messages such as from bad database queries
2007-12-13	JS	Added -> error_lang to provide a reference to the knop_lang object for error messages, to be able to add localized error messages to any Knop type (except knop_lang and knop_base)
2007-12-12	JS	Added -html and -xhtml to ->help to get a nicely formatted output. 
2007-12-11	JS	Centralized ->error_code and ->error_msg to knop_base. Moved all error codes to error_msg
2007-12-06	JS	Changed ->help to improve the self-documentation. It will now always return an up to date list of member tags and parameter. 
2007-11-05	JS	Added var name to trace output
2007-06-17	JS	Added ->tagtime (was in nav earlier)
2007-06-13	JS	Added -> varname to be able to retreive the name of the page variable that a type instance is stored in.
2007-06-13	JS	Added -> xhtml to automatically sense if an xhtml doctype exists in the current page buffer. The result is cached in a page variable for performance. 
				This is for internal use for member tags that output html. 
2007-06-13	JS	Introduced page variable $_knop_data for general page level storage and caching, common between different knop objects. 
2007-06-13	JS	Created the data type

TODO: ->help: add output option to format for Google Code Wiki
->xhtml is not working properly when site is run by atbegin handler and explicitly writing to content_body 


*/

	local: 'debug_trace'=array,
		'_debug_trace'=array,
		'instance_unique'=null,
		'instance_varname'=null,
		'tagtime'=integer,				// time for entire tag in ms
		'tagtime_tagname'=string,
		'error_code'=0,
		'error_msg'=string,
		'error_lang'=null,	// must be defined as knop_lang in each type instead, to avoid recursion
		;

	define_tag: 'ondeserialize', -description='Recreates transient variables after coming back from a session';
		self -> properties -> first -> insert('_debug_trace'=array);
	/define_tag;

	define_tag: 'help', -description='Auto generates an overview of all member tags of a type, with all parameters specified for each member tag.', 
		-optional='html',
		-optional='xhtml';
		local: 'endslash' = ((self -> (xhtml: params)) ? ' /' | '');
		local: 'eol'=(local_defined: 'html') || #endslash -> size ? '<br' + #endslash + '>\n' | '\n';

		local: 'output'=string,
			'tags'=array,
			'description'=string,
			'parameters'=string;
		#output += (self -> type) + ' - version ' + (self -> 'version') + '\n' ;
		#output += (self -> 'description') + '\n\n';
		iterate: (self -> properties -> second) , local: 't';
			#tags -> (insert: #t);
		/iterate;
		if: (self -> parent -> type != 'null'); // this doesn't work
			iterate: (self -> parent -> properties -> second) , local: 't';
				#tags -> (insert: #t);
			/iterate;
		/if;
		#tags -> sort;
		iterate: #tags , local: 't';
			#parameters = string;
			#output += '-> ' + (#t -> name);
			#description=(#t -> value -> description);
			iterate: (#t -> value -> paraminfo) , local: 'p';
				if: #description !>> '-' + (#p -> paramname);
					#parameters += '-' + (#p -> paramname) + ' (' (#p -> isrequired ? 'required' | 'optional') 
						+ (#p -> paramtype != 'null' && #p -> paramtype -> size ? ' ' + (#p -> paramtype))  + ')\n';
				/if;
			/iterate;
			#output += (#description -> size || #parameters -> size ? '\n' + #description);
			#output += (#description >> 'Parameters:' ?  '\n');
			#output += (#description !>> 'Parameters:' && #parameters -> size ? '\nParameters:\n');
			#output += (#parameters -> size ? #parameters);
			#output -> removetrailing('\n');
			#output += '\n\n';
		/iterate;
		if: ((local_defined: 'html') && #html != false) || ((local_defined: 'xhtml') && #xhtml != false);
			#output = encode_html: #output;
			// normalize line breaks and convert to <br>
			#output -> (replace: '\r\n', '\n') & (replace: '\r', '\n') & (replace: '\n', #eol + '\n');
		/if;
		return: #output;
	/define_tag;


	define_tag: 'xhtml', -description='Internal. Finds out if xhtml output should be used. Looks at doctype unless -xhtml is specified \
			in the params array. The result is cached in a page variable. \n\
			Looking at doctype doesn\'t work when using atbegin driven solutions since content_body isn\'t filled with the page buffer until the page has already been processed.  ',
		-optional='params';
		if: (local_defined: 'params') && #params >> '-xhtml';
			local: 'xhtmlparam'=#params -> (find: '-xhtml') -> first;
			if: #xhtmlparam -> type == 'pair'; // -xhtml=true / -xhtml=false
				return: boolean: (#xhtmlparam -> value);
			else; // plain -xhtml
				return: true;
			/if;
		/if;
		if: (var: '_knop_data') -> type != 'map';
			$_knop_data = map;
		/if;
		if: $_knop_data !>> 'doctype_xhtml';
			local: 'doctype' = content_body -> (substring: 1, (content_body -> (find: '>')));
			$_knop_data -> (insert: 'doctype_xhtml' = (#doctype >> '<!DOCTYPE' && #doctype >> 'xhtml'));
		/if;
		return: $_knop_data -> (find: 'doctype_xhtml');
	/define_tag;


	define_tag: 'error_lang', -description='Returns a reference to the language object used for error codes, to be able to add localized error messages to any Knop type (except knop_lang and knop_base)';
		return: @(self -> 'error_lang');
	/define_tag;

	define_tag: 'error_code', -description='Either proprietary error code or standard Lasso error code';
				return: integer: (self -> 'error_code');
	/define_tag;

	define_tag: 'error_msg',
		-optional='error_code', -type='integer', -copy;
		!(local_defined: 'error_code') ? local: 'error_code'=(self -> error_code);
		local: 'error_lang_custom'=(self -> 'error_lang');
		local: 'error_lang'=(knop_lang: -default='en', -fallback);

		local: 'errorcodes'=(map:
			0 = 'No error',
			-1728 = 'No records found', // standard Lasso error code
			
			// database errors 7000
			7001 ='The specified table was not found',
			7002 = 'Keyfield not specified',
			7003 = 'Lockfield not specified',
			7004 = 'User not specified for record lock',
			7005 = 'Either keyvalue or lockvalue must be specified for update or delete',
			7006 = 'Keyfield or keyvalue missing',
			7007 = 'Keyvalue missing',
			7008 = 'Keyvalue not unique',
			7009 = '-sql can not be used with FileMaker',
			7010 = 'Record locked by another user', // see error_data
			7011 = 'Record lock not valid any more',
			7012 = 'Could not set record lock', // see error_data
			7013 = 'Failed to clear record locks', // see error_data
			7016 = 'Add error', // see error_data
			7017 = 'Add failed, duplicate key value',
			7018 = 'Update error', // see error_data
			7019 = 'Delete error', // see error_data
			7020 = 'Keyfield not present in query',
			7021 = 'Lockfield not present in query',
			
			// form errors 7100
			7101 ='Form validation failed',
			7102 = 'Unsupported field type',
			7103 = 'Form->process requires that a database object is defined for the form',
			7104 = 'Copyfield must copy to a different field name',

			// grid errors 7200 
			
			// lang errors 7300
			
			// nav errors 7400
			
			// user errors 7500
			7501 = 'Authentication failed',
			7502 = 'Username or password missing',
			7503 = 'Client fingerprint has changed'
			
			);
		#error_lang -> (addlanguage: -language='en', -strings=@#errorcodes);
		// add any custom error strings
		iterate(#error_lang_custom -> 'strings', local('custom_language'));
			if(#error_lang -> 'strings' !>> #custom_language -> name);
				// add entire language at once
				#error_lang -> addlanguage(-language=#custom_language -> name, -strings=#custom_language -> value);
			else;
				// add one string at a time
				iterate(#custom_language -> value, local('custom_string'));
					#error_lang -> insert(-language=#custom_language -> name, 
						-key=#custom_string -> name, 
						-value=#custom_string -> value);
				/iterate;
			/if;
		/iterate;
		
		if: #errorcodes >> #error_code;
			// return error message defined by this tag
			if: #error_lang -> keys >> #error_code;
				return: #error_lang -> (getstring: #error_code);
			else;
				return: #errorcodes -> (find: #error_code);
			/if;
		else;
			if: (self -> 'error_msg') != '';
				// return literal error message
				return: (self -> 'error_msg');
			else;
				// test for error known by lasso
				error_code = #error_code;
				// return Lasso error message
				return: error_msg;
			/if;
		/if;
	/define_tag;

	define_tag: 'varname', -description='Returns the name of the variable that this type instance is stored in.';
		local: 'timer'=knop_timer;
		if: self -> 'instance_unique' == null;
			self -> 'instance_unique' = knop_unique;
		/if;
		if: self -> 'instance_varname' == null;
			// look for the var name and store it in instance variable
			iterate: (vars -> keys), (local: 'varname');
				if: (var: #varname) -> type == self -> type 
					&& ((var: #varname) -> 'instance_unique') == (self -> 'instance_unique');
					(self -> 'instance_varname')=#varname;
					loop_abort;
				/if;
			/iterate;
		/if;

		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer;
		return: self -> 'instance_varname';
	/define_tag;

	define_tag: 'trace', -description='Returns the debug trace for a type instance',
		-optional='html',
		-optional='xhtml';

		local: 'endslash' = ((self -> (xhtml: params)) ? ' /' | '');
		local: 'eol'=(local_defined: 'html') || #endslash -> size ? '<br' + #endslash + '>\n' | '\n';
		local: 'trace'=(self -> 'debug_trace');
		(self -> '_debug_trace') -> isa('array') ? #trace -> merge(self -> '_debug_trace');
		return: #eol + 'Debug trace for ' + (self -> type ) + ' $' + (self -> varname) + #eol 
			+ #trace -> (join: #eol) + #eol;

	/define_tag;


	define_tag: 'tagtime', -description='Returns the time it took to execute the last executed member tag for a type instance.',
		-optional='html',
		-optional='xhtml';
		/* Standard timer code
		At beginning of tag code:
		local: 'timer'=knop_timer; 
		
		Before the end of tag code (before return):
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		
		*/
		local: 'endslash' = ((self -> (xhtml: params)) ? ' /' | '');

		((local_defined: 'html') || (local_defined: 'xhtml')) ? return: (self -> type) + '->' + (self -> 'tagtime_tagname') + ': ' + (self -> 'tagtime') + ' ms<br' + #endslash + '>';
		return: (self -> 'tagtime');
	/define_tag;

/define_type;



?>
