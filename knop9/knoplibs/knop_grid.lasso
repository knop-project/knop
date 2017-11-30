<?LassoScript


/**!
knop_grid
Custom type to handle data grids (record listings).
**/
define knop_grid => type {
	parent knop_base

/*

CHANGE NOTES

	2013-09-5	JC	Fixed bug where with param in #navitem -> find('params') do would create an error if #navitem -> find('params') returned void
	2013-06-07	JC	Restoring usage of quicksearch_form_reset'<br>'
	2013-06-03	JC	Changed quicksearch handling removing need for quicksearch_form_reset
	2013-05-09	JC	Changed handling of tbody and tfoot
	2013-05-09	JC	Removed all xhtml handling. Will from now on assume this is for HTML 5. Should give some miniscule speed gain.
	2012-10-30	JC	Fixed bug preventing quicksearch hint and input field to work properly
	2012-10-21	JC	Changed old style if to Lasso 9 proper. Removed quotes from local declarations. Replaced .'xxx' with .xxx. Replaced iterate with query expression. Replaced += with append.
	2012-10-21	JC	Added support for bootstrap quicksearch form
	2012-10-21	JC	Changed -> type == 'xxx' to -> isa(::xxx)
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

	data public quicksearch_string::string = 'Quicksearch'
	data public quicksearch_form
	data public quicksearch_form_reset
	data public rawheader::string = string
	data public class::string = string

	data public tbl_id::string = 'grid'
	data public qs_id::string = 'quicksearch'
	data public qsr_id::string = 'qs_reset'

	data public quicksearch_fields::array = array
	data public footer::string = string

	data public lang = knop_lang('en', true)		// language strings object
	data public error_lang = knop_lang('en', true)
	data public numbered = false
	data public nosort
	data public rowsorting

/**!
oncreate
Parameters:\n\
			-database (required database) Database object that the grid object will interact with\n\
			-nav (optional nav) Navigation object to interact with\n\
			-quicksearch (optional) Label text for the quick search field\n\
			-rawheader (optional) Extra html to be inserted in the grid header\n\
			-class (optional) Extra classes to be inserted in the grid header. The standard class "grid" is always inserted\n\
			-id (optional) Creates a custom id used for table, quicksearch and quicksearch_reset\n\
			-nosort (optional flag) Global setting for the entire grid (overrides column specific sort options)\n\
			-language (optional) Language to use for the grid, defaults to the browser\'s preferred language\n\
			-numbered (optional flag or integer) If specified, pagination links will be shown as page numbers instead of regular prev/next links. Defaults to 6 links, specify another number (minimum 6) if more numbers are wanted. Can be specified in ->renderhtml as well.
**/
	public oncreate(
		database::knop_database,
		nav::any = string,
		quicksearch = false,
		rawheader::string = string,
		class::string = string,
		id::string = string,
		nosort = false,
		language::string = 'en',
		numbered::any = false,
		rowsorting::boolean = false,
		quicksearch_btnclass = string
		) => {

		local(lang = .'lang')

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
		.database = #database
		#nav -> isa(::knop_nav) ? .nav = #nav


		.nosort = #nosort
		.rowsorting = #rowsorting

		.numbered = (#numbered != false ? integer(#numbered) | false)

		#class -> size > 0 ?
			.class = #class

		if(#id -> size > 0) => {
			.tbl_id = #id + '_grid'
			.qs_id = #id + '_quicksearch'
			.qsr_id = #id + '_qs_reset'
		}

		local(clientparams = knop_client_params)


		if(!.nosort) => {
			.sortfield = (#clientparams >> '-sort' ? string(#clientparams -> find('-sort') -> first -> value) | string)
			.sortdescending = (#clientparams >> '-desc')
		}
		.page = (#clientparams >> '-page' ? integer(#clientparams -> find('-page') -> first -> value) | 1)
		.page < 1 ? .page = 1

		if(#quicksearch) => {

			#quicksearch -> isa(::string) && #quicksearch -> size > 0 ? .quicksearch_string = #quicksearch
			.quicksearch_form = knop_form(-name = 'quicksearch', -id = .qs_id, -formaction = './', -method = 'get', -template = '#field#\n', -class= 'form-search', -noautoparams)
			.quicksearch_form_reset = knop_form(-name = 'quicksearch_reset', -id = .qsr_id, -formaction = './', -method = 'get', -template = '#field#\n', -class= 'form-search', -noautoparams)
			local(autosavekey = server_name + response_path)
			if(.nav-> isa(::knop_nav) && .nav -> 'navmethod'=='param') => {
				.quicksearch_form -> addfield(-type = 'hidden', -name = '-path', -value= .nav -> path)
				.quicksearch_form_reset -> addfield(-type = 'hidden', -name = '-path', -value = .nav -> path)
				#autosavekey -> removetrailing('/')
				#autosavekey -> append('/' + .nav -> path)
			}

			if(.sortfield != '' && !.nosort) => {
				.quicksearch_form -> addfield(-type = 'hidden', -name = '-sort', -value = .sortfield)
				.quicksearch_form_reset -> addfield(-type = 'hidden', -name = '-sort', -value = .sortfield)
				if(.sortdescending) => {
					.quicksearch_form -> addfield(-type = 'hidden', -name = '-desc')
					.quicksearch_form_reset -> addfield(-type = 'hidden', -name = '-desc')
				}
			}
			if(client_type >> 'WebKit') => {
				// only use<input type=search" for WebKit based browsers like Safari
				.quicksearch_form -> addfield(-type = 'search', -name = '-q', -hint = .quicksearch_string, -size = 16, -id = .qs_id + '_q', -class = 'search-query', -raw = ('autosave="' + #autosavekey + '" results="10"'))
			else
				.quicksearch_form -> addfield(-type = 'text', -name = '-q', -hint = .quicksearch_string, -size = 16, -id = .qs_id + '_q', -class = 'search-query')
			}
			.quicksearch_form -> addfield(-type = 'submit', -name = 's', -class = #quicksearch_btnclass, -value = #lang -> getstring('quicksearch_search'))
			if(#clientparams >> '-q') => {
				.quicksearch_form -> setvalue('-q' = #clientparams -> find('-q') -> first -> value)
				.quicksearch_form_reset -> addfield(-type = 'submit', -name = '-a', -class = #quicksearch_btnclass + ' btn-prepend', -value = #lang -> getstring('quicksearch_showall'))
			else
				.quicksearch_form_reset -> addfield(-type = 'submit', -name = '-a', -class = #quicksearch_btnclass + ' btn-prepend', -value = #lang -> getstring('quicksearch_showall'), -disabled)
			}


		}

		/* Added by JC 071111 to handle extra form included in the header */

		.rawheader = #rawheader


	}

	public oncreate(
		-database::knop_database,
		-nav::any = knop_nav,
		-quicksearch = false,
		-rawheader::string = string,
		-class::string = string,
		-id::string = string,
		-nosort = false,
		-language::string = string,
		-numbered = false,
		-rowsorting::boolean = false,
		-quicksearch_btnclass = string
		) => .oncreate(#database, #nav, #quicksearch, #rawheader, #class, #id, #nosort, #language, #numbered, #rowsorting, #quicksearch_btnclass)

	public onassign(value) => {
		local(description = 'Internal, needed to restore references when ctype is defined as prototype')
		// recreate references here
		.database = #value -> 'database'
		.nav = #value -> 'nav'
	}

/**!
insert
Adds a column to the record listing. \n\
			Parameters:\n\
			-name (optional) Name of the field. If not specified, the field will be omitted from the grid. \
				Useful to be able to quicksearch in fields not shown in the grid. \
				In that case -dbfield must be specified. \n\
			-label (optional) Column heading\n\
			-dbfield (optional) Corresponding database field name (name is used if dbfield is not specified)\n\
			-width (optional) Pixels (CSS width)\n\
			-url (optional) Columns will be linked with this url as base. Can contain #value# for example to create clickable email links. \n\
			-keyparamname (optional) Param name to use instead of the default -keyvalue for edit links\n\
			-defaultsort (optional flag) This field will be the default sort field\n\
			-nosort (optional flag) The field header should not be clickable for sort\n\
			-template (optional) Either string to format values, compound expression or map containing templates to display individual values in different ways, use -default to display unknown values, use #value# to insert the actual field value in the template. \n\t\
				If a compound expression is specified, the field value is passed as param to the expression and can be accessed as params. \n\t\
				Example expressions: \n\t\
				{return: params} to return just the field value as is\n\t\
				{return: (date: (field: "moddate")) -> (format: "%-d/%-m")} to return a specific field as formatted date\n\
			-quicksearch (optional flag) If specified, the field will be used for search with quicksearch. If not a boolean the value will be used as the searchfield name
Previously called addfield
**/
	public insert(
			name::string = string,
			label::string = #name,
			dbfield::string = #name,
			width::integer = -1,
			class = string,
			raw = string, // TODO: not implemented
			url = string,
			keyparamname::string = '-keyvalue',
			defaultsort::any = false,
			nosort::boolean = false,
			template = string,
			quicksearch::any = false
		) => {

		local(template_type = string(#template -> type))


		fail_if(array('string', 'map', 'capture', 'tag') !>> #template_type, -1, 'Template must be either string, map or compound expression')

		local(field = map)
		#name -> size > 0 ? #field -> insert('name' = #name)
		#class -> size > 0 ? #field -> insert('class' = #class)
		#raw -> size > 0 ? #field -> insert('raw' = #raw)
		#url -> size > 0 ? #field -> insert('url' = #url)
		#field -> insert('keyparamname' = #keyparamname)
		#width > -1 ? #field -> insert('width' = #width)

		#template_type == 'capture' || #template_type == 'tag' || #template -> size > 0 ? #field -> insert('template' = (#template_type == 'string' ? map('-default' = #template) | #template))

		if(#name -> size > 0) => {
			#field -> insert('label' = #label)
			#field -> insert('dbfield' = #dbfield )
			#field -> insert('nosort' = #nosort)
			if(#defaultsort != false && .defaultsort -> size == 0) => {
				.defaultsort = #name
				if(.sortfield -> size == 0) => {
					.sortfield = .defaultsort
					if(string(#defaultsort) == 'desc' || string(#defaultsort) == 'descending') => {
						.sortdescending = true
					}
				}
			}
			.dbfieldmap -> insert(#name = #dbfield)
		}
		// changed by Jolle 2011-06-18 to allow different quicksearch field name than
		if(#quicksearch -> isa(::boolean) && #quicksearch) => {
			.quicksearch_fields -> insert( #dbfield)
		else(#quicksearch -> isa(::string) && #quicksearch -> size > 0)
			.quicksearch_fields -> insert( #quicksearch)
		}

		if(#name -> size > 0 || #label -> size > 0) => {
			.fields -> insert(#field)
		}


	}

	public insert(
			-name::string = string,
			-label::string = #name,
			-dbfield::string = #name,
			-width::integer = -1,
			-class::string = string,
			-raw = string, // TODO: not implemented
			-url::string = string,
			-keyparamname::string = '-keyvalue',
			-defaultsort::any = false,
			-nosort::boolean = false,
			-template = string,
			-quicksearch::any = false
		) => .insert(#name, #label, #dbfield, #width, #class, #raw, #url, #keyparamname, #defaultsort, #nosort, #template, #quicksearch)

/**!
addfield
deprecated use insert instead
**/
	public addfield(
			name::string = string,
			label::string = #name,
			dbfield::string = #name,
			width::integer = -1,
			class = string,
			raw = string, // TODO: not implemented
			url = string,
			keyparamname::string = '-keyvalue',
			defaultsort::any = false,
			nosort::boolean = false,
			template = string,
			quicksearch::any = false
		) => .insert(#name, #label, #dbfield, #width, #class, #raw, #url, #keyparamname, #defaultsort, #nosort, #template, #quicksearch)

	public addfield(
			-name::string = string,
			-label::string = #name,
			-dbfield::string = #name,
			-width::integer = -1,
			-class::string = string,
			-raw = string, // TODO: not implemented
			-url::string = string,
			-keyparamname::string = '-keyvalue',
			-defaultsort::any = false,
			-nosort::boolean = false,
			-template = string,
			-quicksearch::any = false
		) => .insert(#name, #label, #dbfield, #width, #class, #raw, #url, #keyparamname, #defaultsort, #nosort, #template, #quicksearch)

/**!
sortparams
Returns a Lasso-style pair array with sort parameters to use in the search inline.
Parameters:
	-sql (optional)
	-removedotbackticks (optional flag) Use with -sql for backward compatibility for fields that contain periods.  If you use periods in a fieldname then you cannot use a JOIN in Knop.
**/
	public sortparams(sql::boolean = false, removedotbackticks::boolean = false) => {

		if(#sql) => {
			fail_if(.database -> 'isfilemaker', 7009, '-sql can not be used with FileMaker')
			.sortfield == '' ? return string
			local(output = string)
			if(.dbfieldmap >> .sortfield) => {
				#output -> append(' ORDER BY ')
				if(#removedotbackticks) => {
					#output -> append('`' + knop_stripbackticks((.dbfieldmap) -> find(.sortfield)) + '`')
				else
					#output -> append('`' + string_replace(knop_stripbackticks((.dbfieldmap) -> find(.sortfield)), -find = '.', -replace = '`.`') + '`')
				}

				.sortdescending ? #output -> append(' DESC')

			}
		else
			local(output = array)
			.sortfield == '' ? return #output
			if(.dbfieldmap >> .sortfield) => {
				#output -> insert(-sortfield = .dbfieldmap -> find(.sortfield) )
				.sortdescending ? #output -> insert(-sortorder = 'descending')

			}
		}

		return #output
	}

	public sortparams(-sql::boolean = false, -removedotbackticks::boolean = false) => .sortparams(#sql, #removedotbackticks)

/**!
quicksearch
Returns a pair array with fieldname = value to use in a search inline. If you specify several fields in the grid as -quicksearch (visible or not), they will be treated as if they were one single concatenated field. Quicksearch will take each word entered in the search field and search for them in the combined set of quicksearch fields, performing a "word begins with" match (unless you specify -contains when calling -> quicksearch).\n\
			So if you enter dev joh it will find records with firstname = Johan, occupation = Developer.\n\
			If you\'re familiar with how FileMaker performs text searches, this is the way quicksearch tries to behave.\n\
			Parameters:\n\
			-sql (optional flag) Return an SQL string for the search parameters instead.\n\
			-contains (optional flag) Perform a simple contains search instead of emulating "word begins with" search\n\
			-value (optional flag) Output just the search value of the quicksearch field instead of a pair array or SQL string\n\
			-removedotbackticks (optional flag) Use with -sql for backward compatibility for fields that contain periods.  If you use periods in a fieldname then you cannot use a JOIN in Knop.
**/
	public quicksearch(
		sql::boolean = false,
		contains::boolean = false,
		value::boolean = false,
		removedotbackticks::boolean = false
	) => {


		local(output = array)
		local(output_temp = array)
		local(_sql = #sql -> ascopy)
		local(wordseparators = array(',', '.', '-', ' ', '(', '"', '@', '\n', '\r')) // \r and \n must not come after each other as \r\n, but \n\r is fine.
		local(fieldvalue = string(.quicksearch_form != NULL ? .quicksearch_form -> getvalue('-q')))

		fail_if(#_sql && .database -> 'isfilemaker', 7009, '-sql can not be used with FileMaker')

		if(not .quicksearch_form -> isa(::knop_form)) => {
			return #value || #_sql ? string | array

		}

		boolean(web_request -> param('-a')) ? return #value || #_sql ? string | array
		#value ? return string(.quicksearch_form -> getvalue('-q'))

		if(#fieldvalue != '') => {

			if(.database -> 'isfilemaker') => {
				#output -> insert(-logicaloperator = 'or')
				with val in .quicksearch_fields do {
					#contains ? #output -> insert(-op = 'cn')
					#output -> insert(#val = #fieldvalue)
				}
			else
				// search each word separately
				with onevalue in #fieldvalue -> split(' ') do {
					#output_temp = array
					with field in .quicksearch_fields do {
						if(#_sql) => {
							if(#contains) => {
								if(#removedotbackticks) => {
									#output_temp -> insert('`' + knop_stripbackticks(encode_sql(#field)) + '`'
										+ ' LIKE "%' + knop_encodesql_full(#onevalue ) + '%"')
								else
									#output_temp -> insert('`' + string_replace(knop_stripbackticks(encode_sql(#field)), -find = '.', -replace = '`.`') + '`'
										+ ' LIKE "%' + knop_encodesql_full(#onevalue ) + '%"')
								}

							else
								if(#removedotbackticks) => {
									#output_temp -> insert('`' + knop_stripbackticks(encode_sql(#field)) + '`'
									+ ' LIKE "' + knop_encodesql_full(#onevalue ) + '%"')
								else
									#output_temp -> insert('`' + string_replace(knop_stripbackticks(encode_sql(#field)), -find = '.', -replace = '`.`') + '`'
									+ ' LIKE "' + knop_encodesql_full(#onevalue ) + '%"')
								}

								// basic emulation of "word begins with"
								with val in #wordseparators do {
									if(#removedotbackticks) => {
										#output_temp -> insert('`' + knop_stripbackticks(encode_sql(#field)) + '`'
											+ ' LIKE "%' + knop_encodesql_full(#val + #onevalue ) + '%"')
									else
										#output_temp -> insert('`' + string_replace(knop_stripbackticks(encode_sql(#field)), -find = '.', -replace = '`.`') + '`'
											+ ' LIKE "%' + knop_encodesql_full(#val + #onevalue ) + '%"')
									}

								}
							}
						else
							if(#contains) => {
								#output_temp -> insert(-op = 'cn')
								#output_temp -> insert(#field = #onevalue )
							else
								#output_temp -> insert(-op = 'bw')
								#output_temp -> insert(#field = #onevalue )
								if( !.database -> 'isfilemaker') => {
								// this variant is not needed for FileMaker since it already searches with "word begins with" as default							#output_temp -> (insert:  -op = 'cn')
									with val in #wordseparators do {
										#output_temp -> insert(-op = 'cn')
										#output_temp -> insert( #field = #val + #onevalue )
									}
								}
							}
						}
					}
					if(#_sql) => {
						if(#output_temp -> size > 1) => {
							#output_temp = ('(' + #output_temp -> join(' OR ') + ')')
						else
							#output_temp = #output_temp -> first
						}
						#output -> insert(#output_temp)
					else
						if(#output_temp -> size > 2) => {
							#output_temp -> insert(-opbegin = 'or', 1)
							#output_temp -> insert(-opend = 'or')
						}
						#output -> merge(#output_temp)
					}
				}

				if(#_sql) => {
					if(#output -> size > 0) => {
						#output = ('(' + #output -> join(' AND ') + ')')
					else
						#output = string
					}
				else
					if(#output -> size > 0) => {
						#output -> insert(-opbegin = 'and', 1)
						#output -> insert(-opend = 'and')
					}
				}

			} // isfilemaker
		} // #fieldvalue != ''


		return #output
	}

	public quicksearch(-sql::boolean = false, -contains::boolean = false, -value::boolean = false, -removedotbackticks::boolean = false) => .quicksearch(#sql, #contains, #value, #removedotbackticks)

/**!
urlargs
Returns all get params that begin with - as a query string, for internal use in links in the grid.
			Parameters:
			-except (optional) Exclude these parameters (string or array)
			-prefix (optional) For example ? or &amp; to include at the beginning of the querystring
			-suffix (optional) For example &amp; to include at the end of the querystring
**/
	public urlargs(except = string, prefix = string, suffix = string) => {


		#except = #except -> ascopy

		local(output = array)
		local(param = null)

		// only getparams to not send along -action etc
		local(clientparams = client_getparams -> asarray)

		#except -> type != 'array' ? #except = array(#except)
		#except -> insert(-session)

		// add getparams that begin with -
		with param in #clientparams do {
			if(#param -> isa(::pair)) => {
				if(#param -> name -> beginswith('-') && #except !>> #param -> name) => {
					#output -> insert(encode_stricturl(string(#param -> name)) + '=' + encode_stricturl(string(#param -> value)))
				}
			else // just a string param (no pair)
				if(#param -> beginswith('-') && #except !>> #param) => {
					#output -> insert(encode_stricturl(string(#param)))
				}
			}
		}

		if(.nav -> isa(::knop_nav)) => {
			// send params that have been defined as -params in nav
			local(navitem = .nav -> getnav)
			if(#navitem -> find('params')) => {
				// add post params
				#clientparams -> merge(client_postparams)

				with param in #navitem -> find('params') do {
					if(#clientparams >> #param && #clientparams -> find(#param) -> first -> isa(::pair)) => {
						#output -> insert(encode_stricturl(string(#clientparams -> find(#param) -> first -> name)) + '=' + encode_stricturl(string(#clientparams -> find(#param) -> first -> value)))
					else(#clientparams >> #param)
						#output -> insert(encode_stricturl(string(#clientparams -> find(#param) -> first)))
					}
				}
			}
		}
		#output = string(#output -> join('&amp;'))
		// restore / in paths
		#output -> replace('%2F', '/')

		if(#output -> size > 0) => {
			return(#prefix + #output + #suffix)
		}
	}

/**!
renderhtml
Outputs the complete record listing. Calls renderheader, renderlisting and renderfooter as well. \
			If 10 records or more are shown, renderfooter is added also just below the header.\n\
			Parameters:\n\
			-inlinename (optional) If not specified, inlinename from the connected database object is used\n\
			-numbered (optional flag or integer) If specified, pagination links will be shown as page numbers instead of regular prev/next links. Defaults to 6 links, specify another number (minimum 6) if more numbers are wanted.
**/
	public renderhtml(
		inlinename = string,
//		xhtml::boolean = false,
		numbered::any = false,
		startwithfooter::boolean = false,
		bootstrap::boolean = false
	) => {


		local(output = string)
		local(db = .database)

		if(#numbered) => {
			local(numberedpaging = (#numbered !== false ? integer(#numbered) | false))
		else
			local(numberedpaging = (.numbered !== false ? integer(.numbered) | false))
		}

		.footer = .renderfooter(#numberedpaging)

		#output -> append( .renderheader(true, #startwithfooter, #bootstrap) + '\n<tbody>\n')

		#db -> shown_count >= 10 && !#startwithfooter ? #output -> append( .footer)

		#output -> append(.renderlisting(#inlinename))

		#output -> append('\n</tbody>\n<tfoot>\n' + .footer + '\n</tfoot>\n</table>\n')


		return #output
	}

	public renderhtml(
		-inlinename = string,
//		-xhtml::boolean = false,
		-numbered::any = false,
		-startwithfooter::boolean = false,
		-bootstrap::boolean = false
	) => .renderhtml(#inlinename, #numbered, #startwithfooter, #bootstrap)

/**!
renderlisting
Outputs just the actual record listing. Is called by renderhtml. \
			Parameters:\n\
			-inlinename (optional) If not specified, inlinename from the connected database object is used
**/
	public renderlisting(
		inlinename = string
//		xhtml::boolean = false
	) => {


		local(_inlinename = string)
		local(output = string)
		local(fields = .fields)
		local(field = string)
		local(keyfield = null)
		local(affectedrecord_keyvalue = null)
		local(record_loop_count = integer)
		local(db = .database)
		local(nav = .nav)
		local(dbfieldmap = .dbfieldmap)
		local(classarray = array)
		local(fieldname = string)
		local(value = string)
		local(keyparamname)
		local(url)
		local(url_cached_temp)
		local(lang = .lang)

		if(#inlinename -> size > 0) => {
			#_inlinename = #inlinename
		else(#db -> isa(::knop_database))
			#_inlinename = #db -> 'inlinename'
			#keyfield = #db -> 'keyfield'
			#affectedrecord_keyvalue = #db -> 'affectedrecord_keyvalue'
		}
		if(#nav -> isa(::knop_nav)) => {
			with field in #fields do {
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
			}
		}

		records(-inlinename = #_inlinename) => {
			#record_loop_count = loop_count

			#output -> append( '\n<tr' + (.rowsorting ? ' class="rowsortable" ref="' + string(field(#keyfield)) + '"') + '>')
			with field in #fields do {
				#fieldname = #dbfieldmap -> find(#field -> find('name'))
				#keyparamname = #field -> find('keyparamname')
				#value = field(#fieldname)
				match(#field -> find('template') -> type) => {
					case(::capture)
						#value = #field -> find('template') -> detach( )->invoke( )
					case(::map)
						#value = string(#value)
						if(#field -> find('template') >> #value) => {
							#value = #field -> find('template') -> find(#value)
						else(#field -> find('template') >> '-default')
							#value = #field -> find('template') -> find('-default')
						else
							// show fieldvalue as is
						}
						// substitute field value in the display template
						#value -> replace('#value#', string(field(#fieldname)))
					case(::tag)
						#value = #field -> find('template') -> run(-params = #value)
				}
				#classarray = array
				if(#affectedrecord_keyvalue == field(#keyfield) && field(#keyfield) != '') => {
					// highlight affected row
					#classarray -> insert('highlight')
				else
					(#record_loop_count - 1)  % 2 == 0 ? #classarray -> insert('even')
				}
				// Added by JC 081127 to handle td specific classes
				#field -> find('class') -> size ? #classarray -> insert( #field -> find('class'))
				#output -> append( '<td')
				if(#classarray -> size) => {
					#output -> append(' class="' + #classarray -> join(' ') + '"')
				}
				if(#field -> find('raw') -> size) => {
					#output -> append(' ' + #field -> find('raw'))
				}
				#output -> append( '>')
				if(#field -> find('url') != void) => {
					#url = string(#field -> find('url'))

					if(#field -> find('url_cached') -> size > 0 && #url !>> '#value#') => {
						#url_cached_temp = #field -> find('url_cached') -> ascopy
						#url_cached_temp -> replace('###keyvalue###', string(field(#keyfield)))
						#output -> append('<a href="' + #url_cached_temp)
						#output -> append('">' +  #value
							// show something to click on even if the field is empty
							+ (string_findregexp(#value, -find = '\\w*') -> size == 0 ? #lang -> getstring('linktext_edit'))
							+ '</a>')
					else
						#url -> replace('#value#', string(field(#fieldname)))
						#output -> append('<a href="' + #url + '"')
						#url -> beginswith('http://') || #url -> beginswith('https://') || #url -> beginswith('mailto:') ? #output -> append(' class="ext"')
						#output -> append('>' +  #value + '</a>')
					}
				else
					#output -> append( #value)
				}
				#output -> append( '</td>\n')
			}
			#output -> append( '</tr>\n')

		}

		return #output
	}

/**!
renderheader
Outputs the header of the grid with the column headings. \
			Automatically included by ->renderhtml. \n\
			Parameters:\n\
			-start (optional flag) Also output opening <table> tag
**/
	public renderheader(start::boolean = false, startwithfooter::boolean = false, bootstrap::boolean = false) => {


		local(output = string)
		local(db = .database)
		local(nav = .nav)
		local(fields = .fields)
		local(field = string)
		local(classarray = array)
		local(lang = .lang)

		#start ? #output -> append('<table id="' + .tbl_id + '" class="grid' + (.class -> size > 0 ? (' ' + .class)) + '">')
		#output -> append('<thead>\n<tr>')
		if(.quicksearch_form -> isa(::knop_form)) => {
			#output -> append('<th colspan="' + #fields -> size + '" class="quicksearch')
			.quicksearch_form -> getvalue('-q') != '' ? #output -> append( ' highlight')
			#output -> append( '">')

			if(.rawheader -> size > 0 ) => {
				#output -> append( .rawheader)
			}


			#output -> append('<div class="qs_section input-prepend input-append">')

			if(.quicksearch_form_reset -> isa(::knop_form)) => {
				#output -> append( .quicksearch_form_reset -> renderform(-bootstrap = #bootstrap))
			}

			#output -> append( .quicksearch_form -> renderform(-bootstrap = #bootstrap))
			#output -> append( '</div></th></tr>\n')
		else(.rawheader -> size > 0)
			#output -> append('<th colspan="' + (#fields -> size) + '">' + .rawheader + '</th></tr>\n')
		}

		if(#startwithfooter) => {
			#output -> append( .footer)
		}

		#output -> append('\n<tr>')

		with field in #fields do {
			#classarray = array
			//(.quicksearch_form) -> isa(::knop_form) ? #classarray -> (insert: 'notopborder')
			if(!.nosort) => {
				(.sortfield == #field -> find('name')
					&& !#field -> find('nosort')) ? #classarray -> insert('sort')
			}
			#output -> append( '<th')
			if(#field -> find('width') > 0) => {
				#output -> append(' style="width: ' + integer(#field -> find('width')) + 'px;"')
			}
			// Added by Jolle 081127 to handle td specific classes
			#field -> find('class') -> size > 0 ? #classarray -> insert( #field -> find('class'))
			#classarray -> size > 0 ? #output -> append(' class="' + #classarray -> join(' ') + '"')

			#output -> append( '>')
			if(#field -> find('nosort') || .nosort) => {
				#output -> append('<div>' + #field -> find('label')+ '</div>')
			else
				if(#classarray >> 'sort' && .sortdescending && .defaultsort == '') => {
					// create link to change to unsorted
					if(#nav -> isa(::knop_nav)) => {
						#output -> append('<a href="' + #nav -> url(-autoparams, -getargs, -except = array('-sort', '-desc', '-page', '-path')) + '"'
							+ ' title="' + #lang -> getstring('linktitle_showunsorted') + '">')
					else
						#output -> append('<a href="./'
							+ .urlargs(-except = array('-sort', '-desc', '-page'), -prefix = '?') + '"'
							+ ' title="' + #lang -> getstring('linktitle_showunsorted') + '">')
					}
				else
					// create link to toggle sort mode
					if(#nav -> isa(::knop_nav)) => {
						#output -> append('<a href="' + #nav -> url(-autoparams, -getargs, -except = array('-sort', '-desc', '-page', '-path'), -urlargs = ('-sort=' + #field -> find('name')
								+ (#classarray >> 'sort' && !(.sortdescending) ? '&amp;-desc'))) + '"'+ ' title="'
								+ (#classarray >> 'sort' ?  (#lang -> getstring('linktitle_changesort') + ' '
									+ (.sortdescending ? #lang -> getstring('linktitle_ascending') | #lang -> getstring('linktitle_descending')) ) | (#lang -> getstring('linktitle_sortascby') + ' ' + encode_html(#field -> find('label'))) ) + '">')
					else
						#output -> append('<a href="./?-sort=' + #field -> find('name')
							+ (#classarray >> 'sort' && !(.sortdescending) ? '&amp;-desc')
							+ .urlargs(-except = array('-sort', '-desc', '-page'), -prefix = '&amp;') + '"'
							+ ' title="' + (#classarray >> 'sort' ?  (#lang -> getstring('linktitle_changesort') + ' '
									+ (.sortdescending ? #lang -> getstring('linktitle_ascending') | #lang -> getstring('linktitle_descending'))) | (#lang -> getstring('linktitle_sortascby') + ' ' + encode_html(#field -> find('label'))) ) + '">')
					}
				}
				#output -> append( #field -> find('label'))
				if(string_findregexp(#field -> find('label'), -find = '\\S') -> size == 0) => {
					#output -> append( '&nbsp;') // to show sort link as block element properly even for empty label
				}
				if(#classarray >> 'sort') => {
					#output -> append(' <span class="sortmarker"> ' + (.sortdescending ? '&#9660;' | '&#9650;') + '</span>')
				}
				#output -> append( '</a>')
			 }
			 #output -> append( '</th>\n')
		}
		#output -> append( '</tr>\n</thead>\n')


		return #output
	}

	public renderheader(
		-start::boolean = false,
//		-xhtml::boolean = false,
		-startwithfooter::boolean = false,
		-bootstrap::boolean = false
	) => .renderheader(#start, #startwithfooter, #bootstrap)

/**!
renderfooter
Outputs the footer of the grid with the prev/next links and information about found count. \
			Automatically included by ->renderhtml\n\
			Parameters:\n\
			-end (optional flag) Also output closing </table> tag\n\
			-numbered (optional flag or integer) If specified, pagination links will be shown as page numbers instead of regular prev/next links. Defaults to 6 links, specify another number (minimum 6) if more numbers are wanted.
**/
	public renderfooter(numbered::any = false) => {


		local(output = string)
		local(db = .database)
		local(nav = .nav)
		local(fields = .fields)
			//'numberedpaging' = (((local_defined: 'numbered') && #numbered !== false) ? integer(#numbered) | false),
		local(lang = .'lang')
		local(page = .page)
		local(lastpage = .lastpage)
		local(url_cached)
		local(url_cached_temp)
		if(#numbered) => {
			local(numberedpaging = (#numbered !== false ? integer(#numbered) | false))
		else
			local(numberedpaging = (.numbered !== false ? integer(.numbered) | false))
		}

		if(#nav -> isa(::knop_nav)) => {
			#url_cached = #nav -> url(-autoparams, -getargs, -except = array('-page', '-path'),
					-urlargs = '-page=###page###')
		}
		if(#numberedpaging !== false && #numberedpaging < 6) => {
			// show 10 page numbers as default
			#numberedpaging = 6
		}
		if(#numberedpaging) => {
			// make sure we have an even number
			#numberedpaging += (#numberedpaging % 2)
		}

		#output -> append('\n<tr><th colspan="' + #fields -> size + '" class="footer first'  + '">')


		if(#numberedpaging) => {

			local(page_from = 1)
			local(page_to = #lastpage)
			if(#lastpage > #numberedpaging) => {
				#page_from = (#page - (#numberedpaging/2 - 1))
				#page_to = (#page + (#numberedpaging/2))
				if(#page_from < 1) => {
					#page_to += (1 - #page_from)
					#page_from = 1
				}
				if(#page_to > #lastpage) => {
					#page_from = (#lastpage - (#numberedpaging - 1))
					#page_to = #lastpage
				}
			}

			#output -> append('<span class="foundcount">' + #db -> found_count + ' ' + (#lang -> getstring('footer_found')) + '</span> <span class="pagination">')

			if(#page > 1) => {
				if(#url_cached -> size > 0) => {
					#url_cached_temp = #url_cached -> ascopy
// old					#url_cached_temp -> replace('-page = ###page###', '-page = ' + (#page - 1))
					#url_cached_temp -> replace('-page=###page###', '-page=' + 1)

					#output -> append(' <a href="' + #url_cached_temp + '" class="prevnext first"'
						+ ' title="' + (#lang -> getstring('linktitle_gofirst')) + '">' + (#lang -> getstring('linktext_first')) + '</a> ')

					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + (#page - 1))
					#output -> append(' <a href="' + #url_cached_temp + '" class="prevnext prev"'
						+ ' title="' + #lang -> getstring('linktitle_goprev') + '">' + #lang -> getstring('linktext_prev') + '</a> ')
				else
					#output -> append(' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=1" class="prevnext first"'
						+ ' title="' + (#lang -> getstring('linktitle_gofirst')) + '">' + (#lang -> getstring('linktext_first')) + '</a> ')
					#output -> append(' <a href="./?' + (.urlargs( -except = array('-page', '-path'), -suffix = '&amp;')) + '-page=' + (#page - 1) + '" class="prevnext prev"' + ' title="' + #lang -> getstring('linktitle_goprev') + '">' + #lang -> getstring('linktext_prev') + '</a> ')
				}
			}
			if(#page_from > 1) => {
				if(#url_cached -> size > 0) => {
					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + 1)
					#output -> append(' <a href="' + #url_cached_temp + '" class="prevnext numbered first">1</a>')
				else
					#output -> append(' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=1" class="prevnext numbered first">1</a> ')
				}
				#page_from > 2 ? #output -> append('...')

			}
			loop(-from = #page_from, -to = #page_to)
				if(loop_count == #page) => {
					#output -> append(' <span class="numbered current">' + loop_count + '</span> ')
				else
					if(#url_cached -> size > 0) => {
						#url_cached_temp = #url_cached -> ascopy
						#url_cached_temp -> replace('-page=###page###', '-page=' + loop_count)
						#output -> append(' <a href="' + #url_cached_temp + '" class="prevnext numbered">' + loop_count + '</a> ')
					else
						#output -> append(' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=' + loop_count + '" class="prevnext numbered">' + loop_count + '</a> ')
					}
				}
			/loop
			if(#page_to < #lastpage) => {
				#page_to < (#lastpage - 1) ? #output -> append('...')

				if(#url_cached -> size > 0) => {
					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + #lastpage)
					#output -> append(' <a href="' + #url_cached_temp + '" class="prevnext numbered last">' + #lastpage + '</a> ')
				else
					#output -> append(' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=' + #lastpage + '" class="prevnext numbered last">' + #lastpage + '</a> ')
				}
			}

			if( #page < #lastpage) => {
				if(#url_cached -> size > 0) => {
					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + (#page + 1))
					#output -> append(' <a href="' + #url_cached_temp + '" class="prevnext next"'
						+ ' title="' + #lang -> getstring('linktitle_gonext') + '">' + #lang -> getstring('linktext_next') + '</a> ')

					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + #lastpage)
					#output -> append(' <a href="' + #url_cached_temp + '" class="prevnext last"'
						+ ' title="' + (#lang -> getstring('linktitle_golast')) + '">' + (#lang -> getstring('linktext_last')) + '</a> ')
				else
					#output -> append(' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=' + (#page + 1) + '" class="prevnext next"'
						+ ' title="' + #lang -> getstring('linktitle_gonext') + '">' + #lang -> getstring('linktext_next') + '</a> ')
					#output -> append(' <a href="./?' + (.urlargs( -except = array( '-page', '-path'), -suffix = '&amp;'))
						+ '-page=' + #lastpage + '" class="prevnext last"'
						+ ' title="' + (#lang -> getstring('linktitle_golast')) + '">' + (#lang -> getstring('linktext_last')) + '</a> ')

				}
			}

			#output -> append('</span> ')


		else  // regular prev/next links


			if(#page > 1) => {
				if(#url_cached -> size > 0) => {
					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + 1)
					#output -> append(' <a href="' + #url_cached_temp + '" class="prevnext first"'
						+ ' title="' + #lang -> getstring('linktitle_gofirst') + '">' + #lang -> getstring('linktext_first') + '</a> ')

					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + (#page - 1))
					#output -> append(' <a href="' + #url_cached_temp + '" class="prevnext prev"'
						+ ' title="' + #lang -> getstring('linktitle_goprev') + '">' + #lang -> getstring('linktext_prev') + '</a> ')
				else
					#output -> append(' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=1" class="prevnext first"'
						+ ' title="' + #lang -> getstring('linktitle_gofirst') + '">' + #lang -> getstring('linktext_first') + '</a> ')

					#output -> append(' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=' + (#page - 1) + '" class="prevnext prev"'
						+ ' title="' + #lang -> getstring('linktitle_goprev') + '">' + #lang -> getstring('linktext_prev') + '</a> ')
				}
			else
				#output -> append(' <span class="prevnext first dim">' + #lang -> getstring('linktext_first') + '</span> \
							<span class="prevnext prev dim">' + #lang -> getstring('linktext_prev') + '</span> ')
			}
			#db -> found_count > #db -> shown_count ?
				#output -> append(#lang -> getstring('footer_shown', -replace = array(string(#db -> shown_first), string(#db -> shown_last))) + ' ')
			#output -> append(#db -> found_count + ' ' + #lang -> getstring('footer_found'))
			if(#db -> shown_last < #db -> found_count) => {
				if(#url_cached -> size > 0) => {
					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + (#page + 1))
					#output -> append(' <a href="' + #url_cached_temp + '" class="prevnext next"'
						+ ' title="' + #lang -> getstring('linktitle_gonext') + '">' + #lang -> getstring('linktext_next') + '</a> ')

					#url_cached_temp = #url_cached -> ascopy
					#url_cached_temp -> replace('-page=###page###', '-page=' + #lastpage)
					#output -> append(' <a href="' + #url_cached_temp + '" class="prevnext last"'
						+ ' title="' + #lang -> getstring('linktitle_golast') + '">' + #lang -> getstring('linktext_last') + '</a> ')
				else
					#output -> append(' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=' + (#page + 1) + '" class="prevnext next"'
						+ ' title="' + #lang -> getstring('linktitle_gonext') + '">' + #lang -> getstring('linktext_next') + '</a> ')
					#output -> append(' <a href="./?' + .urlargs(-except = array('-page', '-path'), -suffix = '&amp;') + '-page=' + .lastpage + '" class="prevnext last"'
						+ ' title="' + #lang -> getstring('linktitle_golast') + '">' + #lang -> getstring('linktext_last') + '</a> ')
				}
			else
				#output -> append(' <span class="prevnext next dim">' + #lang -> getstring('linktext_next') + '</span>  \
							<span class="prevnext last dim">' + #lang -> getstring('linktext_last') + '</span> ')
			}
		}
		#output -> append('</th></tr>\n')

		return #output
	}

	public renderfooter(-numbered::any = false) => .renderfooter(#numbered)

	public lastpage() => {
		local(description = 'Returns the number of the last page for the found records')
		if(.database -> 'found_count' > 0) => {
			return (((.database -> 'found_count' - 1) / .database -> 'maxrecords_value') + 1)
		else
			return 1
		}
	}

/**!
page_skiprecords
Converts current page value to a skiprecords value to use in a search. \n\
			Parameters:\n\
			-maxrecords (required integer) Needed to be able to do the calculation. Maxrecords_value can not be taken from the database object since taht value is not available until aftetr performing the search
**/
	public page_skiprecords(maxrecords::integer) => {
		// TODO: maxrecords_value can be taken from the database object so should not be required
		return ((.page - 1) * #maxrecords)
	}

	public addurlarg(field::string, value = string) => {
		.urlparams -> insert(#value -> size > 0 ? (#field + '=' + #value) | #field)
	}

}


?>
