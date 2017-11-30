<?LassoScript

define_type: 'grid',
	'knop_base',
	-namespace='knop_';
//	-prototype;

	local: 'version'='2011-01-01',
		'description'='Custom type to handle data grids (record listings).';

/*

CHANGE NOTES
2014-07-10  SP  Allow grid element language strings in the language configuration file to override the instance variables in the knop_grid type.
2011-01-01	SP	Correction of invalid HTML in <thead> and <tr>
2010-12-23	SP	Corrected pagination bug for -numbered.
2010-11-17	JC	Added -startwithfooter flag to grid->renderhtml.  This moves the footer before the column titles in the table header.
2010-11-17	JC	Changed rawheader inclusion to work even if there's no quicksearch for a grid
2010-05-14	JC	Added span separation on grid footer for better styling
2010-03-06	SP	Changed default behavior of ->sortparams and ->quicksearch with -sql to add backticks between the table and column names.  Now JOINs may be used.
2010-03-06	SP	Added ->sortparams and ->quicksearch with -removedotbackticks for backward compatibility for fields that contain periods.  If you use periods in a fieldname then you cannot use a JOIN in Knop.
2010-01-27	JC	Adjusted the id support
2010-01-25	JC	Added support for optional id, used by table, quicksearch and quicksearch_reset
2009-09-18	JS	Syntax adjustments for Lasso 9
2009-08-26	JS	Corrected prev/next links when no nav is defined for the grid object
2009-06-29	JS	->renderlisting: documentation correction (renderlisting never calls renderfooter). 
2009-01-11	JS	->renderlisting: Made sure that template isn't applied on NULL field values since that would cause an error with ->replace 
2008-12-29	JC	Support for optional classes in table header
2008-11-27	JC	-> implemented support for td specific classes. The class is inserted in both the TH and TD tag for the specified field
2008-09-24	JS	->sortparams: fieldnames specified by the -sort parameter are now validated so they exist in the database
2008-09-24	JS	->sortparams, ->quicksearch: Added protection against backtick sql injection in MySQL object names
2008-09-10	JS	-numbered can now be specified at oncreate in addition to  ->renderhtml and ->renderfooter. 
2008-09-08	JS	->sortfield changed so defaultsort is honored even if -nosort is specified (-nosort is only used to prevent the user from changing sort order on the fly)
2008-09-08	JS	->renderlisting and ->renderfooter optimized by caching the result of nav->url. 
2008-05-15	JS	->renderfooter: minor adjustment to numbered pagination links
2008-05-14	JS	->renderfooter (and ->renderhtml): added -numbered as option to get google style numbered pagination links. Render the grid with -numbered (defaults to show 6 page number links plus the far ends) or -numbered=10 or another number. 
2008-05-13	JS	Added ->renderlisting which is now part of ->renderhtml for more flexibility
2008-02-25	JS	->renderheader and ->renderfooter calls nav -> url with -getargs 
2008-01-22	JS	->renderheader, ->renderfooter, ->renderhtml: added -autoparams to nav -> url used in links since url was changed to default to no autoparams. 
2008-01-22	JS	->renderheader, ->renderfooter, ->renderhtml: improved support for param based navigation method  in links, cleaned up linking to use nav -> url instead of self -> urlparams when nav is available
2008-01-22	JC	->quicksearch: Changed wordseparators so that \r and \n aren't placed as \r\n, otherwise they are treated as a single character by ->split. 
2007-12-11	JS	Added documentation as -description to most member tags, to be used by the new ->help tag
2007-12-11	JS	Moved ->help to knop_base
2007-12-03	JS	Added optional -language parameter to set the initial language for the grid object
2007-12-03	JS	Added -> lang to provide a reference to the knop_lang object that is used for localized strings
2007-12-03	JS	Added localized strings for English and Swedish
2007-12-03	JS	Added knop_lang to handle localized strings
2007-11-11	JC	Added optional -rawheader for extra header content to be inserted before the Quicksearch form
2007-10-23	JS	->renderheader: added class="grid" to the opening table tag to be able to isolate the css specifications
2007-10-03	JS	->renderfooter: added unique classes for each type of prev/next link to be able to replace with images using css
2007-10-03	JS	->renderfooter: Changed prev/next link texts to simple |< << >> >| instead of unicode glyphs
2007-09-20	JS	Postparams are only sent along for nav params (not "-" params)
2007-09-07	JS	Also send postparams along in prev/next links (not only getparams)
2007-09-06	JS	If nav has params defined, those params will be sent along with prev/next links
2007-09-06	JS	Added encode_url for link params
2007-09-06	JS	Changed -action to -formaction in the quicksearch form
2007-08-08	JS	->urlargs: Added exception for -session
2007-06-18	JS	Added tag timer to most member tags
2007-06-13	JS	added inheritance from knop_base
2007-06-11	JC	added handling of xhtml output
2007-05-30	JS	->quicksearch: added \r and \n as word separators. 
2007-05-03	JS	->addfield: Added check for empty dbfield name before adding to dbfieldmap
2007-04-19	JS	->quicksearch: added  -value (flag) that makes quicksearch output just the value of the quicksearch field instead of a query
2007-04-13	JS	->oncreate: added -nosort as global flag (overrides column specific sort options)
2007-04-13	JS	->renderfooter: Added tbody to footer to make it pass validation, but it's still not semantically correct. 
2007-04-13	JS	Changed field type for quicksearch for non-WebKit based browsers
2007-04-10	JS	->quicksearch: Added @ as word separator for "word begins with" search
2007-04-10	JS	->quicksearch: Added -contains as option to perform a simple contains search instead of emulating "word begins with" search
2007-04-10	JS	->renderheader: When grid has a defaultsort, there should be no "unsort" option in the sortable headings
2007-04-10	JS	->insert: (-defaultsort='desc') or (-defaultsort='descending') makes the default sort order sort in descending order
2007-04-04	JS	->addfield: -template can now also be a compound expression
2007-04-03	JS	Changed namespace from mt_ to knop_
2007-03-01	JS	Added support for FileMaker with quicksearch (untested)
2007-03-01	JS	Changed all texts to English
2007-02-07	JS	Removed classs="first" and class="notopborder" since CSS border-collapse: collapse; eliminates the need
2007-02-05	JS The -keyvalue parameter for url edit links can be given another name by specifying -keyparamname in addfield
2007-01-31	JS	->addfield: #value# can be used in -url, as a way to provide mailto links etc in lists
2007-01-30	JS	Sortable columns now thave three states instead of two: sorted ascending, sorted descending and unsorted. 
2007-01-30	JS	Improvements to quicksearch, to emulate "word begins with"  searches
2007-01-26	JS	Added support for quicksearch field in grid header. Specify -quicksearch at ->oncreate, and tell what fields to search by specifying -quicksearch for those fields at ->addfield. 
				Fields can be search only (no display) by leaving out name and label. All specified fields are searched word for word of thew search string. 
				Use ->quicksearch to get the search parameters (optionally -sql)
2007-01-26	JS	Added ->urlargs to get a querystring with all "-" GET params, except those in optional -except string or array parameter. 
2007-01-22	JS	Adjustments to highlighting and "(redigera)"-link for records with empty values in the linked field
2007-01-19	JS	Added href titles to sort links and prevnext links
2007-01-19	JS	Corrected sortparams when no sortfield is specified
2007-01-19	JS	Added go to first page, go to last page in footer
2007-01-19	JS	Added member tag page_skiprecords to help correcting out of bounds page numbers
2007-01-19	JS	Added member tag lastpage
2007-01-18	JS	Support for highlighting of affected record after edit or update (class name "highlight")
2007-01-17	JS	Added addfield: -template

TODO
Make it possible for knop_grid to work independently of a knop_database object so other types of listings can be created.
tbody is used in renderfooter, which is not semantically correct. can't use tfoot though since the footer is rendered twice. 
Move templates to a member tag to be make it easier to subclass
Change ->addfield to ->insert and make ->addfield deprecated

*/

	// instance variables
	local: 'fields'=array,
		'dbfieldmap'=map,
		'sortfield'=string,
		'defaultsort'=string,
		'page'=integer,
		'sortdescending'=false,
		'database'=null,
		'nav'=null,
		'debug_trace'=array,
		'quicksearch'=string,
		'quicksearch_form',
		'quicksearch_form_reset',
		'rawheader' = string, // added by Jolle 071111
		'class' = string, // Added by Jolle 081229
		'tbl_id' = 'grid', // Added by Jolle 100125
		'qs_id' = 'quicksearch', // Added by Jolle 100125
		'qsr_id' = 'qs_reset', // Added by Jolle 100125
		'quicksearch_fields'=array,
		'footer' = string, // Added by Jolle 101117
		'lang'=(knop_lang: -default='en', -fallback),		// language strings object 
		'error_lang'=(knop_lang: -default='en', -fallback),
		'numbered'=false,
		'nosort';

	#lang -> (addlanguage: -language='en', -strings=(map: 
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
		'linktext_gotopage' = 'Go to page', // SP customization
		'linktitle_gonext' = 'Go to next page',
		'linktitle_golast' = 'Go to last page',

		// language neutral strings, only need to be set for the default language
		'linktext_first'='|&lt;',
		'linktext_prev'='&lt;&lt;',
		'linktext_next'='&gt;&gt;',
		'linktext_last'='&gt;|'
			));
			
	#lang -> (addlanguage: -language='sv', -strings=(map: 
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
		'linktext_gotopage' = 'Gå till sida', // SP cüstømizätiøn
		'linktitle_gonext' = 'Gå till nästa sida',
		'linktitle_golast' = 'Gå till sista sidan'
	));
	
	define_tag: 'oncreate', -description='Parameters:\n\
			-database (required database) Database object that the grid object will interact with\n\
			-nav (optional nav) Navigation object to interact with\n\
			-quicksearch (optional) Label text for the quick search field\n\
			-rawheader (optional) Extra html to be inserted in the grid header\n\
			-class (optional) Extra classes to be inserted in the grid header. The standard class "grid" is always inserted\n\
			-id (optional) Creates a custom id used for table, quicksearch and quicksearch_reset\n\
			-nosort (optional flag) Global setting for the entire grid (overrides column specific sort options)\n\
			-language (optional) Language to use for the grid, defaults to the browser\'s preferred language\n\
            -langobject (optional) Pass in a knop_lang object into the grid. Define the language strings in the language configuration file cfg__lang.inc, overriding the language strings defined as instance variables in the knop_lang type.\n\
			-numbered (optional flag or integer) If specified, pagination links will be shown as page numbers instead of regular prev/next links. Defaults to 6 links, specify another number (minimum 6) if more numbers are wanted. Can be specified in ->renderhtml as well. ',
		-required='database', -type='database',
		-optional='nav', -type='nav',
		-optional='quicksearch',
		-optional='rawheader',
		-optional='class',
		-optional='id',
		-optional='nosort',
		-optional='language',
		-optional='langobject', -type='lang',
		-optional='numbered';
		local: 'timer'=knop_timer; 
		
        if(local_defined('langobject'));
            local('lang') = #langobject;
            self -> 'lang' = #lang;
        else;
            local('lang') = @(self -> 'lang');
        /if;
		
		if: (local_defined: 'language');
			#lang -> (setlanguage: #language);
		/if;
		
		// the following params are stored as reference, so the values of the params can be altered after adding a field simply by changing the referenced variable. 
		local_defined('database') ? (self -> 'database' = @#database);
		local_defined('nav') ? (self -> 'nav' = @#nav);

		(self -> 'nosort')=local_defined('nosort');

		if(local_defined('numbered'));
			(self -> 'numbered')=((#numbered !== false) ? integer(#numbered) | false);
		/if;
		(local_defined('class') && #class -> type == 'string') ?
			(self -> 'class') = #class;
		
		if(local_defined('id') && #id -> type == 'string');
			(self -> 'tbl_id') = #id + '_grid';
			(self -> 'qs_id') = #id + '_quicksearch';
			(self -> 'qsr_id') = #id + '_qs_reset';
		/if;


		local: 'clientparams'=client_getparams;
		#clientparams -> (merge: client_postparams);
		if: !(self -> 'nosort');
			(self -> 'sortfield') = (#clientparams >> '-sort' ? (#clientparams -> (find: '-sort') -> first -> value) | string);
			(self -> 'sortdescending') = (#clientparams >> '-desc');
		/if;
		(self -> 'page') = (#clientparams >> '-page' ? (integer: (#clientparams -> (find: '-page') -> first -> value)) | 1);
		(self -> 'page') < 1 ? (self -> 'page') = 1;

		if: (local_defined: 'quicksearch');
			if: #quicksearch != '';
				(self -> 'quicksearch') = #quicksearch;
			else;
				(self -> 'quicksearch') = 'Quicksearch';
			/if;
			(self -> 'quicksearch_form') = (knop_form: -name='quicksearch', -id = (self -> 'qs_id'), -formaction='./', -method='get', -template='#field#\n', -noautoparams);
			(self -> 'quicksearch_form_reset') = (knop_form: -name='quicksearch_reset', -id = (self -> 'qsr_id'), -formaction='./', -method='get', -template='#field#\n', -noautoparams);
			local: 'autosavekey'=server_name + response_path;
			if: (self -> 'nav') -> type =='nav' && (self -> 'nav') -> 'navmethod'=='param';
				(self -> 'quicksearch_form') -> (addfield: -type='hidden', -name='-path', -value=((self -> 'nav') -> path));
				(self -> 'quicksearch_form_reset') -> (addfield: -type='hidden', -name='-path', -value=((self -> 'nav') -> path));
				#autosavekey -> (removetrailing: '/');
				#autosavekey += '/' + ((self -> 'nav') -> path);
			/if;
			if: (self -> 'sortfield') != '' && !(self -> 'nosort');
				(self -> 'quicksearch_form') -> (addfield: -type='hidden', -name='-sort', -value=(self -> 'sortfield'));
				(self -> 'quicksearch_form_reset') -> (addfield: -type='hidden', -name='-sort', -value=(self -> 'sortfield'));
				if: (self -> 'sortdescending');
					(self -> 'quicksearch_form') -> (addfield: -type='hidden', -name='-desc');
					(self -> 'quicksearch_form_reset') -> (addfield: -type='hidden', -name='-desc');
				/if;
			/if;
			if: client_type >> 'WebKit';
				// only use<input type=search" for WebKit based browsers like Safari
				(self -> 'quicksearch_form') -> (addfield: -type='search', -name='-q', -hint=(self -> 'quicksearch'), 
					-size=15, -id = (self -> 'qs_id') + '_q', -raw='autosave="' + #autosavekey + '" results="10"');
			else;
				(self -> 'quicksearch_form') -> (addfield: -type='text', -name='-q', -hint=(self -> 'quicksearch'), 
					-size=15, -id = (self -> 'qs_id') + '_q');
			/if;
			(self -> 'quicksearch_form') -> (addfield: -type='submit', -name='s', -value=(#lang -> quicksearch_search));
			if: #clientparams >> '-q';
				(self -> 'quicksearch_form') -> (setvalue: '-q'=(#clientparams -> (find: '-q') -> first -> value));
				(self -> 'quicksearch_form_reset') -> (addfield: -type='submit', -name='a', -value=(#lang -> quicksearch_showall));
			else;
				(self -> 'quicksearch_form_reset') -> (addfield: -type='submit', -name='a', -value=(#lang -> quicksearch_showall), -disabled);
			/if;
		/if;

		/* Added by JC 071111 to handle extra form included in the header */
		if: (local_defined: 'rawheader');
			if: #rawheader -> type == 'string';
				(self -> 'rawheader') = #rawheader;
			else;
				(self -> 'rawheader') = '';
			/if;
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;

	define_tag: 'onassign', -required='value', -description='Internal, needed to restore references when ctype is defined as prototype';
		// recreate references here
		(self->'database') = @(#value -> 'database');
		(self->'nav') = @(#value -> 'nav');
	/define_tag;

	define_tag: 'lang', -description='Returns a reference to the language object';
		return: @(self -> 'lang');
	/define_tag;

	
	define_tag: 'addfield', -description='Adds a column to the record listing. \n\
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
			-quicksearch (optional flag) If specified, the field will be used for search with quicksearch',
		-optional='name',
		-optional='label',
		-optional='dbfield',
		-optional='width',
		-optional='class',
		// -optional='raw',		// TODO: not implemented 
		-optional='url',
		-optional='keyparamname',
		-optional='defaultsort',
		-optional='nosort',
		-optional='template',
		-optional='quicksearch';
		local: 'timer'=knop_timer; 
		
		fail_if: (local_defined: 'template') && #template -> type != 'string' 
			&& #template -> type != 'map'  
			&& #template -> type != 'tag', -1, 'Template must be either string, map or compound expression';
		local: 'field'=map;

		local_defined('name') ? #field -> insert('name' = #name); 
		local_defined('class') ? #field -> insert('class' = #class); 
		local_defined('url') ? #field -> insert('url' = #url); 
		local_defined('keyparamname') ? #field -> insert('keyparamname' = #keyparamname); 
		local_defined('width') ? #field -> insert('width' = #width);
		#field !>> 'keyparamname' ? #field -> (insert: 'keyparamname' = '-keyvalue');
		
		if: (local_defined: 'template');
			#field -> (insert: 'template'=(#template -> type == 'string' ? (map: '-default'=#template) | #template));
		/if;
		if: (local_defined: 'name');
			#field -> (insert: 'label'=( (local_defined: 'label') ? #label | #name ) );
			#field -> (insert: 'dbfield'=( (local_defined: 'dbfield') ? #dbfield | #name ) );
			#field -> (insert: 'nosort'=(local_defined: 'nosort'));
			if(local_defined('defaultsort')
				//&& !(local_defined: 'nosort') 
				&& (self -> 'defaultsort') == ''
				//&& !(self -> 'nosort')
				); 
				(self -> 'defaultsort') = #name;
				if: (self -> 'sortfield') == '';
					(self -> 'sortfield') = (self -> 'defaultsort');
					if: #defaultsort == 'desc' || #defaultsort == 'descending';
						(self -> 'sortdescending') = true;
					/if;
				/if;
			/if;
			(self -> 'dbfieldmap') -> (insert: #name = ((local_defined: 'dbfield') && #dbfield != '' ? #dbfield | #name));
		/if;
		(local_defined: 'quicksearch') ? (self -> 'quicksearch_fields') -> (insert: ((local_defined: 'dbfield') ? #dbfield | (local: 'name')));
		
		if(local_defined('name') || local_defined('label'));
			(self -> 'fields') -> (insert: #field);
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;
	
	define_tag: 'sortparams', -description='Returns a Lasso-style pair array with sort parameters to use in the search inline.\n\
		Parameters:\n\
		-sql (optional)\n\
		-removedotbackticks (optional flag) Use with -sql for backward compatibility for fields that contain periods.  If you use periods in a fieldname then you cannot use a JOIN in Knop.',
		-optional='sql',
		-optional='removedotbackticks';
		local: 'timer'=knop_timer; 
		if: local_defined: 'sql';
			fail_if: (self -> 'database') -> 'isfilemaker', 7009, '-sql can not be used with FileMaker';
			(self -> 'sortfield') == '' ? return;
			local('output'=string);
			if: (self -> 'dbfieldmap') >> (self -> 'sortfield');
				#output=' ORDER BY ';
				if(local_defined('removedotbackticks'));
					#output += '`' + knop_stripbackticks((self -> 'dbfieldmap') -> find(self -> 'sortfield')) + '`';
				else;
					#output += '`' + string_replace(knop_stripbackticks((self -> 'dbfieldmap') -> find(self -> 'sortfield')), -find='.', -replace='`.`') + '`';
				/if;
				if: (self -> 'sortdescending');
					#output += ' DESC';
				/if;
			/if;
		else;
			local: 'output'=array;
			(self -> 'sortfield') == '' ? return: @#output;
			if: (self -> 'dbfieldmap') >> (self -> 'sortfield');
				#output -> (insert: -sortfield=(self -> 'dbfieldmap') -> (find: (self -> 'sortfield')) );
				if: (self -> 'sortdescending');
					#output -> (insert: -sortorder='descending');
				/if;
			/if;
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: @#output;
	/define_tag;

	define_tag: 'quicksearch', -description='Returns a pair array with fieldname=value to use in a search inline. If you specify several fields in the grid as -quicksearch (visible or not), they will be treated as if they were one single concatenated field. Quicksearch will take each word entered in the search field and search for them in the combined set of quicksearch fields, performing a "word begins with" match (unless you specify -contains when calling -> quicksearch).\n\
			So if you enter dev joh it will find records with firstname=Johan, occupation=Developer.\n\
			If you\'re familiar with how FileMaker performs text searches, this is the way quicksearch tries to behave.\n\
			Parameters:\n\
			-sql (optional flag) Return an SQL string for the search parameters instead.\n\
			-contains (optional flag) Perform a simple contains search instead of emulating "word begins with" search\n\
			-value (optional flag) Output just the search value of the quicksearch field instead of a pair array or SQL string\n\
			-removedotbackticks (optional flag) Use with -sql for backward compatibility for fields that contain periods.  If you use periods in a fieldname then you cannot use a JOIN in Knop.',
		-optional='sql',
		-optional='contains',
		-optional='value',
		-optional='removedotbackticks';
		local: 'timer'=knop_timer; 
		
		local: 'output'=array,
			'output_temp'=array,
			'_sql'=(local_defined: 'sql'), 
			'wordseparators'=',.- ("@\n\r', // \r and \n must not come after each other as \r\n, but \n\r is fine. 
			'fieldvalue', 'onevalue', 'field', 'wordseparator';
		fail_if: #_sql && (self -> 'database') -> 'isfilemaker', 7009, '-sql can not be used with FileMaker';

		#wordseparators = #wordseparators -> (split: '');
		if: (self -> 'quicksearch_form') -> type != 'form';
			if: #_sql; 
				return: string;
			else;
				return: array;
			/if;
		/if;
		if: local_defined: 'value';
			return: string: ((self -> 'quicksearch_form') -> (getvalue: '-q'));
		/if;
		
		#fieldvalue = string: ((self -> 'quicksearch_form') -> (getvalue: '-q'));
		if: #fieldvalue != '';
			if: (self -> 'database') -> 'isfilemaker';
				#output -> (insert: -logicaloperator='or');
				iterate: (self -> 'quicksearch_fields'), #field;
					if: (local_defined: 'contains');
						#output -> (insert:  -op = 'cn');
					/if;
					#output -> (insert:  #field = #fieldvalue);
				/iterate;
			else;
				// search each word separately
				#fieldvalue = #fieldvalue -> (split: ' ');
				iterate: #fieldvalue, #onevalue;
					#output_temp = array;
					iterate: (self -> 'quicksearch_fields'), #field;
						if: #_sql;
							if: (local_defined: 'contains');
								if(local_defined('removedotbackticks'));
									#output_temp -> insert('`' + knop_stripbackticks(encode_sql(#field)) + '`' 
										+ ' LIKE "%' + encode_sql(#onevalue ) + '%"');
								else;
									#output_temp -> insert('`' + string_replace(knop_stripbackticks(encode_sql(#field)), -find='.', -replace='`.`') + '`' 
										+ ' LIKE "%' + encode_sql(#onevalue ) + '%"');
								/if;
							else;
								if(local_defined('removedotbackticks'));
									#output_temp -> insert('`' + knop_stripbackticks(encode_sql(#field)) + '`' 
									+ ' LIKE "' + encode_sql(#onevalue ) + '%"');
								else;
									#output_temp -> insert('`' + string_replace(knop_stripbackticks(encode_sql(#field)), -find='.', -replace='`.`') + '`' 
									+ ' LIKE "' + encode_sql(#onevalue ) + '%"');
								/if;
								// basic emulation of "word begins with"
								iterate: #wordseparators, #wordseparator;
									if(local_defined('removedotbackticks'));
										#output_temp -> insert('`' + knop_stripbackticks(encode_sql(#field)) + '`' 
											+ ' LIKE "%' + encode_sql(#wordseparator + #onevalue ) + '%"');
									else;
										#output_temp -> insert('`' + string_replace(knop_stripbackticks(encode_sql(#field)), -find='.', -replace='`.`') + '`' 
											+ ' LIKE "%' + encode_sql(#wordseparator + #onevalue ) + '%"');
									/if;
								/iterate;
							/if;
						else;
							if: (local_defined: 'contains');
								#output_temp -> (insert:  -op='cn');
								#output_temp -> (insert:  #field = #onevalue );
							else;
								#output_temp -> (insert:  -op='bw');
								#output_temp -> (insert:  #field = #onevalue );
								if: !(self -> 'database' -> 'isfilemaker');
									// this variant is not needed for FileMaker since it already searches with "word begins with" as default							#output_temp -> (insert:  -op='cn');
									iterate: #wordseparators, #wordseparator;
										#output_temp -> (insert:  -op='cn');
										#output_temp -> (insert:  #field = #wordseparator + #onevalue );
									/iterate;
								/if;
							/if;
						/if;
					/iterate;
					if: #_sql;
						if: #output_temp -> size > 1;
							#output_temp = '(' + #output_temp -> (join: ' OR ') + ')';
						else;
							#output_temp = #output_temp -> first;
						/if;
						#output -> (insert: #output_temp);
					else;
						if: #output_temp -> size > 2;
							#output_temp -> (insert: -opbegin='or', 1);
							#output_temp -> (insert: -opend='or');
						/if;
						#output -> (merge: #output_temp);
					/if;
				/iterate;
				
				if: #_sql;
					if: #output -> size;
						#output = '(' + #output -> (join: ' AND ') + ')';
					else;
						#output = string;
					/if;
				else;
					if: #output -> size;
						#output -> (insert: -opbegin='and', 1);
						#output -> (insert: -opend='and');
					/if;
				/if;
			/if; // isfilemaker
		/if; // #fieldvalue != ''
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: @#output;
	/define_tag;
	
	define_tag: 'urlargs', -description='returns all get params that begin with - as a query string, for internal use in links in the grid. \n\
			Parameters:\n\
			-except (optional) Exclude these parameters (string or array)\n\
			-prefix (optional) For example ? or &amp; to include at the beginning of the querystring \n\
			-suffix (optional) For example &amp; to include at the end of the querystring',
		-optional='except', -copy,
		-optional='prefix',	// for example ? or &amp; to include at the beginning of the querystring 
		-optional='suffix';	// for example &amp; to include at the end of the querystring
		local: 'timer'=knop_timer; 
		local: 'output'=array, 'param'=null;

		// only getparams to not send along -action etc
		local: 'clientparams'=client_getparams;

		!(local_defined: 'except') ? local: 'except'=array;
		#except -> type != 'array' ? #except = array: #except;
		#except -> (insert: -session);
		
		// add getparams that begin with -
		iterate: #clientparams, #param;
			if: #param -> type == 'pair';
				if: #param -> name -> (beginswith: '-') && #except !>> #param -> name;
					#output -> (insert: (encode_stricturl: #param -> name) + '=' + (encode_stricturl: #param -> value));
				/if;
			else; // just a string param (no pair)
				if: #param -> (beginswith: '-') && #except !>> #param;
					#output -> (insert: encode_stricturl: #param);
				/if;
			/if;
		/iterate;

		if: self -> 'nav' -> isa('nav');
			// send params that have been defined as -params in nav
			local: 'navitem'=self -> 'nav' -> getnav;
			// add post params
			#clientparams -> (merge: client_postparams);

			iterate: #navitem -> (find: 'params'), #param;
				if: #clientparams >> #param && #clientparams -> (find: #param) -> first -> type == 'pair';
					#output -> (insert: (encode_stricturl: #clientparams -> (find: #param) -> first -> name) +  '=' + (encode_stricturl: #clientparams -> (find: #param) -> first -> value));
				else: #clientparams >> #param;
					#output -> (insert: encode_stricturl: #clientparams -> (find: #param) -> first);
				/if;
			/iterate;
		/if;
		#output = string: (#output -> (join: '&amp;'));
		// restore / in paths
		#output -> replace('%2F', '/');


		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		if: #output -> size;
			return: (local: 'prefix') + #output + (local: 'suffix');
		/if;

	/define_tag;
	
	
	define_tag: 'renderhtml', -description='Outputs the complete record listing. Calls renderheader, renderlisting and renderfooter as well. \
			If 10 records or more are shown, renderfooter is added also just below the header.\n\
			Parameters:\n\
			-inlinename (optional) If not specified, inlinename from the connected database object is used\n\
			-numbered (optional flag or integer) If specified, pagination links will be shown as page numbers instead of regular prev/next links. Defaults to 6 links, specify another number (minimum 6) if more numbers are wanted.',
		-optional='inlinename',
		-optional='xhtml',
		-optional='numbered',
		-optional='startwithfooter';
		local: 'timer'=knop_timer; 

		local: 'output'=string,
			'db'=@(self -> 'database'), 
			'_xhtml' = (((local_defined: 'xhtml') && #xhtml != false) ? true | false);
		if(local_defined('numbered'));
			local('numberedpaging'=((#numbered !== false) ? integer(#numbered) | false));
		else;
			local('numberedpaging'=(((self -> 'numbered') !== false) ? integer(self -> 'numbered') | false));
		/if;

		local_defined('startwithfooter') && #startwithfooter != false ? #startwithfooter = true | local('startwithfooter') = false;

		!(local_defined: 'inlinename') ? local: 'inlinename'=string;
		self -> 'footer' = (self -> (renderfooter: -xhtml = #_xhtml, -numbered=#numberedpaging));
		#output += (self -> renderheader(-start, -xhtml = #_xhtml, -startwithfooter = #startwithfooter));
		if: #db -> shown_count >= 10 && !#startwithfooter;
			#output += self -> 'footer';
		/if;
		#output += (self -> (renderlisting: -inlinename=#inlinename, -xhtml=#_xhtml));

		#output += self -> 'footer' + '</table>\n';
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: @#output;
	/define_tag;


	define_tag: 'renderlisting', -description='Outputs just the actual record listing. Is called by renderhtml. \
			Parameters:\n\
			-inlinename (optional) If not specified, inlinename from the connected database object is used',
		-optional='inlinename',
		-optional='xhtml';
		local: 'timer'=knop_timer; 

		local: '_inlinename'=string, 
			'output'=string, 
			'fields'=(self -> 'fields'), 
			'field'=string,
			'keyfield'=null,
			'affectedrecord_keyvalue'=null,
			'record_loop_count'=integer,
			'db'=@(self -> 'database'), 
			'nav'=@(self -> 'nav'),
			'dbfieldmap'=@(self -> 'dbfieldmap'),
			'classarray'=array,
			'fieldname'=string,
			'value'=string,
			'keyparamname',
			'url',
			'url_cached_temp',
			'_xhtml' = (((local_defined: 'xhtml') && #xhtml != false) ? true | false),
			'lang'=@(self -> 'lang');
			
		if: (local: 'inlinename')!='';
			#_inlinename = #inlinename;
		else: #db -> type == 'database';
			#_inlinename=#db -> 'inlinename';
			#keyfield=#db -> 'keyfield';
			#affectedrecord_keyvalue = #db -> 'affectedrecord_keyvalue';
		/if;
		#output += '\n<tbody>\n';
		if: #nav -> (isa: 'nav');
			iterate: #fields, #field;
				if: (#field -> (find: 'url')) != '';
					#url = (#field -> (find: 'url'));
					#keyparamname = (#field -> (find: 'keyparamname'));
					#field -> insert('url_cached' = (#nav -> (url: -path=#url, 
						#keyparamname='###keyvalue###',
						-autoparams,
						-except=(array: -path))));
				/if;
			/iterate;
		/if;
		records: -inlinename=#_inlinename;
			#record_loop_count = loop_count;
			#output += '\n<tr>';
			iterate: #fields, #field;
				#fieldname = (#dbfieldmap -> (find: (#field -> (find: 'name'))));
				#keyparamname = (#field -> (find: 'keyparamname'));
				#value=(field: #fieldname);
				if: #field -> (find: 'template') -> type == 'map';
					#value=string(#value);
					if: #field -> (find: 'template') >> #value;
						#value = #field -> (find: 'template') -> (find: #value);
					else: #field -> (find: 'template') >> '-default';
						#value = #field -> (find: 'template') -> (find: '-default');
					else;
						// show fieldvalue as is
					/if;
					// substitute field value in the display template
					#value -> (replace: '#value#', (field: #fieldname));
				else: #field -> (find: 'template') -> (isa: 'tag');
					#value = #field -> (find: 'template') -> (run: -params=#value);
				/if;
				#classarray=array;
				if:  #affectedrecord_keyvalue == (field: #keyfield) && (field: #keyfield) != '';
					// hightlight affected row
					#classarray -> (insert: 'highlight');
				else;
					(#record_loop_count - 1)  % 2 == 0 ? #classarray -> (insert: 'even');
				/if;
				// Added by JC 081127 to handle td specific classes
				(#field -> find('class') -> size ? #classarray -> insert( #field -> find('class')));
				#output += '<td';
				if: #classarray -> size;
					#output += ' class="' + #classarray -> (join: ' ') + '"';
				/if;
				#output += '>';
				if: (#field -> (find: 'url')) != '';
					#url = (#field -> (find: 'url'));
					/*
					if: #nav -> (isa: 'nav') && #url !>> '#value#';
						#output += '<a href="' + (#nav -> (url: -path=#url, 
							#keyparamname=(field: #keyfield),
							-autoparams,
							-except=(array: -path)));
					*/
					if: #field -> find('url_cached') -> size && #url !>> '#value#';
						#url_cached_temp = #field -> find('url_cached');
						#url_cached_temp -> replace('###keyvalue###', field(#keyfield));
						#output += '<a href="' + #url_cached_temp;
						#output += '">' +  #value 
							// show something to click on even if the field is empty
							+ ((string_findregexp: #value, -find='\\w*') -> size == 0 ? (#lang -> linktext_edit)) 
							+ '</a>';
					else;
						#url -> (replace: '#value#', (field: #fieldname));
						#output += '<a href="' + #url + '"'; 
						#url -> (beginswith: 'http://') || #url -> (beginswith: 'https://') || #url -> (beginswith: 'mailto:')
							? #output += ' class="ext"';
						#output += '>' +  #value + '</a>';
					/if;
				else;
					#output += #value;
				/if;
				#output += '</td>\n';
			/iterate;
			#output += '</tr>\n';
		/records;
		#output += '\n</tbody>\n';
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: @#output;
	/define_tag;
	
	
	define_tag: 'renderheader', -description='Outputs the header of the grid with the column headings. \
			Automatically included by ->renderhtml. \n\
			Parameters:\n\
			-start (optional flag) Also output opening <table> tag',
		-optional='start',
		-optional='xhtml',
		-optional = 'startwithfooter';
		local: 'timer'=knop_timer; 
		local: 'output'=string, 
			'db'=@(self -> 'database'), 
			'nav'=@(self -> 'nav'),
			'fields'=@(self -> 'fields'), 
			'field'=string,
			'classarray'=array,
			'_xhtml' = ((local_defined: 'xhtml') && #xhtml != false) ? true | false,
			'lang'=@(self -> 'lang');
		local_defined('startwithfooter') && #startwithfooter != false ? #startwithfooter = true | local('startwithfooter') = false;


		(local_defined: 'start') ? #output += '<table id="' + (self -> 'tbl_id') + '" class="grid' + (self -> 'class' -> size > 0 ? ' ' + self -> 'class') + '">';
		#output += '<thead>\n<tr>';
		if: (self -> 'quicksearch_form') -> type == 'form';
			#output += '<th colspan="' + (#fields -> size) + '" class="quicksearch';
				((self -> 'quicksearch_form') -> (getvalue: '-q') != '') ? #output += ' highlight';
			#output += '">';

			if: (self -> 'rawheader') -> size > 0 ;
				#output += (self -> 'rawheader');
			/if;


			#output += (self -> 'quicksearch_form') -> (renderform: -xhtml = #_xhtml);
			if: (self -> 'quicksearch_form_reset') -> type =='form';
				#output += (self -> 'quicksearch_form_reset') -> (renderform: -xhtml = #_xhtml);
			/if;
			#output += '</th></tr>\n';
		else((self -> 'rawheader') -> size > 0);
			#output += '<th colspan="' + (#fields -> size) + '">';
			#output += (self -> 'rawheader');
			#output += '</th></tr>\n';
		/if;

		if(#startwithfooter);
			#output += self -> 'footer';
		/if;

		#output += '<tr>';

		iterate: #fields, #field;
			#classarray=array;
			//(self -> 'quicksearch_form') -> type == 'form' ? #classarray -> (insert: 'notopborder');
			if: !(self -> 'nosort');
				(self -> 'sortfield') == (#field -> (find: 'name')) 
					&& !(#field -> (find: 'nosort')) ? #classarray -> (insert: 'sort');
			/if;
			#output += '<th';
			if: #field -> (find: 'width') > 0;
				#output += ' style="width: ' + (integer: #field -> (find: 'width')) + 'px;"';
			/if;
			// Added by Jolle 081127 to handle td specific classes
			(#field -> find('class') -> size ? #classarray -> insert( #field -> find('class')));
			if: #classarray -> size;
				#output += ' class="' + #classarray -> (join: ' ') + '"';
			/if;
			#output += '>';
			if: (#field -> (find: 'nosort')) || (self -> 'nosort');
				#output += '<div>' + (#field -> (find: 'label')) '</div>';
			else;
				if: (#classarray >> 'sort' && (self -> 'sortdescending') && (self -> 'defaultsort') == '');
					// create link to change to unsorted
					if: #nav -> isa('nav');
						#output += '<a href="' + #nav -> url(-autoparams, -getargs, -except=(array: -sort, -desc, -page, -path)) + '"'
							+ ' title="' + (#lang -> linktitle_showunsorted) + '">';
					else;
						#output += '<a href="./'
							+ (self -> (urlargs: -except=(array: -sort, -desc, -page), -prefix='?')) + '"'
							+ ' title="' + (#lang -> linktitle_showunsorted) + '">';
					/if;
				else;
					// create link to toggle sort mode
					if: #nav -> isa('nav');
						#output += '<a href="' + #nav -> url(-autoparams, -getargs, -except=(array: -sort, -desc, -page, -path), 
							-urlargs='-sort=' + (#field -> (find: 'name'))
								+ (#classarray >> 'sort' && !(self -> 'sortdescending') ? '&amp;-desc')) + '"'
							+ ' title="' + (#classarray >> 'sort' 
								?  (#lang -> linktitle_changesort) + ' ' 
									+ ((self -> 'sortdescending') ? (#lang -> linktitle_ascending) | (#lang -> linktitle_descending))
								| (#lang -> linktitle_sortascby) + ' ' + (encode_html: (#field -> (find: 'label'))) ) + '">';
					else;
						#output += '<a href="./?-sort=' + (#field -> (find: 'name')) 
							+ (#classarray >> 'sort' && !(self -> 'sortdescending') ? '&amp;-desc') 
							+ (self -> (urlargs: -except=(array: -sort, -desc, -page), -prefix='&amp;')) + '"'
							+ ' title="' + (#classarray >> 'sort' 
								?  (#lang -> linktitle_changesort) + ' ' 
									+ ((self -> 'sortdescending') ? (#lang -> linktitle_ascending) | (#lang -> linktitle_descending))
								| (#lang -> linktitle_sortascby) + ' ' + (encode_html: (#field -> (find: 'label'))) ) + '">';
					/if;
				/if;
				#output += (#field -> (find: 'label'));
				if: (string_findregexp: (#field -> (find: 'label')), -find='\\S') -> size == 0;
					#output += '&nbsp;'; // to show sort link as block element properly even for empty label
				/if;
				if: #classarray >> 'sort';
					#output += ' <span class="sortmarker"> ' + ((self -> 'sortdescending') ? '&#9660;' | '&#9650;') + '</span>';
				/if;
				#output += '</a>';
			 /if;
			 #output += '</th>\n';
		/iterate;
		#output += '</tr>\n</thead>\n';
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: @#output;
	/define_tag;

	define_tag: 'renderfooter', -description='Outputs the footer of the grid with the prev/next links and information about found count. \
			Automatically included by ->renderhtml\n\
			Parameters:\n\
			-end (optional flag) Also output closing </table> tag\n\
			-numbered (optional flag or integer) If specified, pagination links will be shown as page numbers instead of regular prev/next links. Defaults to 6 links, specify another number (minimum 6) if more numbers are wanted.',
		-optional='end',
		-optional='numbered',
		-optional='xhtml';
		local: 'timer'=knop_timer; 
		local: 'output'=string, 
			'db'=@(self -> 'database'), 
			'nav'=@(self -> 'nav'),
			'fields'=@(self -> 'fields'), 
			'field'=string,
			//'numberedpaging'=(((local_defined: 'numbered') && #numbered !== false) ? integer(#numbered) | false),
			'_xhtml' = ((local_defined: 'xhtml') && #xhtml != false) ? true | false,
			'lang'=@(self -> 'lang'),
			'page'=(self -> page),
			'lastpage'=(self -> lastpage),
			'url_cached',
			'url_cached_temp';
		if(local_defined('numbered'));
			local('numberedpaging'=((#numbered !== false) ? integer(#numbered) | false));
		else;
			local('numberedpaging'=(((self -> 'numbered') !== false) ? integer(self -> 'numbered') | false));
		/if;
			
		if(#nav -> isa('nav'));
			#url_cached=#nav -> url(-autoparams, -getargs, -except=(array: -page, -path), 
					-urlargs='-page=###page###');
		/if;
		if: #numberedpaging !== false && #numberedpaging < 6;
			// show 10 page numbers as default
			#numberedpaging = 6;
		/if;
		if: #numberedpaging;
			// make sure we have an even number
			#numberedpaging += #numberedpaging % 2;
		/if;
		
		#output += '\n<tr><th colspan="' + (#fields -> size) + '" class="footer first'  + '">';
		/* not used
		if: #nav -> isa('nav');
			local: 'url'=#nav -> url(-autoparams, -getargs, -except=(array: -page, -path), -urlargs='-page='),
				'url_prefix'=(#nav -> 'navmethod' == 'param' ? '&amp;' | '?');
		else;
			local: 'url'='./' + (self -> (urlargs: -except=(array: -page, -path), -suffix='&amp;')),
				'url_prefix'='?';
		/if;
		*/
		// JC 2010-05-14 added span separation for better styling
		if: #numberedpaging;
			local: 'page_from'=1,
				'page_to'=#lastpage;
			if: #lastpage > #numberedpaging;
				#page_from=#page - (#numberedpaging/2 - 1);
				#page_to=#page + (#numberedpaging/2);
				if: #page_from < 1;
					#page_to += (1 - #page_from);
					#page_from = 1;
				/if;
				if: #page_to > #lastpage;
					#page_from = #lastpage - (#numberedpaging - 1);
					#page_to = #lastpage;
				/if;
			/if;
			#output += '<span class="foundcount">' + #db -> found_count + ' ' + (#lang -> footer_found) + '</span> &#8212; <span class="pagination">' + (#lang -> linktext_gotopage) + ': '; // SP customization
			if: #page > 1;
				if: #url_cached -> size;
					#url_cached_temp=#url_cached;
					// 2010-12-23	SP	Corrected pagination bug for -numbered.
					#url_cached_temp -> replace('-page=###page###', '-page=' + 1);
					/*#output += ' <a href="' + #nav -> url(-autoparams, -getargs, -except=(array: -page, -path), 
						-urlargs='-page=' + (#page - 1)) + '" class="prevnext prev"'
						+ ' title="' + (#lang -> linktitle_goprev) + '">' + (#lang -> linktext_prev) + '</a> ';*/
					#output += ' <a href="' + #url_cached_temp + '" class="prevnext first"'
						+ ' title="' + (#lang -> linktitle_gofirst) + '">' + (#lang -> linktext_first) + '</a> ';

					#url_cached_temp=#url_cached;
					#url_cached_temp -> replace('-page=###page###', '-page=' + (#page - 1));
					#output += ' <a href="' + #url_cached_temp + '" class="prevnext prev"'
						+ ' title="' + (#lang -> linktitle_goprev) + '">' + (#lang -> linktext_prev) + '</a> ';
				else;
					#output += ' <a href="./?' + (self -> (urlargs: -except=(array: -page, -path), -suffix='&amp;')) 
						+ '-page=1" class="prevnext first"'
						+ ' title="' + (#lang -> linktitle_gofirst) + '">' + (#lang -> linktext_first) + '</a> ';
					#output += ' <a href="./?' + (self -> (urlargs: -except=(array: -page, -path), -suffix='&amp;')) 
						+ '-page=' + (#page - 1) + '" class="prevnext prev"'
						+ ' title="' + (#lang -> linktitle_goprev) + '">' + (#lang -> linktext_prev) + '</a> ';
				/if;
			else;
				//#output += ' <span class="prevnext prev dim">' + (#lang -> linktext_prev) + '</span> ';
			/if;
			if: #page_from > 1;
				if: #url_cached -> size;
					#url_cached_temp=#url_cached;
					#url_cached_temp -> replace('-page=###page###', '-page=' + 1);
					/*#output += ' <a href="' + #nav -> url(-autoparams, -getargs, -except=(array: -page, -path),
						-urlargs='-page=1') + '" class="prevnext numbered first">1</a>';*/
					#output += ' <a href="' + #url_cached_temp + '" class="prevnext numbered first">1</a>';
				else;
					#output += ' <a href="./?' + (self -> (urlargs: -except=(array: -page, -path), -suffix='&amp;')) 
						+ '-page=1" class="prevnext numbered first">1</a> ';
				/if;
				if: #page_from > 2;
					#output +='...';
				/if;
			/if;
			loop: -from=#page_from, -to=#page_to;
				if: loop_count == #page;
					#output += ' <span class="numbered current">' + loop_count + '</span> ';
				else;
					if: #url_cached -> size;
						#url_cached_temp=#url_cached;
						#url_cached_temp -> replace('-page=###page###', '-page=' + loop_count);
						/*#output += ' <a href="' + #nav -> url(-autoparams, -getargs, -except=(array: -page, -path),
							-urlargs='-page=' + loop_count) + '" class="prevnext numbered">' + loop_count + '</a> ';*/
						#output += ' <a href="' + #url_cached_temp + '" class="prevnext numbered">' + loop_count + '</a> ';
					else;
						#output += ' <a href="./?' + (self -> (urlargs: -except=(array: -page, -path), -suffix='&amp;')) 
							+ '-page=' + loop_count + '" class="prevnext numbered">' + loop_count + '</a> ';
					/if;
				/if;
			/loop;
			if: #page_to < #lastpage;
				if: #page_to < (#lastpage - 1);
					#output += '...';
				/if;
				if: #url_cached -> size;
					#url_cached_temp=#url_cached;
					#url_cached_temp -> replace('-page=###page###', '-page=' + #lastpage);
					/*#output += ' <a href="' + #nav -> url(-autoparams, -getargs, -except=(array: -page, -path),
						-urlargs='-page=' + #lastpage) + '" class="prevnext numbered last">' + #lastpage + '</a> ';*/
					#output += ' <a href="' + #url_cached_temp + '" class="prevnext numbered last">' + #lastpage + '</a> ';
				else;
					#output += ' <a href="./?' + (self -> (urlargs: -except=(array: -page, -path), -suffix='&amp;')) 
						+ '-page=' + #lastpage + '" class="prevnext numbered last">' + #lastpage + '</a> ';
				/if;
			/if;
	
			if: #page < #lastpage;
				if: #url_cached -> size;
					#url_cached_temp=#url_cached;
					#url_cached_temp -> replace('-page=###page###', '-page=' + (#page + 1));
					/*#output += ' <a href="' + #nav -> url(-autoparams, -getargs, -except=(array: -page, -path), 
						-urlargs='-page=' + (#page + 1)) + '" class="prevnext next"'
						+ ' title="' + (#lang -> linktitle_gonext) + '">' + (#lang -> linktext_next) + '</a> ';*/
					#output += ' <a href="' + #url_cached_temp + '" class="prevnext next"'
						+ ' title="' + (#lang -> linktitle_gonext) + '">' + (#lang -> linktext_next) + '</a> ';

					#url_cached_temp=#url_cached;
					#url_cached_temp -> replace('-page=###page###', '-page=' + #lastpage);
					#output += ' <a href="' + #url_cached_temp + '" class="prevnext last"'
						+ ' title="' + (#lang -> linktitle_golast) + '">' + (#lang -> linktext_last) + '</a> ';
				else;
					#output += ' <a href="./?' + (self -> (urlargs: -except=(array: -page, -path), -suffix='&amp;')) 
						+ '-page=' + (#page + 1) + '" class="prevnext next"'
						+ ' title="' + (#lang -> linktitle_gonext) + '">' + (#lang -> linktext_next) + '</a> ';
					#output += ' <a href="./?' + (self -> (urlargs: -except=(array: -page, -path), -suffix='&amp;')) 
						+ '-page=' + #lastpage + '" class="prevnext last"'
						+ ' title="' + (#lang -> linktitle_golast) + '">' + (#lang -> linktext_last) + '</a> ';
				/if;
			else;
				//#output += ' <span class="prevnext next dim">' + (#lang -> linktext_next) + '</span> ';
			/if;
		
			#output += '</span> ';
		
		
		else;  // regular prev/next links
		
		
			if: #page > 1;
				if: #url_cached -> size;
					#url_cached_temp=#url_cached;
					#url_cached_temp -> replace('-page=###page###', '-page=' + 1);
					/*#output += ' <a href="' + #nav -> url(-autoparams, -getargs, -except=(array: -page, -path),
						-urlargs='-page=1') + '" class="prevnext first"'
						+ ' title="' + (#lang -> linktitle_gofirst) + '">' + (#lang -> linktext_first) + '</a> ';*/
					#output += ' <a href="' + #url_cached_temp + '" class="prevnext first"'
						+ ' title="' + (#lang -> linktitle_gofirst) + '">' + (#lang -> linktext_first) + '</a> ';
		
					#url_cached_temp=#url_cached;
					#url_cached_temp -> replace('-page=###page###', '-page=' + (#page - 1));
					#output += ' <a href="' + #url_cached_temp + '" class="prevnext prev"'
						+ ' title="' + (#lang -> linktitle_goprev) + '">' + (#lang -> linktext_prev) + '</a> ';
				else;
					#output += ' <a href="./?' + (self -> (urlargs: -except=(array: -page, -path), -suffix='&amp;')) 
						+ '-page=1" class="prevnext first"'
						+ ' title="' + (#lang -> linktitle_gofirst) + '">' + (#lang -> linktext_first) + '</a> ';
		
					#output += ' <a href="./?' + (self -> (urlargs: -except=(array: -page, -path), -suffix='&amp;')) 
						+ '-page=' + (#page - 1) + '" class="prevnext prev"'
						+ ' title="' + (#lang -> linktitle_goprev) + '">' + (#lang -> linktext_prev) + '</a> ';
				/if;
			else;
				#output += ' <span class="prevnext first dim">' + (#lang -> linktext_first) + '</span> \
							<span class="prevnext prev dim">' + (#lang -> linktext_prev) + '</span> ';
			/if;
			if: #db -> found_count > #db -> shown_count;
				#output += (#lang -> (footer_shown: -replace=(array: (#db -> shown_first), (#db -> shown_last)))) + ' ';
			/if;
			#output += #db -> found_count + ' ' + (#lang -> footer_found);
			if: (#db -> shown_last) < (#db -> found_count);
				if: #url_cached -> size;
					#url_cached_temp=#url_cached;
					#url_cached_temp -> replace('-page=###page###', '-page=' + (#page + 1));
					/*#output += ' <a href="' + #nav -> url(-autoparams, -getargs, -except=(array: -page, -path), 
						-urlargs='-page=' + (#page + 1)) + '" class="prevnext next"'
						+ ' title="' + (#lang -> linktitle_gonext) + '">' + (#lang -> linktext_next) + '</a> ';*/
					#output += ' <a href="' + #url_cached_temp + '" class="prevnext next"'
						+ ' title="' + (#lang -> linktitle_gonext) + '">' + (#lang -> linktext_next) + '</a> ';

					#url_cached_temp=#url_cached;
					#url_cached_temp -> replace('-page=###page###', '-page=' + #lastpage);
					#output += ' <a href="' + #url_cached_temp + '" class="prevnext last"'
						+ ' title="' + (#lang -> linktitle_golast) + '">' + (#lang -> linktext_last) + '</a> ';
				else;
					#output += ' <a href="./?' + (self -> (urlargs: -except=(array: -page, -path), -suffix='&amp;')) 
						+ '-page=' + (#page + 1) + '" class="prevnext next"'
						+ ' title="' + (#lang -> linktitle_gonext) + '">' + (#lang -> linktext_next) + '</a> ';
					#output += ' <a href="./?' + (self -> (urlargs: -except=(array: -page, -path), -suffix='&amp;')) 
						+ '-page=' + ((self -> lastpage)) + '" class="prevnext last"'
						+ ' title="' + (#lang -> linktitle_golast) + '">' + (#lang -> linktext_last) + '</a> ';
				/if;
			else;
				#output += ' <span class="prevnext next dim">' + (#lang -> linktext_next) + '</span>  \
							<span class="prevnext last dim">' + (#lang -> linktext_last) + '</span> ';
			/if;
		/if;
		#output += '</th></tr>\n';
		(local_defined: 'end') ? #output += '</table>\n';
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: @#output;
	/define_tag;
	
	define_tag: 'page', -description='Returns the current page number';
		return: (self -> 'page');
	/define_tag;
	
	define_tag: 'lastpage', -description='Returns the number of the last page for the found records';
		if: (self -> 'database') -> 'found_count' > 0;
			return: (((self -> 'database') -> 'found_count' - 1) / (self -> 'database') -> 'maxrecords_value') + 1;
		else;
			return: 1;
		/if;
	/define_tag;
	
	define_tag: 'page_skiprecords', -description='Converts curent page value to a skiprecords value to use in a search. \n\
			Parameters:\n\
			-maxrecords (required integer) Needed to be able to do the calculation. Maxrecords_value can not be taken from the database object since taht value is not available until aftetr performing the search',
		-required='maxrecords', -type='integer'; // TODO: maxrecords_value can be taken from the database object so should not be required
		return: ((self -> 'page') - 1) * #maxrecords;
	/define_tag;
	

/define_type;

?>