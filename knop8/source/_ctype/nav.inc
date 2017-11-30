<?LassoScript

define_type: 'nav',
	'knop_base',
	-namespace='knop_';
//	-prototype;

	local: 'version'='2013-08-04',
 		'description'='Custom type to handle site navigation menu';

/*

CHANGE NOTES
2013-08-04	SP	Added optional -tbdropdown parameter to ->insert method.  It may be a flag or any type.  The following values for the parameter -tbdropdown are equivalent.

    -tbdropdown
    -tbdropdown=true
    -tbdropdown=<any non-map type or expression that evaluates to true>
    -tbdropdown=map(
        'tbdd_liclass' = 'dropdown',
        'tbdd_aclass' = 'dropdown-toggle',
        'tbdd_araw' = ' data-toggle="dropdown"',
        'tbdd_labelappend' = ' <span class="caret"></span>');

All will generate HTML markup:

  <li class="dropdown">
    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
      Dropdown <span class="caret"></span>
    </a>

If -tbdropdown is type map, then the values for the keys in the map will be used.  For example, using the Crisp theme <https://wrapbootstrap.com/theme/crisp-responsive-fluid-business-template-WB0F7FH2P>

    -tbdropdown=map(
        'tbdd_liclass' = 'parent',
        'tbdd_aclass' = '',
        'tbdd_araw' = '',
        'tbdd_labelappend' = '<i></i><span class="dcjq-icon"></span>');

Will generate HTML markup:

  <li class="parent">
    <a href="#">
      Dropdown<i></i><span class="dcjq-icon"></span>
    </a>
2013-08-04	SP	Added optional -liclass parameter to ->insert method.  If the HTML template contains "<li>", either by setting it with -template or using the default value, then when the nav is rendered the classes will be inserted into the <li> tag.
2013-08-02	SP	Added optional -ulclass parameter as an instance variable.  If the HTML template begins with "<ul>", either by setting it or using the default value, then when the nav is rendered the classes will be inserted into the <ul> tag.
2010-11-17	JC	Fixed bug so that session links no longer gets added to urls by the nav -> url tag.
2010-11-17	JC	Fixed a bug that would not convert local params to an array under certain situations
2009-09-18	JS	Syntax adjustments for Lasso 9
2009-09-04	JS	->linkparams: Multiple paramaters with the same name (typically checkboxes) are now passed properly
2009-05-06	JS	->directorytree considers _include folders as part of the Knop directory structure. nav->include('_include/myfile.inc') will first look for _include/myfile.inc and if not found it will look for _knop/_include/myfile.inc 
2009-05-05	JS	->include looks for a specified file also inside a _knop folder, if the file does not exist at the specified location
2009-02-09	JS	->filename: Casting path and actionpath to string
2008-12-19	JS	->filename (and consequently ->include and ->library) can now use a specific -path instead of the current location's path
2008-12-09	JS	->linkparams: fixed undefined local in trace call (only showed when trace was enabled for the nav object)
2008-11-25	JS	->getlocation will now avoid disabled and hidden pages when looking for the first page if no default page is specified
2008-11-03	JS	->getlocation will not break if no navigation items have been defined
2008-10-30	JS	_mod folders will now work with knop paths with just a single level, so an include file path can end up as _mod_customer/lib_customer.inc or just _mod_customer/lib.inc (the latter variant does not apply to extension-based filenaming, so _mod_customer/.lib will never be a working file path)
2008-07-10	JS	Added -> label to return the name of the current page
2008-05-20	JS	->renderhtml: #current# is not automatically added to the template if the more elaborate template format is used. This makes it easier to hide the currentmarker without changing the nav config (partial revert of fix 2008-01-04). 
2008-05-08	JS	->insert: A duplicate key does no longer cause a fatal error but instead fails silently and logs to the debug log
2008-05-07	JS	->url: will now call ->linkparams so all links that are constructed from ->url will properly send along the parameters specified in the nav item. This also affects pagination and sort links in grid. 
2008-05-07	JS	Added ->linkparams, Returns an array for all parameters that should be sent along with nav links (this was previously embedded in renderhtml)
2008-02-25	JS	->url: new parameter -getargs to add the getargs to the path link if the path equals the current path
2008-02-06	JC	->insert: the -hide flag can now be a boolean (also the -disabled flag)
2008-02-03	JS	->include: can now include any specified filename
2008-02-01	JS	->oncreate: added optional -fileroot to be able to use a root for files that is different from the logical site root used for navigation 
2008-01-23	JS	->url: Added -autoparams that is required to enable the automatic passing of action_params that begin with "-" (this reverts the default behavior to match the the old)
2008-01-22	JS	->url: GET params that begin with "-" are sent as parameters on links. -path, -sort, -desc, -q are explicitly excluded from nav links in renderhtml. 
2008-01-22	JS	When using param based navigation, navigation links now use much cleaner /?path/to/page/ style links instead of /?-path=path/to/page/
2008-01-22	JS	->getlocation: when navmethod is param, the path can now be sent as unnamed parameter instead of -path parameter (such as /?path/to/page/). 
2008-01-04	JS	->renderbreadcrumb: added flag -plain to output breadcrumb without html
2008-01-04	JS	->renderbreadcrumb: added flag -skipcurrent to not include the current location in the output
2008-01-04	JS	->insert: -template can now be specified also for individual nav items. Use the form #link##label##current##/link##children#. 
2008-01-04	JS	->renderhtml: changed #title# to #label# in template for clarity, for example #link##label##current##/link##children# (#title# will remain supported)
2008-01-04	JS	Added #current# as placeholder for template, to specify where the current marker should occurr. If not specified in the template, the current marker appears immediately after the label.
2007-12-12	JS	->include now logs processing time for the include to debug trace
2007-12-11	JS	Added documentation as -description to most member tags, to be used by the new ->help tag
2007-12-11	JS	Moved ->help to knop_base
2007-12-04	JS	nav item css class is now applied also to disabled nav items (rendered as <span>)
2007-11-08	JS	Changed trace so it tracks some things even when it's not enabled (like include etc)
2007-11-05	JS	Added var name to trace output
2007-10-28	JS	->directorytree: should now work also when knop folders are symlinks
2007-09-06	JS	top level nav elements that are -disabled now behave properly when accessed
2007-09-05	JS	-currentmarker can now be set separately on sublevels, not only on topmost level
2007-08-29	JS	Added _knop as optional base folder to put all knop files in
2007-08-29	JS	->include: Removed file_exists check since the filename has already been verified in ->filename.
2007-08-29	JS	Added ->directorytree which returns a map with all knop filenames, to use when searching for includes
2007-08-28	JS	->oncreate: -filenaming to specify how include files are named prefix/suffix/extension
2007-08-28	JS	->filename: Implemented support for flexible folder structures
2007-08-28	JS	Instance variable #actionconfigfile_didrun was not properly declared
2007-06-18	JS	Added tag timer to most member tags
2007-06-14	JS	->insert: -url='/' can now be used to specify the "home" location. 
2007-06-13	JS	added ->children to get a reference to the children nav object for a specified path, so new children can be inserted. Must call ->reindex afterwards. 
2007-06-13	JS	added ->reindex to rebuild the index maps from scratch. Must be done after adding children items. 
2007-06-13	JS	added ->addchildren to replace a current children nav object for a specified path. Will handle the reindexing transparently. 
2007-06-13	JS	added ->keymap, ->pathmap and ->urlmap to access the index maps so they call reindex if they have been invalidated (for example by ->addchildren)
2007-06-13	JS	added inheritance from knop_base
2007-06-11	JC	added handling of xhtml output
2007-06-08	JS	->insert: params with empty values are now ignored
2007-05-04	JS	->insert: added check that default item exists in children before storing the default
2007-04-19	JS added ->data to retrieve data stored for the current path (or specified path). Optional -type ensures the returned data has the correct type. 
2007-04-19	JS ->insert: added -data to store arbitrary data object for each path. The object is stored as reference so a variable can be changed after it has been added to the nav object
2007-04-19	JS	added ->patharray to return the current path as array
2007-04-17	JS	->renderhtml: template now supports #link##title##/link##children# in addition to #item# to provide more flexibility
2007-04-17	JS	->oncreate: added support for -template, -class, currentclass and -currentmarker
2007-04-13	JS	Implemented -class per navitem (only worked globally with setformat before)
2007-04-03	JS	->renderhtml: added -renderpath, -expand and -flat to be able to render parts of the nav menu for more flexible layout
2007-04-03	JS	->renderbreadcrumb: added -home to show the default navigation item first in the breadcrumb 
2007-04-03	JS	Changed namespace from mt_ to knop_
2007-03-01	JS	Changed navmethod path so it uses response_filepath instead of $url_path
2007-02-25	JS	Added ->actionpath
2007-02-24	JS	->renderhtml: improved handling of classes in nav links
2007-02-22	JS	->url: added -except
2007-02-09	JS	->url: corrected the behavior for plain parameters passed to the tag
2007-02-05	JS	->insert: Added -param to be able to specify params that should be propagated in nav for certain nav elements (like -keyvalue to be able to move between different subtabs for a selected record
2007-02-05	JS	->renderhtml now use ->url to get the right links
2007-02-01	JS	Made usage of trace optional to improve performance
2007-02-01	JS	Improvements to debug_trace to log also recursive events
2007-02-01	JS	Added ->haschildren, which is now used by ->renderhtml to properly show or hide child level
2007-01-31	JS	->renderhtml Added renderhtml_levels to keep track of how many levels deep navigation has been rendered, to be able to add proper spacing between navigation and content
2007-01-31	JS 	->url: -urlargs  Improved handling of urlargs and ?/& delimiters, should work better with navmethod path
2007-01-30	JS	Removed automatic link title attribute since it can be confusing to show children page titles there
2007-01-30	JS	Corrected parameter path to -path (bug)
2007-01-23	JS	->include: 'config' checks if the same config has already run as actionconfig and won't run again in that case
2007-01-23	JS	->include checks if the file exists first, so no need for empty placeholder files
2007-01-23	JS	Added ->include and ->library
2007-01-23	JS	Added ->setlocation
2007-01-17	JS	Added insert: -hide to allow a location without showing it in navigation

TODO
Add support for compound expressions for template. The expression could return a map that would override corresponding param values. 
->insert: Add -raw to be able to inject code into the link tag, similar to form->addfield(-raw). 
Exclude file name for example index.lasso from getargs
Optimize nav->url! Very slow with complex nav object. 
Needs to exclude also -keyfield and -lockfield. Maybe better to add an option to ->url to not auto-add any "-" params at all. 
-params are not sent along in breadcrumb links
Need simple way to exclude certain "-" params from ->url, also in config per nav item
Add support for adding nav structure from a database
Move templates to a member tag to be make it easier to subclass
Make it possible to use external URL for -url (make sure there is no / before http)

*/

	local: 'navitems'=array,	// array of maps
		'keymap'=map,			// to speed up the locating of critical navigation elements (TBD)
		'pathmap'=map,			// contains full key paths also for children navitems
		'urlmap'=map,			// to translate a url to key path, contains url also for children navitems
		'default'=string,		// default path, i.e. home page
		'parentkey'=null,		// the key of the parent to this navitem (null for top item)
		'template'=string,
		'class'=string,
		'currentclass'=string,
		'currentmarker'=null,

		'actionpath'=string,		// captured from -action parameter in submission
		'path'=string,			// captured from path param or urlhandler and translated from url
		'patharray'=array,		// path broken down into elements
		'pathargs'=string,		// extra path parts that can contain record identification etc
		'urlparams'array,		// holds everything needed to generate nav links
		'navmethod'=string,		// path or param depending on how the nav is propagated. To be able to force path, since url handler doesn't kick in for the start page
		'filenaming'=string,
		'directorytreemap'=map,	// contains a list of all existing filenames in the knop directory tree
		'root'='/',				// site root
		'fileroot'='/',			// root for physical files
		'renderhtml_levels'=0,	// number of levels rendered by renderhtml
		// 'tagtime'=integer, 			// moved to knop_base
		// 'tagtime_tagname'=string, 	// moved to knop_base
		'debug_trace'=array,
		'dotrace'=false,
		'actionconfigfile_didrun'=string,	// path to action config file that has been run for the current page load
											// used to not load the same config again
		'error_lang'=(knop_lang: -default='en', -fallback),
		'ulclass'=string,   // class to insert into this nav's <ul> tag
		'currentclasstags'=array;   // array of tags into which the current class as defined by -currentclass will be inserted

	define_tag: 'oncreate', -description='Parameters:\n\
			-default (optional) Key of default navigation item\n\
			-root (optional) The root path for the site section that this nav object is used for\n\
			-fileroot (optional) The root for include files, to be able to use a different root for physical files than the logical root of the site. Defaults to the value of -root. \n\
			-navmethod (optional) path or param. Path for "URL designed" URLs, otherwise a -path parameter will be used for the navigation. \n\
			-filenaming (optional) prefix (default), suffix or extension, specifies how include files are named\n\
			-trace (optional flag) If specified debug_trace will be used. Defaults to disabled for performance reasons. \n\
			-template (optional) html template used to render the navigation menu\n\
			-class (optional) default class for all navigation links\n\
			-currentclass (optional) class added for the currently active link\n\
			-currentmarker (optional) character(s) show to the right link of current nav (typically &raquo;)\n\
			-ulclass (optional) Accepts a string of classes separated by spaces.  If the HTML template begins with "<ul>", either by setting it or using the default value, then when the nav is rendered the classes will be inserted into the <ul> tag.',
		-optional='template',
		-optional='class',
		-optional='currentclass',
		-optional='currentmarker',
		-optional='default',
		-optional='root',
		-optional='fileroot',
		-optional='navmethod',
		-optional='filenaming',
		-optional='trace',
		-optional='ulclass',
		-optional='currentclasstags', -type='array';
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace');
		// TODO: check if we are in an inline, in that case use -key, -label etc as field names and loop through records to fill nav		
		
		local_defined('default') ? (self -> 'default') = #default;
		local_defined('root') ? (self -> 'root') = #root;
		local_defined('navmethod') ? (self -> 'navmethod') = #navmethod; 
		local_defined('template') ? (self -> 'template') = #template;
		local_defined('class') ? (self -> 'class') = #class;
		local_defined('currentclass') ? (self -> 'currentclass') = #currentclass;
		local_defined('currentmarker') ? (self -> 'currentmarker') = #currentmarker;
		local_defined('filenaming') ? (self -> 'filenaming') = #filenaming;
		local_defined('ulclass') ? (self -> 'ulclass') = #ulclass;
		local_defined('currentclasstags') ? (self -> 'currentclasstags') = #currentclasstags;

		(self -> 'dotrace') = (local_defined: 'trace') && #trace != false;
		// normalize slashes
		(self -> 'root') -> removeleading('/') & removetrailing('/');
		(self -> 'root') = '/' + (self -> 'root') + '/';
		(self -> 'root') -> replace('//', '/');

		if: (local_defined: 'fileroot');
			(self -> 'fileroot') = #fileroot;
			// normalize slashes
			(self -> 'fileroot') -> removeleading('/') & removetrailing('/');
			(self -> 'fileroot') = '/' + (self -> 'fileroot') + '/';
			(self -> 'fileroot') -> replace('//', '/');
		else;
			(self -> 'fileroot') = (self -> 'root');
		/if;
		
		// validate and set default value
		(map: 'prefix', 'suffix', 'extension') !>> (self -> 'filenaming') ? (self -> 'filenaming') = 'prefix'; 
		
		// can not perform getlocation here since the nav structure must be defined first
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;
	
	define_tag: 'onconvert', -description='Outputs the navigation object in a very basic form, just to see what it contains';
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		local: 'output' = (self -> 'parentkey') + ': ';
		iterate: (self -> 'navitems'), (local: 'navitem');
			#output += #navitem + '\n';
		/iterate;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: @#output;
	/define_tag;

	define_tag: 'insert', -description='Adds a navigation item to nav structure\n\
			Parameters:\n\ 
			-key (required) The key will be part of the path\n\ 
			-label (optional) The menu text\n\ 
			-url (optional) Nav url to use instead of the default url that is derived from the keys path, used as shortcuts for cleaner URLs\n\ 
			-title (optional) Link href title text\n\ 
			-template (optional) Template to use only for this specific nav item, in the form #link##label##current##/link##children#\n\
			-children (optional nav) Sub navitems\n\ 
			-default (optional) Key of default child subnav item\n\ 
			-param (optional) Name of param or params (string/array) that should be sent along with nav links\n\ 
			-class (optional) CSS class name to use for this nav item (defaults to none)\n\ 
			-filename (optional) Name stem for lib, action and content files (defaults to key path with _ instead of /), to be able to use the same processing files for multiple locations\n\ 
			-disabled (optional flag) Makes the menu item dimmed and non-clickable\n\ 
			-hide (optional flag) Makes the location valid without showing a menu item for it\n\ 
			-after (optional) After which navitem to insert this navitem (key or numeric index)\n\ 
			-data (optional) Arbitrary data object (variable, map, array, compound expression) that can be returned for the location by calling ->data\n\
			-liclass (optional) If the HTML template contains "<li>", either by setting it with -template or using the default value, then when the nav is rendered the classes will be inserted into the <li> tag.\n\
			-tbdropdown (optional flag or map) It may be a flag or any type.  The following values for the parameter -tbdropdown are equivalent.

    -tbdropdown
    -tbdropdown=true
    -tbdropdown=<any non-map type or expression that evaluates to true>
    -tbdropdown=map(
        \'tbdd_liclass\' = \'dropdown\',
        \'tbdd_aclass\' = \'dropdown-toggle\',
        \'tbdd_araw\' = \' data-toggle="dropdown"\',
        \'tbdd_labelappend\' = \' <span class="caret"></span>\');

All will generate HTML markup:

  <li class="dropdown">
    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
      Dropdown <span class="caret"></span>
    </a>

If -tbdropdown is type map, then the values for the keys in the map will be used.  For example, using the Crisp theme <https://wrapbootstrap.com/theme/crisp-responsive-fluid-business-template-WB0F7FH2P>

    -tbdropdown=map(
        \'tbdd_liclass\' = \'parent\',
        \'tbdd_aclass\' = \'\',
        \'tbdd_araw\' = \'\',
        \'tbdd_labelappend\' = \'<i></i><span class="dcjq-icon"></span>\');

Will generate HTML markup:

  <li class="parent">
    <a href="#">
      Dropdown<i></i><span class="dcjq-icon"></span>
    </a>
',
		-required='key',
		-optional='label',
		-optional='default',
		-optional='url', -copy,
		-optional='title',
		-optional='template',
		-optional='children', -type='nav',
		-optional='param',
		-optional='class',
		-optional='filename',
		-optional='disabled',
		-optional='hide',
		-optional='after',
		-optional='data',
		-optional='liclass',
		-optional='tbdropdown';
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		
		fail_if: !(local_defined: 'hide') && (local: 'label') == '', -1, 'Insert requires a label';
		#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': -key = ' + #key);
		// fail_if: (self -> keymap) >> #key, -1, #key + ' is not unique';
		if: (self -> keymap) >> #key;
			(self -> 'debug_trace') -> (insert: tag_name + ': *** Error key ' + #key + ' is not unique - skipping');
			return;
		/if;
		local: 'urlmapchildren'=map,
			'pathmapchildren'=map;
		#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': #key=' + #key);
		if: (local_defined: 'children');
			(#children -> 'parentkey') = #key;
			// grab urlmap and pathmap from children
			#urlmapchildren = (#children -> urlmap);
			#pathmapchildren = (#children -> pathmap);
			if: !(local_defined: 'title');
				// set default title to labels of children
				/*
				local: 'title' = array;
				iterate: (#children -> 'navitems'), (local: 'item');
					#title -> (insert: (#item -> (find: 'label')));
				/iterate;
				#title = #title ->  (join: ', ');
				*/
			/if;
			#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': adding children');
			(self -> 'debug_trace') -> (merge: (#children -> 'debug_trace'));
			#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': done adding children');
		/if;
		#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': #key=' + #key);
		local: 'navitem'=map;
		local_defined('key') && #key != '' ? #navitem -> insert('key' = #key); 
		local_defined('label') && #label != '' ? #navitem -> insert('label' = #label); 
		local_defined('default') && #default != '' ? #navitem -> insert('default' = #default); 
		local_defined('url') && #url != '' ? #navitem -> insert('url' = #url); 
		local_defined('title') && #title != '' ? #navitem -> insert('title' = #title); 
		local_defined('template') && #template != '' ? #navitem -> insert('template' = #template); 
		local_defined('children') && #children != '' ? #navitem -> insert('children' = #children); 
		local_defined('class') && #class != '' ? #navitem -> insert('class' = #class);
		local_defined('filename') && #filename != '' ? #navitem -> insert('filename' = #filename);
		local_defined('liclass') && #liclass != '' ? #navitem -> insert('liclass' = #liclass);

		if(local_defined('default') && #default != '' && #pathmapchildren >> #default);
			// only add default that exists in children
			#navitem -> insert('default' = #default);
		/if;
		// store these params by reference
		#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': #key=' + #key);
		local_defined('data') && #data != '' ? #navitem -> insert('data' = @#data);

		if: (local_defined: 'param') && #param -> type =='array';
			#navitem -> (insert: 'params'=#param);
		else: (local_defined: 'param') && #param != '';
			#navitem -> (insert: 'params'=(array: #param));
		/if;
		#navitem -> (insert: 'disabled'=(local_defined: 'disabled') && #disabled != false);
		#navitem -> (insert: 'hide'=(local_defined: 'hide') && #hide != false);

        if(local_defined('tbdropdown'));
            // initiate values for the Twitter Bootstrap dropdown #item#
            if(#tbdropdown -> isa('map'));
                // use the custom key values in the map
                #navitem -> insert('tbdropdown' = #tbdropdown);
            else(#tbdropdown != false);
                // set default values
                #navitem -> insert('tbdropdown' = map(
                    'tbdd_liclass' = 'dropdown',
                    'tbdd_aclass' = 'dropdown-toggle',
                    'tbdd_araw' = ' data-toggle="dropdown"',
                    'tbdd_labelappend' = ' <span class="caret"></span>'));
            /if;
        /if;

		#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': #key=' + #key);
		local: 'index'=(self -> 'navitems') -> size + 1;
		if: (local_defined: 'after') && (string: #after) -> size;
			#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': -after=' + #after);
			if: #after -> type == 'integer';
				#index = #after;
			else: (self -> keymap) >> #after;
				#index = (self -> keymap) -> (find: #after) + 1;
			/if;
			#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': index=' + #index);
		/if;
		if: #urlmapchildren -> size;
			// we have urlmap from children - insert it into our urlmap with modified keyvalues
			iterate: #urlmapchildren, (local: 'urlitem');
				fail_if: (self -> urlmap) >> #urlitem -> name, -1, 'url ' + (#urlitem -> name) + ' is not unique';
				(self -> 'urlmap') -> (insert: #urlitem -> name = #key + '/' + (#urlitem -> value));
			/iterate;
		/if;
		if: #pathmapchildren -> size;
			// we have pathmap from children - insert it into our pathmap with modified keys
			iterate: #pathmapchildren, (local: 'pathitem');
				(self -> 'pathmap') -> (insert: #key + '/' + #pathitem -> name);
			/iterate;
		/if;
		#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': #key=' + #key);
		if: (local_defined: 'url') && #url != '';
			#url -> (removeleading: '/') & (removetrailing: '/');
			fail_if: (self -> urlmap) >> #url, -1, 'url ' + #url + ' is not unique';
			(self -> 'urlmap') -> (insert: #url = #key);
		/if;
		(self -> 'pathmap') -> (insert: #key);
		(self -> 'navitems') -> (insert: #navitem, #index);
		// update keymap
		(self -> 'keymap') = map;
		iterate: (self -> 'navitems'), (local: 'item');
			(self -> 'keymap') -> (insert: (#item -> (find: 'key'))  = loop_count);
		/iterate;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"	
	/define_tag;
	
	
	/*
	define_tag: 'remove',	-description='Remove nav object and its children for specified key path. Must update index maps afterwards. ',
		-required='path', -type='string', -copy;
		fail: -1, 'Not implemented'; // This tag is not yet functional
		
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		#path -> removeleading('/') & removetrailing('/');
		local: 'path_remove'=#path -> split('/') -> last;
		#path -> removetrailing(#path_remove) & removetrailing('/');
		// we need to find a reference to the navitems array of maps that contains the nav item to remove
		if: #path -> size;
			local: 'navitem'=@(self -> getnav(#path));
		else;
			local: 'navitem'=@self -> getnav;
		/if;
		// we also need to find a reference to the keymap where we can find the index of the array item to remove
		return: #navitem;
		(#navitem -> getnav) -> remove(#navitem -> keymap -> find(#path_remove));
		
		// invalidate index maps
		(#navitem -> 'keymap') = null;
		(#navitem -> 'pathmap') = null;
		(#navitem -> 'urlmap') = null;

		(self -> 'keymap') = null;
		(self -> 'pathmap') = null;
		(self -> 'urlmap') = null;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;
	*/
	
	define_tag: 'addchildren',	-description='Add nav object as children to specified key path, replacing the current children if any. \
		Must update index maps afterwards. ',
		-required='path',
		-required='children', -type='nav';
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		local: 'navitem'=@(self -> (getnav: #path));
		#navitem -> (insert: 'children' = #children);

		// invalidate index maps
		(#navitem -> 'keymap') = null;
		(#navitem -> 'pathmap') = null;
		(#navitem -> 'urlmap') = null;

		(self -> 'keymap') = null;
		(self -> 'pathmap') = null;
		(self -> 'urlmap') = null;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;
	
	define_tag: 'children', -description='Return reference to the children of the current navigation object map, or for the specified path',
		-optional='path', -copy;  
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		!(local_defined: 'path') ? local: 'path'=(self -> 'patharray');
		if: #path -> type != 'array';
			#path = string: #path;
			#path -> (removeleading: '/') & (removetrailing: '/');
			#path = #path -> (split: '/');
		/if;
		(self -> pathmap) !>> (#path -> (join: '/')) ? return: knop_nav;

		local: 'nav'=@(self -> (getnav: #path));
		if: #nav !>> 'children';
			#nav -> (insert: 'children'=knop_nav);
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: @(#nav -> (find: 'children'));
	/define_tag;
	
	define_tag: 'reindex', -description='To recreate keymap, pathmap and urlmap';
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		(self -> 'keymap') = map;
		(self -> 'pathmap') = map;
		(self -> 'urlmap') = map;
		local: 'key'=null, 'pathitem'=null, 'urlitem'=null, 'url'=string;
		iterate: (self -> 'navitems'), (local: 'navitem');
			#key = #navitem -> (find: 'key');
			#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': key=' + #key);
			(self -> 'keymap') -> (insert: #key = loop_count);
			(self -> 'pathmap') -> (insert: #key);
			if: #navitem -> (find: 'url') != '';
				#url=#navitem -> (find: 'url');
				#url -> (removeleading: '/') & (removetrailing: '/');
				fail_if: (self -> urlmap) >> #url, -1, 'url ' + #url + ' is not unique';
				(self -> 'urlmap') -> (insert: #url = #key);
			/if;
			if: #navitem >> 'children';
				#navitem -> (find: 'children') -> reindex; // recursive
				iterate: (#navitem -> (find: 'children') -> pathmap), #pathitem;
					(self -> 'pathmap') -> (insert: #key + '/' + #pathitem -> name);
				/iterate;
				iterate: (#navitem -> (find: 'children') -> urlmap), #urlitem;
					fail_if: (self -> urlmap) >> #urlitem -> name, -1, 'url ' + (#urlitem -> name) + ' is not unique';
					(self -> 'urlmap') -> (insert: #urlitem -> name = #key + '/' + (#urlitem -> value));
				/iterate;
			/if;
		/iterate;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;
	
	define_tag: 'keymap';
		(self -> 'keymap') -> type != 'map' ? self -> reindex;
		return: (self -> 'keymap');
	/define_tag;
	define_tag: 'pathmap';
		(self -> 'pathmap') -> type != 'map' ? self -> reindex;
		return: (self -> 'pathmap');
	/define_tag;
	define_tag: 'urlmap';
		(self -> 'urlmap') -> type != 'map' ? self -> reindex;
		return: (self -> 'urlmap');
	/define_tag;
	
	define_tag: 'getlocation', -description='Grabs path and actionpath from params or urlhandler, translates from url to path if needed. This must be called before using the nav object. \n\
			Parameters:\n\
			-setpath (optional) forces a new path',
		-optional='setpath';
		handle;knop_debug('Done with ' + self->type + ' -> ' + tag_name, -time, -type=self->type);/handle;
		local: 'path'=string, 
			'patharray'=array, 
			'originalpath'=string, 
			'pathargs'=string,
			'actionpath'=string,
			'validurl'=false;
			// TODO: Produce 404 error for invalid urls
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
			
		(self -> 'path') = string;
		(self -> 'patharray') = array;
		(self -> 'pathargs') = string;
		(self -> 'actionpath') = string;
		// get action path
		local: 'clientparams'=client_getparams;
		#clientparams -> (merge: client_postparams);
		#actionpath = (#clientparams >> '-action' ? (#clientparams -> (find: '-action') -> first -> value) | string);
		#actionpath -> (removeleading: '/') & (removetrailing: '/');
		// validate action path
		#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': testing action path ' + #actionpath);
		if: #actionpath -> size && (self -> pathmap) >> #actionpath;
			#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': found match for action path ' + #actionpath);
			(self -> 'actionpath') = #actionpath;
		/if;

		// get url or path
		if: (local: 'setpath') != '';
			#originalpath = string: #setpath;
		else: (self -> 'navmethod') != 'param'; 
			(self -> 'navmethod') = 'path';
			#originalpath = response_filepath;
			#originalpath -> (removeleading: (self -> 'root'));
		else: (self -> 'navmethod') != 'path';
			(self -> 'navmethod') = 'param';
			if: #clientparams >> '-path';
				// path is sent as -path GET or POST parameter
				#originalpath = (#clientparams >> '-path' ? (#clientparams -> (find: '-path') -> first -> value) | string);
			else: client_getparams -> size && client_getparams -> first -> isa('string');
				// path is sent as first unnamed GET parameter 
				#originalpath = client_getparams -> first;
			/if;
		/if;
		#originalpath -> (removeleading: '/') & (removetrailing: '/');
		#path = #originalpath;
		#patharray = (string: #originalpath) -> (split: '/');
		// look for longest match in urlmap
		local: 'pathfinder'=#patharray;
		loop: #pathfinder -> size;
			#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': looking at url ' + #pathfinder -> (join: '/'));
			if: (self -> urlmap) >> #pathfinder -> (join: '/');
				// use translated key path
				#path=(self -> urlmap) -> (find: #pathfinder -> (join: '/'));
				#validurl=true;
				#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': found url match for ' (#pathfinder -> (join: '/')) + ' translating to ' + #path);
				loop_abort;
			else;
				// remove last path part and try again
				#pathfinder -> remove;
			/if;
		/loop;
		if: !#validurl;
			// no url found, dig into the nav structure to see if path is valid
			local: 'pathfinder'=#patharray;
			loop: #pathfinder -> size;
				#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': looking at path ' + #pathfinder -> (join: '/'));
				if: (self -> pathmap) >> #pathfinder -> (join: '/');
					// use key path
					#path=#pathfinder -> (join: '/');
					#validurl=true;
					#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': found path match for ' (#pathfinder -> (join: '/')));
					loop_abort;
				else;
					// remove last path part and try again
					#pathfinder -> remove;
				/if;
			/loop;
		/if;
		// look for disabled path
		if: #validurl;
			#path = (string: #path) -> (split: '/');
			while: #path -> size > 1 && (self -> (getnav: #path)) -> (find: 'disabled');
				#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': path '+ #path + ' is disabled');
				#path -> remove;
			/while;
			if: (self -> (getnav: #path)) -> (find: 'disabled');
				#validurl = false;
			/if;
			#path = #path -> (join: '/');
		/if;
		
		if: !#validurl;
			// we haven't found a valid location, we must resort to a default page
			if: self -> 'default' != '' && self -> pathmap >>  self -> 'default';
				#path = self -> 'default';
				#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': use default location ' #path);
			else;
				// use first page as default, if it exists
				iterate(self -> 'navitems', local('navitem'));
					if(#navitem >> 'key' 
						&& !(#navitem -> find('disabled')) 
						&& !(#navitem -> find('hide')));
						#path = #navitem -> find('key');
						#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': use first page as default location ' #path);
						loop_abort;
					/if;
				/iterate;
			/if;
			if: (self -> pathmap) >> #path;
				#validurl = true;
				(self -> 'debug_trace') -> (insert: tag_name + ': no navigation seems to be defined ' #path);
			/if;
		/if;
		
		if: #validurl;
			// recursively look for default sub page
			local: 'hasdefault'=true;
			while: #hasdefault;
				local: 'defaultkey' = (self -> (getnav: #path)) -> (find: 'default');
				#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': looking for default key ' + #defaultkey);
				if: !(((self -> (getnav: #path))) -> (find: 'disabled')) 
					&& !(((self -> (getnav: #path + '/' + #defaultkey))) -> (find: 'disabled'))
					&& #defaultkey != '' && (self -> (getnav: #path)) -> (find: 'children') -> keymap >> #defaultkey;
					#path += '/' + #defaultkey;
					#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': new path is ' + #path);
				else;
					#hasdefault=false;
				/if;
			/while;
			
			// look for path arguments = the leftover when we found a matching path
			#pathargs = #originalpath;
			#pathargs -> (removeleading: #pathfinder -> (join: '/')) & (removeleading: '/');
			
			// store values
			(self -> 'path') = #path;
			(self -> 'patharray') = (string: #path) -> (split: '/');
			(self -> 'debug_trace') -> (insert: tag_name + ': path is ' + #path);
			if: #pathargs != '';
				(self -> 'pathargs') = #pathargs;
				(self -> 'debug_trace') -> (insert: tag_name + ': pathargs is ' + #pathargs);
			/if;
		else;
			(self -> 'debug_trace') -> (insert: tag_name + ': no matching path found');
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;
	
	define_tag: 'setlocation', -description='Sets the current location to a specific nav path or url',
		-required='path';
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		self -> (getlocation: -setpath=#path);
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;
	
	
	define_tag: 'setformat', -description='Sets html template for the nav object, use #items# #item# #/items# or more elaborate #items# #link##label##current##/link##children# #/items# as placeholders.\n\
			Parameters:\n\
			-template (optional string) Html template, defaults to <ul>#items#<li>#item#</li>#/items#</ul>\n\
			-class (optional string) CSS class name that will be used for every navigation link\n\
			-currentclass (optional string) CSS class name that will be added to the currently active navigation link (defaults to crnt)\n\
			-currentmarker (optional string) String that will be appended to menu text of currently active navigation link',
		-optional='template', -type='string',
		-optional='class', -type='string',
		-optional='currentclass', -type='string',
		-optional='currentmarker', -type='string';
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		
		(local_defined: 'template') ? (self -> 'template') = #template;
		(local_defined: 'class') ? (self -> 'class') = #class;
		(local_defined: 'currentclass') ? (self -> 'currentclass') = #currentclass;
		(local_defined: 'currentmarker') ? (self -> 'currentmarker') = #currentmarker;
		
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;

	define_tag: 'haschildren',	-description='Returns true if nav object has children that are not all -hide.',
		-required='navitem', -type='map';
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		local: 'haschildren'=#navitem >> 'children';
		if: #haschildren;	// verify that there is at least one child that does not have -hide
			#haschildren=false; // assume there is no child to show
			iterate: #navitem -> (find: 'children') -> 'navitems', (local: 'childitem');
				#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': checking ' + (#childitem -> (find: 'key')) + ', hide=' + (#childitem -> (find: 'hide')));
				if: !(#childitem -> (find: 'hide')); // found one
					#haschildren=true;
					loop_abort;
				/if;
			/iterate;
		/if;
		#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': ' + #haschildren);
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: #haschildren;
	/define_tag;

	define_tag: 'renderhtml', -description='Called recursively to render hierarchial nav structure.\n\
			Parameters:\n\
			-renderpath (optional) Only render the children of the specified path (and below)\n\
			-flat (optional flag) Only render one level\n\
			-expand (optional flag) Render the entire expanded nav tree and not just the currently active branch\n\
			-basepath (optional) Internal, needed for recursive calls to get proper paths\n\
			-ancestor (optional nav) Internal, reference to the topmost object, needed for recursive calls\n\
			-xhtml (optional) XHTML valid output',
		-optional='renderpath', -copy,
		-optional='flat',
		-optional='expand',
		-optional='basepath', -copy,
		-optional='ancestor', -type='nav';
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		if: !(local_defined: 'ancestor');
			handle;knop_debug('Done with ' + self->type + ' -> ' + tag_name, -time, -type=self->type);/handle;
			// reset timer when called at top level
			// (self -> 'timer')=0; // undefined instance variable
		/if;
		
		// create reference to the topmost level nav object
		local: 'topself'=(local_defined: 'ancestor') ? @#ancestor | @self ;
		!(local_defined: 'ancestor') ? (#topself -> 'renderhtml_levels') = 1 | (#topself -> 'renderhtml_levels') += 1;
		
		local: '_flat' = (local_defined: 'flat') && #flat != false;
		local: '_expand' = (local_defined: 'expand') && #expand != false;
		
		local: 'template'=(self -> 'template' != '' ? self -> 'template' | #topself -> 'template');
		local('ulclass' = self->'ulclass');
		local: 'clientparams'=client_getparams;
		#clientparams -> (merge: client_postparams);
		
		!(local_defined: 'basepath') ? local: 'basepath'=string;
		if: #template == '';
			#template = '<ul>#items#<li>#item#</li>#/items#</ul>';
		/if;
		local: 'output'=string,
			'itemoutput'=string,
			'itemchildren'=string,
			'itemrow'=string,
			'link'=string,
			'linkparams'=array,
			'thispath'=string,
			'classarray'=array,
			'currentmarker'=string,
			'itemtemplate'=(string_findregexp: #template, -find='(?si)#items#(.*?)#/items#'),
			'itemlinkstart'=string,
			'itemlinkend'=string,
			'itemlabel'=string,
            'ulclassarray'=array,
            'liclassarray'=array,
            'tbdd_liclass' = string,
            'tbdd_aclass' = string,
            'tbdd_araw' = string,
            'tbdd_labelappend' = string;
		// construct the array of classes for the current <ul>
		if(#template->beginswith('<ul>') && #ulclass != '');
		    #ulclassarray = #ulclass->split(' ');
		/if;
        if(#ulclassarray->size > 0);
            #template = string_replaceregexp(#template, -find='<ul', -replace=('<ul class="' + #ulclassarray->join(' ') + '"'));
        /if;
		#itemtemplate = (#itemtemplate -> size >= 2 ? #itemtemplate -> (get: 2) | string);
		
		if: (local_defined: 'renderpath') && #renderpath != '' && #renderpath != '/';
			// render nav for specified path
			#renderpath -> (removeleading: '/') & (removetrailing: '/');
			if: #topself -> (getnav: #renderpath) -> (find: 'children') -> type == 'nav';
				return: @(#topself -> (getnav: #renderpath) -> (find: 'children') -> (renderhtml: -basepath=#renderpath, 
					-ancestor=#topself, -flat=#_flat, -expand=#_expand));
			else;
				return: string;
			/if;
		/if;
		iterate: (self -> 'navitems'), (local: 'navitem');
			if: #navitem -> (find: 'hide');
				// do not show in navigation
			else;
				#itemlinkstart=string;
				#itemlabel=string;
				#itemlinkend=string;
				#itemchildren = string;
				#currentmarker=string;
                
                #tbdd_liclass = string;
                #tbdd_aclass = string;
                #tbdd_araw = string;
                #tbdd_labelappend = string;

				#thispath=#basepath + '/' + (#navitem -> (find: 'key'));
				#thispath -> (removeleading: '/');
				#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': thispath is ' + #thispath + ', currentpath is ' + (#topself -> 'path'));
				if: (#navitem -> (find: 'template')) != '';
					#itemrow = (#navitem -> (find: 'template'));
				else;
					#itemrow = #itemtemplate;
				/if;
                #liclassarray = array;
                if(#itemrow->beginswith('<li>') && #navitem->find('liclass') != '');
                    #liclassarray = #navitem->find('liclass')->split(' ');
                /if;

                if(#navitem -> find('tbdropdown') -> isa('map'));
                    #tbdd_liclass = #navitem -> find('tbdropdown') -> find('tbdd_liclass');
                    #tbdd_aclass = #navitem -> find('tbdropdown') -> find('tbdd_aclass');
                    #tbdd_araw = #navitem -> find('tbdropdown') -> find('tbdd_araw');
                    #tbdd_labelappend = #navitem -> find('tbdropdown') -> find('tbdd_labelappend');
                /if;

                #tbdd_liclass != '' ? #liclassarray->insert(#tbdd_liclass);

                if: (((#topself -> 'path') + '/') -> (beginswith: #thispath + '/'));
                    if(#topself -> 'currentclasstags' >> 'li');
                        // add the current class to the <li> tag
                        #liclassarray -> (insert: ((#topself -> 'currentclass') != '' ? (#topself -> 'currentclass') | 'crnt') );
                    /if;
                /if;

                if(#liclassarray->size > 0);
                    #itemrow = string_replaceregexp(#itemrow, -find='<li', -replace=('<li class="' + #liclassarray->join(' ') + '"'));
                /if;
				#classarray = array;
				(#topself -> 'class') != '' ? #classarray -> (insert: (#topself -> 'class'));
				(#navitem -> (find: 'class')) != '' ? #classarray -> (insert: (#navitem -> (find: 'class')));

                #tbdd_aclass != '' ? #classarray->insert('dropdown-toggle');

				if: #navitem -> (find: 'disabled');
					#itemlinkstart='<span';
					if: #classarray -> size;
						#itemlinkstart += ' class="' + #classarray -> (join: ' ') + '"';
					/if;
                    #tbdd_araw != '' ? #itemlinkstart += #tbdd_araw;
					#itemlinkstart += '>';
					#itemlabel=(#navitem -> (find: 'label'));
                    #tbdd_labelappend != '' ? #itemlinkend = #tbdd_labelappend;
					#itemlinkend += '</span>';
				else;
					/* this code is moved into ->url
					if: (#navitem -> (find: 'params')) -> type == 'array';
						#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': checking params for ' + #thispath + ' with ' + (#navitem -> (find: 'params')));
						// TODO: Move this to a new member tag ->linkparams: path|navitem
						#linkparams=array;
						iterate: #navitem -> (find: 'params'), (local: 'param');
							if: #clientparams >> #param && #clientparams -> (find: #param) -> first -> type == 'pair';
								#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': got pair param');
								#linkparams -> (insert: #clientparams -> (find: #param) -> first -> name = #clientparams -> (find: #param) -> first -> value);
							else: #clientparams >> #param;
								#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': got plain param');
								#linkparams -> (insert: #clientparams -> (find: #param) -> first);
							/if;
						/iterate;
						#link = (self -> (url: -path=#thispath, -params=self -> (linkparams: -navitem=#navitem), -topself=#topself));
					else;*/
						//#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': no params for ' + #thispath);
						#link = (self -> (url: -path=#thispath, -topself=#topself));
					///if;

					#itemlinkstart = '<a href="' + #link + '"';
					if: (#navitem -> (find: 'title')) != '';
						#itemlinkstart += ' title="' + (encode_html: (#navitem -> (find: 'title'))) + '"';
					/if;
					if: (((#topself -> 'path') + '/') -> (beginswith: #thispath + '/'));
					    if(#topself -> 'currentclasstags' >> 'a' || #topself -> 'currentclasstags' -> size == 0);
					        // add the current class to the <a> tag
    						#classarray -> (insert: ((#topself -> 'currentclass') != '' ? (#topself -> 'currentclass') | 'crnt') );
					    /if;
					/if;
					if: #classarray -> size;
						#itemlinkstart += ' class="' + #classarray -> (join: ' ') + '"';
					/if;
                    #tbdd_araw != '' ? #itemlinkstart += #tbdd_araw;
					#itemlinkstart += '>';
					#itemlabel=(#navitem -> (find: 'label'));
					if: #thispath == (#topself -> 'path');
						if: (self -> 'currentmarker') -> type != 'null';
							#currentmarker = (self -> 'currentmarker');
						else: (#topself -> 'currentmarker') -> type != 'null';
							#currentmarker = (#topself -> 'currentmarker');
						/if;
					/if;
                    #tbdd_labelappend != '' ? #itemlinkend = #tbdd_labelappend;
					#itemlinkend += '</a>';
					if: ( (((#topself -> 'path') + '/') -> (beginswith: #thispath + '/')) || #_expand)
						&& self -> (haschildren: #navitem)
						&& !#_flat;
						// recursively render child items
						#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': begin rendering children for ' + #basepath + '/' + (#navitem -> (find: 'key')) );
						// clear debug_trace for child
						(#navitem -> (find: 'children') -> 'debug_trace') = array;
						#itemchildren += (#navitem -> (find: 'children') -> (renderhtml: -basepath=#basepath + '/' + (#navitem -> (find: 'key')), 
							-ancestor=#topself,
							-flat=#_flat,
							-expand=#_expand));
						#dotrace ? (self -> 'debug_trace') -> (merge: (#navitem -> (find: 'children') -> 'debug_trace'));
						#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': done rendering children');
					/if;
				/if;
				if: #itemrow >> '#link#';
					#itemrow -> (replace: '#link#', #itemlinkstart) 
						& (replace: '#title#', #itemlabel)	// deprecated, use #label# instead
						& (replace: '#label#', #itemlabel)	// preferred
						& (replace: '#/link#', #itemlinkend)
						& (replace: '#children#', #itemchildren);
				else;
					if: #itemrow !>> '#current#';
						#itemlabel += '#current#';
					/if;
					#itemrow -> (replace: '#item#', #itemlinkstart + #itemlabel + #itemlinkend 
						+ #itemchildren);
				/if;
				#itemrow -> (replace: '#current#', #currentmarker);
				#itemoutput += #itemrow;
			/if;
		/iterate;
		#output = (string_replaceregexp: #template, -find='(?si)#items#(.*?)#/items#', -replace=#itemoutput);
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': render done in ' (self -> 'tagtime') + ' ms');
		return: @#output;
	/define_tag;

	define_tag: 'renderbreadcrumb', -description='Shows the current navigation as breadcrumb trail. \n\
			Parameters:\n\
			-delimiter (optional) Specifies the delimiter to use between nav levels, defaults to " > " if not specified\n\
			-home (optional flag) Show the default navigation item (i.e. "home") first in the breadcrumb (unless already there).',
		-optional='delimiter',
		-optional='home',
		-optional='skipcurrent',
		-optional='plain';
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		local: 'output'=array, 'path'=array;
		!(local_defined: 'delimiter') ? local: 'delimiter'=' &gt; ';
		if: (local_defined: 'home') && #home != false;
			// show the default navigation item first in breadcrumb
			
			// find default path
			if: self -> 'default' != '' && self -> pathmap >>  self -> 'default';
				local: 'homepath'= (self -> 'default');
			else;
				// use first top level nav item as default
				local: 'homepath'= self -> 'navitems' -> first -> (find: 'key');
			/if;
			
			if: !((self -> 'path') -> (beginswith: #homepath));
				if: (local_defined: 'plain') && #plain != false;
					#output -> (insert: (self -> (getnav: #homepath)) -> (find: 'label'));
				else;
					#output -> (insert: '<a href="' + (self -> (url: -path=#homepath)) + '">' + (self -> (getnav: #homepath)) -> (find: 'label') + '</a>');				
				/if;
			/if;
		/if;
		iterate: (self -> 'patharray'), (local: 'pathitem');
			#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': pathitem ' #pathitem);
			#path -> (insert: #pathitem);
			if: (self -> (getnav: #path)) -> (find: 'hide');
				// do not show in navigation
				loop_abort;
			else;
				if: (local_defined: 'plain') && #plain != false;
					#output -> (insert: (self -> (getnav: #path)) -> (find: 'label'));
				else;
					#output -> (insert: '<a href="' + (self -> (url: -path=#path)) + '">' + (self -> (getnav: #path)) -> (find: 'label') + '</a>');
				/if;
			/if;
		/iterate;
		if: (local_defined: 'skipcurrent') && #skipcurrent != false;
			#output -> removelast;
		/if;
		#output = #output -> (join: #delimiter);
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: @#output;
	/define_tag;

	define_tag: 'getnav', -description='Return reference to the current navigation object map, or for the specified path.',
		-optional='path', -copy;  
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		!(local_defined: 'path') ? local: 'path'=(self -> 'patharray');
		if: #path -> type != 'array';
			#path = string: #path;
			#path -> (removeleading: '/') & (removetrailing: '/');
			#path = #path -> (split: '/');
		/if;
		(self -> pathmap) !>> (#path -> (join: '/')) ? return: map;

		local: 'nav'=@self,
			'navmap'=map;
		local: 'pathitem' = #path -> (get: 1);
		if: #nav -> keymap >> #pathitem; 
			#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': found ' + #pathitem + ' in nav');
			#navmap = @((#nav -> 'navitems') -> (get: ((#nav -> keymap) -> (find: #pathitem))));
			if: #navmap -> type == 'map' && !(#navmap -> (find: 'disabled')) && #navmap -> (find: 'children') -> type == 'nav' && #path -> size > 1;
				// look into children level recursively - remove the path level we are at now
				#path -> (remove: 1);
				return: @(#navmap -> (find: 'children')) -> (getnav: #path); // recursion
			else;
				// we are at the bottom, bail out
				self -> 'tagtime_tagname'=tag_name;
				self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
				return: @#navmap;
			/if;
		/if;
	/define_tag;


	
	define_tag: 'getargs', -description='Path arguments = the leftover when we found a matching path, to be used for keyvalue for example.\n\
			Parameters:\n\
			-index (optional integer) Specifies which leftover path item to return, defaults to all path items as a string',
		-optional='index', -type='integer';
		local: 'dotrace'=(self -> 'dotrace');
		
		local: 'args'=(self -> 'pathargs');
		#args == '' ? return;
		if: local_defined: 'index';
			#args = #args -> (split: '/');
			if: #args -> size >= #index;
				return: #args -> (get: #index);
			else;
				return;
			/if;
		else;
			return: #args;
		/if;
		
	/define_tag;
	
	define_tag: 'label', -description='Returns the name of the current (or specified) nav location\n\
			Parameters:\n\
			-path (optional)',
		-optional='path', -copy;
		local: 'dotrace'=(self -> 'dotrace');
		!(local_defined: 'path') ? local: 'path'=@(self -> 'path');
		return: self -> (getnav: #path) -> (find: 'label');
	/define_tag;

	define_tag: 'path', -description='Returns url or key path for the current or specified location.',
		-optional='path', -copy;	
		local: 'dotrace'=(self -> 'dotrace');
		!(local_defined: 'path') ? local: 'path'=@(self -> 'path');
		if: self -> (getnav: #path) -> (find: 'url') != '';
			local: 'url'=self -> (getnav: #path) -> (find: 'url');
			#url -> (removeleading: '/') & (removetrailing: '/');
			return: #url;
		else: #path -> type == 'array';
			return: @(#path -> (join: '/'));
		else;
			return: @#path;
		/if;
	/define_tag;

	define_tag: 'patharray', -description='Returns current path as array.';
			return: (self -> 'patharray');
	/define_tag;

	define_tag: 'actionpath', -description='Returns action path if any.';
			return: (self -> 'actionpath');
	/define_tag;

	define_tag: 'linkparams', -description='Returns an array for all parameters that should be sent along with nav links',
		-required='navitem', -type='map';
		if: (#navitem -> (find: 'params')) -> type == 'array';
			local: 'linkparams'=array,
				'dotrace'=(self -> 'dotrace'),
				'clientparams'=client_getparams;
			#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': checking params ' + (#navitem -> (find: 'params')));
			#clientparams -> (merge: client_postparams);
			iterate: #navitem -> (find: 'params'), (local: 'param');
					iterate(#clientparams -> find(#param), local('paraminstance'));
					if: #paraminstance -> type == 'pair';
						#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': got pair param');
						#linkparams -> (insert: (#paraminstance -> name) = (#paraminstance -> value));
					else;
						#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': got plain param');
						#linkparams -> (insert: #paraminstance);
					/if;
				/iterate;
			/iterate;
			return: @#linkparams;
		/if;
	/define_tag;

	define_tag: 'data', -description='Returns data object that can be stored for the current nav location (or specified nav location).\n\
			Parameters:\n\
			-path (optional)\n\
			-type (optional string) Force a certain return type. If the stored object doesn´t match the specified type, an empty instance of the type is returned. That way the data can be filtered by type without having to use conditionals to check the type before. ',
		-optional='path', -copy,
		-optional='type';
		local: 'dotrace'=(self -> 'dotrace');
		!(local_defined: 'path') ? local: 'path'=@(self -> 'path');
		if: (local_defined: 'type');
			if: self -> (getnav: #path) -> (find: 'data') -> type == #type;
				return: self -> (getnav: #path) -> (find: 'data');
			else;
				// return empty instance of the specified type
				return: (\#type)->astype;
			/if;
		else;
			return: self -> (getnav: #path) -> (find: 'data');
		/if;
	/define_tag;

	
	define_tag: 'url', -description='Returns full url for current path or specified path. Path parameters can be provided and overridden by \
			passing them to this tag. \n\
			Parameters:\n\
			-path (optional) \n\
			-params (optional) Pair array to be used in url instead of plain parameters sent to this tag\n\
			-urlargs (optional) Raw string with url parameters to append at end of url and -params\n\
			-getargs (optional flag) Add the getargs (leftover path parts) to the url\n\
			-except (optional) Array of parameter names to exclude (or single parameter name as string)\n\
			-topself (optional nav) Internal, needed to call url from renderhtml when rendering sublevels\n\
			-autoparams (optional flag) Enables the automatic passing of action_params that begin with "-"',
		-optional='path', -copy,
		-optional='params', -copy,
		-optional='urlargs',
		-optional='except', -copy,
		-optional='topself', -type='nav',
		-optional='autoparams';

		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		local: 'url'=string,
			'urlparams'=array;
		// only getparams to not send along -action etc
		local: 'clientparams'=client_getparams, 'param'=null;

		!(local_defined: 'except') ? local: 'except'=array;
		#except -> type != 'array' ? #except = array: #except;
		#except -> insert('-session');
		!(local_defined: 'topself') ? local: 'topself'=@self;
		!(local_defined: 'params') ? local: 'params'=(params -> isa('array') ? params | array);
		!#params -> isa('array') ? #params = array(#params); // added by Jolle 101117
		if: local_defined: 'path';
			if: #params >> '-path';
				// -path was passed as explicit param
				#params -> (removeall: '-path');
			else: #params >> #path;
				// -path was passed as implicit param - shows up in params as plain value (no pair) so remove the value from params
				#params -> (removeall: #path);
			/if;
		else;
			local: 'path'=(#topself -> 'path');
		/if;
		local: 'navitem'=#topself -> getnav: #path;
		if: (#navitem -> (find: 'params')) -> type == 'array';
			// add parameters defined as -param for nav item
			#params -> (merge: (#topself -> (linkparams: -navitem=#navitem)));
		/if;
		if: #params -> isa('array');
			// clean up other parameters passed to he tag
			#params -> (removeall: '-urlargs')
				& (removeall: '-topself')
				& (removeall: '-params')
				& (removeall: '-except')
				& (removeall: '-autoparams')
				& (removeall: '-getargs');
		 /if;

		iterate: #except, (local: 'param');
			#params -> (removeall: #param);
		/iterate;

		#url = (#topself -> (path: #path)) + ((#topself -> (path: #path)) != '' ? '/');
		if: (#topself -> getargs) -> size && (local_defined: 'getargs') && #getargs != false;
			// for links to the current path, add the path args 
			#url += (#topself -> getargs) + '/';
		/if;
		if: #params >> '-keyvalue';
			#url += (#params -> (find: '-keyvalue') -> first -> value) + '/';
			#params -> (removeall: '-keyvalue');
		/if;
		
		iterate: (#params -> type == 'array' ? #params | array: #params), (local: 'param');
			if: #param -> type == 'pair';
				#urlparams -> (insert: (encode_stricturl: #param -> name) + '=' + (encode_stricturl: #param -> value));
			else: #param != '';
				#urlparams -> (insert: (encode_stricturl: #param));
			/if;
		/iterate;
		if: (local_defined: 'autoparams') && #autoparams != false;
			// add getparams that begin with -
			iterate: #clientparams, #param;
				if: #param -> type == 'pair';
					if: #param -> name -> (beginswith: '-') && #except !>> #param -> name;
						#urlparams -> (insert: (encode_stricturl: #param -> name) + '=' + (encode_stricturl: #param -> value));
					/if;
				else; // just a string param (no pair)
					if: #param -> (beginswith: '-') && #except !>> #param;
						#urlparams -> (insert: encode_stricturl: #param);
					/if;
				/if;
			/iterate;
		/if;
		
		if: (#topself -> 'navmethod') == 'param';
			#url = './?' + #url + (#urlparams -> size || (local: 'urlargs') != '' ? '&amp;');
		else;  // path
			#url = (#topself -> 'root') + #url +  (#urlparams -> size || (local: 'urlargs') != '' ? '?');
		/if;

		#urlparams = string: (#urlparams -> (join: '&amp;'));
		// restore / in paths for looks
		#urlparams -> replace('%2f', '/');
		#url += #urlparams;
		#urlparams -> size && (local: 'urlargs') -> size ? #url += '&amp;';
		(local: 'urlargs') -> size ? #url += #urlargs;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: @#url;
	/define_tag;
	
	define_tag: 'filename', -description='Returns the full path to the specified type of precissing file for the current navigation. \n\
			Parameters:\n\
			-type (required) lib, act, cnt, cfg, actcfg',
		-required='type',
		-optional='path', -copy;
		/*
		
		-filenaming can be one of prefix, suffix or extension. 
		Prefix is "the old way". lib_customer.inc.  This is the default if -filenaming is not specified. 
		Suffix is a hybrid, for example customer_lib.inc. 
		Extension is for example customer.lib
		
		The rest is automatic. 
		
		
		Possible places to look for a library file that belongs to the path "customer/edit" (in order of precedence):
		A) -filenaming='prefix' (default)
		1. _mod_customer/lib_customer_edit.inc 		// modular prefixed with module name
		2. _mod_customer/lib_edit.inc				// modular
		3. _mod_customer/_library/lib_customer_edit.inc	// modular separated, prefixed with module name
		4. _mod_customer/_library/lib_edit.inc		// modular separated
		5. _library/lib_customer_edit.inc			// collective ("all modules together") separated. This is the old way. 
		
		B) -filenaming='suffix'
		1. _mod_customer/customer_edit_lib.inc
		2. _mod_customer/edit_lib.inc
		3. _mod_customer/_library/customer_edit_lib.inc
		4. _mod_customer/_library/edit_lib.inc
		5. _library/customer_edit_lib.inc
		
		C) -filenaming='extension'
		1. _mod_customer/customer_edit.lib
		2. _mod_customer/edit.lib
		3. _mod_customer/_library/customer_edit.lib
		4. _mod_customer/_library/edit.lib
		5. _library/customer_edit.lib
		
		The principle is to start looking at the most specific location and then look at more and more generic locations, to be able to do the local override. 

		*/
		
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		local: 'filenamearray'=array, 
			'filenamearray_temp'=array,
			'filename'=string,
			'prefix'=string,
			'type_short'=string,
			'suffix'=string,
			'extension'=string,
			'typefoldermap'=(map: 
				'cfg'='_config/', 
				'actcfg'='_config/', 
				'act'='_action/',
				'lib'='_library/',
				'cnt'='_content/'),
			'typefolder'=string,
			'basefolder'=string,
			'directorytree' = (self -> directorytree);
		if: #type == 'act' || #type == 'actcfg';
			local('path') -> size == 0 ? local('actionpath'=string(self -> 'actionpath')) | local('actionpath'=string(#path));
			#actionpath -> removeleading('/') & removetrailing('/');
			#actionpath == '' ? return;
			#filenamearray = (self -> getnav(#actionpath) -> find('filename'));
			if: #filenamearray  == '';
				#filenamearray=#actionpath;
			/if;
			#filenamearray = #filenamearray -> split('/');
		else;
			local('path') -> size == 0 ? local('path'=string(self -> 'path'));
			#path -> removeleading('/') & removetrailing('/');
			self -> getnav(#path) -> size == 0 ? return;
			#filenamearray=(self -> getnav(#path) -> find('filename'));
			if: #filenamearray == '';
				#filenamearray=#path;
			/if;
			#filenamearray = #filenamearray -> split('/');
		/if;
		#type =='actcfg' ? #prefix = 'cfg' | #prefix = #type;
		#type_short = #prefix;
		#typefolder=#typefoldermap -> (find: #type);

		select: (self -> 'filenaming');
		case: 'suffix';
			#suffix='_' + #prefix;
			#extension='.inc';
			#prefix = '';
		case: 'extension';
			#extension='.' + #prefix;
			#suffix='';
			#prefix = '';
		case; // prefix as default
			#prefix += '_';
			#extension='.inc';
			#suffix='';
		/select;

		local: 'findtimer'=_date_msec;
		loop: 2;
			#basefolder=(array: '', '_knop/') -> (get: loop_count);
			loop: 5;
				#filename = string;
				select: loop_count;
				case: 1;
					// customer/lib_customer_edit.inc
					if: #filenamearray -> size >= 1;
						// at least 1 level, look in module folder
						#filenamearray_temp = #filenamearray;
						#filename = #basefolder + '_mod_' + #filenamearray_temp -> first;
						#filename += '/' + #prefix + (#filenamearray_temp -> (join: '_')) + #suffix + #extension;
					/if;
				case: 2; 
					// customer/lib_edit.inc
					if: #filenamearray -> size >= ((self -> 'filenaming') == 'extension' ? 2 | 1);
						// at least 1 level (2 levels for suffix naming), look in module folder
						#filenamearray_temp = #filenamearray;
						#filename = #basefolder + '_mod_' + #filenamearray_temp -> first;
						#filenamearray_temp -> removefirst;
						#filename += '/' + #prefix + (#filenamearray_temp -> (join: '_')) + #suffix + #extension;
						if(#filenamearray -> size == 1);
							// clean up underscore so filename ends up as lib.inc instead of lib_.inc etc
							#filename -> replace('/' + #type_short + '_' + #extension, '/' + #type_short + #extension);
							#filename -> replace('/_' + #type_short + #extension, '/' + #type_short + #extension);
						/if;
					/if;
				case: 3;
					// customer/_library/lib_customer_edit.inc
					if: #filenamearray -> size >= 2;
						// at least 2 levels, look in module folder
						#filenamearray_temp = #filenamearray;
						#filename = #basefolder + '_mod_' + #filenamearray_temp -> first;
						#filename += '/' + #typefolder + #prefix + (#filenamearray_temp -> (join: '_')) + #suffix + #extension;
					/if;
				case: 4;
					// customer/_library/lib_edit.inc
					if: #filenamearray -> size >= 2;
						// at least 2 levels, look in module folder
						#filenamearray_temp = #filenamearray;
						#filename = #basefolder + '_mod_' + #filenamearray_temp -> first;
						#filenamearray_temp -> removefirst;
						#filename += '/' + #typefolder + #prefix + (#filenamearray_temp -> (join: '_')) + #suffix + #extension;
					/if;
				case;
					// _library/lib_customer_edit.inc
					#filename = #basefolder + #typefolder + #prefix + (#filenamearray -> (join: '_')) 
						+ #suffix + #extension;
				/select;
				if: #filename != '';
					#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': trying ' + (self -> 'fileroot') + #filename );
					if: #directorytree >> #filename;
						//file_exists: (self -> 'fileroot') + #filename;
						// clean up and exit
						#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': ** Found ' + (self -> 'fileroot') + #filename + ' in ' + (_date_msec - #findtimer) ' ms');
						self -> 'tagtime_tagname'=tag_name;
						self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
						return: (self -> 'fileroot') + #filename;
					/if;
				/if;
			/loop;
		/loop;
		// clean exit if nothing was found
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return;

	/define_tag;
	
	define_tag: 'actionconfigfile', -description='Shortcut to filename: actcfg'; return: self -> (filename: 'actcfg'); 	/define_tag;
	define_tag: 'actionfile', -description='Shortcut to filename: act'; 		return: self -> (filename: 'act'); 		/define_tag;
	define_tag: 'configfile', -description='Shortcut to filename: cfg'; 		return: self -> (filename: 'cfg'); 		/define_tag;
	define_tag: 'libraryfile', -description='Shortcut to filename: lib'; 		return: self -> (filename: 'lib'); 		/define_tag;
	define_tag: 'contentfile', -description='Shortcut to filename: cnt'; 		return: self -> (filename: 'cnt'); 		/define_tag;

	define_tag: 'include', -description='Includes any of the files for the current path, fails silently if file does not exist. \n\
			Parameters:\n\
			-file (required) lib, act, cnt, cfg, actcfg or library, action, config, actionconfig, content, or any arbitrary filename',
		-required='file',
		-optional='path';
		knop_debug(self->type + ' -> ' + tag_name + ' ' + params -> first, -type=self->type, -open);
		handle;knop_debug('Done with ' + self->type + ' -> ' + tag_name + ' ' + params -> first, -close, -time, -witherrors);/handle;
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		// includes any of the files for the current path, fails silently if file does not exist
		local: 'translation'=(map:
				'actionconfig'= 'actcfg',
				'action'= 'act',
				'config'= 'cfg',
				'library'= 'lib',
				'content'= 'cnt'),
			'types'=(map: 'actcfg', 'act', 'cfg', 'lib', 'cnt'),
			'result'=string;
		local: 'type'= (#translation >> #file ? #translation -> (find: #file) | #types >> #file ? #file | 'other');
		// find out full filename
		!local_defined('path') ? local('path'=null);
		local: 'filename'=null;
		if: #types >> #type;
			// knop include
			#filename = self -> filename(#type, -path=#path);
		else: (self -> directorytree) >> #file;
			// arbitrary include within the Knop folder structure
			#filename = (self -> 'fileroot') + #file;
		else: (self -> directorytree) >> '_knop/' + #file;
			// arbitrary include one level down in _knop folder
			#filename = (self -> 'fileroot') + '_knop/' + #file;
		/if;
		if: #type == 'cfg' && #filename -> size && (self -> 'actionconfigfile_didrun') == #filename;
			#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': ' + #filename ' has already run as actionconfig');
			//knop_debug(self->type + ' -> ' + tag_name + ': ' + #filename ' has already run as actionconfig');
			return;
		else: #type == 'actcfg';
			// remember that we have run this config file as actionconfig so we don't run the same file again as page config
			(self -> 'actionconfigfile_didrun') = #filename;
		/if;
		if: #filename != '';
			local: 't'=_date_msec;
			#result=@(include: #filename);
			(self -> 'debug_trace') -> (insert: 'Include ' + #file + ': ' + #filename + ' processed in ' + (_date_msec - #t) ' ms');
			//knop_debug(self->type + ' -> ' + tag_name + ' ' + #file + ': ' + #filename + ' processed in ' + (_date_msec - #t) ' ms', -type=self->type);
			self -> 'tagtime_tagname'=tag_name;
			self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
			return: @#result;
		else;
			#dotrace ? (self -> 'debug_trace') -> (insert: 'Include ' + #file + ': no matching filename found');
			knop_debug(self->type + ' -> ' + tag_name + ' ' + #file + ': no matching filename found');
		/if;
	/define_tag;
	
	define_tag: 'library', -description='includes file just as ->include, but returns no output', 
		-required='file',
		-optional='path';
		// includes file just as ->include, but returns no output
		!local_defined('path') ? local('path'=null);
		self -> include(#file, -path=#path);
		// returns nothing
	/define_tag;

	define_tag: 'directorytree', -description='Returns a map of all existing knop file paths', 
		-optional='basepath'; // only used for recursive calls
		local: 'timer'=knop_timer, 'dotrace'=(self -> 'dotrace'); 
		local: 'dirlist'=map;
		if: (self -> 'directorytreemap') -> size;
			// use the stored directory tree that has already been created
			#dirlist = (self -> 'directorytreemap');
			#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': Returning stored directorytree');

		else;
			// first time calling this tag - create the directory tree
			if: (local_defined: 'basepath');
				local: 'path' = #basepath;
			else;
				local: 'path'=(self -> 'fileroot');
			/if;
			!(#path -> (endswith: '/')) ? #path += '/';
			local: 'diritem'=string,
				'dirlist_sub'=map,
				'diritem_sub'=pair;
			iterate: file_listdirectory: #path, #diritem;
				if: !(#diritem -> (beginswith: '.'));
					#dirlist_sub = map;
					#diritem -> (removetrailing: '/');
					if: //#diritem -> (endswith: '/') && 
						((map: '_knop', '_include', '_config', '_action', '_library', '_content') >> #diritem
							|| #diritem -> (beginswith: '_mod_'));
						// recursive call for sub folder within the Knop directory structure
						#dirlist_sub = self -> (directorytree: #path + #diritem);
						iterate: #dirlist_sub, #diritem_sub;
							#dirlist -> (insert: #diritem + '/' +  #diritem_sub -> name);
						/iterate;
					/if;
					// Add item to map, with trailing / if item has sub items (folder contents)
					#dirlist -> (insert: #diritem + (#dirlist_sub -> size ? '/'));
				/if;
			/iterate;
			if: !(local_defined: 'basepath');
				// this was the topmost call in the recursive chain, so store the result
				(self -> 'directorytreemap') = #dirlist;
				#dotrace ? (self -> 'debug_trace') -> (insert: tag_name + ': Creating directorytree');
			/if;
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: #dirlist;
	/define_tag;


	define_tag: 'trace', 
		-optional='html',
		-optional='xhtml';
		local: 'dotrace'=(self -> 'dotrace');

		local: 'endslash' = ((self -> (xhtml: params)) ? ' /' | '');

		local: 'eol'=(local_defined: 'html') || #endslash -> size ? '<br' + #endslash + '>\n' | '\n';

		return: #eol + 'Debug trace for nav $' + (self -> varname)
			+ (!#dotrace ? ' (detailed trace not enabled)' )
			+ #eol + (self -> 'debug_trace') -> (join: #eol) 
			+ #eol;

	/define_tag;

/define_type;


?>
