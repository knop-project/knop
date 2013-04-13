<?Lasso
log_critical('loading knop_form')

define knop_form => type {
/*

	2013-03-12	JC	Changed encode_html(#requiredmarker) to #requiredmarker
	2013-03-12	JC	Changed renderform to use #labelstart##labelend# instead of #label#. This to enable #required# to be part of the <label>text</label> code
	2013-03-12	JC	Fixes in renderhtml that contained tracking code no longer needed. Also changed replace #label# calls that should have been #required#
	2013-01-21	JC	Changed remaining isa('xxxx') to isa(::xxxx)
	2012-10-30	JC	Fixed bug preventing hint on input type text field to work properly
	2012-10-20	JC	Expanded support for input type text to include 'text', 'url', 'email', 'number', 'tel'
	2012-10-11	JC	Changing errorclass so that it defaults to "error"
	2012-10-11	JC	Added support for helpblock and error class marking where requested
	2012-09-21	JC	Added support for bootstrap markup of checkbox. New param -bootstrap in render_form
	2012-07-02	JC	Fixed erroneous handling of addlock and clearlocks
	2012-06-10	JC	Changed all iterate to query expr. Changed all += to append. Set br to br /
	2012-06-07	JC	Tweaks to make knop_form -> process work
	2012-05-18	JC	Changed all old style containers to Lasso 9 {} style
	2012-05-18	JC	Fixed bug in process that called database with wrong type of params
	2012-05-18	JC	Fixed bug in process that looked for type database instead of knop_database. Also changed all type checks to use -> isa()
	2012-03-09	JC	Added support for using arrays of dbfield names in searchfields. To allow search on multiple fields in one add field object. So far only for sql searches.
	2012-03-06	JC	Fixed bug that prevented use of empty dbfield values
	2011-11-22	JC	Started on search support allowing a form to be used for searching
	2011-11-22	JC	Cleaned up local creation removing unneeded single quotes
	2011-09-07	JC	Fixed insertion of multiple when used in select fields
	2011-06-08	JC	Fixed bug in renderhtml that assumed field had content (fieldvalue_array)
	2011-06-03	JC	Fixed bug that made lockvalue_decrypted return a byte value
	2011-06-03	JC	Added reseterrors. Empties the error array as if no errors was found
	2011-05-05	JC	Fixed faulty renderhtml. Turned out it was not working at all
	2011-04-19	JC	Fixing bug in setformat that emptied not used params when called
	2010-10-23	JC	Render_form now in a working order
	2010-10-22	JC	Major overhaul of renderform. Broke out start and end rendering to methods of their own. Not in a working order for the moment...
	2010-10-21	JC	Adding the method setparam to knop_form to deal with the non support of referenced variables
	2010-10-18	TT	commented out all references to tag_name until we can figure out why this is a crasher
	2010-10-18	TT	tracked down a number of issues with addfield
	2010-10-18	TT	updating more alt signatures
	2010-09-23	JC	Adding alternative signatures to oncreate and addfield. Added handling of integers for some params
	2010-09-17	JC	Removed the -action support since it's deprecated
	Committed initial version for Lasso9 8-5-2010 by tim taplin
	also provided simple port of knop_base type for compatibility.
	Need to investigate translating the functions from knop_base into a trait
*/
	parent knop_base

	data public version = '2013-03-12'

	// instance variables
	data public fields::array = array

	data public template::string	// html template used to render the html form fields
	data public buttontemplate::string	// html template used to render the html buttons (submit, reset, image)
	data public class::string	// default class for all form fields, can be overridden field by field

	// class used to highlight field labels when validation fails
	data public errorclass::string
	data public formaction
	data public method = 'post'
	// html form fieldset
	data public fieldset = false
	// html form legend
	data public legend
	data public name
	data public id
	data public formid
	data public raw
	// is automatically set to multipart/formdata if the form contains a file input
	data public enctype
	data public actionpath
	// if true then no parameters that begin with - will be automatically added to the form
	data public noautoparams = false
	// the source of the latest -> loadfields, can be database, form or params
	data public fieldsource
	// marker used to show fields that are required (html or plain string)
	data public required::string
	// if true, a javascript will prevent form submit without clicking on submit button (like pressing enter key)
	data public entersubmitblock = false
	data public unsavedmarker
	data public unsavedmarkerclass
	// must be specified, or else there is no unsaved warning for the form
	data public unsavedwarning::string
	data public database
	// param name to use instead of the default -keyvalue
	data public keyparamname::string
	// whether the form is for editing an existing record or a blank for for adding a new record (edit/add)
	// only valid if a database object is specified
	data public formmode
	// the button that was clicked when submitting a form (cancel, add, save, delete)
	data public formbutton
	data public db_keyvalue
	data public db_lockvalue
	// flag showing if its an AND search or an OR search
	data public search_type = 'AND'
	// used when rendering to keep track of if a fieldset from fieldset or legend field types is open so it can be closed properly
	data public render_fieldset_open = false
	// used when rendering to keep track of if a fieldset from renderform or renderhtml legend is open so it can be closed properly
	data public render_fieldset2_open = false
	// when set to true, no scripts will be injected by renderform
	data public noscript = false
	data public error_lang = knop_lang(-default = 'en', -fallback)
	data public errors = null
	//config vars
	data public validfieldtypes::map = map('text' = '', 'password' = '', 'checkbox' = '', 'radio' = '', 'textarea' = '', 'select' = '', 'file' = '', 'search' = '', 'submit' = '', 'reset' = '', 'image' = '', 'hidden' = '', 'fieldset' = '', 'legend' = '', 'html' = '', 'url' = string, 'email' = string, 'number' = string, 'tel' = string)
	//special types
	data public exceptionfieldtypes::map = map('file' = '', 'submit' = '', 'reset' = '', 'image' = '', 'addbutton' = '', 'savebutton' = '', 'searchbutton' = '', 'deletebutton' = '', 'cancelbutton' = '', 'fieldset' = '', 'legend' = '', 'html' = '')

	data private start_rendered = false
	data private end_rendered = false

	data public clientparams::staticarray

/**!
	onCreate
		Parameters:\n\
			-formaction (optional) The action attribute in the form html tag\n\
			-method (optional) Defaults to post\n\
			-name (optional)\n\
			-id (optional)\n\
			-raw (optional) Anything in this parameter will be put in the opening form tag\n\
			-actionpath (optional) Knop action path\n\
			-fieldset (optional)\n\
			-legend (optional string) legend for the entire form - if specified, a fieldset will also be wrapped around the form\n\
			-entersubmitblock (optional)\n\
			-noautoparams (optional)\n\
			-template (optional string) html template, defaults to #label# #field##required#<br>\n\
			-buttontemplate (optional string) html template for buttons, defaults to #field# but uses -template if specified\n\
			-required (optional string) character(s) to display for required fields (used for #required#), defaults to *\n\
			-class (optional string) css class name that will be used for the form element, default none\n\
			-errorclass (optional string) css class name that will be used for the label to highlight input errors, default error\n\
			-unsavedmarker (optional string) id for html element that should be used to indicate when the form becomes dirty. \n\
			-unsavedmarkerclass (optional string) class name to use for the html element. Defaults to "unsaved". \n\
			-unsavedwarning (optional string)\n\
			-keyparamname (optional)\n\
			-noscript (optional flag) if specified, don\'t inject any javascript in the form. This will disable all client side functionality such as hints, focus and unsaved warnings. \n\
			-database (optional database) Optional database object that the form object will interact with
**/
	public oncreate(formaction = null, method = '', name = '', id = '', raw = '',actionpath = '', fieldset::boolean = false, legend = '', entersubmitblock = false, noautoparams = false, template::string = '', buttontemplate::string = '', required::string = '*', class::string = '', errorclass::string = 'error', unsavedmarker::string = '', unsavedmarkerclass::string = 'unsaved', unsavedwarning::string = '', keyparamname::string = '-keyvalue', noscript = true, database::any = '')
		=> {
//		debug => {

		.'method' = #method
		.'name' = #name
		.'id' = #id
		.'raw' = #raw
		.'legend' = #legend
		.'template' = #template
		.'buttontemplate' = #buttontemplate
		.'required' = #required
		.'class' = #class
		.errorclass = #errorclass
		.'unsavedmarker' = #unsavedmarker
		.'unsavedmarkerclass' = #unsavedmarkerclass
		.'unsavedwarning' = #unsavedwarning
		.'keyparamname' = #keyparamname

		.'formaction' = #formaction
		.'actionpath' = #actionpath
		#database -> isa(::knop_database) ? .'database' = #database

		.'noscript' = #noscript

		// default value
		.'required' = #required
		.'keyparamname' = #keyparamname

		.'fieldset' = #fieldset || #legend -> size > 0

		.'entersubmitblock' = #entersubmitblock
		.'noautoparams' = #noautoparams
		.'clientparams' = tie(web_request -> queryparams, web_request -> postparams) -> asstaticarray

		// escape quotes for javascript
		.'unsavedwarning' -> replace('\'', '\\\'')

// 	} // end debug
	} // END oncreate

	public oncreate(-formaction = null, -method = '', -name = '', -id = '', -raw = '', -actionpath = '', -fieldset::boolean = false, -legend = '', -entersubmitblock = false, -noautoparams = false, -template::string = '', -buttontemplate::string = '', -required::string = '*', -class::string = '', -errorclass::string = 'error', -unsavedmarker::string = '', -unsavedmarkerclass::string = 'unsaved', -unsavedwarning::string = '', -keyparamname::string = '-keyvalue', -noscript = true, -database::any = '') => .oncreate(#formaction, #method, #name, #id, #raw, #actionpath, #fieldset, #legend, #entersubmitblock, #noautoparams, #template, #buttontemplate, #required, #class, #errorclass, #unsavedmarker, #unsavedmarkerclass, #unsavedwarning, #keyparamname, #noscript, #database)

/**!
onconvert
Outputs the form data in very basic form, just to see what it contains
**/
	public onconvert() => {
// debug => {

		local(output = string)
		with fieldpair in .'fields' do {
			#output -> append(#fieldpair -> name + ' = ' + #fieldpair -> value + '    <br />\n')
		}

		return #output

// 	} // end debug
	}

/*
/**!
Shortcut to getvalue
**/
	public _unknowntag(index::integer = 1) => {
// debug => {
		local(name = string(currentCapture->calledName))
		if(.'fields' >> #name) => { // should be (.keys) but this is faster
			return(.getvalue(#name, -index = #index))
		else
			log_critical('knop_form _unknowntag called with tag_name ' + #name)
			//fail: -9948, .type + ' -> ' + tag_name + ' not known.'
//			.'_debug_trace' -> insert(.type + ' -> ' + tag_name + ' not known.')
		}
// 	} // end debug
	}


	/**!
	addfield
	Inserts a form element in the form. \n\

			Parameters:\n\
			-type (required) Supported types are listed in form -> \'validfieldtypes\'. Also custom field types addbutton, savebutton or deletebutton are supported (translated to submit buttons with predefined names). \
			For the field types html, fieldset and legend use -value to specify the data to display for these fields. A legend field automatically creates a fieldset (closes any previously open fieldsets). Use fieldset with -value = false to close a fieldset without opening a new one. \n\
			-name (optional) Required for all input types except addbutton, savebutton, deletebutton, fieldset, legend and html\n\
			-id (optional) id for the html object, will be autogenerated if not specified\n\
			-dbfield (optional) Corresponding database field name (name is used if dbfield is not specified), or null/emtpy string if ignore this field for database\n\
			-value (optional) Initial value for the field\n\
			-hint (optional) Optional gray hint text to show in empty text field\n\
			-options (optional) For select, checkbox and radio, must be array or set. For select, the array can contain -optgroup = label to create an optiongroup. \n\
			-multiple (optional flag) Used for select\n\
			-linebreak (optional flag) Put linebreaks between checkbox and radio values\n\
			-default (optional) Default text to display in a popup menu, will be selected (with empty value) if no current value is set. Is followed by an empty option. \n\
			-label (optional) Text label for the field\n\
			-size (optional) Used for text and select\n\
			-maxlength (optional) Used for text\n\
			-rows (optional) Used for textarea\n\
			-cols (optional) Used for textarea\n\
			-focus (optional flag) The first text field with this parameter specified will get focus when page loads\n\
			-class (optional)\n\
			-disabled (optional flag) The form field will be rendered as disabled\n\
			-raw (optional) Raw attributes that will be put in the html tag\n\
			-confirmmessage (optional) Message to show in submit/reset confirm dialog (delete button always shows confirm dialog)\n\
			-required (optional flag) If specified then the field must not be empty (very basic validation)\n\
			-validate (optional) Compound expression to validate the field input. The input can be accessed as params inside the expression which should either return true for valid input or false for invalid, or return 0 for valid input or a non-zero error code or error message string for invalid input. \n\
			-filter (optional) Compound expression to filter the input before it is loaded into the form by ->loadfields. The field value can be accessed as params inside the expression which should return the filtered field value. -filter is applied before validation. \n\
			-nowarning (optional flag) If specified then changing the field will not trigger an unsaved warning\n\
			-after (optional) Numeric index or name of field to insert after
	**/
	public addfield(
		type::string,
		name::string = '',
		label = '',
		value = '',
		id = '',
		dbfield = NULL,
		hint = '',
		options = '',
		default = '',
		size = -1,
		maxlength = -1,
		rows = -1,
		cols = -1,
		class = '',
		labelclass = '',
		raw = '',
		helpblock = '',
		confirmmessage = '',
		validate = '',
		filter = '',
		after = '',
		required = false,
		nowarning = false,
		op::string = 'bw',
		logical_op::string = string,
		multiple = false,
		linebreak = false,
		focus = false,
		disabled = false
	) => {
// debug => {

	// TODO: allow template to be specified per field
		// TODO: add optiontemplate to be able to format individual options
		/*	Notes from Tim Taplin
			validate and filter input parameters for addfield method of form object were specified as option parameters of type tag, I'm not sure how to specify this in Lasso9 since an optional value must have an initial value. Currently set them as empty strings to get thru the basic syntax validation.
*/

		local(_type = #type -> ascopy)
		local(_name = #name -> ascopy)
		local(originaltype = #type -> asCopy)

		if(array('addbutton', 'savebutton', 'deletebutton', 'cancelbutton', 'searchbutton') >> #_type) => {
//			#originaltype = #_type // seems redundant
			#_name = 'button_' + #_type
			#_name -> removetrailing('button')
			#_type = 'submit'
		else(#_type == 'reset' && #name -> size == 0)
			#_name = 'button_' + #_type
		else(array('legend', 'fieldset', 'html') >> #_type && #name -> size == 0)
			#_name = #_type -> ascopy
		else
			fail_if(#name -> size == 0, -9956, 'form -> addfield missing required parameter -name')
		}

	//take out fail statement
	//	fail_if(.'validfieldtypes' !>> #_type, 7102, .error_msg(7202))
		fail_if( (map('select', 'radio', 'checkbox') >> #_type
			&& !#options -> isa(::array)
			&& !#options -> isa(::set)),
			-9956, 'Field type '+#_type+' requires -options array or set. Type is: ' + #options -> type)
		local('index'= .'fields' -> size + 1)

		if(#after -> isa(::integer)) => {
			#index = (#after+1)
		else
			self -> fields>>#after ? #index = (self -> 'fields' -> findindex(#after) -> first + 1)
		}

		if(#_type == 'file') => {
			.'enctype' ='multipart/form-data'
			.'method' = 'post'
		}
		local(field = map(
			'required' = #required,
			'multiple' = #multiple,
			'linebreak' = #linebreak,
			'focus' = #focus,
			'nowarning' = #nowarning,
			'disabled' = #disabled,
			'field_op' =  (array('bw', 'ew', 'cn', 'lt', 'lte', 'gt', 'gte', 'eq', 'neq', 'ft', 'rx', 'nrx') >> #op ? #op | 'bw'),
			'logical_op' = (array('AND', 'OR', 'NOT') >> #logical_op ? #logical_op | string)
			)
		)
		if(.'exceptionfieldtypes' >> #_type) => {
			// || (map: 'legend', 'fieldset', 'html') >> #_type
			// never make certain field types required
			#field -> insert('required' = false)
		}

//log_critical('addfield log: main setup complete, begin inserting field info')

		#field -> insert('type' = #_type)
		#field -> insert('name' = #_name)

		#id -> size > 0 ? #field -> insert('id' = #id -> ascopy)
		#hint -> size > 0 ? #field -> insert('hint' = #hint -> ascopy)
		#default -> size > 0 ? #field -> insert('default' = #default -> ascopy)
		#label -> size > 0 ? #field -> insert('label' = #label -> ascopy)
		#size > 0 ? #field -> insert('size' = #size -> ascopy)
		#maxlength > 0 ? #field -> insert('maxlength' = #maxlength -> ascopy)
		#rows > 0 ? #field -> insert('rows' = #rows -> ascopy)
		#cols > 0 ? #field -> insert('cols' = #cols -> ascopy)
		#class -> size > 0 ? #field -> insert('class' = #class -> ascopy)
		#labelclass -> size > 0 ? #field -> insert('labelclass' = #labelclass -> ascopy)
		#raw -> size > 0 ? #field -> insert('raw' = #raw -> ascopy)
		#helpblock -> size > 0 ? #field -> insert('helpblock' = #helpblock -> ascopy)
		#confirmmessage -> size > 0 ? #field -> insert('confirmmessage' = #confirmmessage -> ascopy)
		#field -> insert('originaltype' = #originaltype -> ascopy)

		#field -> insert('dbfield' = ( #dbfield != NULL ? #dbfield -> ascopy | #_name -> ascopy ) )
		#field -> insert('defaultvalue' = #value -> ascopy)

		// the following params are stored as reference, so the values of the params can be altered after adding a field simply by changing the referenced variable.
		#field -> insert('options' = #options)
		#field -> insert('value' = #value)
		#field -> insert('validate' = #validate)
		#field -> insert('filter' = #filter)

		.'fields' -> insert(#_name = #field, #index)

// 	} // end debug
	}

	public addfield(-type, -name = '', -label = '', -value = '', -id = '', -dbfield = NULL, -hint = '', -options = '', -multiple = false, -linebreak = false, -default = '', -size::integer = -1, -maxlength::integer = -1, -rows::integer = -1, -cols::integer = -1, -focus = false, -class = '', -labelclass = '', -disabled = false, -raw = '', -helpblock = '', -confirmmessage = '', -required = false, -validate = '', -filter = '', -nowarning = false, -op::string = 'bw', -logical_op::string = string, -after = '') => {

	.addfield(#type, #name, #label, #value, #id, #dbfield, #hint, #options, #default, #size, #maxlength, #rows, #cols, #class, #labelclass, #raw, #helpblock, #confirmmessage, #validate, #filter, #after, #required, #nowarning, #op, #logical_op, #multiple, #linebreak, #focus, #disabled)
	}

/*
	public addfield(type, name, -label = '', -value = '', -id = '', -dbfield = NULL, -hint = '', -options = '', -multiple = false, -linebreak = false, -default = '', -size::integer = -1, -maxlength::integer = -1, -rows::integer = -1, -cols::integer = -1, -focus = false, -class = '', -disabled = false, -raw = '', -confirmmessage = '', -required = false, -validate = '', -filter = '', -nowarning = false, -op::string = 'bw', -logical_op::string = string, -after = '') => {

	.addfield(#type, #name, #label, #value, #id, #dbfield, #hint, #options, #default, #size, #maxlength, #rows, #cols, #class, #raw, #confirmmessage, #validate, #filter, #after, #required, #nowarning, #op, #logical_op, #multiple, #linebreak, #focus, #disabled)
	}

	public addfield(-type::string, -name::string) => {
		//log_critical(' using type, name only version')
		.addfield(#type, #name)
	}

	public addfield(-type::string, -name::string = '', -id::string = '', -dbfield::string = '', -size::integer = 0) => {

		//log_critical(' using type, name, id, dbfield, size version')
		.addfield(#type, #name, '', '', #id, #dbfield, '', '', '', #size)
	}
	public addfield(-type::string, -name::string = '', -label = '', -value = '', -id = '', -dbfield = '', -hint = '', -options = '', -default = '', -size = '', -maxlength = '', -rows = '', -cols = '', -class = '', -raw = '', -confirmmessage = '', -validate = '', -filter = '', -after = '', -required = false, -nowarning = false, -multiple = false, -linebreak = false, -focus = false, -disabled = false) => {

		//log_critical(' found full keyword version')
		.addfield(#type, #name, #label, #value, #id, #dbfield, #hint, #options, #default, #size, #maxlength, #rows, #cols, #class, #raw, #confirmmessage, #validate, #filter, #after, #required, #nowarning, #op, #logical_op, #multiple, #linebreak, #focus, #disabled)

	}
*/
/**!
copyfield
Copies a form field to a new name.
**/
	public copyfield(name, newname) => {
// debug => {

		fail_if(#name == #newname, 7104, .error_msg(7104))
		if(.'fields' >> #name) => {
			local(copyfield = .'fields' -> find(#name) -> first -> value -> asCopy)
			#copyfield -> insert('name' = #newname)
			.'fields' -> insert(#newname = #copyfield)
		}

// 	} // end debug
	}

/**!
init
Initiates form to grab keyvalue and set formmode if we have a database connected to the form. \
	Does nothing if no database is specified.
**/
	public init(get = '', post = '', keyvalue = '') => debug => {
		// Initiates form to grab keyvalue and set formmode if we have a database connected to the form.
		// TODO: should we run init if form is not valid? Now we have a condition in lib before running init.
		// TODO: how can we get the right formmode when showing an add form again after failed validation? Now we have an extra condition in lib for this

		if(.'database' -> isa(::knop_database)) => {

			.'db_keyvalue' = string
			.'db_lockvalue' = string
			local(_params = array)
			local(source = 'form')
			local(field = map)

			#post != '' ? #_params -> merge(client_postparams)
			#get != '' ? #_params -> merge(client_getparams)

			if(#post == '' && #get == '') => {
				#_params -> merge(client_postparams)
				#_params -> merge(client_getparams)
			}
//			.'_debug_trace' -> insert('Init ')

			if(#_params >> '-lockvalue') => {
				if(#_params -> isa(::map)) => {
					.'db_lockvalue' = ( #_params -> find('-lockvalue') != '' ? string(#_params -> find('-lockvalue')) | string)
				else
					.'db_lockvalue' = ( #_params -> find('-lockvalue') -> first -> value != '' ? string(#_params -> find('-lockvalue') -> first -> value) | string )
				}
//				.'_debug_trace' -> insert(tag_name + ': grabbing lockvalue from form ' + .'db_lockvalue')
			else(#keyvalue != '')
				.'db_keyvalue' = #keyvalue
//				.'_debug_trace' -> insert(tag_name + ': grabbing keyvalue from parameter ' + .'db_keyvalue')
			else(#_params >> .'keyparamname')
				if(#_params -> isa(::map)) => {
					.'db_keyvalue' = (#_params -> find(.'keyparamname') != '' ? string(#_params -> find(.'keyparamname')) | string)
				else
					.'db_keyvalue' = (#_params -> find(.'keyparamname') -> first -> value != '' ? string(#_params -> find(.'keyparamname') -> first -> value) | string)
				}
//				.'_debug_trace' -> insert(tag_name + ': grabbing keyvalue from form ' + .'db_keyvalue')
			}
			if(.getbutton == 'search') => {
				.'formmode' = 'search'
			else((.'db_lockvalue' == '' || .'db_lockvalue' == null) && (.'db_keyvalue' == '' || .'db_keyvalue' == null))
				// we have no keyvalue or lockvalue - this must be an add operation
				.'formmode' = 'add'
				// create a keyvalue for the record to add
				.'db_keyvalue' = knop_unique9
//				.'_debug_trace' -> insert(tag_name + ': generating keyvalue ' + .'db_keyvalue')
			else(.getbutton == 'add')
				.'formmode' = 'add'
			else(.'formmode' == '' || .'formmode' == null)
				.'formmode' = 'edit'
			}
//			.'_debug_trace' -> insert(tag_name + ': formmode ' + .formmode)
		else(.getbutton == 'search')
			.'formmode' = 'search'
		}

	}

	public init(-get = '', -post = '', -keyvalue = '') => .init(#get, #post, #keyvalue)

/**!
loadfields
Overwrites all field values with values from either database, action_params or explicit -params. \
				Auto-detects based on current lasso_currentaction.\n\
			Parameters:\n\
				-params (optional) Array or map to take field values from instead of database or submit (using dbnames)\n\
				-get (optional flag) Only getparams will be used\n\
				-post (optional flag) Only postparams will be used\n\
				-inlinename (optional) The first record in the result from the specified inline will be used as field values\n\
				-database (optional) If a database object is specified, the first record from the latest search result of the database object will be used. \
					If -database is specified as flag (no value) and the form object has a database object attached to it, that database object will be used.
**/
	public loadfields(params = '', post = '', get = '', inlinename = '', database = '') => {

		local(_params = array)
		local(source = 'form')
		local(field = map)
		local(loopcount = 0)
		//log_critical('checking params')
		.'fieldsource' = null
		if(#params != '') => {
			.'fieldsource' = 'params'
			#source = 'params'
			#_params = #params
		else(#database != '' && #inlinename == '')
			if(#database -> isa(::knop_database)) => {
				#inlinename = #database -> inlinename
			else(.'database' -> isa(::knop_database))
				#inlinename = .'database' -> inlinename
			}
		}

		if(#inlinename != '') => {
			//log_critical('inline name exists')
			.'fieldsource' = 'database'
			#source = 'params'
			#_params = map

			//Why is this not a database method??
			records(-inlinename = #inlinename) => {

				with fieldname in field_names do => {
					#_params -> insert(#fieldname = field(#fieldname) )
				}
				loop_abort
			}

		else(.'fieldsource' == null && lasso_currentaction != 'nothing')
			.'fieldsource' = 'database'
			#source = 'database'
		else(.'fieldsource' == null)
			//log_critical('getting params from form')
			.'fieldsource' = 'form'
			#_params = array
			if(#post!='') => {
				#_params -> insertfrom(client_postparams)
			}
			if(#get!='') => {
				#_params -> insertfrom(client_getparams)
			}
			if(#post == '' && #get == '') => {
				#_params -> insertfrom(client_postparams)
				#_params -> insertfrom(client_getparams)
			}
			//log_critical('params: '+#_params)
		}

		//.'_debug_trace' -> insert(tag_name + ': loading field values from ' + .'fieldsource')
		local(fieldnames_done = map)
		local(fields_samename = array)
		local(params_fieldname = array)

		with fieldpair in .'fields' do => {

			if(.'exceptionfieldtypes' !>> #fieldpair -> value -> find('type')// do not load data for excluded form fields (maybe it should do that in some cases???)
				// && (map: 'legend', 'fieldset', 'html') !>> #fieldpair -> value -> (find: 'type')
				&& !#fieldpair -> name -> beginswith('-')) => {  // exclude field names that begin with "-"
				if(#fieldnames_done !>> #fieldpair -> name) => { // check if we are already done with this field name (for multiple fields with the same name) => {
					// find all fields with the same name
					#fields_samename = .'fields' -> find(#fieldpair -> name)
					#params_fieldname = #_params -> find(#fieldpair -> name)
					if(#source == 'database' && found_count > 0) => {
						// load field values from database
						if(#fieldpair -> value -> find('dbfield') != '') => {

							#fieldpair -> value -> insert('value' = field(#fieldpair -> value -> find('dbfield')) -> asCopy )
						}
					else(#source == 'params')
						// load field values from explicit -params using dbfield names
						if(#_params >> #fieldpair -> value -> find('dbfield') && #fieldpair -> value -> find('dbfield') != '') => {

							if(#_params -> isa(::map)) => {
								#fieldpair -> value -> insert('value' = #_params -> find(#fieldpair -> value -> find('dbfield')) -> asCopy )
							else(#_params -> isa(::array))
								#fieldpair -> value -> insert('value' = #_params -> find(#fieldpair -> value -> find('dbfield')) -> first -> value -> asCopy)
							}
						}
					else(#source == 'form')
						// load field values from form submission
						#loopcount = 0
						with fieldpair_samename in #fields_samename do => {
							#loopcount += 1

							if(#params_fieldname -> size == #fields_samename -> size) => {
								// the number of submitted fields match the number of fields in the form
								#fieldpair_samename -> value -> insert('value' = #params_fieldname -> get(#loopcount) -> value -> ascopy)
							else
								if(#params_fieldname -> size > 1) => {
									// multiple field values
									local(valuearray = array)
									with parampair in #_params -> find(#fieldpair -> name) do => {
										#parampair -> value != '' ? #valuearray -> insert(#parampair -> value)
									}
									#fieldpair_samename -> value -> insert('value' = #valuearray)
								else(#_params >> #fieldpair -> name)
									#fieldpair_samename -> value -> insert('value' = #_params -> find(#fieldpair_samename -> name -> first -> value) -> asCopy )
								else
									#fieldpair_samename -> value -> insert('value' = '')
								}
							}
						}
						#fieldnames_done -> insert(#fieldpair -> name)
					}
				}
				// apply filtering of field value (do this for all instances of the same field name, so outside of the #fieldnames_done check)
				if(#fieldpair -> value -> find('filter') -> isa(::tag)) => {
					#fieldpair -> value -> insert('value'= #fieldpair -> value -> find('filter') -> run(-params = #fieldpair -> value -> find('value')))
				}
			}
		}

		// capture keyvalue or lockvalue if we have a database object connected to the form
		if(.'database' -> isa(::knop_database) && .'formmode' != 'search') => {
			//(.'db_keyvalue') = null
			//(.'db_lockvalue') = null
			if(.'fieldsource' == 'database') => {
				if(.'database' -> lockfield != '' && .'database' -> lockvalue != '') => {
					.'db_lockvalue' = .'database' -> lockvalue_encrypted
					//.'_debug_trace' -> insert(tag_name + ': grabbing lockvalue from database ' + .'db_lockvalue')
				else(.'database' -> keyfield != '' && .'database' -> keyvalue != '')
					.'db_keyvalue' = .'database' -> keyvalue
					//.'_debug_trace' -> insert(tag_name + ': grabbing keyvalue from database ' + .'db_keyvalue')
				}
			else
				if(#_params >> '-lockvalue') => {
					if(#_params -> isa(::map)) => {
						.'db_lockvalue' = (#_params -> find('-lockvalue' ) != ''
							? string(#_params -> find('-lockvalue' )) | string)
					else
						.'db_lockvalue' = (#_params -> find('-lockvalue' ) -> first -> value != ''
							? string(#_params -> find('-lockvalue') -> first -> value) | string)
					}
					//.'_debug_trace' -> insert(tag_name + ': grabbing lockvalue from form ' + .'db_lockvalue')
				else(#_params >> .'keyparamname')
					if(#_params -> isa(::map)) => {
						.'db_keyvalue' = (#_params -> find(.'keyparamname') != ''
							? string(#_params -> find(.'keyparamname')) | string)
					else
						.'db_keyvalue' = (#_params -> find(.'keyparamname') -> first -> value != ''
							? string(#_params -> find(.'keyparamname') -> first -> value) | string)
					}
					//.'_debug_trace' -> insert(tag_name + ': grabbing keyvalue from form ' + .'db_keyvalue')
				}
			}
			if(.'db_lockvalue' == '' && .'db_keyvalue' == '') => {
				// we have no keyvalue or lockvalue - this must be an add operation
				.'formmode' = 'add'
				// create a keyvalue for the record to add
				.'db_keyvalue' = knop_unique9
				//.'_debug_trace' -> insert(tag_name + ': generating keyvalue ' + .'db_keyvalue')
			else(.formmode == '')
				.'formmode' = 'edit'
			}
			//.'_debug_trace' -> insert(tag_name + ': formmode ' + .formmode)
		}

	}

	public loadfields(-inlinename::string) => {
		//log_critical('running single keyword version')
		.loadfields('', '', '', #inlinename, '')
	}

	public loadfields(-params = '', -post = '', -get = '', -inlinename = '', -database = '') => .loadfields(#params, #post, #get, #inlinename, #database)

/**!
clearfields
Empties all form field values
**/
	public clearfields() => {

		with fieldvalue in .'fields' do => {
			if(.'exceptionfieldtypes' !>> #fieldvalue -> value -> find('type')) => {
				// && (map: 'legend', 'fieldset', 'html') !>> #fieldpair -> value -> (find: 'type')
				// first remove value to break reference
				#fieldvalue -> value -> remove('value')
				#fieldvalue -> value -> insert('value' = '')
			}
		}
		if(.'database' -> isa(::knop_database)) => {
			.'db_keyvalue' = string
			.'db_lockvalue' = string
		}

	}

/**!
resetfields
Resets all form field values to their initial values
**/
	public resetfields() => {

		with fieldvalue in .'fields' do => {
			if(.'exceptionfieldtypes' !>> #fieldvalue -> value ->find('type') ) => {
				//&& (map: 'legend', 'fieldset', 'html') !>> #fieldpair -> value -> (find: 'type')
				// first remove value to break reference
				#fieldvalue-> value -> remove('value')
				#fieldvalue-> value -> insert('value' = #fieldvalue -> value -> find('defaultvalue'))
			}
		}
		if(.'database' -> isa(::knop_database)) => {
			.'db_keyvalue' = string
			.'db_lockvalue' = string
		}

	}

/**!
validate
Performs validation and fills a transient array with field names that have input errors. \
	form -> loadfields must be called first.
**/
	public validate() => {
// debug => {

		// Performs validation and fills a transient array with field names that have input errors.
		// Must call -> loadfields first

		if(.'errors' == null) => {
			// initiate the errors array so we know validate has been performed
			.'errors' = array

			with fieldvalue in .'fields' do => {
				if( .'exceptionfieldtypes' !>> #fieldvalue -> value -> find('type') ) => {
					if(#fieldvalue -> value -> find('required') && #fieldvalue -> value -> find('value') == '') => {
						.'errors' -> insert(#fieldvalue-> value -> find('name') )
					}
					if(#fieldvalue -> value -> find('validate') -> isa(::tag)) => {
						// perform validation expression on the field value
						local(result = #fieldvalue -> value -> find('validate') -> run(-params = #fieldvalue -> value -> find('value')))
						if(#result === true || #result === 0) => {
							// validation was ok
						else(#result != 0 || #result -> size)
							// validation result was an error code or message
							.'errors'-> insert(#fieldvalue -> value -> find('name') = #result)
						else
							.'errors' -> insert(#fieldvalue -> value -> find('name') )
						}
					}
				}
			}
		}
//		.'_debug_trace'-> insert(tag_name + ': form is valid ' + (.'errors' -> size == 0))

// 	} // end debug
	}

/**!
isvalid
Returns the result of form -> validate (true/false) without performing the validation again (unless it hasn\'t been performed already)
**/
	public isvalid() => {
// debug => {

		// Returns the result of -> validate (true/false) without performing the validation again (unless it is needed)
		.'errors' == null ? .validate
//		.'_debug_trace' -> insert(string(tag_name) + ': form is valid ' + (.'errors' -> size == 0))

		return(.'errors' -> size == 0)

// 	} // end debug
	}

/**!
adderror
Adds the name for a field that has validation error, used for custom field validation. \
				calls form -> validate first if needed
**/
	public adderror(fieldname) => {

		// adds a field that has error
		// calls ->validate first if needed, to make sure .'errors' is an array
		.'errors' == null ? .validate
		.'errors' -> insert(#fieldname)

	}

/**!
reseterrors
Empties the error array as if no errors was found
**/
	public reseterrors() => {
		.'errors' = array
	}

/**!
errors
Returns an array with fields that have input errors, or empty array if no errors or form has not been validated
**/
	public errors() => {
		// returns an array with fields that have input errors, or emtpy array if no errors or form has not been validated
		if(.'errors' == null) => {
			return(array)
		else
			return(.'errors')
		}
	}

/**!
updatefields
Returns a pair array with fieldname = value, or optionally SQL string to be used in an update inline.
	form -> loadfields must be called first.
**/
	public updatefields(sql::boolean = false) => {
// debug => {

		// Returns a pair array with fieldname = value, or optionally SQL string to be used in an update inline.
		// Must call ->loadfields first.
		local(output = array)
		local(fieldvalue = null)

		with fieldtmp in .'fields' do => {
			if(.'exceptionfieldtypes' !>> #fieldtmp -> value -> find('type')
						&& !(#fieldtmp -> value ->find('name') -> beginswith('-'))
						&& #fieldtmp -> value -> find('dbfield') != '') => {

				// don't use submit etc and exclude fields whose name begins with -
				#fieldvalue = #fieldtmp -> value -> find('value')
				if(!#fieldvalue -> isa(::array)) => {
					// to support multiple values for one fieldname, like checkboxes
					#fieldvalue = array(#fieldtmp -> value -> find('value'))
				}
				if(#sql) => {
					#output ->insert('`' + encode_sql(knop_stripbackticks(#fieldtmp -> value -> find('dbfield') )) + '`'
						+ ' = "' + encode_sql(#fieldvalue -> join(',')) + '"')
				else
					local(dbfield = #fieldtmp -> value -> find('dbfield'))
					loop(#fieldvalue -> size) => {
						#output ->insert(#dbfield = #fieldvalue -> get(loop_count) )
					}
				}
			}
		}
		if(#sql) => {
			#output = '(' + #output ->join(',') + ')'
		}

		return(#output)

// 	} // end debug
	}

/**!
backtickthis
Internal method used by searchfields to prep db field names
**/
	private backtickthis(n) => {
		return '`' + encode_sql(knop_stripbackticks(#n)) + '`'
	}

/**!
searchfields
Returns an array with fieldname = value, or optionally SQL string to be used in a search inline.
	form -> loadfields must be called first.
**/
	public searchfields(sql::boolean = false, params::boolean = false) => {

		local(output = array)
		local(_field = null)
		local(fieldvalue = null)
		local(dbfield = null)
		local(_dbfield = null)
		local(field_op = null)
		local(logical_op = null)
		local(using_logicalop = false)
		local(_search_type = ' ' + .'search_type' + ' ')
		local(sql_field_tmp = array)
		local(tmp_fieldvalue = null)
		local(tmp_dbfieldbuild = null)

		if(#params) => {
			with fieldtmp in .'fields' do => {
				#_field = #fieldtmp -> value
				if(.'exceptionfieldtypes' !>> #_field -> find('type')
							&& #_field -> find('dbfield') -> size > 0) => {
					// don't use submit etc
					#fieldvalue = #_field -> find('value')
					if(!#fieldvalue -> isa(::array)) => {
						// to support multiple values for one fieldname, like checkboxes
						#fieldvalue = array(#_field -> find('value'))
					}
					with valuetmp in #fieldvalue do => {
						if(#valuetmp -> size > 0) => {
							#output -> insert(#_field -> find('name') = #valuetmp)
						}
					}
				}
			}
		else
			with fieldtmp in .'fields' do => {
				#_field = #fieldtmp -> value
				if(.'exceptionfieldtypes' !>> #_field -> find('type')
							&& !(#_field ->find('name') -> beginswith('-'))
							&& #_field -> find('dbfield') -> size > 0) => {
					// don't use submit etc and exclude fields whose name begins with -
					#fieldvalue = #_field -> find('value')
					if(!#fieldvalue -> isa(::array)) => {
						// to support multiple values for one fieldname, like checkboxes
						#fieldvalue = array(#_field -> find('value'))
					}
					#dbfield = #_field -> find('dbfield')
					!#dbfield -> isa(::array) ? #dbfield = array(#dbfield)

					#field_op = #_field -> find('field_op')
					#logical_op = #_field -> find('logical_op')
					if(#sql) => {
						if(#logical_op -> size > 0 && #fieldvalue -> size > 1) => {
							#sql_field_tmp = array
							#using_logicalop = true
						}

						#dbfield -> foreach => {
							#1  -> replace(#1, .backtickthis(#1))
							#1 -> replace('.', '`.`')
						}
						with valuetmp in #fieldvalue do => {
							if(#valuetmp -> size > 0) => {

								#tmp_fieldvalue = #valuetmp
								#tmp_dbfieldbuild = array

								with fieldname in #dbfield do => {
									match(#field_op) => {
										case('ew')
											#tmp_dbfieldbuild -> insert(#fieldname +  ' LIKE "%' + knop_encodesql_full(#tmp_fieldvalue) + '"')

										case('cn')
											#tmp_dbfieldbuild -> insert(#fieldname +  ' LIKE "%' + knop_encodesql_full(#tmp_fieldvalue) + '%"')

										case('lt')
											#tmp_dbfieldbuild -> insert(#fieldname +  ' < "' + encode_sql(#tmp_fieldvalue) + '"')

										case('lte')
											#tmp_dbfieldbuild -> insert(#fieldname +  ' <= "' + encode_sql(#tmp_fieldvalue) + '"')

										case('gt')
											#tmp_dbfieldbuild -> insert(#fieldname +  ' > "' + encode_sql(#tmp_fieldvalue) + '"')

										case('gte')
											#tmp_dbfieldbuild -> insert(#fieldname +  ' >= "' + encode_sql(#tmp_fieldvalue) + '"')

										case('eq')
											#tmp_dbfieldbuild -> insert(#fieldname +  ' = "' + encode_sql(#tmp_fieldvalue) + '"')

										case('neq')
											#tmp_dbfieldbuild -> insert(#fieldname +  ' <> "' + encode_sql(#tmp_fieldvalue) + '"')

										case // bw
											#tmp_dbfieldbuild -> insert(#fieldname + ' LIKE "' + encode_sql(#tmp_fieldvalue) + '%"')

									} // match(#field_op)
								} // with(#dbfield)

								#using_logicalop ?
									#sql_field_tmp ->insert(' (' + #tmp_dbfieldbuild -> join(' OR ') + ') ')
								|
									#output ->insert(' (' + #tmp_dbfieldbuild -> join(' OR ') + ') ')
							}
						} // with(#fieldvalue)

						if(#using_logicalop) => {
							#output ->insert('(' + #sql_field_tmp ->join(' ' + #logical_op + ' ') + ')')
							#using_logicalop = false
						}
					else // prepare an array with pair values
						if(#logical_op -> size > 0 && #fieldvalue -> size > 1) => {
							#output ->insert('-opbegin' = #logical_op)
							#using_logicalop = true
						}

						with valuetmp in #fieldvalue do => {

							if(#valuetmp -> size > 0) => {
								#tmp_fieldvalue = #valuetmp
								#dbfield -> size > 1 ? #output ->insert('-opbegin' = 'OR') // multiple fields to search on
								with fieldname in #dbfield do => {
									#output -> insert('-op' = #field_op)
									#output -> insert(#fieldname =  #tmp_fieldvalue)
								}
								#dbfield -> size > 1 ? #output ->insert('-opend' = 'OR') // multiple fields to search on

							}
						}
						if(#using_logicalop) => {
							#output ->insert('-opend' = #logical_op)
							#using_logicalop = false
						}
	//stdoutnl('knop_form ' + loop_value -> name + ' | ' + #dbfield)
	//stdoutnl('knop_form ' + #output)

					}
				}
			}
			if(#sql) => {
				#output = #output ->join(#_search_type)
			}
		}


		return #output

	}

	public searchfields(-sql::boolean = false, -params::boolean = false) => .searchfields(#sql, #params)

/**!
Returns what button was clicked on the form on the previous page. Assumes that submit buttons are named button_add etc.
	Returns add, update, delete, cancel or any custom submit button name that begins with button_.
**/
	public getbutton() => {
// debug => {
		if(.'formbutton' != null) => {
			// we have already found out once what button was clicked
//			.'debug_trace'-> insert((tag_name + ': cached ' + .'formbutton'))

			return .'formbutton'

		}
		local(clientparams = .'clientparams' -> asstring)

		// look for submit buttons, the least destructive first
		with i in array('cancel', 'save', 'add', 'search', 'delete') do => {
			if(#clientparams >> 'button_' + #i
				|| #clientparams >> 'button_' + #i + '.x'
				|| #clientparams >> 'button_' + #i + '.y') => {
				.'formbutton' = #i

				return #i

			}
		}

		// no button found yet - look for custom button names
		local(paramname = string)
		with i in .'clientparams' do => {
			 #paramname = (#i -> isa(::pair) ? #i -> name | #i)
			if(#paramname -> beginswith('button_')) => {
				//not sure which is the best way to do this...
				//continuing commands as in L8
				#paramname -> removeleading('button_') & removetrailing('.x') & removetrailing('.y')
				//or chaining commands (not sure if these return themselves for chaining or not)
				//loop_value -> removeleading('button_') -> removetrailing('.x') -> removetrailing('.y')
//				.'_debug_trace' -> insert(tag_name + ': custom button name ' + loop_value)
				.'formbutton'= #paramname

				return #paramname

			}
		}
//		.'_debug_trace' -> insert(tag_name + ': No button found')
// 	} // end debug
	}

/**!
process
Automatically handles a form submission and handles add, update, or delete.
	Requires that a database object is specified for the form
**/
	public process(user = '', lock = '', keyvalue = '') => {
// debug => {

		fail_if(!.'database' -> isa(::knop_database), 7103, .error_msg(7103))

		.'error_code'= 0
		.'error_msg'= string

		match(.getbutton) => {
			case('cancel')
			// do nothing at all
//			.'_debug_trace' -> insert(tag_name + ': cancelling ')
			case('save')
				.loadfields
				if(.isvalid) => {
					if(#user -> size > 0 && .lockvalue != '') => {
						.'database' -> saverecord(-fields = .updatefields, -lockvalue = .lockvalue, -keyvalue = .keyvalue, -user = #user)
					else
						.'database' -> saverecord(-fields = .updatefields, -keyvalue = .keyvalue)
					}
					if(.'database' -> error_code != 0) => {
						.'error_code' = .'database' -> error_code
						.'error_msg' = ('Process: update record error ' + .'database' -> error_msg)
					}
	//				.'_debug_trace' -> insert(tag_name + ': updating record ' + .'database' -> error_msg + ' ' + .'database' -> error_code)
				else
					.'error_code' = 7101; // Process: update record did not pass form validation
	//				.'_debug_trace' -> insert(tag_name + ': update record did not pass form validation')
				}

			case('add')
				.loadfields
				if(.isvalid) => {
					.'database' -> addrecord(-fields = .updatefields, -keyvalue = .keyvalue)
					if(.'database' -> error_code != 0) => {
						.'error_code' = .'database' -> error_code
						.'error_msg' = ('Process: add record error ' + .'database' -> error_msg)
					}
	//				.'_debug_trace'-> insert(tag_name + ': adding record ' + .'database' -> error_msg + ' ' + .'database' -> error_code)
				else
					.'error_code' = 7101; // Process: add record did not pass form validation
	//				.'_debug_trace' -> insert(tag_name + ': add record did not pass form validation')
	//				.'_debug_trace' -> insert(tag_name + ': reverting form mode to add')
				}
			case('delete')

				.loadfields
	//			.'_debug_trace'-> insert(tag_name + ': will delete record with keyvalue ' + .keyvalue + ' lockvalue ' + .lockvalue)

				if(#user -> size > 0 && .lockvalue != '') => {
					.'database' -> deleterecord(-lockvalue = .lockvalue, -keyvalue = .keyvalue, -user = #user)
				else
					.'database' -> deleterecord(-keyvalue = .keyvalue)
				}
				if(.'database' -> error_code == 0) => {
					.resetfields
				else
					.'error_code' = .'database' -> error_code
					.'error_msg' = ('Process: delete record error ' + .'database' -> error_msg)
				}
	//			.'_debug_trace' ->insert(tag_name + ': deleting record ' + .'database' -> error_msg + ' ' + .'database' -> error_code)
		}

// 	} // end debug
	}

/**!
	Defines a html template for the form. \n\
			Parameters:\n\
			-template (optional string) html template, defaults to #label# #field##required#<br>\n\
			-buttontemplate (optional string) html template for buttons, defaults to #field#\n\
			-required (optional string) character(s) to display for required fields (used for #required#), defaults to *\n\
			-legend (optional string) legend for the entire form - if specified, a fieldset will also be wrapped around the form\n\
			-class (optional string) css class name that will be used for the form element, default none\n\
			-errorclass (optional string) css class name that will be used for the label to highlight input errors, default error\n\
			-unsavedmarker (optional string) \n\
			-unsavedmarkerclass (optional string) \n\
			-unsavedwarning (optional string)
	**/
	public setformat(template::string = .'template', buttontemplate::string = .'buttontemplate', required::string = .'required', legend::string = .'legend', class::string = .'class', errorclass::string = .'errorclass', unsavedmarker::string = .'unsavedmarker', unsavedmarkerclass::string = .'unsavedmarkerclass', unsavedwarning::string = .'unsavedwarning') => {
// debug => {

		.'template' = #template
		.'buttontemplate' = #buttontemplate
		.'required' = #required
		.'legend' = #legend
		.'class' = #class
		.'errorclass' = #errorclass
		.'unsavedmarker' = #unsavedmarker
		.'unsavedmarkerclass' = #unsavedmarkerclass
		.'unsavedwarning' = #unsavedwarning

		.'unsavedwarning' -> replace('\'', '\\\'')

// 	} // end debug
	}
	public setformat(-template::string = .'template', -buttontemplate::string = .'buttontemplate', -required::string = .'required', -legend::string = .'legend', -class::string = .'class', -errorclass::string = .'errorclass', -unsavedmarker::string = .'unsavedmarker', -unsavedmarkerclass::string = .'unsavedmarkerclass', -unsavedwarning::string = .'unsavedwarning') => .setformat(#template, #buttontemplate, #required, #legend, #class, #errorclass, #unsavedmarker, #unsavedmarkerclass, #unsavedwarning)

	public renderformstart(xhtml::boolean = false) => {
// debug => {

		.'start_rendered' ? return
		.'end_rendered' ? return

		local(output = '')
		local(formid = null)
		local(usehint = array)
		local(nowarning = false)

		// local var that adjust tag endings if rendered for XHTML
		local(endslash = (.xhtml(params) ? ' /' | ''))

		// page var to keep track of the number of forms that has been rendered on a page
		!var_defined('knop_form_renderform_counter') ? var('knop_form_renderform_counter' = 0)

		$knop_form_renderform_counter += 1

		if(.'id' != '') => {
			#formid = .'id'
		else(.'name' != '')
			#formid = .'name'
		else
			#formid = 'form' + $knop_form_renderform_counter
		}

		.'formid' = #formid

		// render opening form tag
		#output -> append('<form')
		//.'_debug_trace'-> insert(tag_name + ': formaction = ' + .'formaction')
		if(.'formaction' != null) => {
			local(clientparams = .clientparams -> asarray)
			#clientparams -> removeall(.'keyparamname')
			#clientparams -> removeall('-lockvalue')
			#clientparams -> removeall('-action')
			#clientparams -> removeall('-xhtml')

			#output -> append(' action="' + .'formaction')
			if(.'method' == 'post' && !.'noautoparams') => {
				local(actionparams = array)
				with cp_pair in #clientparams do => {
					if(#cp_pair -> isa(::pair)) => {
						// check if param name appears in form action
						// turn param into [p][a][r][a][m] to avoid problems with most reserved regex characters like "."
						if(#cp_pair -> name -> beginswith('-')
							&& #cp_pair -> name != '-session'
							&& .'fields' !>> #cp_pair -> name
							&& string_findregexp( .'formaction', -find = ('[?;&][' + #cp_pair -> name -> split('') -> join('][') + ']([&=]|$)'), -ignorecase) -> size == 0) => {
							#actionparams -> insert(#cp_pair -> name + '=' + encode_url(string(#cp_pair -> value)))
						}
					// check if param appears in form action
					// turn param into [p][a][r][a][m] to avoid problems with most reserved regex characters like "."
					else(#cp_pair -> isa(::string)
						&& #cp_pair -> beginswith('-')
						&& .'fields' !>> #cp_pair
						&& string_findregexp(.'formaction', -find = ('[?;&][' + #cp_pair -> split('') -> join('][') + ']([&=]|$)'), -ignorecase) -> size == 0)
						#actionparams -> insert(#cp_pair)
					}
				}
				if(#actionparams -> size > 0) => {
					#output -> append((.'formaction' >> '?' ? '&amp;' | '?' ) + #actionparams -> join('&amp;'))
				}
			}
			#output -> append('"')
		}

		.'method' != null && .'method' != '' 	? #output -> append(' method="' + .'method' + '"')
		.'name' != null && .'name' != ''		? #output -> append(' name="' + .'name' + '"')
		#output -> append(' id="' + #formid + '"')
		.'class' != null && .'class' != ''		? #output -> append(' class="' + .'class' + '"')
		.'enctype' != null && .'enctype' != ''		? #output -> append(' enctype="' + .'enctype' + '"')
		.'raw' != null && .'raw' != '' 		? #output -> append(' ' + .'raw')
		!.'noscript' ? #output -> append(' onsubmit="return validateform(this)"')
		(.'entersubmitblock' && !.'noscript')	? #output -> append(' onkeydown="return submitOk(event);" onfocus="submitBlock=true; return true;" onblur="submitBlock=false; return true;"')
		#output -> append('>\n')

		if(.'actionpath' != '' && !.'noautoparams' && .'fields' !>> '-action') => {
			// auto-add -action unless there is already an -action field in the form
			#output -> append('<input type="hidden" name="-action" value="' + encode_html(.'actionpath') + '"' + #endslash + '>\n')
		}
		if(.'fieldset') => {
			#output -> append('<fieldset>\n')
			#output -> append('<legend>' + .'legend' + '</legend>\n')
		}
		if(.'method' == 'get' && !.'noautoparams') => {
			with cp_pair in #clientparams do => {
				if(#cp_pair -> isa(::pair)) => {
					// check if param name appears in form action
					// turn param into [p][a][r][a][m] to avoid problems with most reserved regex characters like .
					if(#cp_pair-> name -> beginswith('-')
						&& #cp_pair -> name != '-session'
						&& .'fields' !>> #cp_pair -> name
						&& string_findregexp(.'formaction', -find = ('[?;&][' + #cp_pair-> name -> split('') -> join('][') + ']([&=]|$)'), -ignorecase) -> size == 0) => {
						#output -> append(('<input type="hidden" name="' + #cp_pair-> name + '" value="' + encode_html(#cp_pair-> value) + '"' + #endslash + '>\n'))
					}
				// check if param appears in form action
				// turn param into [p][a][r][a][m] to avoid problems with most reserved regex characters like .
				else(#cp_pair-> isa(::string)
					&& #cp_pair -> beginswith('-')
					&& .'fields' !>> #cp_pair
					&& string_findregexp(.'formaction', -find = ('[?;&][' + #cp_pair -> split('') ->join('][') + ']([&=]|$)'), -ignorecase) -> size == 0)
					#output -> append('<input type="hidden" name="' + #cp_pair + '"' + #endslash + '>\n')
				}
			}
		}

		if(.'database' -> isa(::knop_database)) => {
			if(string(.'database' -> lockfield) -> size > 0 && string(.'db_lockvalue') -> size > 0) => {
				#output -> append('<input type="hidden" name="-lockvalue" value="' + encode_html(.'db_lockvalue') + '"' + #endslash + '>\n')
			else(.'database' -> keyfield != '' && .'db_keyvalue' != '' && .'db_keyvalue' != null)
				#output -> append('<input type="hidden" name="' + .'keyparamname' + '" value="' + encode_html(.'db_keyvalue') + '"' + #endslash + '>\n')
			}
		}

		.'start_rendered' = true
		return #output

// 	} // end debug
	}

	public renderformend(xhtml::boolean = false) => {
// debug => {

		local(output = string)
		if(.'fieldset') => {
			#output -> append('</fieldset>\n')
		}

		// render closing form tag
		#output -> append('</form>')

		.'end_rendered' = true
		return(#output)

// 	} // end debug
	}

/**!
Outputs HTML for the form fields, a specific field, a range of fields or all fields of a specific type. \
			Also inserts all needed javascripts into the page. \
			Use form -> setformat first to specify the html format, otherwise default format #label# #field##required#<br> is used. \n\
			Parameters:\n\
			-name (optional) Render only the specified field\n\
			-from (optional) Render form fields from the specified number index or field name. Negative number count from the last field.\n\
			-to (optional) Render form fields to the specified number index or field name. Negative number count from the last field.\n\
			-type (optional) Only render fields of this or these types (string or array)\n\
			-excludetype (optional) Render fields except of this or these types (string or array)\n\
			-legend (optional) Groups the rendered fields in a fieldset and outputs a legend for the fieldset\n\
			-start (optional) Only render the starting <form> tag\n\
			-end (optional) Only render the ending </form> tag\n\
			-xhtml (optional flag) XHTML valid output
**/
	public renderform(
		name::string = '',
		from = 0,
		to = 0,
		type = '',
		excludetype = '',
		legend::string = '',
		xhtml::boolean = false,
		onlyformcontent::boolean = false,
		bootstrap::boolean = false
	) => debug => {
/*name::string = '', 	// field name
		from = 1, 	// number index or field name
		to = 0, 		// number index or field name
		type = '',	// only output fields of this or these types (string or array)
		excludetype = '',	// output fields except of this or these types (string or array)
		legend::string = '', // groups the rendered fields in a fieldset and outputs a legend for the fieldset
		xhtml::boolean = false   // xhtml =  boolean, if set to true adjust output for XHTML
		*/

		/*
		protect
			handle()
				//log_critical('protect handler triggered: '+error_currenterror)
				//knop_debug('Done with ' + .type + ' -> ' + tag_name, -time, -type = .type)
			/handle
		*/

		// Outputs HTML for the form fields
		/*
			TODO:
			Handling of multiple fields with the same name
		*/
		local(output = '')
		local(onefield = map)
		local(renderfield = '')
		local(renderfield_base = '')
		local(renderrow = '')
		local(usehint = array)
		local(nowarning = false)
		local(fieldtype = null)
		local(fieldvalue = '')
		local(fieldvalue_array = array)
		local(options = array)
		local(focusfield = null)
		local(_from = #from -> ascopy)
		local(_to = #to -> ascopy)
		local(_type = #type -> ascopy)
		local(linebreak = false)

		local(endslash = (.xhtml(params) ? ' /' | ''))

		#onlyformcontent ? .'start_rendered' = true

		if(.'start_rendered' == false) => {
			#output -> append(.renderformstart)
		}

		(string(#name) -> size > 0 && .'fields' !>> #name) 	? 	return('name failure')

		if(#name != '') => {
			#_from = #name -> ascopy
			#_to = #name -> ascopy
		}

		(#_to -> isa(::string) && #_to -> size == 0) || (#_to -> isa(::integer) && #_to == 0) ? #_to = .'fields' -> size
		#_type == '' ? #_type = .'validfieldtypes'
		#excludetype == '' ? #excludetype = map
		#_type -> isa(::string) ? #_type = map(#_type)
		#excludetype -> isa(::string) ? #excludetype = map(#excludetype)

		// only render form inputs if we are not only rendering the form tags

		// use field name if #_from is a string
		#_from -> isa(::string) ? #_from = integer(.'fields' -> findindex(#_from) -> first)
		#_from == 0 ? #_from = 1

		// negative numbers count _from the end
		#_from < 0 ? #_from = .'fields'-> size + #_from

		// use field name if #_to is a string
		#_to -> isa(::string) ? #_to = integer(.'fields' -> findindex(#_to) -> last)
		#_to == 0 ? #_to = .'fields'-> size
		// negative numbers count from the end
		#_to < 0 ? #_to = .'fields'-> size + #_to

		// sanity check
		#_from > #_to ? #_to = #_from

		local(template = ( .template != '' ? .template | '#label# #field##required#<br />\n' ) )

		#template -> replace('#label#', '#labelstart##labelend#')


		//local('buttontemplate'= ( .'buttontemplate' != '' ? .'buttontemplate' | (.'template' != '' ? .'template' | '#field#\n' )))
		if(.buttontemplate -> size > 0) => {
			local(buttontemplate = .'buttontemplate')
		else(.'template' -> size > 0)
			local(buttontemplate = .'template')
		else
			local(buttontemplate = '#field#\n')
		}
		local(requiredmarker = .'required')
		local(defaultclass = ( .'class' != '' ? .'class' | ''))
		if(#legend -> size > 0) => {
			.'render_fieldset2_open' = true
			#output -> append('<fieldset>\n' + '<legend>' + #legend + '</legend>\n')
		}

		loop(-from = #_from, -to = #_to) => {

			#onefield = .'fields' -> get(loop_count) -> value
			#fieldvalue = #onefield -> find('value')
			#fieldvalue_array = #fieldvalue -> asCopy
//log_critical('onefield: '+#onefield+' fieldvalue: '+#fieldvalue+' array: '+#fieldvalue_array)
			if(!#fieldvalue_array -> isa(::array)) => {
				if(string(#fieldvalue_array) >> '\r') => { // Filemaker value list with multiple checked
					#fieldvalue_array = #fieldvalue_array -> split('\r')
				else(string(#fieldvalue_array) >> ','); // Other database with multiple checked
					#fieldvalue_array = #fieldvalue_array -> split(',')
				else
					#fieldvalue_array = array(#fieldvalue_array)
				}
			}

			if(#onefield -> find('options') -> size > 0) => {

				#options = array

				// convert types for pair
				with optionitem in #onefield -> find('options') do => {
					(!#optionitem -> isa(::pair)) ?
						#options -> insert(pair(#optionitem -> ascopy = #optionitem -> ascopy)) |
						#options -> insert(#optionitem -> ascopy)
				}
				#onefield -> insert('options' = #options)

			}

			#fieldtype = #onefield ->find('type')
			if(#_type >> #fieldtype && #excludetype !>> #fieldtype) => {

				if(.'unsavedwarning' == '') => {
					#nowarning = true
				else
					#nowarning = #onefield ->find('nowarning')
				}

				if(map('submit', 'reset', 'image') >> #fieldtype) => {
					#renderrow = #buttontemplate -> asCopy
				else
					#renderrow = #template -> asCopy
				}
				if(#onefield -> find('id') -> size) => {
					local(id = #onefield -> find('id'))
				else
					local(id = (.'formid' + '_' + #onefield ->find('name') + loop_count))
				}
				if((.'errors' == null || .'errors'-> size == 0) && #focusfield == '' && #onefield -> find('focus')) => {
					// give this field focus
					#focusfield = #id
				}

				// set field label, with error marker if field validation failed
				// if((.'exceptionfieldtypes') >> (#fieldtype) && (#fieldtype) != 'file')
				//	#renderrow -> replace('#label#', '')
				//else:
				if(.'errors'-> isa(::array) && .'errors' >> #onefield -> find('name')) => {
					#renderrow -> replace('#labelstart#',
						('<label for="' + #id + '" id="' + #id + '_label" class="' + .errorclass + '">' + #onefield -> find('label')))
					#renderrow -> replace('#labelend#',
						('</label>'))
					#renderrow ->replace('#errorclass#', .errorclass)
					if(#focusfield == '') => {
						#focusfield = #id
					}
				else
					#renderrow ->replace('#labelstart#', ('<label for="' + #id + '" id="' + #id + '_label">' + #onefield -> find('label')))
					#renderrow ->replace('#labelend#', ('</label>'))
					#renderrow ->replace('#errorclass#', '')
				}

				if(#onefield -> find('helpblock') -> size) => {
					#renderrow -> replace('#helpblock#', #onefield -> find('helpblock'))
				else
					#renderrow -> replace('#helpblock#', '')
				}

				// helps identifying layout blocks related to this field
				#renderrow -> replace('#id#', #id)

				// set markers for required fields
				if(#onefield -> find('required') && .'exceptionfieldtypes' !>> #fieldtype) => {
					#renderrow -> replace('#required#', #requiredmarker)
				else
					#renderrow -> replace('#required#', '')
				}
				#renderfield = string
				#renderfield_base = (' name="' + encode_html(#onefield ->find('name')) + '"'
					+ (#onefield >> 'class' ?  (' class="' + #onefield ->find('class') + '"')
						| (#defaultclass != '' ? (' class="' + #defaultclass + '"') ) )
					+ ' id="' + encode_html(#id) + '"'
					+ (#onefield >> 'raw'	?  (' ' + #onefield ->find('raw')) )
					+ (#onefield ->find('disabled') ? ' disabled="disabled"') )

				if(#fieldtype == 'search' && client_type !>> 'WebKit') => {
					// only show <input type=search" for WebKit based browsers like Safari
					#fieldtype = 'text'
				}
				match(#fieldtype) => {
					case('html')

						#renderrow = #template -> ascopy
						#renderrow -> replace('#labelstart#', '')
						#renderrow -> replace('#labelend#', '')
						#renderrow -> replace('#required#', '')
						#renderfield = (#fieldvalue + '\n')
					case('legend')
						#renderrow = ''
						if(.'render_fieldset_open') => {
							#output -> append('</fieldset>\n')
							.'render_fieldset_open' = false
						}
						#output -> append('<fieldset'
							+ (#onefield >> 'class' ?  (' class="' + #onefield -> find('class') + '"')
								| (#defaultclass != '' ? (' class="' + #defaultclass + '"') ))
							+ (#onefield ->find('id') != '' ? (' id="' + #id + '"') )
							+ '>\n')
						.'render_fieldset_open' = true
						#output -> append('<legend>' + encode_html(#fieldvalue) + '</legend>\n')
					case('fieldset')
						#renderrow = ''
						if(.'render_fieldset_open') => {
							#output -> append('</fieldset>\n')
							.'render_fieldset_open' = false
						}
						if(#fieldvalue !== false) => {
							.'render_fieldset_open' = true
							#output -> append('<fieldset'
							+ (#onefield >> 'class' ?  (' class="' + #onefield -> find('class') + '"')
								| (#defaultclass != '' ? (' class="' + #defaultclass + '"')))
							+ (#onefield ->find('id') != '' ? (' id="' + #id + '"') )
							+ '>\n<legend>' + encode_html(#fieldvalue) + '</legend>\n') // must contain a legend
						}
					case('hidden')
						#renderfield -> append('<input type="hidden"'
							+ #renderfield_base
							+ ' value="' + encode_html(#fieldvalue) + '"' + #endslash + '>')
						#renderrow = ''
						#output -> append((#renderfield + '\n'))
					case('text', 'url', 'email', 'number', 'tel')
						#renderfield -> append('<input type="' + #fieldtype + '"'
							+ #renderfield_base
							+ ' value="' + encode_html(#fieldvalue) + '"'
							+ (#onefield >> 'size' 	? (' size="' + #onefield ->find('size') + '"' ))
							+ (#onefield >> 'maxlength' ? (' maxlength="' + #onefield ->find('maxlength') + '"' )))
						if(!.'noscript' && #onefield ->find('hint') -> size > 0) => {
							#renderfield -> append(' onfocus="clearHint(this)" onblur="setHint(this, \''+#onefield ->find('hint')+'\')"')
							#usehint ->insert(#onefield -> find('name') = #id)
						else(#onefield ->find('hint') -> size > 0)
							#renderfield -> append(' placeholder="' + encode_html(#onefield ->find('hint')) + '"')
						}
						if(!.'noscript' && !#nowarning) => {
							#renderfield -> append(' onkeydown="dirtyvalue(this)" onkeyup="makedirty(this)"')
						}
						#renderfield -> append(#endslash + '>')
					case('search')
						#renderfield -> append('<input type="search"'
							+ #renderfield_base
							+ ' value="' + encode_html(#fieldvalue) + '"'
							+ (#onefield >> 'size' 	? (' size="' + #onefield ->find('size') + '"' )))
						if(#onefield ->find('hint') -> size > 0) => {
							#renderfield -> append(' placeholder="' + encode_html(#onefield ->find('hint')) + '"')
						}
						if(!.'noscript' && !#nowarning) => {
							#renderfield -> append(' onkeydown="dirtyvalue(this)" onkeyup="makedirty(this)"')
						}
						#renderfield -> append(#endslash + '>')
					case('password')
						#renderfield -> append('<input type="password"'
							+ #renderfield_base
							+ ' value="' + encode_html(#fieldvalue) + '"'
							+ (#onefield >> 'size' 	? (' size="' + #onefield ->find('size') + '"' )))
						if(!.'noscript' && !#nowarning) => {
							#renderfield -> append(' onkeydown="dirtyvalue(this)" onkeyup="makedirty(this)"')
						}
						#renderfield -> append(#endslash + '>')
					case('textarea')
						#renderfield -> append('<textarea'
							+ #renderfield_base
							+ (#onefield >> 'cols' 	? (' cols="' + #onefield ->find('cols') + '"'))
							+ (#onefield >> 'rows' 	? (' rows="' + #onefield ->find('rows') + '"')))
						if(!.'noscript' && #onefield ->find('hint') != '') => {
							#renderfield -> append(' onfocus="clearHint(this)" onblur="setHint(this, \''+#onefield ->find('hint')+ '\')"')
							#usehint ->insert(#onefield -> find('name') = #id)
						}
						if(!.'noscript' && !#nowarning) => {
							#renderfield -> append(' onkeydown="dirtyvalue(this)" onkeyup="makedirty(this)"')
						}
						#renderfield -> append('>' + encode_html(#fieldvalue) + '</textarea>')
					case('checkbox')
						#linebreak = #onefield -> find('linebreak')
						if(#bootstrap) => {
							local(optioncount = integer)
							#renderfield -> append('<div class="inputgroup'
								+ (#onefield -> find('class') -> size > 0 ?  ' ' + (#onefield -> find('class'))
								| (#defaultclass != '' ? ' ' + #defaultclass) )
								+ '" id="' + #id + '">\n')

							with optionitem in #options do => {

								#optioncount += 1
//								#renderfield -> append( (#optioncount > 1 && #linebreak) ? ('<br />') + '\n')
								if(#optionitem -> name == '-optgroup') => {
									#renderfield -> append((!#linebreak && #optioncount > 1) ? ('\n<br />'))
									if(#optionitem -> value != '-optgroup') => {
										#renderfield -> append(#optionitem -> value
											+ (!#linebreak ? ('<br />\n')))
									}
								else
									#renderfield -> append('<label class="checkbox ' + (#linebreak ? ' inline') + '"><input type="checkbox"'
										+ string_replaceregexp(#renderfield_base, -find = 'id="(.+?)"', -replace = ('id="\\1_' + #optioncount + '"'))
										+ ' value="' + encode_html(#optionitem -> name) + '"')
									if(#optionitem -> name != '' && #fieldvalue_array >> #optionitem -> name) => {
										#renderfield -> append(' checked="checked"')
									}
									#renderfield -> append(#endslash + '> ' + #optionitem -> value + '</label>\n')
								}
							}
							#renderfield -> append('</div>\n')
						else
							local(optioncount = integer)
							#renderfield -> append('<div class="inputgroup'
								+ (#onefield -> find('class') -> size > 0 ?  ' ' + (#onefield -> find('class'))
								| (#defaultclass != '' ? ' ' + #defaultclass) )
								+ '" id="' + #id + '">\n')

							with optionitem in #options do => {

								#optioncount += 1
								#renderfield -> append( (#optioncount > 1 && #linebreak) ? ('<br />') + '\n')
								if(#optionitem -> name == '-optgroup') => {
									#renderfield -> append((!#linebreak && #optioncount > 1) ? ('\n<br />'))
									if(#optionitem -> value != '-optgroup') => {
										#renderfield -> append(#optionitem -> value
											+ (!#linebreak ? ('<br />\n')))
									}
								else
									#renderfield -> append('<span><input type="checkbox"'
										+ string_replaceregexp(#renderfield_base, -find = 'id="(.+?)"', -replace = ('id="\\1_' + #optioncount + '"'))
										+ ' value="' + encode_html(#optionitem -> name) + '"')
									if(#optionitem -> name != '' && #fieldvalue_array >> #optionitem -> name) => {
										#renderfield -> append(' checked="checked"')
									}
									if(!.'noscript' && !#nowarning) => {
										#renderfield -> append(' onclick="makedirty();"')
									}
									#renderfield -> append(#endslash + '> <label for="' + #id + '_' + #optioncount
										+ '" id="' + #id + '_' + #optioncount + '_label"')
									if(.'noscript' && !#nowarning) => {
										#renderfield -> append(' onclick="makedirty();"')
									}
									#renderfield -> append('>' + #optionitem -> value + '</label></span>')
								}
							}
							#renderfield -> append('</div>\n')
						}


					case('radio')
						if(#bootstrap) => {
							local(optioncount = integer)
							#renderfield -> append('<div class="inputgroup'
								+ (#onefield -> find('class') -> size > 0 ?  ' ' + (#onefield -> find('class'))
								| (#defaultclass != '' ? ' ' + #defaultclass) )
								+ '" id="' + #id + '">\n')

							with optionitem in #options do => {

								#optioncount += 1
//								#renderfield -> append( (#optioncount > 1 && #linebreak) ? ('<br />') + '\n')
								if(#optionitem -> name == '-optgroup') => {
									#renderfield -> append((!#linebreak && #optioncount > 1) ? ('\n<br />'))
									if(#optionitem -> value != '-optgroup') => {
										#renderfield -> append(#optionitem -> value
											+ (!#linebreak ? ('<br />\n')))
									}
								else
									#renderfield -> append('<label class="radio ' + (#linebreak ? ' inline') + '"><input type="radio"'
										+ string_replaceregexp(#renderfield_base, -find = 'id="(.+?)"', -replace = ('id="\\1_' + #optioncount + '"'))
										+ ' value="' + encode_html(#optionitem -> name) + '"')
									if(#optionitem -> name != '' && #fieldvalue_array >> #optionitem -> name) => {
										#renderfield -> append(' checked="checked"')
									}
									#renderfield -> append(#endslash + '> ' + #optionitem -> value + '</label>\n')
								}
							}
							#renderfield -> append('</div>\n')
						else
							#linebreak = #onefield -> find('linebreak')
							local(optioncount = integer)
							#renderfield -> append('<div class="inputgroup'
								+ (#onefield -> find('class') -> size > 0 ?  ' ' + (#onefield -> find('class'))
								| (#defaultclass != '' ? ' ' + #defaultclass) )
								+ '" id="' + #id + '">\n')

							with optionitem in #options do => {

								#optioncount += 1
								#renderfield -> append(((#optioncount > 1 && #linebreak) ? ('<br />') )+ '\n')
								if(#optionitem -> name == '-optgroup') => {
									#renderfield -> append((!#linebreak && #optioncount > 1) ? ('\n<br />'))
									if(#optionitem -> value != '-optgroup') => {
										#renderfield -> append(#optionitem -> value
											+ (!#linebreak ? ('<br />\n')))
									}
								else
									#renderfield -> append('<input type="radio"'
										+ string_replaceregexp(#renderfield_base, -find = 'id="(.+?)"', -replace = ('id="\\1_' + #optioncount + '"'))
										+ ' value="' + encode_html(#optionitem -> name) + '"')
									if(#optionitem-> name != '' && #fieldvalue_array >> #optionitem -> name) => {
										#renderfield -> append(' checked="checked"')
									}
									if(!.'noscript' && !#nowarning) => {
										#renderfield -> append(' onclick="makedirty();"')
									}
									#renderfield -> append(#endslash + '> <label for="' + #id + '_' + #optioncount
										+ '" id="' + #id + '_' + #optioncount + '_label"')
									if(!.'noscript' && !#nowarning) => {
										#renderfield -> append(' onclick="makedirty();"')
									}
									#renderfield -> append('>' + #optionitem -> value + '</label> ')
								}
							}
							#renderfield -> append('</div>\n')
						}

					case('select')
						#renderfield -> append('<select '
							+ #renderfield_base
							+ (#onefield -> find('multiple') ? ' multiple="true"')
							+ (#onefield >> 'size' 	? (' size="' + #onefield ->find('size') + '"') ))
						if(!.'noscript' && !#nowarning) => {
							if(#renderfield >> 'onchange="') => {
								#renderfield -> replace('onchange="', 'onchange="makedirty();')
							else
								#renderfield -> append(' onchange="makedirty()"')
							}
						}
						#renderfield -> append('>\n')
						if(#onefield -> find('default') -> size > 0 && #onefield ->find('size') <= 1) => {
							#renderfield -> append('<option value="">' + encode_html(#onefield -> find('default')) + '</option>\n<option value=""></option>\n')
						}
						local(optgroup_open = false)
						with optionitem in #options do => {
							if(#optionitem -> name == '-optgroup') => {
								if(#optgroup_open) => {
									#renderfield -> append('</optgroup>\n')
								}
								if(#optionitem -> value != '-optgroup') => {
									#renderfield -> append('<optgroup label="' + #optionitem -> value + '">\n')
									#optgroup_open = true
								}
							else
								#renderfield -> append('<option value="' + encode_html(#optionitem -> name) + '"')
								if(#optionitem -> name != '' && #fieldvalue_array >> #optionitem -> name) => {
									#renderfield -> append(' selected="selected"')
								}
								#renderfield -> append('>' + encode_html(#optionitem -> value) + '</option>\n')
							}
						}
						if(#optgroup_open) => {
							#renderfield -> append('</optgroup>\n')
						}
						#renderfield -> append('</select>\n')
					case('submit')
						if(#bootstrap) => {
							#renderfield -> append('<button type="submit"'
								+ #renderfield_base)
							if(.formmode == 'add'
								&& !#onefield -> find('disabled') // already disabled
								&& (#onefield -> find('originaltype') == 'savebutton' || #onefield -> find('originaltype') == 'deletebutton'
								|| #onefield -> find('name') == 'button_save' || #onefield -> find('name') == 'button_delete')) => {
								#renderfield -> append(' disabled="disabled"')
							}

							#renderfield -> append('>' + #fieldvalue + '</button>')

						else
							#renderfield -> append('<input type="submit"'
								+ #renderfield_base
								+ ' value="' + encode_html(#fieldvalue) + '"')
							if(.formmode == 'add'
								&& !#onefield -> find('disabled') // already disabled
								&& (#onefield -> find('originaltype') == 'savebutton' || #onefield -> find('originaltype') == 'deletebutton'
								|| #onefield -> find('name') == 'button_save' || #onefield -> find('name') == 'button_delete')) => {
								#renderfield -> append(' disabled="disabled"')
							}
							if(!.'noscript'
								&& (#onefield ->find('name') == 'button_delete'
									|| #onefield ->find('originaltype') == 'deletebutton'
									|| #onefield ->find('confirmmessage') != '')) => {
								local(confirmmessage = (#onefield -> find('confirmmessage') -> size > 0
									? #onefield -> find('confirmmessage') | 'Really delete?'))
								#confirmmessage ->replace('"', '&quot;')
								#confirmmessage ->replace('\'', '\\\'')
								#renderfield -> append(' onclick="return confirm(\'' + #confirmmessage +  '\')"')
							}
							#renderfield -> append(#endslash + '>')
						}
					case('reset')
						#renderfield -> append('<input type="reset"'
							+ #renderfield_base
							+ ' value="' + encode_html(#fieldvalue) + '"')

						if(!.'noscript' && #onefield -> find('confirmmessage') != '') => {
							local(confirmmessage = #onefield ->find('confirmmessage'))
							#confirmmessage ->replace('"', '&quot;')
							#confirmmessage ->replace('\'', '\\\'')
							#renderfield -> append(' onclick="if(confirm(\'' + #confirmmessage +  '\')){makeundirty();return true}else{return false};"')
						else(!.'noscript')
							#renderfield -> append(' onclick="makeundirty();"')
						}
						#renderfield -> append(#endslash + '>')
					case('image')
						#renderfield -> append('<input type="image"'
							+ #renderfield_base
							+ ' value="' + encode_html(#fieldvalue) + '"')
						if(.formmode == 'add' &&
							(#onefield -> find('originaltype') == 'savebutton' || #onefield ->find('originaltype') == 'deletebutton'
							|| #onefield ->find('name') == 'button_save' || #onefield ->find('name') == 'button_delete')) => {
							#renderfield -> append(' disabled="disabled"')
						}
						if(!.'noscript'
							&& (#onefield ->find('name') == 'button_delete'
								|| #onefield ->find('originaltype') == 'deletebutton'
								|| #onefield ->find('confirmmessage') != '')) => {
							local(confirmmessage = (#onefield ->find('confirmmessage') != ''
								? #onefield ->find('confirmmessage') | 'Really delete?'))
							#confirmmessage ->replace('"', '&quot;')
							#confirmmessage ->replace('\'', '\\\'')
							#renderfield -> append(' onclick="return confirm(\'' + #confirmmessage +  '\')"')
						}
						#renderfield -> append(#endslash + '>')
					case('file')
						#renderfield -> append('<input type="file"' + #renderfield_base)
						if(!.'noscript' && !#nowarning) => {
							if(#renderfield >> 'onchange="') => {
								#renderfield ->replace('onchange="', 'onchange="makedirty();')
							else
								#renderfield -> append(' onchange="makedirty()"')
							}
						}
						#renderfield -> append(#endslash + '>')
				}

				#renderrow ->replace('#field#', #renderfield)
				#output -> append(#renderrow)
			}
		}

		// Add just the needed scripts to support the client side functionality
		if(!.'noscript') => {

			#output >> 'togglecontrol(' ?
				 .afterhandler(-endscript = 'function togglecontrol(obj){
					// toggles checkboxes and radios when clicking on label (for browsers that don´t support this already)
					switch (obj.type){
					case \'checkbox\':
						obj.checked=!obj.checked
						break
					case \'radio\':
						obj.checked=true
						break
					}
				}')
			#output >> 'setHint(' ?
				 		.afterhandler(-endscript = 'function setHint(myField, hint) {
					if(myField.value==\'\') {
						if(myField.name.indexOf(\'off_\') != 0) {
							myField.name=\'off_\' + myField.name
						}
						myField.value=hint
						getStyleObject(myField.id).color=\'#aaa\'
					}
				}
				function clearHint(myField) {
					if(myField.name.indexOf(\'off_\') == 0) {
						myField.name=myField.name.substr(4)
						myField.value=\'\'
						getStyleObject(myField.id).color=\'black\'
					}
				}
				function getStyleObject(objectId) {
					if(document.getElementById && document.getElementById(objectId)) {
					return document.getElementById(objectId).style
					} else {
					return false
					}
				}')

			#output >> 'makedirty(' || #output >> 'validateform(' ?
				 .afterhandler(-endscript = ('
				var dirty=' + (.'errors' -> size ? 'true' | 'false') + '
				var dirtycheckname=null
				var dirtycheckvalue=null
				var submitBlock=false
				function validateform(myForm) {
					// perform validation of myForm here
					if(submitBlock){return false}
					makeundirty()
					return true
				}

				function dirtyvalue(obj){ // to be called at keydown to track if a text field changes or if arrow keys/tab/cmd-keys are pressed
					 dirtycheckname = obj.name
					 dirtycheckvalue = obj.value
				}
				function makeundirty(){
					dirty=false
					dirtymarker()
					window.onbeforeunload=null
				}
				function makedirty(obj){
					if(obj){ // if object is specified then we are tracking if the value changes through keydown/keyup
						if (obj.value == dirtycheckvalue || obj.name != dirtycheckname) { // no change or tabbed to another field - return immediately
							return
						}
					}
					dirty=true
					dirtymarker()
				}
				function checkdirty(){
					if(dirty){
						return confirm(\'' + (.'unsavedwarning') + '\')
					} else {return true}
				}

				function dirtymarker() {
					var obj = document.getElementById(\'' + (.'unsavedmarker') + '\')
					if(dirty && obj){
						jscss(\'add\',obj,\'' + (.'unsavedmarkerclass') + '\')
					}else if(obj) {
						jscss(\'remove\',obj,\'' + (.'unsavedmarkerclass') + '\')
					}
				}
				function jscss(a,o,c1,c2){
					/*
						a = action: swap, add, remove, check
						o = object
						c1 = name of the class (first class for swap)
						c2 = for swap, name of the second class
						http://onlinetools.org/articles/unobtrusivejavascript/cssjsseparation.html
					*/
					switch (a){
						case \'swap\':
							o.className=!jscss(\'check\',o,c1)?o.className.replace(c2,c1): o.className.replace(c1,c2)
							break
						case \'add\':
							if(!jscss(\'check\',o,c1)){o.className+=o.className?\' \'+c1:c1;}
							break
						case \'remove\':
							var rep=o.className.match(\' \'+c1)?\' \'+c1:c1
							o.className=o.className.replace(rep,\'\')
							break
						case \'check\':
							return new RegExp(\'\\\\b\'+c1+\'\\\\b\').test(o.className)
							break
					}
				}
				if(dirty) {makedirty()};'))

				(.'unsavedwarning') != '' ?
					.afterhandler(-endscript = ('function beforeunload() {
					if(dirty) {return \'' + (.'unsavedwarning') + '\';}
				}
				window.onbeforeunload=beforeunload;'))

			#output >> 'submitOk' ?
				.afterhandler(-endscript = ('function submitOk(e) { // prevents submit-on-enter
				var keynum
				var elTarget
				var elType

				// get keycode for the event
				if(window.event) keynum = e.keyCode; // IE
				else if(e.which) keynum = e.which; // DOM

				// get target
				if (e.target) elTarget = e.target
				else if (e.srcElement) elTarget = e.srcElement

				if(elTarget.tagName.toLowerCase()  == \'input\') elType = elTarget.getAttribute(\'type\').toLowerCase()
				submitBlock=false
				if (elType != \'submit\' && elType != \'image\' && elType != \'reset\') {
					// allow enter submit when submit button/image or reset button has focus
					if (keynum==13) submitBlock=true
				}
				return true
			}'))
		} // noscript

		if(false && $knop_form_renderform_counter <= 1) => {
				.afterhandler(-headscript =
					('function getStyleObject(objectId) {
						if(document.getElementById && document.getElementById(objectId)) {
						return document.getElementById(objectId).style
						} else {
						return false
						}
					}

					function jscss(a,o,c1,c2){
						/*
							a = action: swap, add, remove, check
							o = object
							c1 = name of the class (first class for swap)
							c2 = for swap, name of the second class
							http://onlinetools.org/articles/unobtrusivejavascript/cssjsseparation.html
						*/
						switch (a){
							case \'swap\':
								o.className=!jscss(\'check\',o,c1)?o.className.replace(c2,c1): o.className.replace(c1,c2)
								break
							case \'add\':
								if(!jscss(\'check\',o,c1)){o.className+=o.className?\' \'+c1:c1;}
								break
							case \'remove\':
								var rep=o.className.match(\' \'+c1)?\' \'+c1:c1
								o.className=o.className.replace(rep,\'\')
								break
							case \'check\':
								return new RegExp(\'\\\\b\'+c1+\'\\\\b\').test(o.className)
								break
						}
					}

					function togglecontrol(obj){
						// toggles checkboxes and radios when clicking on label (for browsers that don´t support this already)
						switch (obj.type){
						case \'checkbox\':
							obj.checked=!obj.checked
							break
						case \'radio\':
							obj.checked=true
							break
						}
					}

					function setHint(myField, hint) {
						if(myField.value==\'\') {
							if(myField.name.indexOf(\'off_\') != 0) {
								myField.name=\'off_\' + myField.name
							}
							myField.value=hint
							getStyleObject(myField.id).color=\'#aaa\'
						}
					}
					function clearHint(myField) {
						if(myField.name.indexOf(\'off_\') == 0) {
							myField.name=myField.name.substr(4)
							myField.value=\'\'
							getStyleObject(myField.id).color=\'black\'
						}
					}
					var dirty=' + (.'errors' -> size ? 'true' | 'false') + '
					var dirtycheckname=null
					var dirtycheckvalue=null
					var submitBlock=false

					function validateform(myForm) {
						// perform validation of myForm here
						if(submitBlock){return false}
						makeundirty()
						return true
					}

					function dirtyvalue(obj){ // to be called at keydown to track if a text field changes or if arrow keys/tab/cmd-keys are pressed
						 dirtycheckname = obj.name
						 dirtycheckvalue = obj.value
					}
					function makeundirty(){
						dirty=false
						dirtymarker()
						window.onbeforeunload=null
					}
					function makedirty(obj){
						if(obj){ // if object is specified then we are tracking if the value changes through keydown/keyup
							if (obj.value == dirtycheckvalue || obj.name != dirtycheckname) { // no change or tabbed to another field - return immediately
								return
							}
						}
						dirty=true
						dirtymarker()
					}
					function checkdirty(){
						if(dirty){
							return confirm(\'' + (.'unsavedwarning') + '\')
						} else {return true}
					}
					function beforeunload() {
						if(dirty) {
							return \'' + (.'unsavedwarning') + '\'
						}
					}

					function dirtymarker() {
						var obj = document.getElementById(\'' + (.'unsavedmarker') + '\')
						if(dirty && obj){
							jscss(\'add\',obj,\'' + (.'unsavedmarkerclass') + '\')
						}else if(obj) {
							jscss(\'remove\',obj,\'' + (.'unsavedmarkerclass') + '\')
						}
					}
					' + (.'unsavedwarning' != '' ? 'window.onbeforeunload=beforeunload;') + '

					function submitOk(e) { // prevents submit-on-enter
						var keynum
						var elTarget
						var elType

						// get keycode for the event
						if(window.event) keynum = e.keyCode; // IE
						else if(e.which) keynum = e.which; // DOM

						// get target
						if (e.target) elTarget = e.target
						else if (e.srcElement) elTarget = e.srcElement

						if(elTarget.tagName.toLowerCase()  == \'input\') elType = elTarget.getAttribute(\'type\').toLowerCase()
						submitBlock=false
						if (elType != \'submit\' && elType != \'image\' && elType != \'reset\') {
							// allow enter submit when submit button/image or reset button has focus
							if (keynum==13) submitBlock=true
						}
						return true
					}

					'))
		}

		if(!.'noscript' && #usehint -> size > 0) => {
			local(hintscript = string)
			// #usehint is a pair array with name = id
			with hintitem in #usehint do => {
				if(.'fields' >> #hintitem -> name) => {
					#onefield = .'fields' -> find(#hintitem -> name) -> first -> value
					#hintscript -> append('setHint(document.getElementById(\'' + encode_html(#hintitem -> value) + '\'), \''
						+ #onefield -> find('hint') + '\');\n')
				}
			}

			.afterhandler(-endscript = #hintscript)
		}

		if(!.'noscript' && #focusfield != '') => {
			.afterhandler(-endscript = ('document.getElementById(\'' + #focusfield + '\').focus();document.getElementById(\'' + #focusfield + '\').select();'))
		}

		if(.'render_fieldset_open' && (params -> size == 0 || local_defined('end'))) => {
			// inner fieldset is open
			.'render_fieldset_open' = false
			#output -> append('</fieldset>\n')
		}
		if(.'render_fieldset2_open' && #legend -> size > 0) => {
			// inner fieldset is open
			.'render_fieldset2_open' = false
			#output -> append('</fieldset>\n')
		}

		// check if it's relevant to close the form. Should only happen if renderform is called with no params
		if(.'end_rendered' == false && .'formaction' != null && #name == '' && #from == 0 && #to == 0 && #type -> size == 0 && #excludetype -> size == 0) => {
			#output -> append(.renderformend)
		}

		return(#output)

		///protect
	} // end renderform

	public renderform(
		-name::string = '', 	// field name
		-from = 0, 	// number index or field name
		-to = 0, 		// number index or field name
		-type = '',	// only output fields of this or these types (string or array)
		-excludetype = '',	// output fields except of this or these types (string or array)
		-legend::string = '',			// groups the rendered fields in a fieldset and outputs a legend for the fieldset
		-start::boolean = false,
		-end::boolean = false,
		-onlyformcontent::boolean = false,
		-bootstrap::boolean = false,
		-xhtml::boolean = false   // xhtml =  boolean, if set to true adjust output for XHTML

		) => {

		#start ? return(.renderformstart(#xhtml))	// only output the starting <form> tag
		#end ? return(.renderformend(#xhtml))	// only output the end </form> tag
		return .renderform(#name, #from, #to, #type, #excludetype, #legend, #xhtml, #onlyformcontent, #bootstrap)
	}

/**!
renderhtml
Outputs form data as plain HTML, a specific field, a range of fields or all fields of a specific type.
	Some form field types are excluded, such as submit, reset, file etc.
	Use form -> setformat first to specify the html format, otherwise default format #label#: #field#<br> is used.
	Parameters:
		-name (optional) Render only the specified field\n\
		-from (optional) Render fields from the specified number index or field name\n\
		-to (optional) Render fields to the specified number index or field name\n\
		-type (optional) Only render fields of this or these types (string or array)\n\
		-excludetype (optional) Render fields except of this or these types (string or array)\n\
		-legend (optional) Groups the rendered fields in a fieldset and outputs a legend for the fieldset\n\
		-xhtml (optional flag) XHTML valid output
**/
	public renderhtml(name::string = '',	// field name
			from = 0, 	// number index or field name
			to = 0, 			// number index or field name
			type::any = '',			// only output fields of this or these types (string or array)
			excludetype::any = '',	// do not output fields of this or these types (string or array)
			legend::string = '',		// groups the rendered fields in a fieldset and outputs a legend for the fieldset
			xhtml::boolean = false			// boolean, if set to true adjust output for XHTML
			) => {
// debug => {

		local(output = string)
		local(onefield = map)
		local(renderfield = string)
		local(renderfield_base = string)
		local(renderrow = string)
		local(fieldvalue = string)
		local(fieldvalue_array = array)
		local(fieldtype = string)
		local(options = array)
		local(usehint = array)
		local(loopcount = 0)
		local(linebreak = false)

		// local var that adjust tag endings if rendered for XHTML
		local(endslash = (.xhtml(params) ? ' /' | ''))

		#name -> size > 0 && .'fields' !>> #name ? return

		if(#name -> size > 0) => {
			#from = #name -> ascopy
			#to = #name -> ascopy
		}
		#from == '' ? #from = 1
		#to == '' ? #to = .'fields'-> size
		#type == '' ? #type = .'validfieldtypes'
		#excludetype == '' ? #excludetype = map
		#type -> isa(::string) ? #type = map(#type)
		#excludetype -> isa(::string) ? #excludetype = map(#excludetype)

		// use field name if #from is a string
		((#from -> isa(::string)) ? (#from = integer((.'fields') -> findindex( #from) -> first)))
		#from == 0 ? #from = 1
		// negative numbers count from the end
		#from < 0 ? #from = (.'fields') -> size + #from

		// use field name if #to is a string
		((#to -> isa(::string)) ? (#to = integer((.'fields') -> findindex(#to) -> last)))
		#to == 0 ? #to = (.'fields') -> size
		// negative numbers count from the end
		#to < 0 ? #to = (.'fields') -> size + #to

		//Sanity check
		#from > #to ? #to = #from

		local(template = (.'template' != '' ? .'template' | ('#label#: #field#<br />\n' )))
		local(buttontemplate = (.'buttontemplate' != '' ? .'buttontemplate' | (.'template' != '' ? .'template' | '#field#\n') ))
		local(defaultclass = (.'class' != '' ? .'class' | ''))
		if(#legend -> size > 0) => {
			#output -> append('<fieldset>\n' + '<legend>' + #legend + '</legend>\n')
			.'render_fieldset2_open' = true
		}

		loop(-from = #from, -to = #to) => {

			#onefield = .'fields' -> get(loop_count) -> value

			#fieldtype = #onefield -> find('type')

			#fieldvalue = #onefield ->find('value') -> ascopy
			#fieldvalue_array = #fieldvalue
			if(!#fieldvalue_array -> isa(::array)) => {
				if(string(#fieldvalue_array) >> '\r') => { // Filemaker value list with multiple checked
					#fieldvalue_array = #fieldvalue_array -> split('\r')
				else(string(#fieldvalue_array) >> ','); // Other database with multiple checked
					#fieldvalue_array = #fieldvalue_array -> split(',')
				else
					#fieldvalue_array = array(#fieldvalue_array)
				}
			}
			if(#onefield >> 'options') => {
				#options = #onefield -> find('options')
				// convert types for pair
				#options -> isa(::string) ? #options = array(#options)
				with optionitem in #options do => {
					if(!#optionitem -> isa(::pair)) => {
						#optionitem = pair(#optionitem = #optionitem)
					}
					// name must be string to make sure comparisons work
					#optionitem =  pair(string(#optionitem -> name) = #optionitem -> value)
//					#option -> name = string(#option -> name)
				}
			}

			if(loop_count >= #from
				&& loop_count <= #to
				&& #type >> #fieldtype
				&& !(#excludetype >> #onefield ->find('type'))) => {

				if(map('submit', 'reset', 'image') >> #fieldtype) => {
					#renderrow = #buttontemplate -> ascopy
				else
					#renderrow = #template -> ascopy
				}

				if(.'exceptionfieldtypes' >> #fieldtype) => {
					#renderrow -> replace('#label#:', '')
					#renderrow -> replace('#required#', '')
				else(#onefield -> find('label') != '')
					#renderrow -> replace('#label#', encode_html(#onefield -> find('label')) )
				else
					#renderrow -> replace('#label#:', '')
					#renderrow -> replace('#required#', '')
				}
				if(map('radio', 'checkbox', 'select') >> #onefield ->find('type')) => {
					#linebreak = #onefield -> find('linebreak')
					#renderfield = string
					#loopcount = 0
					with onefieldvalue in #fieldvalue_array do => {
						#loopcount += 1
						if(#loopcount > 1) => {
							#renderfield -> append(#linebreak ? ('<br />\n') | ', ')
						}
						if(#options >> #onefieldvalue) => {
							// show the display text for a selected option
							local(thisonefieldvalue = #options ->find(#onefieldvalue) -> first)
							#renderfield -> append(encode_break(string(#thisonefieldvalue -> isa(::pair) ? #thisonefieldvalue -> value | #thisonefieldvalue)))
						else
							// show the option value itself
							#renderfield -> append(encode_break(string(#onefieldvalue)))
						}
					}
				else(#fieldtype == 'html')
					#renderrow = #template
					#renderrow -> replace('#label#', '')
					#renderrow -> replace('#required#', '')
					#renderfield = (#fieldvalue + '\n')
				else(#fieldtype == 'legend')
					#renderrow = ''
					if(.'render_fieldset_open') => {
						#output -> append('</fieldset>\n')
						.'render_fieldset_open' = false
					}
					#output -> append('<fieldset>\n')
					#output -> append('<legend>' + encode_html(#fieldvalue) + '</legend>')
					.'render_fieldset_open' = true
				else(#fieldtype == 'fieldset')
					#renderrow = ''
					if(.'render_fieldset_open') => {
						#output -> append('</fieldset>\n')
						.'render_fieldset_open' = false
					}
					if(#fieldvalue != false) => {
						#output -> append('<fieldset>\n<legend></legend>') // must contain a legend
						.'render_fieldset_open' = true
					}
				else
					#renderfield = encode_break(string(#fieldvalue))
				}
				#renderrow -> replace('#field#', #renderfield)
				#output -> append(#renderrow)
			}
//		}
		}
		if(#legend!='' && .'render_fieldset2_open') => {
			// inner fieldset is open
			.'render_fieldset2_open' = false
			#output -> append('</fieldset>\n')
		}
		return(#output)

// 	} // end debug
	}

	public renderhtml(-name = '',	// field name
			-from = 0, 	// number index or field name
			-to = 0, 			// number index or field name
			-type::any = '',			// only output fields of this or these types (string or array)
			-excludetype::any = '',	// do not output fields of this or these types (string or array)
			-legend::string = '',		// groups the rendered fields in a fieldset and outputs a legend for the fieldset
			-xhtml::boolean = false			// boolean, if set to true adjust output for XHTML
			) => .renderhtml(#name, #from, #to, #type, #excludetype, #legend, #xhtml)

/**!
getvalue
Returns the current value of a form field. Returns an array for repeated form fields.
**/
	public getvalue(name::string, index::integer = 0) => {
// debug => {

		#index < 1 ? #index = 1
		if(.'fields' >> #name) => {
			if(#index > .'fields' -> find(#name) -> size) => {
				return
			}
			return(.'fields' -> find(#name) -> get(#index) -> value -> find('value'))
		}
// 	} // end debug
	}

	public getvalue(name::string, -index::integer = 0) => .getvalue(#name, #index)

/**!
getlabel
Returns the label for a form field.
**/
	public getlabel(name::string) => {

		if(.'fields' >> #name) => {
			return(.'fields' -> find(#name) -> first -> value ->find('label'))
		}
	}

/**!
setvalue
Sets the value for a form field.
	Either form -> (setvalue: fieldname = newvalue) or form -> (setvalue: -name = fieldname, -value = newvalue)
**/
	public setvalue(name, value = '', index::integer = 0) => {
// debug => {

		// either -> (setvalue: 'fieldname' = 'newvalue') or -> (setvalue: -name = 'fieldname', -value = 'newvalue')
		local(_name = #name, '_value' = #value)
		#index < 1 ? #index = 1
		if(#name -> isa(::pair)) => {
			#_name = #name -> name
			#_value = #name -> value
		}
		if(.'fields' >> #_name) => {
			if(#index > .'fields'-> find(#_name)-> size) => {
				return
			}
			// first remove value to break reference
			.'fields' -> get(.'fields' -> findindex(#_name) -> get(#index)) -> value -> remove('value')
			.'fields' -> get(.'fields' -> findindex(#_name) -> get(#index)) -> value -> insert('value' = #_value)
		}

// 	} // end debug
	}

/**!
Sets the param content for a form field.
**/
	public setparam(name::string, param::string, value::any, index::integer = 0) => {
// debug => {

		local(_name = #name -> ascopy)
		#index < 1 ? #index = 1

		if(.'fields' >> #_name && array('class', 'cols', 'confirmmessage', 'dbfield', 'default', 'defaultvalue', 'disabled', 'filter', 'focus', 'hint', 'id', 'label', 'linebreak', 'maxlength', 'multiple', 'name', 'nowarning', 'options', 'raw', 'required', 'rows', 'size', 'type', 'validate', 'value') >> #param) => {

			match(true) => {
				case(#param == 'type')
					fail_if(array('addbutton', 'savebutton', 'deletebutton', ) !>> #value && .'validfieldtypes' !>> #value, -9956, 'The specified param not of the correct type for type')

				case(#param == 'name')

// there's a problem with this since there's no support yet to assign a new value to a pair
// as of 2010-10-21
//					.'fields' -> find(#name) -> get(#index) -> name = (#value -> ascopy)
// instead we need to be a bit more elaborate
					.'fields' -> find(#_name) -> get(#index) = pair(#value = .'fields' -> find(#_name) -> get(#index) -> value)

					local(position = (.'fields' -> findposition(#name)) -> get(#index))
					local(tempcontent = .'fields' -> find(#_name) -> get(#index))
					.'fields' -> remove(#position)

					.'fields' -> insert(pair(#value = #tempcontent -> value), #position)

					#_name = #value

				case(#param == 'size' || #param == 'rows' || #param == 'cols')
					fail_if(!#value -> isa(::integer), -9956, 'The specified value not of the correct type (not integer)')

				case(#param == 'multiple' || #param == 'linebreak' || #param == 'focus' || #param == 'disabled' || #param == 'required' || #param == 'nowarning')

					fail_if(!#value -> isa(::boolean), -9956, 'The specified value not of the correct type (not boolean)')

				case(#param == 'options')

					fail_if(!#value -> isa(::array) && !#value -> isa(::set), -9956, 'The specified value not of the correct type (not array or set)')

			}

			.'fields' -> find(#_name) -> get(#index) -> value -> find(#param) = (#value -> ascopy)
		}

// 	} // end debug
	}

	public setparam(-name::string, -param::string, -value::any, -index::integer = 0) => .setparam(#name, #param, #value, #index)

/**!
removefield
Removes all form elements with the specified name from the form
**/
	public removefield(name::string) => {
// debug => {

		.'fields' -> removeall(#name)

// 	} // end debug
	}

	public removefield(-name::string) => .removefield(#name)

/**!
keys
Returns an array of all field names
**/
	public keys() => {
// debug => {

		local(output = array)
		with fieldpair in .'fields' do => {
			#output -> insert(#fieldpair -> name)
		}

		return(#output)

// 	} // end debug
	}

	public keyvalue() => { return(.'db_keyvalue') }
	public lockvalue() => {return(.'db_lockvalue') }
	public lockvalue_decrypted() => {
		!.'database' -> isa(::knop_database) ? return string
		return(string(decrypt_blowfish(decode_base64(.'db_lockvalue'), -seed = (.'database' -> 'lock_seed'))))




	}

	public database() => { return(.'database') }

/**!
formmode
Returns add or edit after form -> init has been called
**/
	public formmode() => {
// debug => {

		if(.getbutton == 'add') => {
			// this is needed to keep the right form mode after a failed add
			.'formmode' = 'add'
		}

 		return(.'formmode')

//	} // end debug
	}

	public error_code() => {
		// custom error_code for knop_form
		if(.'error_code') => {
			return(integer(.'error_code'))
		else(.'errors' -> isa(::array) && .'errors'-> size > 0)
			.'error_code' = 7101
			return(.'error_code')
		else
			return(0)
		}
	}

/**!
afterhandler
Internal member tag. Adds needed javascripts through an atend handler that will be processed when the entire page is done.
			Parameters:
			-headscript (optional) A single script, will be placed before </head>  (or at top of page if </head> is missing)
			-endscript (optional) Multiple scripts (no duplicates), will be placed before </body> (or at end of page if </body> is missing)
**/
	public afterhandler(headscript::string = '', endscript::string = '') => {
// debug => {

		// adds needed javascripts through an atend handler that will be processed when the entire page is done
		if(!var_defined('knop_afterhandler_data')) => {
			var('knop_afterhandler_data' = map)
			define_atend({ // this will run after the page is done processing
				if($knop_afterhandler_data >> 'headscript') => {
					// put before </head> or at beginning of page
					local(scriptdata = '<script language="javascript" type="text/javascript">\n/*<![CDATA[ */\n'
						+ $knop_afterhandler_data -> find('headscript') -> join('\n')
						+ '\n/* ]]> */\n</script>\n')
					if(content_body >> '</head>') => {
						content_body ->replace('</head>', (#scriptdata + '</head>'))
					else
						content_body = #scriptdata + content_body
					}
				}
				if($knop_afterhandler_data >> 'endscript') => {
					// put before </body> or at end of page
					local(scriptdata = '\n\n\n\n<script language="javascript" type="text/javascript">\n/* <![CDATA[ */\n'
						+ $knop_afterhandler_data ->find('endscript') -> join('\n')
						+ '\n/* ]]> */\n</script>\n')
					if(content_body >> '</body>') => {
						content_body -> replace('</body>', (#scriptdata + '</body>'))
					else
						content_body -> append(#scriptdata)
					}
				}
			})
		}

		if(#headscript!='') => {
			// add to current headscript
			if($knop_afterhandler_data !>> 'headscript') => {
				$knop_afterhandler_data ->insert('headscript' = array)
			}
			if($knop_afterhandler_data ->find('headscript') !>> #headscript) => {
				$knop_afterhandler_data ->find('headscript') -> insert(#headscript)
			}
		}
		if(#endscript!='') => {
			// add to current endscript
			if($knop_afterhandler_data !>> 'endscript') => {
				$knop_afterhandler_data ->insert('endscript' = array)
			}
			if($knop_afterhandler_data ->find('endscript') !>> #endscript) => {
				$knop_afterhandler_data ->find('endscript') -> insert(#endscript)
			}
		}
// 	} // end debug
	}

}
//log_critical('loading knop_form done')
?>