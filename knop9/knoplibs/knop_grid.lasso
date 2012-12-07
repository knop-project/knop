﻿<?LassoScript
log_critical('loading knop_grid')

/**!
Custom type to handle data grids (record listings).
**/
define knop_grid => type {
	parent knop_base

	data public version = '2012-05-18'

/*

CHANGE NOTES

	2012-05-19	JC	Added -getargs = false when creating url_cached
	2012-05-18	JC	Fixed bug that would not populate dbfield and label if only a name param was supplied
	2011-12-20	JC	Added support for jquery row sorting
	2011-09-05	JC	Changed encode_sql to knop_encodesql_full for LIKE queries
	2011-06-18	JC	Changed insert Quicksearch to allow different quicksearch field name than dbfield name. Makes searches using JOIN tables easier
	2011-06-09	JC	Fixed bug with encode_stricturl if param was null
	2011-06-03	JC	Fixing bug in relation to defaultsort
	2011-05-04	JC	Setting some default values to strings like sortfield etc
	2011-05-04	JC	Removed the dash in footer
	2011-04-30	JC	Corrected a bug that displayed quicksearch no matter what
	2011-04-22	JC	Added support for -raw in field rendering
	2011-02-24	JC	Changed all short calls to lang object to use getstring due to the bug when using unknowntag
	2011-02-16	JC	First working version for Lasso 9
	2011-02-08	TT	First version for Lasso 9

TODO
Make it possible for knop_grid to work independently of a knop_database object so other types of listings can be created.
Language of quicksearch buttons can't be changed after the grid has been created
tbody is used in renderfooter, which is not semantically correct. can't use tfoot though since the footer is rendered twice.
Move templates to a member tag to be make it easier to subclass

*/

	// instance variables
	data public fields::array = array
	data public dbfieldmap::map = map
	data public sortfield::string = string
	data public defaultsort::string = string
	data public page::integer = integer
	data public sortdescending = false
	data public database
	data public nav = null

	data public quicksearch::string = 'Quicksearch'
	data public quicksearch_form
	data public quicksearch_form_reset
	data public rawheader::string = ''
	data public class::string = ''

	data public tbl_id::string = 'grid'
	data public qs_id::string = 'quicksearch'
	data public qsr_id::string = 'qs_reset'

	data public quicksearch_fields::array = array
	data public footer::string = string

	data public lang = knop_lang(-default = 'en', -fallback)		// language strings object
	data public error_lang = knop_lang(-default = 'en', -fallback)
	data public numbered = false
	data public nosort
	data public rowsorting

/**!
Parameters:
	- database (required database)
	  Database object that the grid object will interact with

	- nav (optional nav)
	  Navigation object to interact with

	- quicksearch (optional)
	  Label text for the quick search field

	- rawheader (optional)
	  Extra html to be inserted in the grid header

	- class (optional)
	  Extra classes to be inserted in the grid header. The standard class "grid" is always inserted

	- id (optional)
	  Creates a custom id used for table, quicksearch and quicksearch_reset

	- nosort (optional flag)
	  Global setting for the entire grid (overrides column specific sort options)

	- language (optional)
	  Language to use for the grid, defaults to the browser's preferred language

	- numbered (optional flag or integer)
	  If specified, pagination links will be shown as page numbers instead of regular prev/next links. 
	  Defaults to 6 links, specify another number (minimum 6) if more numbers are wanted. Can be specified in ->renderhtml as well.
**/
	public oncreate(
		database::knop_database,
		nav::any = '',
		quicksearch = false,
		rawheader::string = '',
		class::string = '',
		id::string = '',
		nosort = false,
		language::string = 'en',
		numbered::any = false,
		rowsorting::boolean = false
		) => {

		local('lang' = .'lang')
		#lang -> addlanguage(-language = 'en', -strings = map(
			'quicksearch_showall' = 'Show all',
			'quicksearch_search' = 'Search',
			'linktext_edit' = '(edit)',
			'linktitle_showunsorted' = 'Show unsorted',
			'linktitle_changesort' = 'Change sort order to',
			'linktitle_ascending' = 'ascending',
			'linktitle_descending' = 'descending',
			'linktitle_sortascby' = 'Sort ascending by',
			'linktitle_gofirst' = 'Go to first page',
			'linktitle_goprev' = 'Go to previous page',
			'footer_shown' = '#1# - #2# of',
			'footer_found' = 'found',
			'gotopage' = 'Go to page', // SP customization
			'linktitle_gonext' = 'Go to next page',
			'linktitle_golast' = 'Go to last page',

			// language neutral strings, only need to be set for the default language
			'linktext_first' = '|&lt;',
			'linktext_prev' = '&lt;&lt;',
			'linktext_next' = '&gt;&gt;',
			'linktext_last' = '&gt;|'
			))

		#lang -> addlanguage(-language = 'sv', -strings = map(
			'quicksearch_showall' = 'Visa alla',
			'quicksearch_search' = 'Sök',
			'linktext_edit' = '(redigera)',
			'linktitle_showunsorted' = 'Visa osorterade',
			'linktitle_changesort' = 'Ändra sorteringsordning till',
			'linktitle_ascending' = 'stigande',
			'linktitle_descending' = 'fallande',
			'linktitle_sortascby' = 'Sortera i stigande ordning efter',
			'linktitle_gofirst' = 'Gå till första sidan',
			'linktitle_goprev' = 'Gå till föregående sida',
			'footer_shown' = '#1# - #2# av',
			'footer_found' = 'hittade',
			'gotopage' = 'Gå till sida', // SP cüstømizätiøn
			'linktitle_gonext' = 'Gå till nästa sida',
			'linktitle_golast' = 'Gå till sista sidan'
		))
		#language -> size > 0 ?
			#lang -> setlanguage(#language)

		//need to review and address the following functionality TT Feb4, 2011
		// the following params are stored as reference, so the values of the params can be altered after adding a field simply by changing the referenced variable.
		.'database' = #database
		#nav -> isa('knop_nav') ? .'nav' = #nav

		.'nosort' = #nosort
		.'rowsorting' = #rowsorting

		.'numbered' = (#numbered != false ? integer(#numbered) | false)

		#class -> size > 0 ?
			.'class' = #class

		if(#id -> size > 0);
			.'tbl_id' = #id + '_grid';
			.'qs_id' = #id + '_quicksearch';
			.'qsr_id' = #id + '_qs_reset';
		/if;

		local('clientparams' = knop_client_params)

		if(!.'nosort')
			.'sortfield' = (#clientparams >> '-sort' ? string(#clientparams -> find('-sort') -> first -> value) | string);
			.'sortdescending' = (#clientparams >> '-desc')
		/if
		.'page' = (#clientparams >> '-page' ? integer(#clientparams -> find('-page') -> first -> value) | 1)
		.'page' < 1 ? .'page' = 1

		if(#quicksearch != false) => {

			.'quicksearch' = (#quicksearch -> isa(::string) && #quicksearch -> size > 0 ? #quicksearch | 'Quicksearch')

			.'quicksearch_form' = knop_form(-name = 'quicksearch', -id = .'qs_id', -formaction = './', -method = 'get', -template = '#field#\n', -noautoparams)
			.'quicksearch_form_reset' = knop_form(-name = 'quicksearch_reset', -id = .'qsr_id', -formaction = './', -method = 'get', -template = '#field#\n', -noautoparams)
			local('autosavekey' = server_name + response_path)
			if(.'nav'-> type == 'knop_nav' && .'nav' -> 'navmethod'=='param')
				.'quicksearch_form' -> addfield(-type = 'hidden', -name = '-path', -value= .'nav' -> path)
				.'quicksearch_form_reset' -> addfield(-type = 'hidden', -name = '-path', -value = .'nav' -> path)
				#autosavekey -> removetrailing('/')
				#autosavekey += ('/' + .'nav' -> path)
			/if
			if(.'sortfield' != '' && !.'nosort')
				.'quicksearch_form' -> addfield(-type = 'hidden', -name = '-sort', -value = .'sortfield')
				.'quicksearch_form_reset' -> addfield(-type = 'hidden', -name = '-sort', -value = .'sortfield')
				if(.'sortdescending')
					.'quicksearch_form' -> addfield(-type = 'hidden', -name = '-desc')
					.'quicksearch_form_reset' -> addfield(-type = 'hidden', -name = '-desc')
				/if
			/if
			if(client_type >> 'WebKit')
				// only use<input type=search" for WebKit based browsers like Safari
				.'quicksearch_form' -> addfield(-type = 'search', -name = '-q', -hint = .'quicksearch', -size = 15, -id = .'qs_id' + '_q', -raw = ('autosave="' + #autosavekey + '" results="10"'))
			else
				.'quicksearch_form' -> addfield(-type = 'text', -name = '-q', -hint = .'quicksearch', -size = 15, -id = .'qs_id' + '_q')
			/if
			.'quicksearch_form' -> addfield(-type = 'submit', -name = 's', -value = #lang -> getstring('quicksearch_search'))
			if(#clientparams >> '-q')
				.'quicksearch_form' -> setvalue('-q' = #clientparams -> find('-q') -> first -> value)
				.'quicksearch_form_reset' -> addfield(-type = 'submit', -name = 'a', -value = #lang -> getstring('quicksearch_showall'))
			else
				.'quicksearch_form_reset' -> addfield(-type = 'submit', -name = 'a', -value = #lang -> getstring('quicksearch_showall'), -disabled)
			/if

		}

		/* Added by JC 071111 to handle extra form included in the header */

		.'rawheader' = #rawheader

	}

	public oncreate(
		-database::knop_database,
		-nav::any = knop_nav,
		-quicksearch = false,
		-rawheader::string = '',
		-class::string = '',
		-id::string = '',
		-nosort = false,
		-language::string = '',
		-numbered = false,
		-rowsorting::boolean = false
		) => .oncreate(#database, #nav, #quicksearch, #rawheader, #class, #id, #nosort, #language, #numbered, #rowsorting)

	public onassign(value) => {
		local('description' = 'Internal, needed to restore references when ctype is defined as prototype')
		// recreate references here
		.'database' = #value -> 'database'
		.'nav' = #value -> 'nav'
	}

/**!
Returns a reference to the language object
**/
	public lang => .'lang'

/**!
Adds a column to the record listing.

Parameters:
	- name (optional)
	  Name of the field. If not specified, the field will be omitted from the grid.
	  Useful to be able to quicksearch in fields not shown in the grid.
	  In that case -dbfield must be specified.

	- label (optional)
	  Column heading
	
	- dbfield (optional)
	  Corresponding database field name (name is used if dbfield is not specified)

	- width (optional)
	  Pixels (CSS width)

	- url (optional)
	  Columns will be linked with this url as base. Can contain #value# for example to create clickable email links.

	- keyparamname (optional)
	  Param name to use instead of the default -keyvalue for edit links

	- defaultsort (optional flag)
	  This field will be the default sort field

	- nosort (optional flag)
	  The field header should not be clickable for sort

	- template (optional)
	  Either string to format values, compound expression or map containing templates to display individual values in different ways, use -default to display unknown values, use #value# to insert the actual field value in the template.

	  	If a compound expression is specified, the field value is passed as param to the expression and can be accessed as params.
	  	Example expressions::
	  	
	  		{return: params} to return just the field value as is
	  		{return: (date: (field: "moddate")) -> (format: "%-d/%-m")} to return a specific field as formatted date

	- quicksearch (optional flag)
	  If specified, the field will be used for search with quicksearch. If not a boolean the value will be used as the searchfield name

*(Previously called addfield)*
*/
	public insert(
			name::string = '',
			label::string = #name,
			dbfield::string = #name,
			width::integer = -1,
			class = '',
			raw = '', // TODO: not implemented
			url = '',
			keyparamname::string = '-keyvalue',
			defaultsort::any = false,
			nosort::boolean = false,
			template = '',
			quicksearch::any = false
		) => {

		fail_if(#template -> type != 'string'
			&& #template -> type != 'map'
			&& #template -> type != 'capture'
			&& #template -> type != 'tag', -1, 'Template must be either string, map or compound expression')

		local('field' = map)
		#name -> size > 0 ? #field -> insert('name' = #name)
		#class -> size > 0 ? #field -> insert('class' = #class)
		#raw -> size > 0 ? #field -> insert('raw' = #raw)
		#url -> size > 0 ? #field -> insert('url' = #url)
		#field -> insert('keyparamname' = #keyparamname)
		#width > -1 ? #field -> insert('width' = #width)

		#template -> isa('capture') || #template -> isa('tag') || #template -> size > 0 ? #field -> insert('template' = (#template -> type == 'string' ? map('-default' = #template) | #template))

		if(#name -> size > 0)
			#field -> insert('label' = #label)
			#field -> insert('dbfield' = #dbfield )
			#field -> insert('nosort' = #nosort)
			if(#defaultsort != false && .'defaultsort' -> size == 0)
				.'defaultsort' = #name
				if(.'sortfield' -> size == 0)
					.'sortfield' = .'defaultsort'
					if(string(#defaultsort) == 'desc' || string(#defaultsort) == 'descending')
						.'sortdescending' = true
					/if
				/if
			/if
			.'dbfieldmap' -> insert(#name = #dbfield)
		/if
		// changed by Jolle 2011-06-18 to allow different quicksearch field name than
		if(#quicksearch -> isa(::boolean) && #quicksearch) => {
			.'quicksearch_fields' -> insert( #dbfield)
		else(#quicksearch -> isa(::string) && #quicksearch -> size > 0)
			.'quicksearch_fields' -> insert( #quicksearch)
		}

		if(#name -> size > 0 || #label -> size > 0)
			.'fields' -> insert(#field)
		/if

	}

	public insert(
			-name::string = '',
			-label::string = #name,
			-dbfield::string = #name,
			-width::integer = -1,
			-class::string = '',
			-raw = '', // TODO: not implemented
			-url::string = '',
			-keyparamname::string = '-keyvalue',
			-defaultsort::any = false,
			-nosort::boolean = false,
			-template = '',
			-quicksearch::any = false
		) => .insert(#name, #label, #dbfield, #width, #class, #raw, #url, #keyparamname, #defaultsort, #nosort, #template, #quicksearch)

/**!
deprecated use insert instead
**/
	public addfield(
			name::string = '',
			label::string = #name,
			dbfield::string = #name,
			width::integer = -1,
			class = '',
			raw = '', // TODO: not implemented
			url = '',
			keyparamname::string = '-keyvalue',
			defaultsort::any = false,
			nosort::boolean = false,
			template = '',
			quicksearch::any = false
		) => .insert(#name, #label, #dbfield, #width, #class, #raw, #url, #keyparamname, #defaultsort, #nosort, #template, #quicksearch)

	public addfield(
			-name::string = '',
			-label::string = #name,
			-dbfield::string = #name,
			-width::integer = -1,
			-class::string = '',
			-raw = '', // TODO: not implemented
			-url::string = '',
			-keyparamname::string = '-keyvalue',
			-defaultsort::any = false,
			-nosort::boolean = false,
			-template = '',
			-quicksearch::any = false
		) => .insert(#name, #label, #dbfield, #width, #class, #raw, #url, #keyparamname, #defaultsort, #nosort, #template, #quicksearch)

/**!
Returns a Lasso-style pair array with sort parameters to use in the search inline.

Parameters:
	- sql (optional)
	- removedotbackticks (optional flag)
	  Use with -sql for backward compatibility for fields that contain periods.
	  If you use periods in a fieldname then you cannot use a JOIN in Knop.
**/
	public sortparams(sql::boolean = false, removedotbackticks::boolean = false) => {

		if(#sql)
			fail_if(.'database' -> 'isfilemaker', 7009, '-sql can not be used with FileMaker')
			.'sortfield' == '' ? return string;
			local('output' = string);
			if(.'dbfieldmap' >> .'sortfield')
				#output = ' ORDER BY '
				if(#removedotbackticks)
					#output += ('`' + knop_stripbackticks((.'dbfieldmap') -> find(.'sortfield')) + '`')
				else
					#output += ('`' + string_replace(knop_stripbackticks((.'dbfieldmap') -> find(.'sortfield')), -find = '.', -replace = '`.`') + '`')
				/if

				.'sortdescending' ? #output += ' DESC'

			/if
		else
			local('output' = array)
			.'sortfield' == '' ? return #output
			if(.'dbfieldmap' >> .'sortfield')
				#output -> insert(-sortfield = .'dbfieldmap' -> find(.'sortfield') )
				.'sortdescending' ? #output -> insert(-sortorder = 'descending')

			/if
		/if

		return #output
	}

	public sortparams(-sql::boolean = false, -removedotbackticks::boolean = false) => .sortparams(#sql, #removedotbackticks)

/**!
Returns a pair array with fieldname = value to use in a search inline. If you
specify several fields in the grid as -quicksearch (visible or not), they will
be treated as if they were one single concatenated field. Quicksearch will take
each word entered in the search field and search for them in the combined set of
quicksearch fields, performing a "word begins with" match (unless you specify
-contains when calling -> quicksearch).

So if you enter dev joh it will find records with 
firstname = Johan, occupation = Developer.

If you're familiar with how FileMaker performs text searches, this is the way
quicksearch tries to behave.

Parameters:
	- sql (optional flag)
	  Return an SQL string for the search parameters instead.

	- contains (optional flag)
	  Perform a simple contains search instead of emulating "word begins with" search

	- value (optional flag)
	  Output just the search value of the quicksearch field instead of a pair array or SQL string

	- removedotbackticks (optional flag)
	  Use with -sql for backward compatibility for fields that contain periods. If you use periods in a fieldname then you cannot use a JOIN in Knop.
**/
	public quicksearch(sql::boolean = false, contains::boolean = false, value::boolean = false, removedotbackticks::boolean = false) => {

		local('output' = array)
		local('output_temp' = array)
		local('_sql' = #sql -> ascopy)
		local('wordseparators' = array(',', '.', '-', ' ', '(', '"', '@', '\n', '\r')) // \r and \n must not come after each other as \r\n, but \n\r is fine.
		local('fieldvalue' = string(.'quicksearch_form' != NULL ? .'quicksearch_form' -> getvalue('-q')))
		local('onevalue' = '')
		local('field' = '')

		fail_if(#_sql && .'database' -> 'isfilemaker', 7009, '-sql can not be used with FileMaker')

		if(.'quicksearch_form' -> type != 'knop_form')
			#_sql ? return string | return array

		/if
		#value ? return(string(.'quicksearch_form' -> getvalue('-q')))

		if(#fieldvalue != '')

			if(.'database' -> 'isfilemaker')
				#output -> insert(-logicaloperator = 'or')
				iterate(.'quicksearch_fields')
					#contains ? #output -> insert(-op = 'cn')
					#output -> insert(loop_value = #fieldvalue)
				/iterate
			else
				// search each word separately
				#fieldvalue = #fieldvalue -> split(' ')
				iterate(#fieldvalue, #onevalue)
					#output_temp = array;
					iterate(.'quicksearch_fields', #field)
						if(#_sql)
							if(#contains)
								if(#removedotbackticks);
									#output_temp -> insert('`' + knop_stripbackticks(encode_sql(#field)) + '`'
										+ ' LIKE "%' + knop_encodesql_full(#onevalue ) + '%"');
								else;
									#output_temp -> insert('`' + string_replace(knop_stripbackticks(encode_sql(#field)), -find = '.', -replace = '`.`') + '`'
										+ ' LIKE "%' + knop_encodesql_full(#onevalue ) + '%"');
								/if;

							else;
								if(#removedotbackticks);
									#output_temp -> insert('`' + knop_stripbackticks(encode_sql(#field)) + '`'
									+ ' LIKE "' + knop_encodesql_full(#onevalue ) + '%"');
								else;
									#output_temp -> insert('`' + string_replace(knop_stripbackticks(encode_sql(#field)), -find = '.', -replace = '`.`') + '`'
									+ ' LIKE "' + knop_encodesql_full(#onevalue ) + '%"');
								/if;

								// basic emulation of "word begins with"
								iterate(#wordseparators) => {
									if(#removedotbackticks);
										#output_temp -> insert('`' + knop_stripbackticks(encode_sql(#field)) + '`'
											+ ' LIKE "%' + knop_encodesql_full(loop_value + #onevalue ) + '%"');
									else;
										#output_temp -> insert('`' + string_replace(knop_stripbackticks(encode_sql(#field)), -find = '.', -replace = '`.`') + '`'
											+ ' LIKE "%' + knop_encodesql_full(loop_value + #onevalue ) + '%"');
									/if;

								}
							/if
						else
							if(#contains)
								#output_temp -> insert(-op = 'cn')
								#output_temp -> insert(#field = #onevalue )
							else
								#output_temp -> insert(-op = 'bw')
								#output_temp -> insert(#field = #onevalue )
								if( !.'database' -> 'isfilemaker')
								// this variant is not needed for FileMaker since it already searches with "word begins with" as default							#output_temp -> (insert:  -op = 'cn');
									iterate(#wordseparators) => {
										#output_temp -> insert(-op = 'cn')
										#output_temp -> insert( #field = loop_value + #onevalue )
									}
								/if
							/if
						/if
					/iterate
					if(#_sql)
						if(#output_temp -> size > 1)
							#output_temp = ('(' + #output_temp -> join( ' OR ') + ')')
						else
							#output_temp = #output_temp -> first
						/if
						#output -> insert(#output_temp)
					else
						if(#output_temp -> size > 2)
							#output_temp -> insert(-opbegin = 'or', 1)
							#output_temp -> insert(-opend = 'or')
						/if;
						#output -> merge(#output_temp)
					/if
				/iterate

				if(#_sql)
					if(#output -> size > 0)
						#output = ('(' + #output -> join(' AND ') + ')')
					else
						#output = string
					/if
				else
					if(#output -> size > 0)
						#output -> insert(-opbegin = 'and', 1)
						#output -> insert(-opend = 'and')
					/if
				/if

			/if // isfilemaker
		/if // #fieldvalue != ''

		return #output
	}

	public quicksearch(-sql::boolean = false, -contains::boolean = false, -value::boolean = false, -removedotbackticks::boolean = false) => .quicksearch(#sql, #contains, #value, #removedotbackticks)

/**!
Returns all get params that begin with - as a query string, for internal use in links in the grid.

Parameters:
	- except (optional)
	  Exclude these parameters (string or array)

	- prefix (optional)
	  For example ? or &amp; to include at the beginning of the querystring

	- suffix (optional)
	  For example &amp; to include at the end of the querystring
**/
	public urlargs(except = '', prefix = '', suffix = '') => {

		#except = #except -> ascopy

		local('output' = array)
		local('param' = null)

		// only getparams to not send along -action etc
		local('clientparams' = client_getparams -> asarray)

		#except -> type != 'array' ? #except = array(#except)
		#except -> insert(-session)

		// add getparams that begin with -
		iterate(#clientparams, #param)
			if(#param -> type == 'pair')
				if(#param -> name -> beginswith('-') && #except !>> #param -> name)
					#output -> insert(encode_stricturl(string(#param -> name)) + '=' + encode_stricturl(string(#param -> value)))
				/if
			else // just a string param (no pair)
				if(#param -> beginswith('-') && #except !>> #param)
					#output -> insert(encode_stricturl(string(#param)))
				/if
			/if
		/iterate

		if(.'nav' -> isa('knop_nav'))
			// send params that have been defined as -params in nav
			local('navitem' = .'nav' -> getnav)
			// add post params
			#clientparams -> merge(client_postparams)

			iterate(#navitem -> find('params'), #param)
				if(#clientparams >> #param && #clientparams -> find(#param) -> first -> type == 'pair')
					#output -> insert(encode_stricturl(string(#clientparams -> find(#param) -> first -> name)) + '=' + encode_stricturl(string(#clientparams -> find(#param) -> first -> value)))
				else(#clientparams >> #param)
					#output -> insert(encode_stricturl(string(#clientparams -> find(#param) -> first)))
				/if
			/iterate
		/if
		#output = string(#output -> join('&amp;'))
		// restore / in paths
		#output -> replace('%2F', '/')

		if(#output -> size > 0)
			return(#prefix + #output + #suffix)
		/if
	}

/**!
Outputs the complete record listing. Calls renderheader, renderlisting and renderfooter as well.
If 10 records or more are shown, renderfooter is added also just below the header.

Parameters:
	- inlinename (optional)
	  If not specified, inlinename from the connected database object is used

	- numbered (optional flag or integer)
	  If specified, pagination links will be shown as page numbers instead of
	  regular prev/next links. Defaults to 6 links, specify another number
	  (minimum 6) if more numbers are wanted.
**/
	public renderhtml(inlinename = '', xhtml::boolean = false, numbered::any = false, startwithfooter::boolean = false) => {

		local('output' = string)
		local('db' = .'database')

		if(#numbered)
			local('numberedpaging' = (#numbered !== false ? integer(#numbered) | false))
		else
			local('numberedpaging' = (.'numbered' !== false ? integer(.'numbered') | false))
		/if

		.'footer' = .renderfooter(false, #numberedpaging, #xhtml )

		#output += .renderheader(true, #xhtml, #startwithfooter)

		#db -> shown_count >= 10 && !#startwithfooter ? #output += .'footer'

		#output += (.renderlisting(#inlinename, #xhtml))

		#output += (.'footer' + '</table>\n')

		return #output
	}

	public renderhtml(-inlinename = '', -xhtml::boolean = false, -numbered::any = false, -startwithfooter::boolean = false) => .renderhtml(#inlinename, #xhtml, #numbered, #startwithfooter)

/**!
Outputs just the actual record listing. Is called by renderhtml.

Parameters:
	- inlinename (optional)
	  If not specified, inlinename from the connected database object is used
**/
	public renderlisting(inlinename = '', xhtml::boolean = false) => {

		local('_inlinename' = string)
		local('output' = string)
		local('fields' = .'fields')
		local('field' = string)
		local('keyfield' = null)
		local('affectedrecord_keyvalue' = null)
		local('record_loop_count' = integer)
		local('db' = .'database')
		local('nav' = .'nav')
		local('dbfieldmap' = .'dbfieldmap')
		local('classarray' = array)
		local('fieldname' = string)
		local('value' = string)
		local('keyparamname')
		local('url')
		local('url_cached_temp')
		local('lang' = .'lang')

		if(#inlinename -> size > 0)
			#_inlinename = #inlinename
		else(#db -> type == 'knop_database')
			#_inlinename = #db -> 'inlinename'
			#keyfield = #db -> 'keyfield'
			#affectedrecord_keyvalue = #db -> 'affectedrecord_keyvalue'
		/if
		#output += '\n<tbody>\n'
		if(#nav -> isa('knop_nav'))
			iterate(#fields, #field)
				if(#field -> find('url') != void) => {
					#url = string(#field -> find('url'))
					#keyparamname = #field -> find('keyparamname')
					#field -> insert('url_cached' = #nav -> url(-path = #url,
						-getargs = false,
						-params = array(#keyparamname = '###keyvalue###'),
						-autoparams,
						-except = array('-path')
						)
					)
				else
					#url = string
				}
			/iterate
		/if

		records(-inlinename = #_inlinename) => {
			#record_loop_count = loop_count

			#output += '\n<tr' + (.'rowsorting' ? ' class="rowsortable" ref="' + string(field(#keyfield)) + '"') + '>'
			iterate(#fields, #field)
				#fieldname = #dbfieldmap -> find(#field -> find('name'))
				#keyparamname = #field -> find('keyparamname')
				#value = field(#fieldname)
				if(#field -> find('template') -> type == 'map')
					#value = string(#value)
					if(#field -> find('template') >> #value)
						#value = #field -> find('template') -> find(#value)
					else(#field -> find('template') >> '-default')
						#value = #field -> find('template') -> find('-default')
					else
						// show fieldvalue as is
					/if
					// substitute field value in the display template
					#value -> replace('#value#', string(field(#fieldname)))
				else(#field -> find('template') -> isa('tag'))
					#value = #field -> find('template') -> run(-params = #value)
				else(#field -> find('template') -> isa('capture'))
					#value = #field -> find('template') -> detach( )->invoke( )
//					#value = #field -> find('template') -> run(#value)
				/if
				#classarray = array
				if(#affectedrecord_keyvalue == field(#keyfield) && field(#keyfield) != '')
					// hightlight affected row
					#classarray -> insert('highlight')
				else
					(#record_loop_count - 1)  % 2 == 0 ? #classarray -> insert('even')
				/if
				// Added by JC 081127 to handle td specific classes
				#field -> find('class') -> size ? #classarray -> insert( #field -> find('class'))
				#output += '<td'
				if(#classarray -> size)
					#output += (' class="' + #classarray -> join(' ') + '"')
				/if
				if(#field -> find('raw') -> size) => {
					#output += (' ' + #field -> find('raw'))
				}
				#output += '>'
				if(#field -> find('url') != void)
					#url = string(#field -> find('url'))
stdoutnl('grid field url ' + #field -> find('url_cached'))
					if(#field -> find('url_cached') -> size > 0 && #url !>> '#value#')
						#url_cached_temp = #field -> find('url_cached') -> ascopy
						#url_cached_temp -> replace('###keyvalue###', string(field(#keyfield)))
						#output += ('<a href="' + #url_cached_temp)
						#output += ('">' +  #value
							// show something to click on even if the field is empty
							+ (string_findregexp(#value, -find = '\\w*') -> size == 0 ? #lang -> getstring('linktext_edit'))
							+ '</a>')
					else
						#url -> replace('#value#', string(field(#fieldname)))
						#output += ('<a href="' + #url + '"')
						#url -> beginswith('http://') || #url -> beginswith('https://') || #url -> beginswith('mailto:') ? #output += ' class="ext"'
						#output += ('>' +  #value + '</a>')
					/if
				else
					#output += #value
				/if
				#output += '</td>\n'
			/iterate
			#output += '</tr>\n'

		}

		#output += '\n</tbody>\n'

		return #output
	}

/**!
Outputs the header of the grid with the column headings.
Automatically included by ->renderhtml.

Parameters:
	- start (optional flag)
	  Also output opening <table> tag
**/
	public renderheader(start::boolean = false, xhtml::boolean = false, startwithfooter::boolean = false) => {

		local('output' = string)
		local('db' = .'database')
		local('nav' = .'nav')
		local('fields' = .'fields')
		local('field' = string)
		local('classarray' = array)
		local('lang' = .'lang')

		#start ? #output += ('<table id="' + .'tbl_id' + '" class="grid' + (.'class' -> size > 0 ? (' ' + .'class')) + '">')
		#output += '<thead>\n<tr>'
		if(.'quicksearch_form' -> type == 'knop_form')
			#output += ('<th colspan="' + #fields -> size + '" class="quicksearch')
			.'quicksearch_form' -> getvalue('-q') != '' ? #output += ' highlight'
			#output += '">'

			if(.'rawheader' -> size > 0 )
				#output += .'rawheader'
			/if

			#output += .'quicksearch_form' -> renderform(-xhtml = #xhtml)
			if(.'quicksearch_form_reset' -> type == 'knop_form')
				#output += .'quicksearch_form_reset' -> renderform(-xhtml = #xhtml)
			/if
			#output += '</th></tr>\n<tr>'
		else(.'rawheader' -> size > 0);
			#output += ('<th colspan="' + (#fields -> size) + '">' + .'rawheader' + '</th></tr>\n<tr>')
		/if

		if(#startwithfooter);
			#output += .'footer'
		/if;

		iterate(#fields, #field)
			#classarray = array
			//(.'quicksearch_form') -> type == 'knop_form' ? #classarray -> (insert: 'notopborder');
			if(!.'nosort')
				(.'sortfield' == #field -> find('name')
					&& !#field -> find('nosort')) ? #classarray -> insert('sort')
			/if
			#output += '<th'
			if(#field -> find('width') > 0)
				#output += (' style="width: ' + integer(#field -> find('width')) + 'px;"')
			/if
			// Added by Jolle 081127 to handle td specific classes
			#field -> find('class') -> size > 0 ? #classarray -> insert( #field -> find('class'))
			#classarray -> size > 0 ? #output += (' class="' + #classarray -> join(' ') + '"')

			#output += '>'
			if(#field -> find('nosort') || .'nosort')
				#output += ('<div>' + #field -> find('label')+ '</div>')
			else
				if(#classarray >> 'sort' && .'sortdescending' && .'defaultsort' == '')
					// create link to change to unsorted
					if(#nav -> isa('knop_nav'))
						#output += ('<a href="' + #nav -> url(-autoparams, -getargs, -except = array('-sort', '-desc', '-page', '-path')) + '"'
							+ ' title="' + #lang -> getstring('linktitle_showunsorted') + '">')
					else
						#output += ('<a href="./'
							+ .urlargs(-except = array('-sort', '-desc', '-page'), -prefix = '?') + '"'
							+ ' title="' + #lang -> getstring('linktitle_showunsorted') + '">')
					/if
				else
					// create link to toggle sort mode
					if(#nav -> isa('knop_nav'))
						#output += ('<a href="' + #nav -> url(-autoparams, -getargs, -except = array('-sort', '-desc', '-page', '-path'), -urlargs = ('-sort=' + #field -> find('name')
								+ (#classarray >> 'sort' && !(.'sortdescending') ? '&amp;-desc'))) + '"'+ ' title="'
								+ (#classarray >> 'sort' ?  (#lang -> getstring('linktitle_changesort') + ' '
									+ (.'sortdescending' ? #lang -> getstring('linktitle_ascending') | #lang -> getstring('linktitle_descending')) ) | (#lang -> getstring('linktitle_sortascby') + ' ' + encode_html(#field -> find('label'))) ) + '">')
					else
						#output += ('<a href="./?-sort=' + #field -> find('name')
							+ (#classarray >> 'sort' && !(.'sortdescending') ? '&amp;-desc')
							+ .urlargs(-except = array('-sort', '-desc', '-page'), -prefix = '&amp;') + '"'
							+ ' title="' + (#classarray >> 'sort' ?  (#lang -> getstring('linktitle_changesort') + ' '
									+ (.'sortdescending' ? #lang -> getstring('linktitle_ascending') | #lang -> getstring('linktitle_descending'))) | (#lang -> getstring('linktitle_sortascby') + ' ' + encode_html(#field -> find('label'))) ) + '">')
					/if
				/if
				#output += #field -> find('label')
				if(string_findregexp(#field -> find('label'), -find = '\\S') -> size == 0)
					#output += '&nbsp;' // to show sort link as block element properly even for empty label
				/if
				if(#classarray >> 'sort')
					#output += (' <span class="sortmarker"> ' + (.'sortdescending' ? '&#9660;' | '&#9650;') + '</span>')
				/if
				#output += '</a>'
			 /if
			 #output += '</th>\n'
		/iterate
		#output += '</tr>\n</thead>\n'

		return #output
	}

	public renderheader(-start::boolean = false, -xhtml::boolean = false, -startwithfooter::boolean = false) => .renderheader(#start, #xhtml, #startwithfooter)

/**!
Outputs the footer of the grid with the prev/next links and information about
found count. Automatically included by ->renderhtml

Parameters:
	- end (optional flag)
	  Also output closing </table> tag\n\

	- numbered (optional flag or integer)
	  If specified, pagination links will be shown as page numbers instead of
	  regular prev/next links. Defaults to 6 links, specify another number
	  (minimum 6) if more numbers are wanted.
**/
	public renderfooter(end::boolean = false, numbered::any = false, xhtml::boolean = false) => {

		local('output' = string)
		local('db' = .'database')
		local('nav' = .'nav')
		local('fields' = .'fields')
		local('field' = string)
			//'numberedpaging' = (((local_defined: 'numbered') && #numbered !== false) ? integer(#numbered) | false),
		local('lang' = .'lang')
		local('page' = .page)
		local('lastpage' = .lastpage)
		local('url_cached')
		local('url_cached_temp')
		if(#numbered)
			local('numberedpaging' = (#numbered !== false ? integer(#numbered) | false))
		else
			local('numberedpaging' = (.'numbered' !== false ? integer(.'numbered') | false))
		/if

		if(#nav -> isa('knop_nav'))
			#url_cached = #nav -> url(-autoparams, -getargs, -except = array('-page', '-path'),
					-urlargs = '-page=###page###')
		/if
		if(#numberedpaging !== false && #numberedpaging < 6)
			// show 10 page numbers as default
			#numberedpaging = 6
		/if
		if(#numberedpaging)
			// make sure we have an even number
			#numberedpaging += (#numberedpaging % 2)
		/if

		#output += ('<tbody>\n<tr><th colspan="' + #fields -> size + '" class="footer first'  + '">')
		/* not used
		if: #nav -> isa('knop_nav');
			local: 'url' = #nav -> url(-autoparams, -getargs, -except = (array: -page, '-path'), -urlargs = '-page='),
				'url_prefix' = (#nav -> 'navmethod' == 'param' ? '&amp;' | '?');
		else;
			local: 'url' = './' + (.(urlargs: -except = (array: -page, '-path'), -suffix = '&amp;')),
				'url_prefix' = '?';
		/if;
		*/

		if(#numberedpaging)
			local('page_from' = 1)
			local('page_to' = #lastpage)
			if(#lastpage > #numberedpaging)
				#page_from = (#page - (#numberedpaging/2 - 1))
				#page_to = (#page + (#numberedpaging/2))
				if(#page_from < 1)
					#page_to += (1 - #page_from)
					#page_from = 1
				/if
				if(#page_to > #lastpage)
					#page_from = (#lastpage - (#numberedpaging - 1))
					#page_to = #lastpage
				/if
			/if

			#output += ('<span class="foundcount">' + #db -> found_count + ' ' + (#lang -> getstring('footer_found')) + '</span> <span class="pagination">')

			if(#page > 1)
				if(#url_cached -> size > 0)
					#url_cached_temp = #url_cached -> ascopy
// old					#url_cached_temp -> replace('-page = ###page###', '-page = ' + (#page - 1))
					#url_cached_temp -> replace('-page=###page###', '-page=' + 1);

					/*#output += ' <a href="' + #nav -> url(-autoparams, -getargs, -except = (array: -page, '-path'),
						-urlargs = '-page = ' + (#page - 1)) + '" class="prevnext prev"'
						+ ' title="' + (#lang -> getstring('linktitle_goprev')) + '">' + (#lang -> getstring('linktext_prev')) + '</a> ';*/
					#output += (' <a href="' + #url_cached_temp + '" class="prevnext first"'
						+ ' title="' + (#lang -> getstring('linktitle_gofirst')) + '">' + (#lang -> getstring('linktext_first')) + '</a> ')

					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + (#page - 1));
					#output += (' <a href="' + #url_cached_temp + '" class="prevnext prev"'
						+ ' title="' + #lang -> getstring('linktitle_goprev') + '">' + #lang -> getstring('linktext_prev') + '</a> ')
				else
					#output += (' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=1" class="prevnext first"'
						+ ' title="' + (#lang -> getstring('linktitle_gofirst')) + '">' + (#lang -> getstring('linktext_first')) + '</a> ')
					#output += (' <a href="./?' + (.urlargs( -except = array('-page', '-path'), -suffix = '&amp;')) + '-page=' + (#page - 1) + '" class="prevnext prev"' + ' title="' + #lang -> getstring('linktitle_goprev') + '">' + #lang -> getstring('linktext_prev') + '</a> ')
				/if
			else
				//#output += ' <span class="prevnext prev dim">' + (#lang -> getstring('linktext_prev')) + '</span> ';
			/if
			if(#page_from > 1)
				if(#url_cached -> size > 0)
					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + 1)
					/*#output += ' <a href="' + #nav -> url(-autoparams, -getargs, -except = (array: -page, '-path'),
						-urlargs = '-page=1') + '" class="prevnext numbered first">1</a>';*/
					#output += (' <a href="' + #url_cached_temp + '" class="prevnext numbered first">1</a>')
				else
					#output += (' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=1" class="prevnext numbered first">1</a> ')
				/if
				#page_from > 2 ? #output +='...'

			/if
			loop(-from = #page_from, -to = #page_to)
				if(loop_count == #page)
					#output += (' <span class="numbered current">' + loop_count + '</span> ')
				else
					if(#url_cached -> size > 0)
						#url_cached_temp = #url_cached -> ascopy
						#url_cached_temp -> replace('-page=###page###', '-page=' + loop_count)
						/*#output += ' <a href="' + #nav -> url(-autoparams, -getargs, -except=(array: -page, '-path'),
							-urlargs='-page=' + loop_count) + '" class="prevnext numbered">' + loop_count + '</a> ';*/
						#output += (' <a href="' + #url_cached_temp + '" class="prevnext numbered">' + loop_count + '</a> ')
					else
						#output += (' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=' + loop_count + '" class="prevnext numbered">' + loop_count + '</a> ')
					/if
				/if
			/loop
			if(#page_to < #lastpage)
				#page_to < (#lastpage - 1) ? #output += '...';

				if(#url_cached -> size > 0)
					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + #lastpage)
					/*#output += ' <a href="' + #nav -> url(-autoparams, -getargs, -except = (array: -page, '-path'),
						-urlargs = '-page=' + #lastpage) + '" class="prevnext numbered last">' + #lastpage + '</a> ';*/
					#output += (' <a href="' + #url_cached_temp + '" class="prevnext numbered last">' + #lastpage + '</a> ')
				else
					#output += (' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=' + #lastpage + '" class="prevnext numbered last">' + #lastpage + '</a> ')
				/if
			/if

			if( #page < #lastpage)
				if(#url_cached -> size > 0)
					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + (#page + 1))
					/*#output += ' <a href="' + #nav -> url(-autoparams, -getargs, -except=(array: -page, '-path'),
						-urlargs='-page=' + (#page + 1)) + '" class="prevnext next"'
						+ ' title="' + (#lang -> getstring('linktitle_gonext')) + '">' + (#lang -> getstring('linktext_next')) + '</a> ';*/
					#output += (' <a href="' + #url_cached_temp + '" class="prevnext next"'
						+ ' title="' + #lang -> getstring('linktitle_gonext') + '">' + #lang -> getstring('linktext_next') + '</a> ')

					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + #lastpage);
					#output += (' <a href="' + #url_cached_temp + '" class="prevnext last"'
						+ ' title="' + (#lang -> getstring('linktitle_golast')) + '">' + (#lang -> getstring('linktext_last')) + '</a> ')
				else
					#output += (' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=' + (#page + 1) + '" class="prevnext next"'
						+ ' title="' + #lang -> getstring('linktitle_gonext') + '">' + #lang -> getstring('linktext_next') + '</a> ')
					#output += (' <a href="./?' + (.urlargs( -except = array( '-page', '-path'), -suffix = '&amp;'))
						+ '-page=' + #lastpage + '" class="prevnext last"'
						+ ' title="' + (#lang -> getstring('linktitle_golast')) + '">' + (#lang -> getstring('linktext_last')) + '</a> ')

				/if
			else
				//#output += ' <span class="prevnext next dim">' + (#lang -> getstring('linktext_next')) + '</span> ';
			/if

			#output += '</span> '

		else  // regular prev/next links

			if(#page > 1)
				if(#url_cached -> size > 0)
					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + 1)
					/*#output += ' <a href="' + #nav -> url(-autoparams, -getargs, -except=(array: -page, '-path'),
						-urlargs='-page=1') + '" class="prevnext first"'
						+ ' title="' + (#lang -> getstring('linktitle_gofirst')) + '">' + (#lang -> getstring('linktext_first')) + '</a> ';*/
					#output += (' <a href="' + #url_cached_temp + '" class="prevnext first"'
						+ ' title="' + #lang -> getstring('linktitle_gofirst') + '">' + #lang -> getstring('linktext_first') + '</a> ')

					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + (#page - 1))
					#output += (' <a href="' + #url_cached_temp + '" class="prevnext prev"'
						+ ' title="' + #lang -> getstring('linktitle_goprev') + '">' + #lang -> getstring('linktext_prev') + '</a> ')
				else
					#output += (' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=1" class="prevnext first"'
						+ ' title="' + #lang -> getstring('linktitle_gofirst') + '">' + #lang -> getstring('linktext_first') + '</a> ')

					#output += (' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=' + (#page - 1) + '" class="prevnext prev"'
						+ ' title="' + #lang -> getstring('linktitle_goprev') + '">' + #lang -> getstring('linktext_prev') + '</a> ')
				/if
			else
				#output += (' <span class="prevnext first dim">' + #lang -> getstring('linktext_first') + '</span> \
							<span class="prevnext prev dim">' + #lang -> getstring('linktext_prev') + '</span> ')
			/if
			#db -> found_count > #db -> shown_count ?
				#output += (#lang -> getstring('footer_shown', -replace = array(string(#db -> shown_first), string(#db -> shown_last))) + ' ')
			#output += (#db -> found_count + ' ' + #lang -> getstring('footer_found'))
			if(#db -> shown_last < #db -> found_count)
				if(#url_cached -> size > 0)
					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + (#page + 1))
					/*#output += ' <a href="' + #nav -> url(-autoparams, -getargs, -except=(array: -page, '-path'),
						-urlargs='-page=' + (#page + 1)) + '" class="prevnext next"'
						+ ' title="' + (#lang -> getstring('linktitle_gonext')) + '">' + (#lang -> getstring('linktext_next')) + '</a> ';*/
					#output += (' <a href="' + #url_cached_temp + '" class="prevnext next"'
						+ ' title="' + #lang -> getstring('linktitle_gonext') + '">' + #lang -> getstring('linktext_next') + '</a> ')

					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + #lastpage)
					#output += (' <a href="' + #url_cached_temp + '" class="prevnext last"'
						+ ' title="' + #lang -> getstring('linktitle_golast') + '">' + #lang -> getstring('linktext_last') + '</a> ')
				else
					#output += (' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=' + (#page + 1) + '" class="prevnext next"'
						+ ' title="' + #lang -> getstring('linktitle_gonext') + '">' + #lang -> getstring('linktext_next') + '</a> ')
					#output += (' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=' + .lastpage + '" class="prevnext last"'
						+ ' title="' + #lang -> getstring('linktitle_golast') + '">' + #lang -> getstring('linktext_last') + '</a> ')
				/if
			else
				#output += (' <span class="prevnext next dim">' + #lang -> getstring('linktext_next') + '</span>  \
							<span class="prevnext last dim">' + #lang -> getstring('linktext_last') + '</span> ')
			/if
		/if
		#output += ('</th></tr>\n</tbody>')
		#end ? #output += '</table>\n'

		return #output
	}

	public renderfooter(-end::boolean = false, -numbered::any = false, -xhtml::boolean = false) => .renderfooter(#end, #numbered, #xhtml)

	public page() => {
		local('description' = 'Returns the current page number')
		return .'page'
	}

	public lastpage() => {
		local('description'='Returns the number of the last page for the found records')
		if(.'database' -> 'found_count' > 0)
			return (((.'database' -> 'found_count' - 1) / .'database' -> 'maxrecords_value') + 1)
		else
			return 1
		/if
	}

/**!
Converts current page value to a skiprecords value to use in a search.

Parameters:
	- maxrecords (required integer)
	  Needed to be able to do the calculation. Maxrecords_value can not be taken
	  from the database object since that value is not available until after
	  performing the search
**/
	public page_skiprecords(maxrecords::integer) => {
		// TODO: maxrecords_value can be taken from the database object so should not be required
		return ((.'page' - 1) * #maxrecords)
	}

	public addurlarg(field::string, value = '') => {
		.'urlparams' -> insert(#value -> size > 0 ? (#field + '=' + #value) | #field)
	}

}

?>