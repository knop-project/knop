knop_nav
========

.. class:: knop_nav

    Experimental new leaner version of custom type to handle site navigation menu
    
    .. method:: acceptDeserializedElement(d::serialization_element)

        Called when a knop_user object is retrieved from a session
        
    .. method:: actionconfigfile()

        Shortcut to filename: actcfg.
        
    .. method:: actionconfigfile_didrun()

    .. method:: actionconfigfile_didrun=(actionconfigfile_didrun::string)

    .. method:: actionfile()

        Shortcut to filename: act.
        
    .. method:: actionpath()

        Returns current path as array.
        
    .. method:: actionpath=(actionpath::string)

    .. method:: addchildren(-path::string, -children::knop_nav)

    .. method:: addchildren(path::string, children::knop_nav)

        Add nav object as children to specified key path, replacing the current children if any.
        
    .. method:: children(-path)

    .. method:: children(path =?)

        Return reference to the children of the current navigation object map, or for the specified path
        
    .. method:: class()

    .. method:: class=(class::string)

    .. method:: configfile()

        Shortcut to filename: cfg.
        
    .. method:: contentfile()

        Shortcut to filename: cnt.
        
    .. method:: currentclass()

    .. method:: currentclass=(currentclass::string)

    .. method:: currentmarker()

    .. method:: currentmarker=(currentmarker::string)

    .. method:: data(-path::string =?, -type::string =?)

    .. method:: data(path::string =?, type::string =?)

        Returns data object that can be stored for the current nav location (or specified nav location).
        
        Parameters:
        	- path (optional)
        
        	- type (optional string)
        
        		Force a certain return type. If the stored object doesn´t match the specified
        		type, an empty instance of the type is returned. That way the data can be
        		filtered by type without having to use conditionals to check the type before.
        
    .. method:: default()

    .. method:: default=(default::string)

    .. method:: directorytree(basepath::string =?, firstrun::boolean =?)

        Returns a map of all existing knop file paths.
        
    .. method:: directorytreemap()

    .. method:: directorytreemap=(directorytreemap::map)

    .. method:: dotrace()

    .. method:: dotrace=(dotrace::boolean)

    .. method:: error_lang()

    .. method:: error_lang=(error_lang::knop_lang)

    .. method:: filename(-type::string, -path::string =?)

    .. method:: filename(type::string, -path::string =?)

    .. method:: filename(type::string, path::string =?)

        Returns the full path to the specified type of precissing file for the current navigation.
        
        Parameters:
        	-type (required)
        
        		lib, act, cnt, cfg, actcfg
        
    .. method:: filenaming()

    .. method:: filenaming=(filenaming::string)

    .. method:: fileroot()

    .. method:: fileroot=(fileroot::string)

    .. method:: findnav(path::array, navitems::array)

    .. method:: getargs(-index::integer)

    .. method:: getargs(index::integer =?)

        Path arguments = the leftover when we found a matching path, to be used for keyvalue for example.
        
        Parameters:
        	- index (optional integer)
        
        		Specifies which leftover path item to return, defaults to all path items as a string
        
    .. method:: getlocation(-setpath::string, -refresh::boolean =?)

    .. method:: getlocation(setpath::string =?, refresh::boolean =?)

        Grabs path and actionpath from params or urlhandler, translates from url to path
        if needed. This must be called before using the nav object.
        
        Parameters:
        	- setpath (optional)
        
        		forces a new path
        
    .. method:: getlocation_didrun()

    .. method:: getlocation_didrun=(getlocation_didrun::boolean)

    .. method:: getnav(-path)

    .. method:: getnav(path =?)

        Return reference to the current navigation object map, or for the specified path.
        
    .. method:: haschildren(-navitem::map)

    .. method:: haschildren(navitem::map)

        Returns true if nav object has children that are not all -hide.
        
    .. method:: include(-file::string, -path::string =?)

    .. method:: include(file::string, path::string =?)

        Includes any of the files for the current path, fails silently if file does not exist.
        
        Parameters:
        	-file (required)
        
        		lib, act, cnt, cfg, actcfg or library, action, config, actionconfig,
        		content, or any arbitrary filename
        
    .. method:: insert(-key::string, -label =?, -default =?, -url =?, -title =?, -id =?, -template =?, -children =?, -param =?, -class =?, -filename =?, -disabled::boolean =?, -after =?, -target =?, -data =?, -hide::boolean =?)

    .. method:: insert(key::string, label =?, default =?, url =?, title =?, id =?, template =?, children =?, param =?, class =?, filename =?, disabled::boolean =?, after =?, target =?, data =?, hide::boolean =?)

        Inserts a nav item into the nav array
        
    .. method:: label(-path::string)

    .. method:: label(path::string =?)

        Returns the name of the current (or specified) nav location
        
        Parameters:
        	-path (optional)
        
    .. method:: library(-file::string, -path =?)

    .. method:: library(file::string, path =?)

        includes file just as ->include, but returns no output.
        
    .. method:: libraryfile()

        Shortcut to filename: lib.
        
    .. method:: linkparams(-navitem::map)

    .. method:: linkparams(navitem::map)

        Returns an array for all parameters that should be sent along with nav links
        
    .. method:: navitems()

    .. method:: navitems=(navitems::array)

    .. method:: navmethod()

    .. method:: navmethod=(navmethod::string)

    .. method:: onconvert()

        Shortcut to renderhtml
        
    .. method:: oncreate(-template::string =?, -class::string =?, -currentclass::string =?, -currentmarker::string =?, -default::string =?, -root::string =?, -fileroot::string =?, -navmethod::string =?, -filenaming::string =?, -trace::boolean =?)

    .. method:: oncreate(template::string =?, class::string =?, currentclass::string =?, currentmarker::string =?, default::string =?, root::string =?, fileroot::string =?, navmethod::string =?, filenaming::string =?, trace::boolean =?)

        Parameters:
        	- default (optional)
        
        		Key of default navigation item
        
        	- root (optional)
        
        		The root path for the site section that this nav object is used for
        
        	- fileroot (optional)
        
        		The root for include files, to be able to use a different root for physical
        		files than the logical root of the site. Defaults to the value of -root. 
        
        	- navmethod (optional)
        
        		path or param. Path for "URL designed" URLs, otherwise a -path parameter
        		 will be used for the navigation. 
        
        	- filenaming (optional)
        
        		prefix (default), suffix or extension, specifies how include files are named
        
        	- trace (optional flag)
        
        		If specified debug_trace will be used. Defaults to disabled for performance reasons. 
        
        	- template (optional)
        
        		html template used to render the navigation menu
        
        	- class (optional)
        
        		default class for all navigation links
        
        	- currentclass (optional)
        
        		class added for the currently active link
        
        	- currentmarker (optional)
        
        		character(s) show to the right link of current nav (typically &raquo;)
        
        
    .. method:: path(-path::string)

    .. method:: path(path::string =?)

        Returns url or key path for the current or specified location
        
        Parameters:
        	- path (optional)
        
    .. method:: path=(path::string)

    .. method:: pathargs()

    .. method:: pathargs=(pathargs::string)

    .. method:: patharray()

        Returns current path as array.
        
    .. method:: patharray=(patharray::array)

    .. method:: pathmap()

    .. method:: pathmap=(pathmap::map)

    .. method:: renderbreadcrumb(-delimiter::string =?, -home::boolean =?, -skipcurrent::boolean =?, -plain::boolean =?)

    .. method:: renderbreadcrumb(delimiter::string =?, home::boolean =?, skipcurrent::boolean =?, plain::boolean =?)

        Shows the current navigation as breadcrumb trail.
        
        Parameters:
        	- delimiter (optional)
        
        		Specifies the delimiter to use between nav levels, defaults to " > " if not specified
        
        	- home (optional flag)
        
        		Show the default navigation item (i.e. "home") first in the breadcrumb (unless already there).
        
    .. method:: renderhtml(-items::array =?, -keyval::array =?, -flat::boolean =?, -toplevel::boolean =?, -xhtml::boolean =?, -patharray =?, -levelcount::integer =?)

    .. method:: renderhtml(items::array =?, keyval::array =?, flat::boolean =?, toplevel::boolean =?, xhtml::boolean =?, patharray =?, levelcount::integer =?)

        Render hierarchial nav structure.
        
        Parameters:
        	- renderpath (optional)
        
        		Only render the children of the specified path (and below)
        
        	- flat (optional flag)
        
        		Only render one level
        
        	- expand (optional flag)
        
        		Render the entire expanded nav tree and not just the currently active branch
        
        	- xhtml (optional)
        
        		XHTML valid output
        
    .. method:: renderhtml_levels()

    .. method:: renderhtml_levels=(renderhtml_levels::integer)

    .. method:: rendernav(-active::string =?)

    .. method:: root()

    .. method:: root=(root::string)

    .. method:: sanitycheck()

        Outputs the navigation object in a very basic form, just to see what it contains
        
    .. method:: scrubKeywords(input)

    .. method:: scrubKeywords(input::trait_queriable)

        Pinched from Kyles inline definitions. Needed to have keywords, like -path act like regular pairs
        
    .. method:: serializationElements()

        Called when a knop_user object is stored in a session
        
    .. method:: setformat(-template::string =?, -class::string =?, -currentclass::string =?, -currentmarker::string =?)

    .. method:: setformat(template::string =?, class::string =?, currentclass::string =?, currentmarker::string =?)

        Sets html template for the nav object, use #items# #item# #/items# or more
        elaborate #items# #link##label##current##/link##children# #/items# as 
        placeholders.
        
        Parameters:
        	- template (optional string)
        
        		Html template, defaults to <ul>#items#<li>#item#</li>#/items#</ul>
        
        	- class (optional string)
        
        		Css class name that will be used for every navigation link
        
        	- currentclass (optional string)
        
        		Css class name that will be added to the currently active navigation link (defaults to crnt)
        
        	- currentmarker (optional string)
        
        		String that will be appended to menu text of currently active navigation link
        
    .. method:: setlocation(-path::string)

    .. method:: setlocation(path::string)

        Sets the current location to a specific nav path or url
        
    .. method:: template()

    .. method:: template=(template::string)

    .. method:: url(-path::string =?, -params =?, -urlargs::string =?, -getargs::boolean =?, -except =?, -topself::knop_nav =?, -autoparams::boolean =?, ...)

    .. method:: url(path::string =?, params =?, urlargs::string =?, getargs::boolean =?, except =?, topself::knop_nav =?, autoparams::boolean =?, ...)

        Returns full url for current path or specified path. Path parameters can be provided and overridden by passing them to this tag.
        
        Parameters:\n\
        	- path (optional) 
        
        	- params (optional)
        		
        		Pair array to be used in url instead of plain parameters sent to this tag
        
        	- urlargs (optional)
        
        		Raw string with url parameters to append at end of url and -params
        
        	- getargs (optional flag)
        
        		Add the getargs (leftover path parts) to the url
        
        	- except (optional)
        
        		Array of parameter names to exclude (or single parameter name as string)
        
        	- topself (optional nav)
        
        		Internal, needed to call url from renderhtml when rendering sublevels
        
        	-autoparams (optional flag)
        
        		Enables the automatic passing of action_params that begin with "-"
        
    .. method:: urlmap()

    .. method:: urlmap=(urlmap::map)

    .. method:: urlparams()

    .. method:: urlparams=(urlparams::array)

    .. method:: version()

    .. method:: version=(version)

