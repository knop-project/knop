knop_grid
=========

.. class:: knop_grid

    Custom type to handle data grids (record listings).
    
    .. method:: addfield(-name::string =?, -label::string =?, -dbfield::string =?, -width::integer =?, -class::string =?, -raw =?, -url::string =?, -keyparamname::string =?, -defaultsort =?, -nosort::boolean =?, -template =?, -quicksearch =?)

    .. method:: addfield(name::string =?, label::string =?, dbfield::string =?, width::integer =?, class =?, raw =?, url =?, keyparamname::string =?, defaultsort =?, nosort::boolean =?, template =?, quicksearch =?)

        deprecated use insert instead
        
    .. method:: addurlarg(field::string, value =?)

    .. method:: class()

    .. method:: class=(class::string)

    .. method:: database()

    .. method:: database=(database)

    .. method:: dbfieldmap()

    .. method:: dbfieldmap=(dbfieldmap::map)

    .. method:: defaultsort()

    .. method:: defaultsort=(defaultsort::string)

    .. method:: error_lang()

    .. method:: error_lang=(error_lang)

    .. method:: fields()

    .. method:: fields=(fields::array)

    .. method:: footer()

    .. method:: footer=(footer::string)

    .. method:: insert(-name::string =?, -label::string =?, -dbfield::string =?, -width::integer =?, -class::string =?, -raw =?, -url::string =?, -keyparamname::string =?, -defaultsort =?, -nosort::boolean =?, -template =?, -quicksearch =?)

    .. method:: insert(name::string =?, label::string =?, dbfield::string =?, width::integer =?, class =?, raw =?, url =?, keyparamname::string =?, defaultsort =?, nosort::boolean =?, template =?, quicksearch =?)

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
        
    .. method:: lang()

        Returns a reference to the language object
        
    .. method:: lang=(lang)

    .. method:: lastpage()

    .. method:: nav()

    .. method:: nav=(nav)

    .. method:: nosort()

    .. method:: nosort=(nosort)

    .. method:: numbered()

    .. method:: numbered=(numbered)

    .. method:: onassign(value)

    .. method:: oncreate(-database::knop_database, -nav =?, -quicksearch =?, -rawheader::string =?, -class::string =?, -id::string =?, -nosort =?, -language::string =?, -numbered =?, -rowsorting::boolean =?)

    .. method:: oncreate(database::knop_database, nav =?, quicksearch =?, rawheader::string =?, class::string =?, id::string =?, nosort =?, language::string =?, numbered =?, rowsorting::boolean =?)

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
        
    .. method:: page()

    .. method:: page=(page::integer)

    .. method:: page_skiprecords(maxrecords::integer)

        Converts current page value to a skiprecords value to use in a search.
        
        Parameters:
        	- maxrecords (required integer)
        	  Needed to be able to do the calculation. Maxrecords_value can not be taken
        	  from the database object since that value is not available until after
        	  performing the search
        
    .. method:: qs_id()

    .. method:: qs_id=(qs_id::string)

    .. method:: qsr_id()

    .. method:: qsr_id=(qsr_id::string)

    .. method:: quicksearch(-sql::boolean =?, -contains::boolean =?, -value::boolean =?, -removedotbackticks::boolean =?)

    .. method:: quicksearch(sql::boolean =?, contains::boolean =?, value::boolean =?, removedotbackticks::boolean =?)

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
        
    .. method:: quicksearch=(quicksearch::string)

    .. method:: quicksearch_fields()

    .. method:: quicksearch_fields=(quicksearch_fields::array)

    .. method:: quicksearch_form()

    .. method:: quicksearch_form=(quicksearch_form)

    .. method:: quicksearch_form_reset()

    .. method:: quicksearch_form_reset=(quicksearch_form_reset)

    .. method:: rawheader()

    .. method:: rawheader=(rawheader::string)

    .. method:: renderfooter(-end::boolean =?, -numbered =?, -xhtml::boolean =?)

    .. method:: renderfooter(end::boolean =?, numbered =?, xhtml::boolean =?)

        Outputs the footer of the grid with the prev/next links and information about
        found count. Automatically included by ->renderhtml
        
        Parameters:
        	- end (optional flag)
        	  Also output closing </table> tag\n\
        
        	- numbered (optional flag or integer)
        	  If specified, pagination links will be shown as page numbers instead of
        	  regular prev/next links. Defaults to 6 links, specify another number
        	  (minimum 6) if more numbers are wanted.
        
    .. method:: renderheader(-start::boolean =?, -xhtml::boolean =?, -startwithfooter::boolean =?)

    .. method:: renderheader(start::boolean =?, xhtml::boolean =?, startwithfooter::boolean =?)

        Outputs the header of the grid with the column headings.
        Automatically included by ->renderhtml.
        
        Parameters:
        	- start (optional flag)
        	  Also output opening <table> tag
        
    .. method:: renderhtml(-inlinename =?, -xhtml::boolean =?, -numbered =?, -startwithfooter::boolean =?)

    .. method:: renderhtml(inlinename =?, xhtml::boolean =?, numbered =?, startwithfooter::boolean =?)

        Outputs the complete record listing. Calls renderheader, renderlisting and renderfooter as well.
        If 10 records or more are shown, renderfooter is added also just below the header.
        
        Parameters:
        	- inlinename (optional)
        	  If not specified, inlinename from the connected database object is used
        
        	- numbered (optional flag or integer)
        	  If specified, pagination links will be shown as page numbers instead of
        	  regular prev/next links. Defaults to 6 links, specify another number
        	  (minimum 6) if more numbers are wanted.
        
    .. method:: renderlisting(inlinename =?, xhtml::boolean =?)

        Outputs just the actual record listing. Is called by renderhtml.
        
        Parameters:
        	- inlinename (optional)
        	  If not specified, inlinename from the connected database object is used
        
    .. method:: rowsorting()

    .. method:: rowsorting=(rowsorting)

    .. method:: sortdescending()

    .. method:: sortdescending=(sortdescending)

    .. method:: sortfield()

    .. method:: sortfield=(sortfield::string)

    .. method:: sortparams(-sql::boolean =?, -removedotbackticks::boolean =?)

    .. method:: sortparams(sql::boolean =?, removedotbackticks::boolean =?)

        Returns a Lasso-style pair array with sort parameters to use in the search inline.
        
        Parameters:
        	- sql (optional)
        	- removedotbackticks (optional flag)
        	  Use with -sql for backward compatibility for fields that contain periods.
        	  If you use periods in a fieldname then you cannot use a JOIN in Knop.
        
    .. method:: tbl_id()

    .. method:: tbl_id=(tbl_id::string)

    .. method:: urlargs(except =?, prefix =?, suffix =?)

        Returns all get params that begin with - as a query string, for internal use in links in the grid.
        
        Parameters:
        	- except (optional)
        	  Exclude these parameters (string or array)
        
        	- prefix (optional)
        	  For example ? or &amp; to include at the beginning of the querystring
        
        	- suffix (optional)
        	  For example &amp; to include at the end of the querystring
        
    .. method:: version()

    .. method:: version=(version)

