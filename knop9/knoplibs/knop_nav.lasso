<?LassoScript
//log_critical('loading knop_nav from LassoApp')

/**!
knop_nav
Experimental new leaner version of custom type to handle site navigation menu
**/
define knop_nav => type {

/*

CHANGE NOTES
	2016-06-08	JS	Removed tagtime
	2016-06-08	JS	Changed onconvert to asString
	2016-06-08	JS	Place oncreate signature for named keyword first (for no reason, really)
	2013-08-31	JC	Added support for dropdownheader
	2012-11-26	JC	Added support for divider list item in bootstrap
	2012-11-26	JC	Added param raw
	2012-11-26	JC	Fixes for bootstrap rendering
	2012-09-11	JC	Minor tweak to getlocation adding knop_trim
	2012-07-08	JC	Fixed bug that was using type as a reference instead of a copy in method filename
	2012-06-10	JC	Changed += to append. Changed iterate to query expr. or loop.
	2012-05-19	JC	Changed web_request->scriptURL to web_request->fcgiReq->requestParams->find(::REQUEST_URI)->asString -> split('?') -> first to make it consistent between different Apache platforms
	2012-05-18	JC	Fixed bug in getnav that would change the supplied path param instead of copying it
	2012-05-17	JC	Changed all old style containers to Lasso 9 {} style
	2012-05-17	JC	changed response_filepath to web_request->scriptURL for better handling with virtual urls
	2011-10-08	JC	added support for insert params to be of type void or null
	2011-10-08	JC	added support for target param in urls
	2011-02-27	JC	added support for id in nav links


*/

	parent knop_base

	data public version = '2016-06-08'

	// instance variables
	data public navitems::array = array
	data public pathmap::map = map
	data public urlmap::map = map

	data public default::string = string		// default path, i.e. home page
	data public template::string = string
	data public class::string = string
	data public currentclass::string = string
	data public currentmarker::string = string

	data public actionpath::string = string		// captured from -action parameter in submission
	data public path::string = string			// captured from path param or urlhandler and translated from url
	data public patharray::array = array		// path broken down into elements
	data public pathargs::string = string		// extra path parts that can contain record identification etc
	data public urlparams::array = array		// holds everything needed to generate nav links
	data public navmethod::string = string		// path or param depending on how the nav is propagated. To be able to force path, since url handler doesn't kick in for the start page
	data public filenaming::string = string
	data public directorytreemap::map = map	// contains a list of all existing filenames in the knop directory tree
	data public root::string				// site root
	data public fileroot::string		// root for physical files
	data public renderhtml_levels::integer = 0		// root for physical files
	data public dotrace::boolean = false
	data public actionconfigfile_didrun::string = string	// path to action config file that has been run for the current page load, used to not load the same config again
	data public getlocation_didrun::boolean = false	// flag set when setlocation ran so that not having to do it twice
	data public error_lang::knop_lang = knop_lang('en', true)

/**!
oncreate
Parameters:\n\
			-default (optional) Key of default navigation item\n\
			-root (optional) The root path for the site section that this nav object is used for\n\
			-fileroot (optional) The root for include files, to be able to use a different root for physical files than the logical root of the site. Defaults to the value of -root. \n\
			-navmethod (optional) path or param. Path for "URL designed" URLs, otherwise a -path parameter will be used for the navigation. \n\
			-filenaming (optional) prefix (default), suffix or extension, specifies how include files are named\n\
			-trace (optional flag) If specified debug_trace will be used. Defaults to disabled for performance reasons. \n\
			-template (optional) html template used to render the navigation menu\n\
			-class (optional) default class for all navigation links\n\
			-currentclass (optional) class added for the currently active link\n\
			-currentmarker (optional) character(s) show to the right link of current nav (typically &raquo;)
**/

	public oncreate(
		-template::string,
		-class::string = string,
		-currentclass::string = 'crnt',
		-currentmarker::string = string,
		-default::string = string,
		-root::string = '/',
		-fileroot::string = '/',
		-navmethod::string = string,
		-filenaming::string = 'prefix',
		-trace::boolean = false

	) => {
//	debug => {

		// protect input vars
		#root = #root -> ascopy
		#fileroot = #fileroot -> ascopy

		.'template' = #template
		.'class' = #class
		.'currentclass' = #currentclass
		.'currentmarker' = #currentmarker
		.'default' = #default
		.'navmethod' = #navmethod
		.'filenaming' = #filenaming
		.'dotrace' = #trace

		// normalize slashes
		#root -> removeleading('/') & removetrailing('/')
		#root = '/' + #root + '/'
		#root -> replace('//', '/')
		.'root' = #root

		if(#fileroot != '') => {
			// normalize slashes
			#fileroot -> removeleading('/') & removetrailing('/')
			#fileroot = '/' + #fileroot + '/'
			#fileroot -> replace('//', '/')
			.'fileroot' = #fileroot
		else
			.'fileroot' = #root
		}

//	} // end debug
	}

	public oncreate(
		template::string = string,
		class::string = string,
		currentclass::string = 'crnt',
		currentmarker::string = string,
		default::string = string,
		root::string = '/',
		fileroot::string = '/',
		navmethod::string = string,
		filenaming::string = 'prefix',
		trace::boolean = false

	) => .oncreate(
		-template=#template,
		-class=#class,
		-currentclass=#currentclass,
		-currentmarker?#currentmarker,
		-default=#default,
		-root=#root,
		-fileroot=#fileroot,
		-navmethod=#navmethod,
		-filenaming=#filenaming,
		-trace=#trace)

/**!
Outputs the navigation object in a very basic form, just to see what it contains
**/
	public sanitycheck() => array('navitems' = .'navitems', 'pathmap' = .'pathmap', 'urlmap' = .'urlmap')

/**!
Shortcut to renderhtml
**/
	public asstring() => .renderhtml

/**!
Inserts a nav item into the nav array
**/
	public insert(
		key::string,
		label::any = string,
		default::any = string,
		url::any = string,
		title::any = string,
		id::any = string,
		template::any = string,
		children::any = null,
		param::any = string,
		class::any = string,
		filename::any = string,
		disabled::boolean = false,
		after::any = string,
		target::any = string,
		data::any = string,
		hide::boolean = false,
		raw::string = string,
		divider::boolean = false,
		dropdownheader::boolean = false
	) => {
//	debug => {

		fail_if(#hide == false && #label == '', -1, 'Insert requires a label')

		local(_url = #url -> ascopy)

 		local('navitem' = map(
			'key' = string(#key),
			'label' = string(#label),
			'default' = string(#default),
			'url' = string(#url),
			'title' = string(#title),
			'id' = string(#id),
			'template' = string(#template),
			'param' = string(#param),
			'class' = string(#class),
			'filename' = string(#filename),
			'disabled' = #disabled,
			'after' = string(#after),
			'target' = string(#after),
			'data' = string(#data),
			'hide' = #hide,
			'raw' = #raw,
			'divider' = #divider,
			'dropdownheader' = #dropdownheader
 		))

		if(#children -> isa('knop_nav')) => {
			#navitem -> insert('children' = #children -> 'navitems')
			#navitem -> insert('children_nav' = #children)
			with loopkey in #children -> 'pathmap' -> keys do => {
 				.'pathmap' -> insert(#key + '/' + #loopkey)
			}
		}
		.'navitems' -> insert(#key = #navitem)
		.'pathmap' -> insert(#key)

		if(#_url != '') => {
			#_url -> removeleading('/') & removetrailing('/')
			fail_if(.'urlmap' >> #_url, -1, 'url ' + #_url + ' is not unique')
			.'urlmap' -> insert(#_url = #key)
		}

//	} // end debug
	}

	public insert(
		-key::string,
		-label::any = string,
		-default::any = string,
		-url::any = string, // copy
		-title::any = string,
		-id::any = string,
		-template::any = string,
		-children::any = string,
		-param::any = string,
		-class::any = string,
		-filename::any = string,
		-disabled::boolean = false,
		-after::any = string,
		-target::any = string,
		-data::any = string,
		-hide::boolean = false,
		-raw::string = string,
		-divider::boolean = false,
		-dropdownheader::boolean = false
	) => .insert(#key, #label, #default, #url, #title, #id, #template, #children, #param, #class, #filename, #disabled, #after, #target, #data, #hide, #raw, #divider, #dropdownheader)

/**!
Render hierarchial nav structure.\n\
			Parameters:\n\
			-renderpath (optional) Only render the children of the specified path (and below)\n\
			-flat (optional flag) Only render one level\n\
			-expand (optional flag) Render the entire expanded nav tree and not just the currently active branch\n\
			-xhtml (optional) XHTML valid output

**/
	public renderhtml(
		items::array = array,
		keyval::array = array,
		flat::boolean = true,
		toplevel::boolean = true,
		xhtml::boolean = false,
		patharray = .'patharray' -> ascopy,
		levelcount::integer = 1,
		bootstrap::boolean = false
	) => debug => {

		local(output = string)
		#items -> size == 0 ? #items = .'navitems'

		local(localkeyval = #keyval -> ascopy)
		local(navitem = null)
		local(levelcounted = false)
		.'renderhtml_levels' = #levelcount -> ascopy

		if(#bootstrap) => {

/*
<ul class="nav nav-pills">
            <li class="active"><a href="#">Regular link</a></li>
            <li class="dropdown">
              <a href="#" data-toggle="dropdown" class="dropdown-toggle">Dropdown <b class="caret"></b></a>
              <ul class="dropdown-menu" id="menu1">
                <li><a href="#">Action</a></li>
                <li><a href="#">Another action</a></li>
                <li><a href="#">Something else here</a></li>
                <li class="divider"></li>
                <li><a href="#">Separated link</a></li>
              </ul>
            </li>
            <li class="dropdown">
              <a href="#" data-toggle="dropdown" class="dropdown-toggle">Dropdown 2 <b class="caret"></b></a>
              <ul class="dropdown-menu" id="menu2">
                <li><a href="#">Action</a></li>
                <li><a href="#">Another action</a></li>
                <li><a href="#">Something else here</a></li>
                <li class="divider"></li>
                <li><a href="#">Separated link</a></li>
              </ul>
            </li>
            <li class="dropdown">
              <a href="#" data-toggle="dropdown" class="dropdown-toggle">Dropdown 3 <b class="caret"></b></a>
              <ul class="dropdown-menu" id="menu3">
                <li><a href="#">Action</a></li>
                <li><a href="#">Another action</a></li>
                <li><a href="#">Something else here</a></li>
                <li class="divider"></li>
                <li><a href="#">Separated link</a></li>
              </ul>
            </li>
          </ul>
*/
			local(gotchildren = false)
			local(li_class = array)
			local(a_class = array)

			#output -> append('<ul' + (#toplevel && .'class' -> size > 0 ? ' class="' + .'class' + '"' | ' class="dropdown-menu"') + '>\r')

			with itemtmp in #items do => {
				#navitem = #itemtmp -> value
				#localkeyval -> insert(#navitem -> find('key'))

				if(#navitem -> find('divider')) => {
					#output -> append('<li class="divider"></li>\r')
				else(#navitem -> find('dropdownheader'))
					#output -> append('<li class="' + #navitem -> find('class') + '">' + #navitem -> find('label') + '</li>\r')
				else(not (#navitem -> find('hide')))

					#li_class = array
					#a_class = array
					if(#navitem -> find('class') -> size > 0) => {
						#li_class -> insert(#navitem -> find('class'))
						#a_class -> insert(#navitem -> find('class'))
					}

					#gotchildren = (((not #flat || #patharray -> first == #navitem -> find('key')) && #navitem >> 'children' && #navitem -> find('children') -> isa('array') && #navitem -> find('children') -> size) ? true | false)

					if(#gotchildren) => {
						#li_class -> insert('dropdown')
						#a_class -> insert('dropdown-toggle')
					}

					#output -> append('<li' + (#li_class -> size > 0 ? ' class="' + #li_class -> join(' ') + '"') + '>\r')

					if(#navitem -> find('disabled')) => {
						#output -> append('<a href="#"' + (#navitem -> find('class') -> size > 0 ? ' class="' + #navitem -> find('class') + '"') + ' disabled="disabled">' + #navitem -> find('label') + '</a>')

					else

						#output -> append('<a href="' +
							(.'navmethod' == 'param' ? './?') +
							(#navitem -> find('url') -> size > 0 ? #navitem -> find('url') | '/' + #localkeyval -> join('/') + '/') +
							'"' +
							(#navitem -> find('id') -> size > 0 ? ' id="' + #navitem -> find('id') + '"') +
							(#a_class -> size > 0 ? ' class="' + #a_class -> join(' ') + '"') +
							(#gotchildren ? ' data-toggle="dropdown"') +
							(#navitem -> find('title') -> size > 0 ? ' title="' + #navitem -> find('title') + '"') +
							(#navitem -> find('target') -> size > 0 ? ' target="' + #navitem -> find('target') + '"') +
							(#navitem -> find('raw') -> size > 0 ? ' ' + #navitem -> find('raw')) +
							'>' + #navitem -> find('label') + '</a>'
						)

					} // (#navitem -> find('disabled'))

					if(#gotchildren and not #navitem -> find('disabled')) => {
						local(subpatharray = #patharray -> ascopy)
						#subpatharray -> size > 0 ? #subpatharray -> removefirst
						!#levelcounted ? #levelcount += 1
						#levelcounted = true
						#output -> append(.renderhtml(#navitem -> find('children'), #localkeyval -> ascopy, #flat, false, #xhtml, #subpatharray, #levelcount, true))
					} // (!#flat || #patharray -> first == #navitem -> find('key')) && #navitem >> 'children' && #navitem -> find('children') -> isa('array') && #navitem -> find('children') -> size
					#output -> append('</li>\n')
				} // !(#navitem -> find('hide'))
				#localkeyval = #keyval -> ascopy
			} //with
			#output -> append('</ul>\r')
		else // not bootstrap
			#output -> append('<ul' + (#toplevel && .'class' -> size > 0 ? ' class="' + .'class' + '"') + '>\r')

			with itemtmp in #items do => {
				#navitem = #itemtmp -> value
				#localkeyval -> insert(#navitem -> find('key'))

				if(!(#navitem -> find('hide'))) => {
					#output -> append('<li' + (#navitem -> find('class') -> size > 0 ? ' class="' + #navitem -> find('class') + '"') + '>\r')

					if(#navitem -> find('disabled')) => {
						#output -> append('<span' + (#navitem -> find('class') -> size > 0 ? ' class="' + #navitem -> find('class') + '"') + ' disabled="disabled">' + #navitem -> find('label') + '</span>')

					else
	/* code from original nav
			if((#topself -> 'navmethod') == 'param') => {
				#url = './?' + #url + (#urlparams -> size || (local: 'urlargs') != '' ? '&amp;')
			else  // path
				#url = (#topself -> 'root') + #url +  (#urlparams -> size || (local: 'urlargs') != '' ? '?')
			}
	TODO Still need to implement urlparams support
	*/

						#output -> append('<a href="' +
							(.'navmethod' == 'param' ? './?') +
							(#navitem -> find('url') -> size > 0 ? #navitem -> find('url') | '/' + #localkeyval -> join('/') + '/') +
							'"' +
							(#navitem -> find('id') -> size > 0 ? ' id="' + #navitem -> find('id') + '"') +
							(#navitem -> find('class') -> size > 0 ? ' class="' + #navitem -> find('class') + '"') +
							(#navitem -> find('title') -> size > 0 ? ' title="' + #navitem -> find('title') + '"') +
							(#navitem -> find('target') -> size > 0 ? ' target="' + #navitem -> find('target') + '"') +
							(#navitem -> find('raw') -> size > 0 ? ' ' + #navitem -> find('raw')) +
							'>' + #navitem -> find('label') + '</a>'
						)

					} // (#navitem -> find('disabled'))

					if((!#flat || #patharray -> first == #navitem -> find('key')) && #navitem >> 'children' && #navitem -> find('children') -> isa('array') && #navitem -> find('children') -> size) => {
						local(subpatharray = #patharray -> ascopy)
						#subpatharray -> size > 0 ? #subpatharray -> removefirst
						!#levelcounted ? #levelcount += 1
						#levelcounted = true
						#output -> append(.renderhtml(#navitem -> find('children'), #localkeyval -> ascopy, #flat, false, #xhtml, #subpatharray, #levelcount))
					} // (!#flat || #patharray -> first == #navitem -> find('key')) && #navitem >> 'children' && #navitem -> find('children') -> isa('array') && #navitem -> find('children') -> size
					#output -> append('</li>\r')
				} // !(#navitem -> find('hide'))
				#localkeyval = #keyval -> ascopy
			} //with
			#output -> append('</ul>\r')
		}

		return #output
	}

	public renderhtml(
		-items::array = array,
		-keyval::array = array,
		-flat::boolean = true,
		-toplevel::boolean = true,
		-xhtml::boolean = false,
		-patharray = .'patharray' -> ascopy,
		-levelcount::integer = 1,
		-bootstrap::boolean = false
	) => .renderhtml(#items, #keyval, #flat, #toplevel, #xhtml, #patharray, #levelcount, #bootstrap)

/**!
setlocation
Sets the current location to a specific nav path or url
**/
	public setlocation(
		path::string
	) => {

		.getlocation(#path)

	}

	public setlocation(
		-path::string
	) => .setlocation(#path)

/**!
getlocation
Grabs path and actionpath from params or urlhandler, translates from url to path if needed. This must be called before using the nav object. \n\
			Parameters:\n\
			-setpath (optional) forces a new path
**/
	public getlocation(
		setpath::string = '',
		refresh::boolean = false
	) => {
//	debug => {

		#refresh ? .'getlocation_didrun' = false

		if(!.'getlocation_didrun' || #setpath -> size > 0) => {

			local('path'=string,
				'patharray'=array,
				'originalpath'=string,
				'pathargs'=string,
				'actionpath'=string,
				'validurl'=false)
				// TODO: Produce 404 error for invalid urls

			.'path' = string
			.'patharray' = array
			.'pathargs' = string
			.'actionpath' = string

			local(clientparams = tie(web_request -> queryParams, web_request -> postParams) -> asStaticArray)

			// get action path
			#actionpath = (#clientparams >> '-action' ? string(#clientparams -> find('-action') -> first -> value) -> knop_trim('/')& | string)

			// validate action path
			if(#actionpath -> size && .'pathmap' >> #actionpath) => {
				.'actionpath' = #actionpath
			}

			// get url or path
			if(#setpath -> size) => {
				#originalpath = string(#setpath)
				.'getlocation_didrun' = true
			else(.'navmethod' != 'param')
				.'navmethod' = 'path'
				#originalpath = knop_response_filepath
				#originalpath -> removeleading(.'root')
			else(.'navmethod' != 'path')
				.'navmethod' = 'param'
				if(#clientparams >> '-path') => {
					// path is sent as -path GET or POST parameter
					#originalpath = string(#clientparams -> find('-path') -> first -> value)
				else(client_getparams -> size && client_getparams -> first -> value == null)
					// path is sent as first unnamed GET parameter
					#originalpath = string(client_getparams -> first -> name)
				}
			}

			#originalpath -> removeleading('/') & removetrailing('/')

			#path = #originalpath -> ascopy
			#patharray = string(#originalpath) -> split('/')
			// look for longest match in urlmap
			local('pathfinder' = #patharray -> ascopy)

			loop(#pathfinder -> size) => {

				if(.urlmap >> #pathfinder -> join('/')) => {
					// use translated key path
					#path = .urlmap -> find(#pathfinder -> join('/'))
					#validurl = true

					loop_abort
				else
					// remove last path part and try again
					#pathfinder -> remove
				}
			}

			if(!#validurl) => {

				// no url found, dig into the nav structure to see if path is valid
				local('pathfinder' = #patharray -> ascopy)

				loop(#pathfinder -> size) => {

					if(.'pathmap' >> #pathfinder -> join('/')) => {
						// use key path
						#path = #pathfinder -> join('/')
						#validurl = true

						loop_abort
					else
						// remove last path part and try again
						#pathfinder -> remove
					}
				}
			}

			// look for disabled path
			if(#validurl) => {

				#path = string(#path) -> split('/')
				while(#path -> size > 1 && .getnav(#path) -> find('disabled')) => {
					#path -> remove
				}

				if(.getnav(#path) -> find('disabled')) => {
					#validurl = false
				}

				#path = #path -> join('/')
			}

			if(!#validurl) => {

				// we haven't found a valid location, we must resort to a default page
				if(.'default' != '' && .'pathmap' >>  .'default') => {
					#path = .'default'
				else
					// use first page as default, if it exists
					local(loopvalue = string)
					loop(.'navitems' -> size) => {
						#loopvalue = .'navitems' -> get(loop_count)
						if(#loopvalue -> value >> 'key'
							&& !(#loopvalue -> value -> find('disabled'))
							&& !(#loopvalue -> value -> find('hide'))) =>{
							#path = #loopvalue -> value -> find('key')
							loop_abort
						}
					}
				}
				if(.'pathmap' >> #path) => {
					#validurl = true
				}
			}

			if(#validurl) => {

				// recursively look for default sub page
				local('hasdefault' = true)
				while(#hasdefault) => {
					local('base_path' = .getnav(#path))
					local('defaultkey' = #base_path -> find('default'))
					local('key_path' = .getnav(#path + '/' + #defaultkey))

					if(!(.getnav(#path) -> find('disabled'))
						&& !(.getnav(#path + '/' + #defaultkey) -> find('disabled'))
						&& #defaultkey != '' && .getnav(#path) -> find('children_nav') && .getnav(#path) -> find('children_nav') -> 'pathmap' >> #defaultkey) => {

						#path -> append('/' + #defaultkey)
					else

						#hasdefault = false
					}
				}

				// look for path arguments = the leftover when we found a matching path
				#pathargs = #originalpath
				#pathargs -> removeleading(#pathfinder -> join('/')) & removeleading('/')

				// store values
				.'path' = #path
				.'patharray' = string(#path) -> split('/')
				if(#pathargs != '') => {
					.'pathargs' = #pathargs
				}
			else

			}
			.'getlocation_didrun' = true
		} // (!.'getlocation_didrun')

//	} // end debug
	}

	public getlocation(
		-setpath::string,
		-refresh::boolean = false
	) => .getlocation(#setpath, #refresh)

/**!
label
Returns the name of the current (or specified) nav location
			Parameters:
			-path (optional)
**/
	public label(
		path::string = .'path'
	) => .getnav(#path) -> find('label')

	public label(
		-path::string
	) => .getnav(#path) -> find('label')

/**!
path
Returns url or key path for the current or specified location
			Parameters:
			-path (optional)
**/
	public path(
		path::string = .'path'
	) => {

		local(url = .getnav(#path) -> find('url'))
		if(#url != '' && #url != void) => {
			#url -> knop_trim('/')
			return #url
		else(#path -> type == 'array')
			return #path -> join( '/')
		}
		return #path
	}

	public path(
		-path::string
	) => .path(#path)

/**!
patharray
Returns current path as array.
**/
	public patharray() => .'patharray'

/**!
actionpath
Returns current path as array.
**/
	public actionpath() => .'actionpath'

/**!
actionconfigfile
Shortcut to filename: actcfg.
**/
	public actionconfigfile() => .filename('actcfg')

/**!
actionfile
Shortcut to filename: act.
**/
	public actionfile() => .filename('act')

/**!
configfile
Shortcut to filename: cfg.
**/
	public configfile() => .filename('cfg')

/**!
libraryfile
Shortcut to filename: lib.
**/
	public libraryfile() => .filename('lib')

/**!
contentfile
Shortcut to filename: cnt.
**/
	public contentfile() => .filename('cnt')

/**!
library
includes file just as ->include, but returns no output.
**/
	public library(file::string, path = null) => {.include(#file, #path)}

	public library(-file::string, -path = null) => {.include(#file, #path)}

/**!
directorytree
Returns a map of all existing knop file paths.
**/
	public directorytree(basepath::string = .'fileroot', firstrun::boolean = true) => {

		.'directorytreemap' -> size > 0 ? return .'directorytreemap'

		// first time calling this tag - create the directory tree
		local(path = #basepath -> ascopy)

		!(#path -> endswith('/')) ? #path -> append('/')

		local('dirlist' = map)
		local('diritem' = string)
		local('dirlist_sub' = map)
		local('defaultitems' = map('_knop', '_include', '_config', '_action', '_library', '_content'))

		with diritem in file_listdirectory(#path) do {

			if(!(#diritem -> beginswith('.'))) => {
				#dirlist_sub = map
				#diritem -> removetrailing('/')
				if(//loop_value -> endswith('/') &&
					(#defaultitems >> #diritem
						|| #diritem -> beginswith('_mod_'))) => {
					// recursive call for sub folder within the Knop directory structure
					#dirlist_sub = .directorytree(#path + #diritem, false)

					with loopkey in #dirlist_sub -> keys do => {
						#dirlist -> insert(#diritem + '/' +  #loopkey)
					}
				}
				// Add item to map, with trailing / if item has sub items (folder contents)
				#dirlist -> insert(#diritem + (#dirlist_sub -> size ? '/'))
			}
		}

		#firstrun ? .'directorytreemap' = #dirlist
		// this was the topmost call in the recursive chain, so store the result

		return #dirlist

	}

/**!
url
Returns full url for current path or specified path. Path parameters can be provided and overridden by \
			passing them to this tag. \n\
			Parameters:\n\
			-path (optional) \n\
			-params (optional) Pair array to be used in url instead of plain parameters sent to this tag\n\
			-urlargs (optional) Raw string with url parameters to append at end of url and -params\n\
			-getargs (optional flag) Add the getargs (leftover path parts) to the url\n\
			-except (optional) Array of parameter names to exclude (or single parameter name as string)\n\
			-topself (optional nav) Internal, needed to call url from renderhtml when rendering sublevels\n\
			-autoparams (optional flag) Enables the automatic passing of action_params that begin with "-"
**/
	public url(
		path::string = '',
		params::any = array,
		urlargs::string = '',
		getargs::boolean = true,
		except::any = array,
		topself::knop_nav = self,
		autoparams::boolean = false,
		...

	) => {

		#path = #path -> ascopy

		#params = #params -> ascopy
		!#params -> isa(::array) ? #params = array(#params)
		#params = .scrubKeywords(#params) -> asarray

		#except = #except -> ascopy
		!#except -> isa(::array) ? #except = array(#except)

		local(url = string)
		local(urlparams = array)

		// only getparams to not send along -action etc
		local(clientparams = client_getparams)
		local(param = null)

//		(#params -> size == 0 && #rest -> isa('staticarray') ? #params = .scrubKeywords(#rest) -> asarray)

		if(#path -> size) => {
			if(#params >> '-path') => {
				#params -> removeall('-path')
			else(#params >> #path)
				// -path was passed as implicit param - shows up in params as plain value (no pair) so remove the value from params
				#params -> removeall(#path)
			}
		else
			#path = .'path'
		}

		local('navitem' = .getnav(#path))
		if(#navitem -> find('params') -> type == 'array') => {
			// add parameters defined as -param for nav item
			#params -> merge(.linkparams(-navitem = #navitem))
		}

		with excepttmp in #except do => {
			#params -> removeall(#excepttmp)
		}

		#url = (.path(#path) + (.path(#path) != '' ? '/'))
		if(.getargs -> size > 0 && #getargs) => {
			// for links to the current path, add the path args
			#url -> append(.getargs + '/')
		}

		if(#params >> '-keyvalue') => {
			#url -> append(#params -> find('-keyvalue') -> first -> value + '/')
			#params -> removeall('-keyvalue')
		}

		with param in #params do => {

			if(#param -> type == 'pair') => {
				#urlparams -> insert(encode_stricturl(#param -> name) + '=' + encode_stricturl(string(#param -> value)))
			else(#param != '' && #param != void && #param != null)
				#urlparams -> insert(encode_stricturl(string(#param)))
			}
		}

		if(#autoparams) => {
			// add getparams that begin with -
			with param in #clientparams do => {
				if(#param -> isa(::pair)) => {
					if(#param -> name -> beginswith('-') && #except !>> #param -> name) => {
						#urlparams -> insert(encode_stricturl(string(#param -> name)) + '=' + encode_stricturl(string(#param -> value)))
					}
				else // just a string param (no pair)
					if(#param -> beginswith('-') && #except !>> #param) => {
						#urlparams -> insert(encode_stricturl(string(#param)))
					}
				}
			}
		}
		if(.'navmethod' == 'param') => {
			#url = './?' + #url + (#urlparams -> size || #urlargs != '' ? '&amp;')
		else  // path
			#url = .'root' + #url +  (#urlparams -> size || #urlargs != '' ? '?')
		}

		#urlparams = string(#urlparams -> join('&amp;'))
		// restore / in paths for looks
		#urlparams -> replace('%2f', '/')
		#url -> append(#urlparams)

		#urlparams -> size && #urlargs -> size ? #url -> append('&amp;')
		#urlargs -> size ? #url -> append(#urlargs)

		return #url

	}

	public url(
		-path::string = '',
		-params::any = array,
		-urlargs::string = '',
		-getargs::boolean = true,
		-except::any = array,
		-topself::knop_nav = self,
		-autoparams::boolean = false,
		...

	) => .url(#path, #params, #urlargs, #getargs, #except, #topself, #autoparams, #rest)

/**!
filename
Returns the full path to the specified type of precissing file for the current navigation. \n\
			Parameters:\n\
			-type (required) lib, act, cnt, cfg, actcfg
**/
	public filename(
		type::string,
		path::string = ''
	) => {

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
		local(timer = knop_timer)

		local('filenamearray' = array,
			'filenamearray_temp' = array,
			'filename' = string,
			'prefix' = string,
			'type_short' = string,
			'suffix' = string,
			'extension' = string,
			'typefoldermap' = map(
				'cfg' = '_config/',
				'actcfg' = '_config/',
				'act' = '_action/',
				'lib' = '_library/',
				'cnt' = '_content/'),
			'typefolder' = string,
			'basefolder' = string,
			'directorytree' = .directorytree
			)

		if(#type == 'act' || #type == 'actcfg') => {
			local('actionpath' = string(#path -> size == 0 ? .'actionpath' | #path))
			#actionpath -> knop_trim('/')
			#actionpath == '' ? return
			#filenamearray = .getnav(#actionpath) -> find('filename')
			#filenamearray  == '' ? #filenamearray = #actionpath
			#filenamearray = #filenamearray -> split('/')
		else
			#path -> size == 0 ? #path = string(.'path')
			#path -> knop_trim('/')
			.getnav(#path) -> size == 0 ? return
			#filenamearray = .getnav(#path) -> find('filename')
			#filenamearray  == '' ? #filenamearray = #path
			#filenamearray = #filenamearray -> split('/')
		}
		#type =='actcfg' ? #prefix = 'cfg' | #prefix = string(#type)
		#type_short = #prefix
		#typefolder = #typefoldermap -> find(#type)

		match(.'filenaming') => {
			case('suffix')
				#suffix = '_' + #prefix
				#extension = '.inc'
				#prefix = ''
			case('extension')
				#extension = '.' + #prefix
				#suffix = ''
				#prefix = ''
			case // prefix as default
				#prefix -> append('_')
				#extension = '.inc'
				#suffix = ''
		}

		local('findtimer' = _date_msec)

		loop(2) => {
			#basefolder = array('', '_knop/') -> get(loop_count)
			loop(5) => {
				#filename = string
				match(loop_count) => {
					case(1)
						// customer/lib_customer_edit.inc
						if(#filenamearray -> size >= 1) => {
							// at least 1 level, look in module folder
							#filenamearray_temp = #filenamearray -> ascopy
							#filename = #basefolder + '_mod_' + string(#filenamearray_temp -> first)
							#filename -> append('/' + string(#prefix) + string(#filenamearray_temp -> join('_')) + string(#suffix) + string(#extension))
						}

					case(2)
						// customer/lib_edit.inc
						if(#filenamearray -> size >= ((self -> 'filenaming') == 'extension' ? 2 | 1)) => {
							// at least 1 level (2 levels for suffix naming), look in module folder
							#filenamearray_temp = #filenamearray -> ascopy
							#filename = #basefolder + '_mod_' + string(#filenamearray_temp -> first)
							#filenamearray_temp -> removefirst
							#filename -> append('/' + string(#prefix) + string(#filenamearray_temp -> join('_')) + string(#suffix) + string(#extension))
							if(#filenamearray -> size == 1) => {
								// clean up underscore so filename ends up as lib.inc instead of lib_.inc etc
								#filename -> replace('/' + string(#type_short) + '_' + string(#extension), '/' + string(#type_short) + string(#extension))
								#filename -> replace('/_' + string(#type_short) + string(#extension), '/' + string(#type_short) + string(#extension))
							}
						}

					case(3)
						// customer/_library/lib_customer_edit.inc
						if(#filenamearray -> size >= 2) => {
							// at least 2 levels, look in module folder
							#filenamearray_temp = #filenamearray -> ascopy
							#filename = #basefolder + '_mod_' + string(#filenamearray_temp -> first)
							#filename -> append('/' + string(#typefolder) + string(#prefix) + string(#filenamearray_temp -> join('_')) + string(#suffix) + string(#extension))
						}

					case(4)
						// customer/_library/lib_edit.inc
						if(#filenamearray -> size >= 2) => {
							// at least 2 levels, look in module folder
							#filenamearray_temp = #filenamearray -> ascopy
							#filename = #basefolder + '_mod_' + string(#filenamearray_temp -> first)
							#filenamearray_temp -> removefirst
							#filename -> append('/' + string(#typefolder) + string(#prefix) + string(#filenamearray_temp -> join('_')) + string(#suffix) + string(#extension))
						}

					case
						// _library/lib_customer_edit.inc
						#filename = #basefolder + string(#typefolder) + string(#prefix) + string(#filenamearray -> join('_')) 							+ string(#suffix) + string(#extension)

				}

				if(#filename != '') => {
//					#dotrace ? (self -> 'debug_trace') -> insert(tag_name + ': trying ' + (self -> 'fileroot') + #filename )

					if(#directorytree >> #filename) => {
						//file_exists((self -> 'fileroot') + #filename)
						// clean up and exit
//						#dotrace ? (self -> 'debug_trace') -> insert(tag_name + ': ** Found ' + (self -> 'fileroot') + #filename + ' in ' + (_date_msec - #findtimer) ' ms')
//						self -> 'tagtime_tagname'=tag_name
//						..'tagtime' = integer(#timer) // cast to integer to trigger onconvert and to "stop timer"
						return(.'fileroot' + #filename)
					}
				}
			}
		}

		// clean exit if nothing was found
//		..'tagtime' = integer(#timer) // cast to integer to trigger onconvert and to "stop timer"

		return

	}

	public filename(
		-type::string,
		-path::string = ''
	) => .filename(#type, #path)

	public filename(
		type::string,
		-path::string = ''
	) => .filename(#type, #path)

	public pathmap() => .'pathmap'

	public urlmap() => .'urlmap'

/**!
include
Includes any of the files for the current path, fails silently if file does not exist. \n\
			Parameters:\n\
			-file (required) lib, act, cnt, cfg, actcfg or library, action, config, actionconfig, content, or any arbitrary filename
**/
	public include(
		file::string,
		path::string = ''
	) => {

		local(timer = knop_timer)

		local('translation' = map(
				'actionconfig'= 'actcfg',
				'action'= 'act',
				'config'= 'cfg',
				'library'= 'lib',
				'content'= 'cnt'))
		local('types' = map('actcfg', 'act', 'cfg', 'lib', 'cnt'))
		local('result' = string)
		local('type'= (#translation >> #file ? #translation -> find(#file) | #types >> #file ? #file | 'other'))
		// find out full filename
		local('filename' = string)
		if(#types >> #type) => {
			// knop include
			#filename = .filename(#type, #path)
		else(.directorytree >> #file)
			// arbitrary include within the Knop folder structure
			#filename = .'fileroot' + #file
		else(.directorytree >> '_knop/' + #file)
			// arbitrary include one level down in _knop folder
			#filename = .'fileroot' + '_knop/' + #file
		}

		if(#type == 'cfg' && #filename -> size && .'actionconfigfile_didrun' == #filename) => {
//			#dotrace ? (self -> 'debug_trace') -> insert(tag_name + ': ' + #filename ' has already run as actionconfig')
			//knop_debug(self->type + ' -> ' + tag_name + ': ' + #filename ' has already run as actionconfig')
			return
		else(#type == 'actcfg')
			// remember that we have run this config file as actionconfig so we don't run the same file again as page config
			.'actionconfigfile_didrun' = string(#filename)
		}

		if(#filename -> size > 0) => {
			local('t' = _date_msec)
			#result = include(#filename)
//			(self -> 'debug_trace') -> insert('Include ' + #file + ': ' + #filename + ' processed in ' + (_date_msec - #t) ' ms')
			//knop_debug(self->type + ' -> ' + tag_name + ' ' + #file + ': ' + #filename + ' processed in ' + (_date_msec - #t) ' ms', -type=self->type)
//			self -> 'tagtime_tagname'=tag_name
//			..'tagtime' = integer(#timer) // cast to integer to trigger onconvert and to "stop timer"
			return #result
		else
//			#dotrace ? (self -> 'debug_trace') -> insert('Include ' + #file + ': no matching filename found')
//			knop_debug(self->type + ' -> ' + tag_name + ' ' + #file + ': no matching filename found')
		}

	}

	public include(
		-file::string,
		-path::string = ''
	) => .include(#file, #path)

/**!
getnav
Return reference to the current navigation object map, or for the specified path.
**/
	public getnav(
		path::any = .'patharray' -> ascopy
	) => {

		local(timer = knop_timer)

		local(_path = #path -> ascopy)

		if(#_path -> type != 'array') => {
			#_path = string(#_path)
			#_path -> knop_trim('/')
			#_path = #_path -> split('/')
		}

		.'pathmap' !>> #_path -> join('/') ? return(map)

		return .findnav(#_path, .'navitems')

	}

	public getnav(
		-path::any
	) => .getnav(#path)

	private findnav(
		path::array,
		navitems::array
	) => {

		local('navitem' = #navitems -> find(#path -> get(1)))
		if(#navitem -> first -> isa('pair')) => {
			local('navmap' = #navitem -> first -> value)
			if(#navmap -> type == 'map' && !(#navmap -> find('disabled')) && #navmap -> find('children') && #path -> size > 1) => {
				#path -> remove(1)
				return .findnav(#path, #navmap -> find('children'))
			else
				// we are at the bottom, bail out
				return #navmap
			}

		}
		return map

	}

/**!
getargs
Path arguments = the leftover when we found a matching path, to be used for keyvalue for example.\n\
			Parameters:\n\
			-index (optional integer) Specifies which leftover path item to return, defaults to all path items as a string
**/
	public getargs(
		index::integer = -1
	) => {

		if(#index < 1) => {
			return .'pathargs'
		else
			local('args' = .'pathargs' -> split('/'))
			if(#args -> size >= #index) => {
				return(#args -> get(#index))
			}
		}
		return
	}

	public getargs(
		-index::integer
	) => .getargs(#index)

/**!
linkparams
Returns an array for all parameters that should be sent along with nav links
**/
	public linkparams(
		navitem::map
	) => {

		if((#navitem -> find('params')) -> isa('array')) => {
			local('linkparams' = array)
			local('clientparams' = knop_client_params)

			with param in #navitem -> find('params') do => {
				with paraminstance in #clientparams -> find(#param) do => {
					if(#paraminstance -> type == 'pair') => {
						#linkparams -> insert((#paraminstance -> name) = (#paraminstance -> value))
					else
						#linkparams -> insert(#paraminstance)
					}
				}
			}
			return(#linkparams)
		}
	}

	public linkparams(
		-navitem::map
	) => .linkparams(#navitem)

/**!
children
Return reference to the children of the current navigation object map, or for the specified path
**/
	public children(
		path::any = .'patharray' -> ascopy
	) => {

		local(timer = knop_timer)

		if(!#path -> isa('array')) => {
			#path = string(#path)
			#path -> knop_trim('/')
			#path = #path -> split('/')
		}
		.'pathmap' !>> (#path -> join('/')) ? return(knop_nav)

		local('nav' = .getnav(#path))
		if(#nav !>> 'children') => {
			#nav -> insert('children' = knop_nav)
		}
// 		..'tagtime' = integer(#timer) // cast to integer to trigger onconvert and to "stop timer"

		return(#nav -> find('children'))

	}

	public children(
		-path::any
	) => .children(#path)

/**!
addchildren
Add nav object as children to specified key path, replacing the current children if any.
**/
	public addchildren(
		path::string,
		children::knop_nav
	) => {

		local(timer = knop_timer)

		local('navitem' = .getnav(#path))
		#navitem -> insert('children' = #children)

/*
		// invalidate index maps
		(#navitem -> 'keymap') = null
		(#navitem -> 'pathmap') = null
		(#navitem -> 'urlmap') = null

		(self -> 'keymap') = null
		(self -> 'pathmap') = null
		(self -> 'urlmap') = null

*/
// 		..'tagtime' = integer(#timer) // cast to integer to trigger onconvert and to "stop timer"

	}

	public addchildren(
		-path::string,
		-children::knop_nav
	) => .addchildren(#path, #children)

/**!
setformat
Sets html template for the nav object, use #items# #item# #/items# or more elaborate #items# #link##label##current##/link##children# #/items# as placeholders.\n\
			Parameters:\n\
			-template (optional string) Html template, defaults to <ul>#items#<li>#item#</li>#/items#</ul>\n\
			-class (optional string) Css class name that will be used for every navigation link\n\
			-currentclass (optional string) Css class name that will be added to the currently active navigation link (defaults to crnt)\n\
			-currentmarker (optional string) String that will be appended to menu text of currently active navigation link
**/
	public setformat(
		template::string = string,
		class::string = string,
		currentclass::string = string,
		currentmarker::string = string
	) => {

		local(timer = knop_timer)

		#template -> size > 0 ? .'template' = #template
		#class -> size > 0 ? .'class' = #class
		#currentclass -> size > 0 ? .'currentclass' = #currentclass
		#currentmarker -> size > 0 ? .'currentmarker' = #currentmarker

// 		..'tagtime' = integer(#timer) // cast to integer to trigger onconvert and to "stop timer"

	}

	public setformat(
		-template::string = string,
		-class::string = string,
		-currentclass::string = string,
		-currentmarker::string = string
	) => .setformat(#template, #class, #currentclass, #currentmarker)

/**!
haschildren
Returns true if nav object has children that are not all -hide.
**/
	public haschildren(
		navitem::map
	) => {

		local(timer = knop_timer)

		local(haschildren = #navitem >> 'children')
		if(#haschildren) => {	// verify that there is at least one child that does not have -hide
			#haschildren = false // assume there is no child to show
			loop(#navitem -> find('children') -> 'navitems' -> size) => {
				if(!(#navitem -> find('children') -> 'navitems' -> get(loop_count) -> find('hide'))) => { // found one
					#haschildren = true
					loop_abort
				}
			}
		}

//		..'tagtime' = integer(#timer) // cast to integer to trigger onconvert and to "stop timer"

		return(#haschildren)

	}

	public haschildren(
		-navitem::map
	) => .haschildren(#navitem)

/**!
renderbreadcrumb
Shows the current navigation as breadcrumb trail. \n\
			Parameters:\n\
			-delimiter (optional) Specifies the delimiter to use between nav levels, defaults to " > " if not specified\n\
			-home (optional flag) Show the default navigation item (i.e. "home") first in the breadcrumb (unless already there).
**/
	public renderbreadcrumb(
		delimiter::string = ' &gt; ',
		home::boolean = false,
		skipcurrent::boolean = false,
		plain::boolean = false
	) => {

		local(timer = knop_timer)

		local('output' = array)
		local('path' = array)

		if(#home) => {
			// show the default navigation item first in breadcrumb

			// find default path
			if(.'default' != '' && .'pathmap' >>  .'default') => {
				local(homepath = .'default')
			else
				// use first top level nav item as default
				local(homepath = .'navitems' -> first ->value -> find('key'))
			}

			if(!.'path' -> beginswith(#homepath)) => {
				if(#plain) => {
					#output -> insert(.getnav(#homepath) -> find('label'))
				else
					#output -> insert('<a href="' + .url(-path = #homepath) + '">' + .getnav(#homepath) -> find('label') + '</a>')
				}
			}
		}
		loop(.'patharray' -> size) => {
			#path -> insert(.'patharray' -> get(loop_count))
			if(.getnav(#path) -> find('hide')) => {
				// do not show in navigation
				loop_abort
			else
				if(#plain) => {
					#output -> insert(.getnav(#path) -> find('label'))
				else
					#output -> insert('<a href="' + .url(-path = #path) + '">' + .getnav(#path) -> find('label') + '</a>')
				}
			}
		}
		if(#skipcurrent) => {
			#output -> removelast
		}

//		..'tagtime' = integer(#timer) // cast to integer to trigger onconvert and to "stop timer"

		return(#output -> join(#delimiter))

	}

	public renderbreadcrumb(
		-delimiter::string = ' &gt; ',
		-home::boolean = false,
		-skipcurrent::boolean = false,
		-plain::boolean = false
	) => .renderbreadcrumb(#delimiter, #home, #skipcurrent, #plain)

/**!
data
Returns data object that can be stored for the current nav location (or specified nav location).\n\
			Parameters:\n\
			-path (optional)\n\
			-type (optional string) Force a certain return type. If the stored object doesn´t match the specified type, an empty instance of the type is returned. That way the data can be filtered by type without having to use conditionals to check the type before.
**/
	public data(
		path::string = .'path',
		type::string = ''
	) => {

		local(timer = knop_timer)

		local('data' = .getnav(#path) -> find('data'))
		if(#type -> size > 0) => {
			if(#data -> isa(#type)) => {
// 				..'tagtime' = integer(#timer) // cast to integer to trigger onconvert and to "stop timer"
				return(#data)
			else
// 				..'tagtime' = integer(#timer) // cast to integer to trigger onconvert and to "stop timer"
				// return empty instance of the specified type
				return((\#type)->astype)
			}
		else
// 			..'tagtime' = integer(#timer) // cast to integer to trigger onconvert and to "stop timer"
			return(#data)
		}

	}

	public data(
		-path::string = .'path',
		-type::string = ''
	) => .data(#path, #type)

/*
trace // can wait

*/

/**!
	Called when a knop_user object is stored in a session
**/
	public serializationElements() => {

//		local('timer' = knop_timer)

		local(ret = map)

		#ret -> insert(pair('version', .'version'))
		#ret -> insert(pair('navitems', .'navitems'))
		#ret -> insert(pair('pathmap', .'pathmap'))
		#ret -> insert(pair('urlmap', .'urlmap'))

		#ret -> insert(pair('default', .'default'))
		#ret -> insert(pair('template', .'template'))
		#ret -> insert(pair('class', .'class'))
		#ret -> insert(pair('currentclass', .'currentclass'))
		#ret -> insert(pair('currentmarker', .'currentmarker'))

		#ret -> insert(pair('actionpath', .'actionpath'))
		#ret -> insert(pair('path', .'path'))
		#ret -> insert(pair('patharray', .'patharray'))
		#ret -> insert(pair('pathargs', .'pathargs'))
		#ret -> insert(pair('urlparams', .'urlparams'))
		#ret -> insert(pair('navmethod', .'navmethod'))
		#ret -> insert(pair('filenaming', .'filenaming'))
		#ret -> insert(pair('directorytreemap', .'directorytreemap'))
		#ret -> insert(pair('root', .'root'))
		#ret -> insert(pair('fileroot', .'fileroot'))
		#ret -> insert(pair('dotrace', .'dotrace'))

		return array(serialization_element('items', #ret))

	}

/**!
	Called when a knop_user object is retrieved from a session
**/
	public acceptDeserializedElement(d::serialization_element)  => {

//		local('timer' = knop_timer)
		if(#d->key == 'items') => {

			local(ret = #d -> value)

			.'version' = (#ret-> find('version'))
			.'navitems' = (#ret-> find('navitems'))
			.'pathmap' = (#ret-> find('pathmap'))
			.'urlmap' = (#ret-> find('urlmap'))

			.'default' = (#ret-> find('default'))
			.'template' = (#ret-> find('template'))
			.'class' = (#ret-> find('class'))
			.'currentclass' = (#ret-> find('currentclass'))
			.'currentmarker' = (#ret-> find('currentmarker'))

			.'actionpath' = (#ret-> find('actionpath'))
			.'path' = (#ret-> find('path'))
			.'patharray' = (#ret-> find('patharray'))
			.'pathargs' = (#ret-> find('pathargs'))
			.'urlparams' = (#ret-> find('urlparams'))
			.'navmethod' = (#ret-> find('navmethod'))
			.'filenaming' = (#ret-> find('filenaming'))
			.'directorytreemap' = (#ret-> find('directorytreemap'))
			.'root' = (#ret-> find('root'))
			.'fileroot' = (#ret-> find('fileroot'))
			.'dotrace' = (#ret-> find('dotrace'))

		}

//		..'tagtime' = integer(#timer) // cast to integer to trigger onconvert and to "stop timer"

	}

/**!
	scrubKeywords
	Pinched from Kyles inline definitions. Needed to have keywords, like -path act like regular pairs
**/
	protected scrubKeywords(input::trait_queriable)::trait_forEach => {
		local(ret = array)
		with i in #input
		do {
			if (#i->isa(::keyword)) => {
				#ret->insert(pair('-'+#i->name->asString, .scrubKeywords(#i->value)))
			else (#i->isa(::pair))
				#ret->insert(pair(#i->first, .scrubKeywords(#i->second)))
			else (#i->isa(::trait_forEach))
				local(tst = .scrubKeywords(#i))
				#tst->size > 0?
					#ret->insert(#tst)
			else (#i->isa(::string) && #i->beginsWith('-'))
				#ret->insert(pair(#i, true))
			else
				#ret->insert(#i)
			}
		}
		return #ret->asStaticArray
	}
	protected scrubKeywords(input) => #input

	public rendernav(
		-active::string = ''
	) => .renderhtml()

    trait {
      import trait_serializable
    }

}
//log_critical('loading knop_nav done')

?>