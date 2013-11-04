<?LassoScript

define_type: 'form', 
	'knop_base',
	-namespace='knop_';
//	-prototype; 

	local: 'version'='2013-10-20',
		'description'='Custom type to handle forms.';

/*

CHANGE NOTES
2013-11-04  SP  Added support for buttons to custom widget templates.
2013-11-04  SP  Added support for inputs of type radio and checkbox, and textarea to custom widget templates.
2013-11-03  SP  Added support for <select> to custom widget templates.
2013-11-03  SP  Added -group and -groupclass options to ->addfield for custom widget templates.
2013-10-20  SP  ->renderform and ->addfield(-widget=string): Added new feature.  Provide the name of a widget, which is a custom tag that serves as a template for the field.  All the features of ->renderform are supported.  More flexible than -template.  Idea obtained from Pyramid, a Python web application framework.
2013-10-20  SP  ->fields: Added new feature.  This method returns a map of all non-special type field names and their parameters.
2011-02-28	JS	->addfield: Added -template to specify field specific template 
2010-11-22	SP	->init: Correction of -lockvalue handling after L9 syntax adjustment
2010-07-18	SP	Added support for series for -options
2010-06-10	JS	->renderform: avoid adding -upload parameters to post forms since it conflicts with file uploads (found by Steve Piercy)
2010-04-21	JS	->renderhtml:  removed encode_html for label
2010-03-06	SP	Changed default behavior of ->updatefields with -sql to add backticks between the table and column names.  Now JOINs may be used.
2010-03-06	SP	Added ->updatefields with -removedotbackticks for backward compatibility for fields that contain periods.  If you use periods in a fieldname then you cannot use a JOIN in Knop.
2009-11-11	JS	Added class and id to optiongroup div that surrounds for checkbox and radio
2009-11-11	JS	Corrected id for checkbox and radio option labels
2009-10-02	JS	Added id for labels, auto generated from the field's id with _label appended
2009-09-16	JS	Syntax adjustments for Lasso 9
2009-09-04	JS	Changed $__html_reply__ to content_body
2009-09-04	JS	->renderhtml: corrected typ for autoparams
2009-07-23	JS	->renderform: removed encode_html that somehow has reappeared for label. 
2009-07-10	SP	added -maxlength option for text fields
2009-06-26	JS	->oncreate: added deprecation warning for -action
2009-06-22	JS	->addfield: corrected -options check to look for set instead of series (besides array)
2009-04-16	JS	->loadfileds can now load field values from -params also inside an inline
2009-03-20	JS	Added  <![CDATA[ ... ]]>  around injected scripts for better xhtml compliance
2009-01-08	JS	->getvalue and _unknowntag: added -index parameter to be able to get value for a specific field instance when there are multiple fields with the same name 
2009-01-08	JS	->loadfields: implemented support for multiple fields with the same name when loading field values from form submission where the number of same name fields matches
2009-01-07	JS	->setvalue: added -index parameter to be able to set value for a specific field instance when there are multiple fields with the same name 
2008-12-08	JS	->renderform: Removed the onclick handlers for checkbox and radio since Safari now supports clicking the label text as click for the checkbox/radio control. 
2008-12-05	JS	->renderform: the fieldset and legend field types will now use id and class on the fieldset tag if specified
2008-12-03	JS	->renderform: fields of type fieldset now uses value as legend (just as field type legend already did) instead of always using an empty legend
2008-09-24	JS	->updatefields: Added protection against backtick sql injection in MySQL object names
2008-09-17	JS	->renderform and ->renderhtml: -from and -to allows negative numbers to count from end of form instead
2008-09-13	JS	Added ->getlabel to return the display name for a field. 
2008-09-13	JS	->addfield and ->validate: Implemented -validate to specify a compound expression to validate the field input. 
2008-09-13	JS	->addfield and ->loadfields: Implemented -filter to specify a compound expression to filter the field input. 
2008-09-11	JS	->updatefields: fixed exclusion of special field types html, legend and fieldset. 
2008-09-11	JS	->renderform: Fixed missing value for password fields
2008-07-02	JS	->renderform: Cleaned up the automatic adding of javascript code so it's not added if not needed. Also moved all scripts to the end of the page. More work with with the javascripts is needed.
2008-06-03	JS	->renderform: corrected missing closing </fieldset>
2008-05-15	JS	->renderform and ->renderhtml: adjusted the behavior for nested fieldsets
2008-05-13	JS	Implemented -legend for ->renderhtml, to make it consistent with the new legend field type
2008-05-13	JS	Implemented special field types html, fieldset and legend. Use -value to display data for these fields. A legend field also creates a fieldset (closes any previously open fieldsets). Use fieldset with -value=false to close a fieldset without opening a new one. 
2008-05-06	JS	Added unknowntag as shortcut to getvalue
2008-01-30	JS	Removed duplicate endscript entries for if(dirty) {makedirty()};
2007-12-13	JS	Corrected ->addfield: -dbfield so empty dbfields are properly ignored by ->updatefields. 
2007-12-11	JS	Moved error_msg to knop_base (special version of error_code stays here) 
2007-12-11	JS	Added documentation as -description to most member tags, to be used by the new ->help tag
2007-12-11	JS	Moved ->help to knop_base
2007-11-13	JS	Added -buttontemplate to be able to specify separate template for buttons, defaults to no <br>, but if template has been specified that will be used instead (for backwards compatibility)
2007-11-12	JS	->process delete now works also when not using record locking (not specifying -user)
2007-11-01	JS	->renderform: added support for -hint for textarea fields.
2007-09-27	JS	->renderhtml: multiple values (array) for radio, checkbox and select are now rendered properly with either "," or <br> depending on the presence of -linebreak, and with the display text instead of the actual option value
2007-09-27	JS	->renderform: improved handling of multiple values for checkbox, radio and select
2007-09-21	JS	->addfield: flag parameters now accept false as value
2007-09-06	JS	->oncreate: changed name of -action to -formaction to make it more clear what it is. -action is still supported but deprecated.
2007-09-06	JS	->renderform: Corrected the exception for -session... (duh)
2007-08-08	JS	->renderform: Added exception for -session
2007-06-18	JS	Added tag timer to most member tags
2007-06-13	JS	added inheritance from knop_base
2007-06-12	JC	bugfixed -xhtml form rendering when called by quicksearch
2007-06-11	JC	added handling of xhtml output
2007-04-19	JS	->loadfields: fixed -params that was broken when adding -database
2007-04-19	JS	->renderform: removed invalid wrap="soft" from textarea
2007-04-12	JS	->process: made -user optional (only needed when using record locking)
2007-04-12	JS ->loadfields can now take a -database parameter, either as a flag (no value) where the database object connected to the form will be used, or by specifying a database object as value. 
2007-04-03	JS	Changed namespace from mt_ to knop_
2007-03-01	JS	->renderform fixed unsavedwarning on page load by moving checkdirty() to afterscript
2007-03-01	JS	->formmode and ->init changed so it preserves the right mode after a failed add
2007-02-27	JS	->renderform: added <div class="inputgroup"> around checkboxes and radios for css formating
2007-02-26	JS	->oncreate: added -actionpath to specify the framework action path for the form instead of manually adding the -action hidden field
2007-02-24	JS	Corrected entersubmitblock behavior by adding onfocus handler on form and starting with submitBlock=false
2007-02-23	JS	Removed encode_html from form field labels
2007-02-22	JS	->setformat: Added -legend
2007-02-07	JS	Added ->copyfield to copy a form field to a new name, with the same properties. 
2007-02-07	JS	->errors now returns empty array if validate has not been called, instead of performing validation
2007-02-05	JS	->getbutton can now look for also button names that are not one of the built-in ones (for example button_apply)
2007-02-05	JS The -keyvalue parameter can be given another name by specifying -keyparamname in oncreate
2007-02-02	JS	Added ->lockvalue_decrypted
2007-02-02	JS	->addfield: -value is now stored as reference
2007-02-02	JS	error_code now returns an error for when the form contains validation errors
2007-02-02	JS	Improved reporting of Lasso error messaged in error_msg
2007-02-02	JS 	Added real error codes
2007-01-31	JS	->rederform action_params now also exclude "-" params that appear in the form action
2007-01-29	JS	->renderform: The first field with input error will get focus when loading page
2007-01-29	JS	Added -focus to ->addfield to give default field focus when loading page with form
2007-01-29	JS	Added -disabled to ->addfield, and handling of it in ->renderform
2007-01-29	JS	Added -noautoparams to ->oncreate to disable the automatic passing of action_params that begin with "-"
2007-01-29	JS	->renderform now renders label also for submit, reset to format properly with css
2007-01-26	JS	Added support for Safari specific <input type="search">
2007-01-26	JS	->renderform action_params that begin with "-" now exclude params that exist in the form. Minor corrections to the behavior. 
2007-01-25	JS	Added -nowarning to ->oncreate to disable unsaved warnings for the entire form
2007-01-25	JS	Added -required to ->oncreate (and a few more from ->setformat)
2007-01-23	JS	Autogenerates id for the form itself
2007-01-23	JS	Added ->getbutton to return the button that was clicked when submitting a form (cancel, add, save, delete)
2007-01-23	JS	Added auto conversion of options left hand pair member to string, to make comparsions work reliably. Integer zeros don't compare nicely to strings. 
2007-01-23	JS	Added support for submit-on-enter prevention: specify -entersubmitblock at oncreate
2007-01-19	JS	Addes renderform: -legend to be able to group form fields at render time
2007-01-19	JS	added support for -optgroup in -options for select. Also works for radio and checkbox. Specify empty -optgroup to close optgroup in select without starting a new, or to add extra linebreak between checkboxes/radio buttons. 
2007-01-19	JS	added -template for oncreate
2007-01-19	JS	added optional fieldset and legend to form, legend can be specified as -legend at oncreate. if -legend is specified, the form will be wrapped in a fieldset. 
2007-01-19	JS	method now defaults to post
2007-01-19	JS	Corrected line separator for FileMaker checkboxes and added the same handling also for radio
2007-01-18	JS	renderform: any action_params that begin with "-" (except -keyvalue and -lockvalue) are added as form parameters
2007-01-18	JS	renderform: checkboxes and multiselects now show checked and selected properly when loading values from database
2007-01-18	JS	updatefields: added support for multiple values for one fieldname, like checkboxes (multiple fields in the update pair array, -sql generates comma separated values)
2007-01-17	JS	reset button now makes form undirty
2007-01-17	JS	addfield: -confirmmessage can now be specified for any submit or reset button
2007-01-17	JS	added addfield: -nowarning to avoid unsaved warning when the field is changed
2007-01-17	JS	changed default class name for unsaved marker from dirty to unsaved
2007-01-17	JS	changed name of -dirtymarker and -dirtymarkerclass to unsavedmarker and -unsavedmarkerclass for userfriendlyness
2007-01-17	JS	added setformat: -unsavedwarning to dynamically set the javascript form dirty warning message
2007-01-17	JS	renderform: -field changed to renderform: -name for consistency
2007-01-16	JS	renderform: -field with wrong field name does not output anything, instead of the entire form
2007-01-16	JS	fixed onbeforeunload in javascript form dirty handler

TODO:
->addfield: Add -format to manipulate the field value before it is displayed by ->renderform and ->renderhtml, much like -filter but only for display and without affecting input. 
->addfield: Add -fieldgroup to be able to group related fields together, useful for ->updatefields to return just fields that belong to a specific db table, or ->renderform as another way to render a form selectively
->renderform needs a better way to display errors inline together with the fields
Make _unknowntag also work as shortcut to setvalue if a value is specified
Add a new special field type to the form object, let's say "data". That field type will not interact with forms and will never be touched by loadfields, but it will populate ->updatefields.
Add -> searchfields, which will return a fulltext enabled pair array better suited for searchs than ->updatefields is. -fulltext needs to be specified per field. 
Review and clean up the javascripts inserted automatically by knop_form - partially done
Option to let textarea grow automatically depending on the amount of text in it.  
Use http://bassistance.de/jquery-plugins/jquery-plugin-validation/ instead of client side validation
Possibly add support for the same validation expressions as the jquery validation plugin uses, so server side a nd client side validation can be specified at once. 
Add -path as parameter for oncreate so the form action can be set with less confusion...  In that case -formaction will be a physical url, while -path would be a framework path. 
Fix actionpath reference so it updates properly when altering the value (not possible?)
Should loadfields load "-" params?
Unsavedwarning made optional, does not seem to work properly now?
More flexible error hightlighting
Move templates to a member tag to be make it easier to subclass (Douglas Burchard)
Add "button". <button></button>. Subtypes are submit, reset and button. How to specify the subtype? (Douglas Burchard)
Change ->addfield to ->insert and make ->addfield deprecated
There is no src for input type image!
Add ->size and ->get so the form object can be iterated
Add -skipemtpy to to ->renderhtml
Option for -> renderhtml to output without html encoding
->renderhtml should never html encode fields of type html

*/
	

	// instance variables
	local: 'fields'=array,
		'template'=string,			// html template used to render the html form fields
		'buttontemplate'=string,	// html template used to render the html buttons (submit, reset, image)
		'class'=string,				// default class for all form fields, can be overridden field by field
		'errorclass'=string,		// class used to highlight field labels when validation fails
		'formaction'=null,
		'method'='post',
		'fieldset'=false,			// html form fieldset
		'legend'=null,				// html form legend
		'name'=null,
		'id'=null,
		'raw'=null,
		'enctype'=null,				// is automatically set to multipart/formdata if the form contains a file input
		'actionpath'=null,
		'noautoparams'=false,		// if true then no parameters that begin with - will be automatically added to the form
		'fieldsource'=null,			// the source of the latest -> loadfields, can be database, form or params
		'required'=string,			// marker used to show fields that are required (html or plain string)
		'entersubmitblock'=false,	// if true, a javascript will prevent form submit without clicking on submit button (like pressing enter key)
		'unsavedmarker'=null,
		'unsavedmarkerclass'=null,
		'unsavedwarning'=string,	// must be specified, or else there is no unsaved warning for the form
		'database'=null,
		'keyparamname'=string,		// param name to use instead of the default -keyvalue
		'formmode'=null,			// whether the form is for editing an existing record or a blank for for adding a new record (edit/add)
									// only valid if a database object is specified
		'formbutton'=null,			// the button that was clicked when submitting a form (cancel, add, save, delete)
		'db_keyvalue'=null,
		'db_lockvalue'=null,
		
		'render_fieldset_open'=false,	// used when rendering to keep track of if a fieldset from fieldset or legend field types is open so it can be closed properly
		'render_fieldset2_open'=false,	// used when rendering to keep track of if a fieldset from renderform or renderhtml legend is open so it can be closed properly
		'noscript'=false,				// when set to true, no scripts will be injected by renderform
		'error_lang'=(knop_lang: -default='en', -fallback);
	
	local: 'errors'=null;


	// config vars
	local: 'validfieldtypes' = (map: 'text', 'password', 'checkbox', 'radio', 'textarea', 'select', 'file', 'search',
				'submit', 'reset', 'image', 'hidden', 
				'fieldset', 'legend', 'html'), // special types
		'exceptionfieldtypes' = (map: 'file', 'submit', 'reset', 'image', 'addbutton', 'savebutton', 'deletebutton', 'cancelbutton',
				'fieldset', 'legend', 'html'); // special types
	local: 'validfieldtypes_array'=array;
	iterate: #validfieldtypes, (local: 'temp');
		#validfieldtypes_array -> (insert: #temp -> name);
	/iterate;
	local: 'exceptionfieldtypes_array'=array;
	iterate: #exceptionfieldtypes, (local: 'temp');
		#exceptionfieldtypes_array -> (insert: #temp -> name);
	/iterate;
	
	// page var to keep track of the number of forms that have been rendered on a page
	if: !(var_defined: 'knop_form_renderform_counter');
		var: 'knop_form_renderform_counter'=0;
	/if;
	

	define_tag: 'oncreate', -description='Parameters:\n\
			-formaction (optional) The action atribute in the form html tag\n\
			-action (optional) Deprecated synonym to -formaction\n\
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
			-errorclass (optional string) css class name that will be used for the label to highlight input errors, if not defined style="color: red" will be used\n\
			-unsavedmarker (optional string) id for html element that should be used to indicate when the form becomes dirty. \n\
			-unsavedmarkerclass (optional string) class name to use for the html element. Defaults to "unsaved". \n\
			-unsavedwarning (optional string)\n\
			-keyparamname (optional)\n\
			-noscript (optional flag) if specified, don\'t inject any javascript in the form. This will disable all client side functionality such as hints, focus and unsaved warnings. \n\
			-database (optional database) Optional database object that the form object will interact with',
		// parameters for form html tag attributes
		-optional='formaction',
		-optional='action',
		-optional='method',
		-optional='name',
		-optional='id',
		-optional='raw',

		// knop parameters
		-optional='actionpath',
		-optional='fieldset',
		-optional='legend', 
		-optional='entersubmitblock',
		-optional='noautoparams',
		-optional='template', -type='string',
		-optional='buttontemplate', -type='string',
		-optional='required', -type='string',
		-optional='class', -type='string',
		-optional='errorclass', -type='string',
		-optional='unsavedmarker', -type='string',
		-optional='unsavedmarkerclass', -type='string',
		-optional='unsavedwarning', -type='string',
		-optional='keyparamname',
		-optional='noscript',
		-optional='database', -type='database';
		local: 'timer'=knop_timer; 


		local_defined('method') ? (self -> 'method') = #method;
		local_defined('name') ? (self -> 'name') = #name;
		local_defined('id') ? (self -> 'id') = #id;
		local_defined('raw') ? (self -> 'raw') = #raw;
		local_defined('legend') ? (self -> 'legend') = #legend;
		local_defined('template') ? (self -> 'template') = #template;
		local_defined('buttontemplate') ? (self -> 'buttontemplate') = #buttontemplate;
		local_defined('required') ? (self -> 'required') = #required;
		local_defined('class') ? (self -> 'class') = #class;
		local_defined('errorclass') ? (self -> 'errorclass') = #errorclass;
		local_defined('unsavedmarker') ? (self -> 'unsavedmarker') = #unsavedmarker;
		local_defined('unsavedmarkerclass') ? (self -> 'unsavedmarkerclass') = #unsavedmarkerclass;
		local_defined('unsavedwarning') ? (self -> 'unsavedwarning') = #unsavedwarning;
		local_defined('keyparamname') ? (self -> 'keyparamname') = #keyparamname;

		// the following params are stored as reference, so the values of the params can be altered after adding a field simply by changing the referenced variable. 
		local_defined('formaction') ? (self -> 'formaction') = @#formaction;
		local_defined('actionpath') ? (self -> 'actionpath') = @#actionpath;
		local_defined('database') ? (self -> 'database') = @#database;

		if: !(local_defined: 'formaction') && (local_defined: 'action');
			// keep support for old -action insead of -formaction
			(self -> 'debug_trace') -> insert('*** DEPRECATION WARNING *** ' + tag_name + ' -action parameter is deprecated, use -formaction instead ');
			(self -> 'formaction') = @#action;
		/if;
		
		(self -> 'noscript') = (local_defined('noscript') && #noscript != false);

		// default value
		!(local_defined: 'required') ? (self -> 'required' = '*');
		!(local_defined: 'keyparamname') ? (self -> 'keyparamname' = '-keyvalue');

		(self -> 'fieldset') = ((local_defined: 'fieldset') && #fieldset != false) || (self -> 'legend') != '';
		(self -> 'entersubmitblock') = (local_defined: 'entersubmitblock');
		(self -> 'noautoparams') = (local_defined: 'noautoparams');


		if: (self -> 'unsavedmarker') != '' && (self -> 'unsavedmarkerclass') == '';
			// set default unsavedmarkerclass
			(self -> 'unsavedmarkerclass')='unsaved';
		/if;

		if: (self -> 'unsavedwarning') == '';
			// set default dirtywarning message
			//(self -> 'unsavedwarning')='Det finns ändringar som inte har sparats - vill du fortsätta utan att spara?';
		/if;
		
		// escape quotes for javascript
		(self -> 'unsavedwarning') -> (replace: '\'', '\\\'');
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;

	/*
	define_tag: 'onassign', -description='Internal, needed to restore references when ctype is defined as prototype',
		-required='value'; 
		// recreate references here

		iterate: (array: 
			'formaction',
			'actionpath',
			'database'), (local: 'param');
			(self -> #param) = @(#value -> #param);
		/iterate;

	/define_tag;
	*/
	
	define_tag: 'onconvert', -description='Outputs the form data in very basic form, just to see what it contains',
		-optional='xhtml';
		local: 'timer'=knop_timer; 

		local: 'endslash' = ((self -> (xhtml: params)) ? ' /' | '');

		local: 'output'=string;
		iterate: (self -> 'fields'), (local: 'fieldpair');
			#output += #fieldpair -> name + ' = ' + #fieldpair -> value + '    <br' + #endslash + '>\n';
		/iterate;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: #output;
	/define_tag;
	
	define_tag: '_unknowntag', -description='Shortcut to getvalue',
		-optional='index', -type='integer', -copy;
		!local_defined('index') ? local('index') = 1;
		if: (self -> 'fields') >> tag_name; // should be (self -> keys) but this is faster
			return: (self -> (getvalue: tag_name, -index=#index));
		else;
			//fail: -9948, self -> type + '->' + tag_name + ' not known.';
			(self -> '_debug_trace') -> insert(self -> type + '->' + tag_name + ' not known.');
		/if;
	/define_tag;
	
	define_tag: 'addfield', -description='Inserts a form element in the form. \n\
			Parameters:\n\
			-type (required) Supported types are listed in form -> \'validfieldtypes_array\'. Also custom field types addbuton, savebutton or deletebutton are supported (translated to submit buttons with predefined names). \
			For the field types html, fieldset and legend use -value to specify the data to display for these fields. A legend field automatically creates a fieldset (closes any previously open fieldsets). Use fieldset with -value=false to close a fieldset without opening a new one. \n\
			-name (optional) Required for all input types except addbuton, savebutton, deletebutton, fieldset, legend and html\n\
			-id (optional) id for the html object, will be autogenerated if not specified\n\
			-dbfield (optional) Corresponding database field name (name is used if dbfield is not specified), or null/emtpy string if ignore this field for database\n\
			-value (optional) Initial value for the field\n\
			-hint (optional) Optional gray hint text to show in empty text field\n\
            -options (optional) For select, checkbox and radio, must be array, set or series. For select, the array can contain -optgroup=label to create an optiongroup. \n\ 
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
			-after (optional) Numeric index or name of field to insert after\n\
			-template (optional) Format string that will override global template or buttontemplate\n\
			-widget (optional) Name of a widget to use as a template for a given field.\n\
			-errorclass (optional) A class for custom widgets to indicate through CSS that the user caused an error.\n\
			-placeholder (optional) Similar to -hint, but for custom widgets.  Adds placeholder text for fields using HTML5 standards.\n\
			-group (optional) For custom widgets.  Wraps a widget—defined as a control, its label, and its messages—with HTML as defined in the widget template.  Twitter Bootstrap also uses the group markup for styling fields as inline.  Boolean.  Default is false.\n\
			-groupclass (optional) A class for custom widgets.  Adds a class to the wrapper HTML of the widget.  Allows easier toggling of widget display between vertical, horizontal, and inline.  Requires -group=true.',
		-required='type',
		-optional='name',
		-optional='id',	
		-optional='dbfield',
		-optional='value',
		-optional='hint',
		-optional='options',
		-optional='multiple',
		-optional='linebreak',
		-optional='default',
		-optional='label',
		-optional='size',
		-optional='maxlength',
		-optional='rows',
		-optional='cols',
		-optional='focus',
		-optional='class',
		-optional='disabled',
		-optional='raw',
		-optional='confirmmessage',
		-optional='required',
		-optional='validate', -type='tag',
		-optional='filter', -type='tag',
		-optional='nowarning',
		-optional='after',
		-optional='template',
		-optional='widget',
		-optional='errorclass',
		-optional='placeholder',
		-optional='group',
		-optional='groupclass'
		;
		// TODO: add optiontemplate to be able to format individual options
		local: 'timer'=knop_timer; 
		
		local: '_type'=(local: 'type'), '_name'=(local: 'name'), 'originaltype'=(local: 'type');
		if: (map: 'addbutton', 'savebutton', 'deletebutton', 'cancelbutton') >> #_type;
			#originaltype = #_type;
			#_name = 'button_' + #_type;
			#_name -> (removetrailing: 'button');
			#_type = 'submit';
		else: #_type == 'reset' && (local: 'name') == '';
			#_name = 'button_' + #_type;
		else: (map: 'legend', 'fieldset', 'html') >> #_type && (local: 'name') == '';
			#_name = #_type;
		else;
			fail_if: (local: 'name') == '', -9956, 'form->addfield missing required parameter -name';
		/if;
		
		
		fail_if: !((self -> 'validfieldtypes') >> #_type), 7102, self -> error_msg(7202);
		fail_if: (map: 'select', 'radio', 'checkbox') >> #_type 
			&& (local: 'options') -> type != 'array' 
			&& (local: 'options') -> type != 'set' 
			&& (local: 'options') -> type != 'series', 
			-9956, 'Field type ' #_type ' requires -options array, set or series'; 
		local: 'index'= (self -> 'fields') -> size + 1;
		(local_defined: 'after') 	? (#after -> type == 'string' && (self -> 'fields') >> #after 
										? #index = (integer: ((self -> 'fields') -> (findindex: #after) -> first)) + 1
										| #after -> type == 'integer' ? #index= #after + 1);
		if: #_type == 'file';
			(self -> 'enctype') ='multipart/form-data';
			(self -> 'method') = 'post';
		/if;
		local: 'field'=(map: 
			'required'=(local_defined: 'required') 		&& #required != false,
			'multiple'=(local_defined: 'multiple') 		&& #multiple != false,
			'linebreak'=(local_defined: 'linebreak') 	&& #linebreak != false,
			'focus'=(local_defined: 'focus') 			&& #focus != false,
			'nowarning'=(local_defined: 'nowarning') 	&& #nowarning != false,
			'disabled'=(local_defined: 'disabled') 		&& #disabled != false
			);
		if: (self -> 'exceptionfieldtypes') >> #_type;
			// || (map: 'legend', 'fieldset', 'html') >> #_type;
			// never make certain field types required
			#field -> insert('required'=false);
		/if;

		#field -> (insert: 'type'=#_type);
		#field -> (insert: 'name'=#_name);

		local_defined('id') ? #field -> insert('id' = #id);
		local_defined('hint') ? #field -> insert('hint' = #hint);
		local_defined('default') ? #field -> insert('default' = #default); 
		local_defined('label') ? #field -> insert('label' = #label); 
		local_defined('size') ? #field -> insert('size' = #size); 
		local_defined('maxlength') ? #field -> insert('maxlength' = #maxlength); 
		local_defined('rows') ? #field -> insert('rows' = #rows); 
		local_defined('cols') ? #field -> insert('cols' = #cols); 
		local_defined('class') ? #field -> insert('class' = #class); 
		local_defined('raw') ? #field -> insert('raw' = #raw); 
		local_defined('confirmmessage') ? #field -> insert('confirmmessage' = #confirmmessage);
		local_defined('originaltype') ? #field -> insert('originaltype' = #originaltype);
		(local_defined: 'template') ? #field -> (insert: 'template'=#template);
        // the following params are for use in custom widgets only
		local_defined('widget') ? #field -> insert('widget'=#widget);
        local_defined('errorclass') ? #field -> insert('errorclass' = #errorclass);
        local_defined('placeholder') ? #field -> insert('placeholder' = #placeholder);
        local_defined('group') && #group != false ? #field -> insert('group' = #group);
        local_defined('groupclass') ? #field -> insert('groupclass' = #groupclass);

		#field -> (insert: 'dbfield'=( (local_defined: 'dbfield') ? #dbfield | #_name ) );
		(local_defined: 'value') ? #field -> (insert: 'defaultvalue'=#value);
		
		// the following params are stored as reference, so the values of the params can be altered after adding a field simply by changing the referenced variable. 
		local_defined('options') ? #field -> insert('options' = @#options);
		local_defined('value') ? #field -> insert('value' = @#value);
		local_defined('validate') ? #field -> insert('validate' = @#validate);
		local_defined('filter') ? #field -> insert('filter' = @#filter);
		
		(self -> 'fields') -> (insert: #_name = @#field, #index);

		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;

	define_tag: 'copyfield', -description='Copies a form field to a new name.',
		-required='name',
		-required='newname';
		local: 'timer'=knop_timer; 
		fail_if: #name == #newname, 7104, self -> error_msg(7104);
		if: (self -> 'fields') >> #name;
			local: 'copyfield'=(self -> 'fields') -> (find: #name) -> first -> value;
			#copyfield -> (insert: 'name' = #newname);
			(self -> 'fields') -> (insert: #newname = #copyfield);
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;


	define_tag: 'init', -description='Initiates form to grab keyvalue and set formmode if we have a database connected to the form. \
			Does nothing if no database is specified. ',
		-optional='get',
		-optional='post',
		-optional='keyvalue';
		local: 'timer'=knop_timer; 
		// Initiates form to grab keyvalue and set formmode if we have a database connected to the form. 
		// TODO: should we run init if form is not valid? Now we have a condition in lib before running init. 
		// TODO: how can we get the right formmode when showing an add form again after failed validation? Now we have an extra condition in lib for this
		
		if: (self -> 'database') -> type == 'database';
			(self -> 'db_keyvalue') = null;
			(self -> 'db_lockvalue') = null;
			local: '_params'=array,
				'source'='form',
				'field'=map;
			#_params = array;
			if: (local_defined: 'post');
				#_params -> (merge: client_postparams);
			/if;
			if: (local_defined: 'get');
				#_params -> (merge: client_getparams);
			/if;
			if: !(local_defined: 'post') && !(local_defined: 'get');
				#_params -> (merge: client_postparams);
				#_params -> (merge: client_getparams);
			/if;
			(self -> 'debug_trace') -> (insert: 'Init ');
		
			if: #_params >> '-lockvalue';
				if: #_params -> type == 'map';
					(self -> 'db_lockvalue')=((#_params -> (find: '-lockvalue' ) ) != '' 
						? (#_params -> (find: '-lockvalue' ) ) | null);
				else;
					(self -> 'db_lockvalue')=((#_params -> (find: '-lockvalue' ) -> first -> value) != '' 
						? (#_params -> (find: '-lockvalue' ) -> first -> value) | null);
				/if;
				(self -> 'debug_trace') -> (insert: tag_name + ': grabbing lockvalue from form ' + (self -> 'db_lockvalue'));
			else: (local_defined: 'keyvalue');
				(self -> 'db_keyvalue') = #keyvalue;
				(self -> 'debug_trace') -> (insert: tag_name + ': grabbing keyvalue from parameter ' + (self -> 'db_keyvalue'));
			else: #_params >> (self -> 'keyparamname');
				if: #_params -> type == 'map';
					(self -> 'db_keyvalue')=((#_params -> (find: (self -> 'keyparamname') ) ) != '' 
						? (#_params -> (find: (self -> 'keyparamname') ) ) | null);
				else;
					(self -> 'db_keyvalue')=((#_params -> (find: (self -> 'keyparamname') ) -> first -> value) != '' 
						? (#_params -> (find: (self -> 'keyparamname') ) -> first -> value) | null);
				/if;
				(self -> 'debug_trace') -> (insert: tag_name + ': grabbing keyvalue from form ' + (self -> 'db_keyvalue'));
			/if;
			if: (self -> 'db_lockvalue') == '' && (self -> 'db_keyvalue') == '';
				// we have no keyvalue or lockvalue - this must be an add operation
				(self -> 'formmode') = 'add';
				// create a keyvalue for the record to add
				(self -> 'db_keyvalue') = knop_unique;
				(self -> 'debug_trace') -> (insert: tag_name + ': generating keyvalue ' + (self -> 'db_keyvalue'));
			else: (self -> getbutton) == 'add';
				(self -> 'formmode') = 'add';
			else: (self -> formmode)=='';
				(self -> 'formmode') = 'edit';
			/if;
			(self -> 'debug_trace') -> (insert: tag_name + ': formmode ' + (self -> formmode));
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;


	define_tag: 'loadfields', -description='Overwrites all field values with values from either database, action_params or explicit -params. \
				Auto-detects based on current lasso_currentaction.\n\
			Parameters:\n\
				-params (optional) Array or map to take field values from instead of database or submit (using dbnames)\n\
				-get (optional flag) Only getparams will be used\n\
				-post (optional flag) Only postparams will be used\n\
				-inlinename (optional) The first record in the result from the specified inline will be used as field values\n\ 
				-database (optional) If a database object is specified, the first record from the latest search result of the database object will be used. \
					If -database is specified as flag (no value) and the form object has a database object attached to it, that database object will be used.',
		-optional='params',
		-optional='post',
		-optional='get',
		-optional='inlinename',
		-optional='database';
		local: 'timer'=knop_timer; 
		local: '_params'=array,
			'source'='form',
			'field'=map;
		(self -> 'fieldsource') = null;
		if: (local_defined: 'params');
			(self -> 'fieldsource') = 'params';
			local: 'source'='params';
			#_params = #params;
		else: (local_defined: 'database') && !(local_defined: 'inlinename');
			if: #database -> type == 'database';
				local: 'inlinename'=#database -> inlinename;
			else: self -> 'database' -> type == 'database';
				local: 'inlinename'=self -> 'database' -> inlinename;
			/if;
		/if;
			
		if: (local_defined: 'inlinename');
			(self -> 'fieldsource') = 'database';
			local: 'source'='params';
			#_params=map;
			records: -inlinename=#inlinename;
				loop: (field_name: -count);
					#_params -> (insert: (field_name: loop_count)  =  (field: (field_name: loop_count)) );
				/loop;
				loop_abort;
			/records;
		else: (self -> 'fieldsource') == null && lasso_currentaction != 'nothing';
			(self -> 'fieldsource') = 'database';
			local: 'source'='database';
		else: (self -> 'fieldsource') == null;
			(self -> 'fieldsource') = 'form';
			#_params = array;
			if: (local_defined: 'post');
				#_params -> (merge: client_postparams);
			/if;
			if: (local_defined: 'get');
				#_params -> (merge: client_getparams);
			/if;
			if: !(local_defined: 'post') && !(local_defined: 'get');
				#_params -> (merge: client_postparams);
				#_params -> (merge: client_getparams);
			/if;
		/if;
		(self -> 'debug_trace') -> (insert: tag_name + ': loading field values from ' + (self -> 'fieldsource'));
		local('fieldnames_done'=map, 'fields_samename'=array, 'params_fieldname'=array);
		iterate: (self -> 'fields'), (local: 'fieldpair');
			//#field = @(#fieldpair -> value);
			if: (self -> 'exceptionfieldtypes') !>> #fieldpair -> value -> (find: 'type') // do not load data for excluded form fields (maybe it should do that in some cases???)
				// && (map: 'legend', 'fieldset', 'html') !>> #fieldpair -> value -> (find: 'type')
				&& !(#fieldpair -> name -> (beginswith: '-')); // exclude field names that begin with "-"
				if(#fieldnames_done !>> #fieldpair -> name); // check if we are already done with this field name (for multiple fields with the same name)
					// find all fields with the same name
					#fields_samename = @((self -> 'fields') -> find(#fieldpair -> name));
					#params_fieldname = @(#_params -> find(#fieldpair -> name));
					if: #source == 'database' && found_count > 0;
						// load field values from database
						if: (#fieldpair -> value -> find: 'dbfield') != '';
							// first remove value to break reference
							(#fieldpair -> value) -> (remove: 'value');
							(#fieldpair -> value) -> (insert: 'value'=(field: (#fieldpair -> value -> find: 'dbfield')) );
						/if;
					else: #source == 'params';
						// load field values from explicit -params using dbfield names
						if: #_params >> (#fieldpair -> value -> find: 'dbfield') && (#fieldpair -> value -> find: 'dbfield') != '';
							// first remove value to break reference
							(#fieldpair -> value) -> (remove: 'value');
							if(#_params -> isa('map'));
								(#fieldpair -> value) -> (insert: 'value'=(#_params -> (find: (#fieldpair -> value -> find: 'dbfield') ) ) );
							/*else: #_params -> (find: (#fieldpair -> value -> find: 'dbfield') ) -> size > 1;
								// multiple field values
								local: 'valuearray'=array;
								iterate: #_params -> (find:  (#fieldpair -> value -> find: 'dbfield')), (local: 'parampair');
									#parampair -> value != '' ? #valuearray -> (insert: #parampair -> value);
								/iterate;
								(#fieldpair -> value) -> (insert: 'value'=#valuearray);*/
							else(#_params -> isa('array'));
								(#fieldpair -> value) -> (insert: 'value'=(#_params -> (find: (#fieldpair -> value -> find: 'dbfield')) -> first -> value) );
							/if;
						/if;
					else: #source == 'form';
						// load field values from form submission
						iterate(#fields_samename, local('fieldpair_samename'));
							// first remove value to break reference
							(#fieldpair_samename -> value) -> (remove: 'value');
							if(#params_fieldname -> size == #fields_samename -> size);
								// the number of submitted fields match the number of fields in the form
								(#fieldpair_samename -> value) -> (insert: 'value'=(#params_fieldname -> get(loop_count) -> value) );
							else;
								if: #params_fieldname -> size > 1;
									// multiple field values
									local: 'valuearray'=array;
									iterate: #_params -> (find:  (#fieldpair -> name)), (local: 'parampair');
										#parampair -> value != '' ? #valuearray -> (insert: #parampair -> value);
									/iterate;
									(#fieldpair_samename -> value) -> (insert: 'value'=#valuearray);
								else: #_params >> (#fieldpair -> name);
									(#fieldpair_samename -> value) -> (insert: 'value'=(#_params -> (find: #fieldpair_samename -> name) -> first -> value) );
								else;
									(#fieldpair_samename -> value) -> (insert: 'value'='');
								/if;
							/if;
						/iterate;
						#fieldnames_done -> insert(#fieldpair -> name);
					/if;
				/if;
				// apply filtering of field value (do this for all instances of the same field name, so outside of the #fieldnames_done check
				if(#fieldpair -> value -> find('filter') -> isa('tag'));
					(#fieldpair -> value) -> insert('value'= (#fieldpair -> value -> find('filter')) -> run(-params=(#fieldpair -> value -> find('value'))));
				/if;
			/if;
		/iterate;
		
		// capture keyvalue or lockvalue if we have a database object connected to the form
		if: (self -> 'database') -> type == 'database';
			//(self -> 'db_keyvalue') = null;
			//(self -> 'db_lockvalue') = null;
			if: (self -> 'fieldsource') == 'database';
				if: (self -> 'database') -> lockfield != '' && (self -> 'database') -> lockvalue != '';
					(self -> 'db_lockvalue') = (self -> 'database') -> lockvalue_encrypted;
					(self -> 'debug_trace') -> (insert: tag_name + ': grabbing lockvalue from database ' + (self -> 'db_lockvalue'));
				else: (self -> 'database') -> keyfield != '' && (self -> 'database') -> keyvalue != '';
					(self -> 'db_keyvalue') = (self -> 'database') -> keyvalue;
					(self -> 'debug_trace') -> (insert: tag_name + ': grabbing keyvalue from database ' + (self -> 'db_keyvalue'));
				/if;
			else;
				if: #_params >> '-lockvalue';
					if: #_params -> type == 'map';
						(self -> 'db_lockvalue')=((#_params -> (find: '-lockvalue' ) ) != '' 
							? (#_params -> (find: '-lockvalue' ) ) | null);
					else;
						(self -> 'db_lockvalue')=((#_params -> (find: '-lockvalue' ) -> first -> value) != '' 
							? (#_params -> (find: '-lockvalue' ) -> first -> value) | null);
					/if;
					(self -> 'debug_trace') -> (insert: tag_name + ': grabbing lockvalue from form ' + (self -> 'db_lockvalue'));
				else: #_params >> (self -> 'keyparamname');
					if: #_params -> type == 'map';
						(self -> 'db_keyvalue')=((#_params -> (find: (self -> 'keyparamname') ) ) != '' 
							? (#_params -> (find: (self -> 'keyparamname') ) ) | null);
					else;
						(self -> 'db_keyvalue')=((#_params -> (find: (self -> 'keyparamname') ) -> first -> value) != '' 
							? (#_params -> (find: (self -> 'keyparamname') ) -> first -> value) | null);
					/if;
					(self -> 'debug_trace') -> (insert: tag_name + ': grabbing keyvalue from form ' + (self -> 'db_keyvalue'));
				/if;
			/if;
			if: (self -> 'db_lockvalue') == '' && (self -> 'db_keyvalue') == '';
				// we have no keyvalue or lockvalue - this must be an add operation
				(self -> 'formmode') = 'add';
				// create a keyvalue for the record to add
				(self -> 'db_keyvalue') = knop_unique;
				(self -> 'debug_trace') -> (insert: tag_name + ': generating keyvalue ' + (self -> 'db_keyvalue'));
			else: (self -> formmode) == '';
				(self -> 'formmode') = 'edit';
			/if;
			(self -> 'debug_trace') -> (insert: tag_name + ': formmode ' + (self -> formmode));
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;

	define_tag: 'clearfields', -description='Emtpies all form field values';
		local: 'timer'=knop_timer; 
		iterate: (self -> 'fields'), (local: 'fieldpair');
			if: (self -> 'exceptionfieldtypes') !>> #fieldpair -> value -> (find: 'type');
				// && (map: 'legend', 'fieldset', 'html') !>> #fieldpair -> value -> (find: 'type');
				// first remove value to break reference
				(#fieldpair -> value) -> (remove: 'value');
				(#fieldpair -> value) -> (insert: 'value'='');
			/if;
		/iterate;	
		if: (self -> 'database') -> type == 'database';
			(self -> 'db_keyvalue') = null;
			(self -> 'db_lockvalue') = null;
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;

	define_tag: 'resetfields', -description='Resets all form field values to their initial values';
		local: 'timer'=knop_timer; 
		iterate: (self -> 'fields'), (local: 'fieldpair');
			if: (self -> 'exceptionfieldtypes') !>> #fieldpair -> value -> (find: 'type');
				//&& (map: 'legend', 'fieldset', 'html') !>> #fieldpair -> value -> (find: 'type');
				// first remove value to break reference
				(#fieldpair -> value) -> (remove: 'value');
				(#fieldpair -> value) -> (insert: 'value'=#fieldpair -> value -> (find: 'defaultvalue'));
			/if;
		/iterate;	
		if: (self -> 'database') -> type == 'database';
			(self -> 'db_keyvalue') = null;
			(self -> 'db_lockvalue') = null;
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;

	define_tag: 'validate', -description='Performs validation and fills a transient array with field names that have input errors. \
				 form -> loadfields must be called first.';
		local: 'timer'=knop_timer; 
		
		// Performs validation and fills a transient array with field names that have input errors.
		// Must call -> loadfields first
		if: (self -> 'errors') == null;
			// initiate the errors array so we know validate has been performed
			(self -> 'errors') = array;
			iterate: (self -> 'fields'), (local: 'fieldpair');
				if: !( (self -> 'exceptionfieldtypes') >> #fieldpair -> value -> (find: 'type') );
					if: (#fieldpair -> value -> (find: 'required') ) 
						&& (#fieldpair -> value -> (find: 'value') ) == '';
						(self -> 'errors') -> (insert: (#fieldpair -> value -> (find: 'name') ));
					/if;
					if(#fieldpair -> value -> find('validate') -> isa('tag'));
						// perform validation expression on the field value
						local('result'=(#fieldpair -> value -> find('validate')) -> run(-params=#fieldpair -> value -> find('value')));
						if(#result === true || #result === 0);
							// validation was ok
						else(#result != 0 || #result -> size);
							// validation result was an error code or message
							(self -> 'errors') -> insert(#fieldpair -> value -> find('name') = #result);
						else;
							(self -> 'errors') -> insert(#fieldpair -> value -> find('name'));
						/if;
					/if;
				/if;
			/iterate;
		/if;
		(self -> 'debug_trace') -> (insert: tag_name + ': form is valid ' + ((self -> 'errors') -> size == 0));
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;

	define_tag: 'isvalid', -description='Returns the result of form -> validate (true/false) without performing the validation again (unless it hasn\'t been performed already)';
		local: 'timer'=knop_timer; 
		// Returns the result of -> validate (true/false) without performing the validation again (unless it is needed)
		(self -> 'errors') == null ? self -> validate;
		(self -> 'debug_trace') -> (insert: tag_name + ': form is valid ' + ((self -> 'errors') -> size == 0));
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: (self -> 'errors') -> size == 0;
	/define_tag;


	define_tag: 'adderror', -description='adds the name for a field that has validation error, used for custom field validation. \
				calls form -> validate first if needed',
		-required='fieldname';
		local: 'timer'=knop_timer; 
		// adds a field that has error
		// calls ->validate first if needed, to make sure self -> 'errors' is an array
		(self -> 'errors') == null ? self -> validate;
		(self -> 'errors') -> (insert: #fieldname);
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;


	define_tag: 'errors', -description='Returns an array with fields that have input errors, or empty array if no errors or form has not been validated';
		// returns an array with fields that have input errors, or emtpy array if no errors or form has not been validated
		if: (self -> 'errors') == null;
			return: array;
		else;
			return: (self -> 'errors');
		/if;
	/define_tag;



	define_tag: 'updatefields', -description='Returns a pair array with fieldname=value, or optionally SQL string to be used in an update inline.\
		form -> loadfields must be called first.\n\
		Parameters:\n\
		-sql (optional)\n\
		-removedotbackticks (optional flag) Use with -sql for backward compatibility for fields that contain periods.  If you use periods in a fieldname then you cannot use a JOIN in Knop.',
		-optional='sql',
		-optional='removedotbackticks';
		local: 'timer'=knop_timer; 
		// Returns a pair array with fieldname=value, or optionally SQL string to be used in an update inline. Optionally use -removedotbackticks with -sql for backward compatibility with fields that contain periods.
		// Must call ->loadfields first.
		local: 'output'=array,
			'_sql'=(local_defined: 'sql'),
			'_removedotbackticks'=(local_defined: 'removedotbackticks'),
			'fieldvalue'=null, 'onevalue'=null;
		iterate: (self -> 'fields'), (local: 'fieldpair');
			if: !( (self -> 'exceptionfieldtypes') >> #fieldpair -> value -> (find: 'type') )
				&& !(#fieldpair -> value -> (find: 'name') -> (beginswith: '-'))
				&& (#fieldpair -> value -> (find: 'dbfield')) != '';
				// don't use submit etc and exclude fields whose name begins with -
				#fieldvalue = (#fieldpair -> value -> (find: 'value') );
				if: #fieldvalue -> type != 'array';
					// to support multiple values for one fieldname, like checkboxes
					#fieldvalue = array: #fieldvalue;
				/if;
				if: #_sql;
					if(#_removedotbackticks);
						#output -> (insert:  '`' + (encode_sql(knop_stripbackticks(#fieldpair -> value -> find('dbfield'))) ) + '`' 
							+ '="' + (encode_sql: (#fieldvalue -> (join: ',')) ) + '"');
					else;
						#output -> (insert:  '`' + (encode_sql(string_replace(knop_stripbackticks(#fieldpair -> value -> find('dbfield')), -find='.', -replace='`.`')) ) + '`' 
						+ '="' + (encode_sql: (#fieldvalue -> (join: ',')) ) + '"');
					/if;
				else;
					iterate: #fieldvalue, #onevalue;
						#output -> (insert:  (#fieldpair -> value -> (find: 'dbfield') ) 
							= #onevalue );
					/iterate;
				/if;
			/if;
		/iterate;
		if: #_sql;

			#output = '(' + #output -> (join: ',') + ')';

		/if;

		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: @#output;
		
	/define_tag;
	
	
	define_tag: 'getbutton', -description='Returns what button was clicked on the form on the previous page. Assumes that submit buttons are named button_add etc. \
				Returns add, update, delete, cancel or any custom submit button name that begins with button_.';
		local: 'timer'=knop_timer; 
		if: (self -> 'formbutton') != '';
			// we have already found out once what button was clicked
			(self -> 'debug_trace') -> (insert: tag_name + ': cached ' + (self -> 'formbutton'));
			self -> 'tagtime_tagname'=tag_name;
			self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
			return: (self -> 'formbutton');
		/if;
		local: 'clientparams'=client_getparams;
		#clientparams -> (merge: client_postparams);
		// look for submit buttons, the least destructive first
		iterate: (array: 'cancel', 'save', 'add', 'delete'), (local: 'buttonname');
			if: #clientparams >> 'button_' + #buttonname 
				|| #clientparams >> 'button_' + #buttonname + '.x'
				|| #clientparams >> 'button_' + #buttonname + '.y';
				(self -> 'debug_trace') -> (insert: tag_name + ': built-in button name ' + #buttonname);
				(self -> 'formbutton') = #buttonname;
				self -> 'tagtime_tagname'=tag_name;
				self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
				return: #buttonname;
			/if;
		/iterate;
		// no button found yet - look for custom button names
		iterate: #clientparams, #buttonname;
			#buttonname -> type == 'pair' ? #buttonname =  #buttonname -> name;
			if: #buttonname -> (beginswith: 'button_');
				#buttonname -> (removeleading: 'button_') & (removetrailing: '.x') & (removetrailing: '.y');
				(self -> 'debug_trace') -> (insert: tag_name + ': custom button name ' + #buttonname);
				(self -> 'formbutton') = #buttonname;
				self -> 'tagtime_tagname'=tag_name;
				self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
				return: #buttonname;
			/if;
		/iterate;
		(self -> 'debug_trace') -> (insert: tag_name + ': No button found');
	/define_tag;
	
	define_tag: 'process', -description='Automatically handles a form submission and handles add, update, or delete. \
				Requires that a database object is specified for the form',
		-optional='user',
		-optional='lock',
		-optional='keyvalue';
		local: 'timer'=knop_timer; 
		fail_if: (self -> 'database') -> type != 'database', 7103, self -> error_msg(7103);

		(self -> 'error_code') = 0;
		(self -> 'error_msg') = string;
		
		if: self -> getbutton == 'cancel';
			// do nothing at all
			(self -> 'debug_trace') -> (insert: tag_name + ': cancelling ');
			
		else: self -> getbutton == 'save';
			self -> loadfields;
			if: self -> isvalid;
				if: (local_defined: 'user') && (self -> lockvalue) != '';
					(self -> database) -> (saverecord: (self -> updatefields), -lockvalue=(self -> lockvalue), -keyvalue=(self -> keyvalue), -user=#user);
				else;
					(self -> database) -> (saverecord: (self -> updatefields), -keyvalue=(self -> keyvalue));
				/if;
				if: self -> database -> error_code != 0;
					(self -> 'error_code') = self -> database -> error_code;
					(self -> 'error_msg') = 'Process: update record error ' + (self -> database -> error_msg);
				/if;
				(self -> 'debug_trace') -> (insert: tag_name + ': updating record ' + (self -> database -> error_msg) + ' ' + (self -> database -> error_code));
			else;
				(self -> 'error_code') = 7101; // Process: update record did not pass form validation
				(self -> 'debug_trace') -> (insert: tag_name + ': update record did not pass form validation');
			/if;
		
		else: self -> getbutton == 'add';
			self -> loadfields;
			if: self -> isvalid;
				(self -> database) -> (addrecord: (self -> updatefields), -keyvalue=(self -> keyvalue));
				if: self -> database -> error_code != 0;
					(self -> 'error_code') = self -> database -> error_code;
					(self -> 'error_msg') = 'Process: add record error ' + (self -> database -> error_msg);
				/if;
				(self -> 'debug_trace') -> (insert: tag_name + ': adding record ' + (self -> database -> error_msg) + ' ' + (self -> database -> error_code));
			else;
				(self -> 'error_code') = 7101; // Process: add record did not pass form validation
				(self -> 'debug_trace') -> (insert: tag_name + ': add record did not pass form validation');
				(self -> 'debug_trace') -> (insert: tag_name + ': reverting form mode to add');
			/if;

		else: self -> getbutton == 'delete';
			self -> loadfields;
			(self -> 'debug_trace') -> (insert: tag_name + ': will delete record with keyvalue ' + (self -> keyvalue) + ' lockvalue ' + (self -> lockvalue));
			if: (local_defined: 'user') && (self -> lockvalue) != '';
				(self -> database) -> (deleterecord: -lockvalue=(self -> lockvalue), -keyvalue=(self -> keyvalue), -user=#user);
			else;
				(self -> database) -> (deleterecord: -keyvalue=(self -> keyvalue));
			/if;
			if: self -> database -> error_code == 0;
				self -> resetfields;
			else;
				(self -> 'error_code') = self -> database -> error_code;
				(self -> 'error_msg') = 'Process: delete record error ' + (self -> database -> error_msg);
			/if;
			(self -> 'debug_trace') -> (insert: tag_name + ': deleting record ' + (self -> database -> error_msg) + ' ' + (self -> database -> error_code));
		else: false;
			// do not go here, database record should be loaded with a separate call
			if: (local_defined: 'lock');
				self -> database ->(getrecord: (local: 'keyvalue'), -lock, -user=#user);
				(self -> 'debug_trace') -> (insert: tag_name + ': loading record using lock' + (self -> database -> error_msg) + ' ' + (self -> database -> error_code));
			else;
				self -> database ->(getrecord: (local: 'keyvalue'), -user=#user);
				(self -> 'debug_trace') -> (insert: tag_name + ': loading record' + (self -> database -> error_msg) + ' ' + (self -> database -> error_code));
			/if;
			self -> (loadfields: -inlinename=(self -> database -> inlinename));
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;

	define_tag: 'setformat', -description='Defines a html template for the form. \n\
			Parameters:\n\
			-template (optional string) html template, defaults to #label# #field##required#<br>\n\
			-buttontemplate (optional string) html template for buttons, defaults to #field#\n\
			-required (optional string) character(s) to display for required fields (used for #required#), defaults to *\n\
			-legend (optional string) legend for the entire form - if specified, a fieldset will also be wrapped around the form\n\
			-class (optional string) css class name that will be used for the form element, default none\n\
			-errorclass (optional string) css class name that will be used for the label to highlight input errors, if not defined style="color: red" will be used\n\
			-unsavedmarker (optional string) \n\
			-unsavedmarkerclass (optional string) \n\
			-unsavedwarning (optional string)',
		-optional='template', -type='string',
		-optional='buttontemplate', -type='string',
		-optional='required', -type='string',
		-optional='legend', -type='string',
		-optional='class', -type='string',
		-optional='errorclass', -type='string',
		-optional='unsavedmarker', -type='string',
		-optional='unsavedmarkerclass', -type='string',
		-optional='unsavedwarning', -type='string';
		local: 'timer'=knop_timer; 

		local_defined('template') ? (self -> 'template') = #template;
		local_defined('buttontemplate') ? (self -> 'buttontemplate') = #buttontemplate;
		local_defined('required') ? (self -> 'required') = #required;
		local_defined('legend') ? (self -> 'legend') = #legend;
		local_defined('class') ? (self -> 'class') = #class;
		local_defined('errorclass') ? (self -> 'errorclass') = #errorclass;
		local_defined('unsavedmarker') ? (self -> 'unsavedmarker') = #unsavedmarker;
		local_defined('unsavedmarkerclass') ? (self -> 'unsavedmarkerclass') = #unsavedmarkerclass;
		local_defined('unsavedwarning') ? (self -> 'unsavedwarning') = #unsavedwarning;

		if: local_defined: 'unsavedwarning';
			// escape quotes for javascript
			(self -> 'unsavedwarning') -> (replace: '\'', '\\\'');
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;


	define_tag: 'renderform', -description='Outputs HTML for the form fields, a specific field, a range of fields or all fields of a specific type. \
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
			-xhtml (optional flag) XHTML valid output',
		-optional='name', -copy, 	// field name
		-optional='from', -copy, 	// number index or field name
		-optional='to', -copy, 		// number index or field name
		-optional='type', -copy,	// only output fields of this or these types (string or array)
		-optional='excludetype', -copy,	// output fields except of this or these types (string or array)
		-optional='legend',			// groups the rendered fields in a fieldset and outputs a legend for the fieldset
		-optional='start',			// only output the starting <form> tag
		-optional='end',			// only output the ending </form> tag
		-optional='xhtml';			// boolean, if set to true adjust output for XHTML
		local: 'timer'=knop_timer; 
		handle;knop_debug('Done with ' + self->type + ' -> ' + tag_name, -time, -type=self->type);/handle;
		
		// Outputs HTML for the form fields
		
		/*
			TODO: 
			Handling of multiple fields with the same name
		*/
		local: 'output'=string, 
			'onefield'=map, 
			'renderfield'=string, 
			'renderfield_base'=string, 
			'renderrow'=string,
			'formid'=null,
			'usehint'=array,
			'nowarning'=false,
			'fieldtype',
			'fieldvalue'=string,
			'fieldvalue_array'=array,
			'options'=array,
			'focusfield';

		local: 'clientparams'=client_getparams;
		#clientparams -> (merge: client_postparams);
		#clientparams -> (removeall: (self -> 'keyparamname'));
		#clientparams -> (removeall: '-lockvalue');
		#clientparams -> (removeall: '-action');
		#clientparams -> (removeall: '-xhtml');

		// local var that adjust tag endings if rendered for XHTML
		local: 'endslash' = ((self -> (xhtml: params)) ? ' /' | '');

		// page var to keep track of the number of forms that has been rendered on a page
		if: !(var_defined: 'knop_form_renderform_counter');
			var: 'knop_form_renderform_counter'=0;
		/if;
		
		$knop_form_renderform_counter += 1;

		if: (self -> 'id') != '';
			#formid = (self -> 'id');
		else: (self -> 'name') != '';
			#formid = (self -> 'name');
		else;
			#formid = 'form' + $knop_form_renderform_counter;
		/if;
		
		
		local: 'renderformStartTag'=false, 'renderformEndTag'=false;
		// remove params that should not stop formstarttag and formendtag from rendering
		params -> type == 'array' ? params -> (removeall: '-legend') & (removeall: '-xhtml');
		if: (self -> 'formaction') != null 
			&& (params -> size == 0 || (local_defined: 'start') );
			#renderformStartTag=true;
		/if;
		if: (self -> 'formaction') != null 
			&& (params -> size == 0 || (local_defined: 'end') );
			#renderformEndTag=true;
		/if;
		if: #renderformStartTag;
			// render opening form tag

			#output +='<form';
			(self -> 'debug_trace') -> insert(tag_name + ': formaction = ' + (self -> 'formaction'));
			if: (self -> 'formaction') != null;
				#output += ' action="' + (self -> 'formaction');
				if: (self -> 'method') == 'post' && !(self -> 'noautoparams');
					local: 'actionparams'=array;
					iterate: #clientparams, (local: 'clientparam');
						if: #clientparam -> type == 'pair';
							if: #clientparam -> name -> (beginswith: '-') 
							    && !(#clientparam -> name -> (beginswith: '-upload.'))
							    && !(#clientparam -> name -> (beginswith: '-upload2.'))
								&& #clientparam -> name != '-session'
								&& (self -> 'fields') !>> #clientparam -> name
								// check if param name appears in form action
								// turn param into [p][a][r][a][m] to avoid problems with most reserved regex characters like "."
								&& (string_findregexp: (self -> 'formaction'), -find='[?;&]['
									+ ((#clientparam -> name) -> (split: '') -> (join: '][')) 
									+ ']([&=]|$)', -ignorecase) -> size == 0;
								#actionparams -> (insert: (#clientparam -> name) + '=' + (encode_url: (#clientparam -> value)) );
							/if;
						else: #clientparam -> type == 'string' 
							&& #clientparam -> (beginswith: '-') 
							&& (self -> 'fields') !>> #clientparam
							// check if param appears in form action
							// turn param into [p][a][r][a][m] to avoid problems with most reserved regex characters like "."
							&& (string_findregexp: (self -> 'formaction'), -find='[?;&]['
								+ (#clientparam -> (split: '') -> (join: '][')) 
								+ ']([&=]|$)', -ignorecase) -> size == 0;
							#actionparams -> (insert: #clientparam );
						/if;
					/iterate;
					if: #actionparams -> size;
						#output += ((self -> 'formaction') >> '?' ? '&amp;' | '?' ) + #actionparams -> (join: '&amp;');
					/if;
				/if;
				#output += '"';
			/if;
			(self -> 'method') != null		? #output += ' method="' + (self -> 'method') + '"';
			(self -> 'name') != null		? #output += ' name="' + (self -> 'name') + '"';
			#output += ' id="' + #formid + '"';
			(self -> 'class') != null		? #output += ' class="' + (self -> 'class') + '"';
			(self -> 'enctype') != ''		? #output += ' enctype="' + (self -> 'enctype') + '"';
			(self -> 'raw') != null			? #output += ' ' + (self -> 'raw');
			!(self -> 'noscript') ? #output += ' onsubmit="return validateform(this)"';
			(self -> 'entersubmitblock') && !(self -> 'noscript')	? #output += ' onkeydown="return submitOk(event);" onfocus="submitBlock=true; return true;" onblur="submitBlock=false; return true;"';
			#output += '>\n';


			if: (self -> 'actionpath') != '' 
				&& !(self -> 'noautoparams') 
				&& (self -> 'fields') !>> '-action';
				// auto-add -action unless there is already an -action field in the form
				#output += '<input type="hidden" name="-action" value="' + (encode_html: (self -> 'actionpath')) + '"' + #endslash + '>\n';
			/if;
			if: (self -> 'fieldset');
				#output += '<fieldset>\n';
				#output +='<legend>' + (self -> 'legend') + '</legend>\n';
			/if;
			if: (self -> 'method') == 'get' && !(self -> 'noautoparams');
				iterate: #clientparams, (local: 'clientparam');
					if: #clientparam -> type == 'pair';
						if: #clientparam -> name -> (beginswith: '-')
							&& #clientparam -> name != '-session'
							&& (self -> 'fields') !>> #clientparam -> name
							// check if param name appears in form action
							// turn param into [p][a][r][a][m] to avoid problems with most reserved regex characters like .
							&& (string_findregexp: (self -> 'formaction'), -find='[?;&]['
								+ ((#clientparam -> name) -> (split: '') -> (join: '][')) 
								+ ']([&=]|$)', -ignorecase) -> size == 0;
							#output += '<input type="hidden" name="' + (#clientparam -> name) + '" value="' + (encode_html: (#clientparam -> value)) + '"' + #endslash + '>\n';
						/if;
					else: #clientparam -> type == 'string' 
						&& #clientparam -> (beginswith: '-')
						&& (self -> 'fields') !>> #clientparam
						// check if param appears in form action
						// turn param into [p][a][r][a][m] to avoid problems with most reserved regex characters like .
						&& (string_findregexp: (self -> 'formaction'), -find='[?;&]['
							+ (#clientparam -> (split: '') -> (join: ']['))
							+ ']([&=]|$)', -ignorecase) -> size == 0;
						#output += '<input type="hidden" name="' + #clientparam + '"' + #endslash + '>\n';
					/if;
				/iterate;
			/if;
			if: (self -> 'database') -> type == 'database';
				if: (self -> 'database') -> lockfield != '' && (self -> 'db_lockvalue') != '';
					#output += '<input type="hidden" name="-lockvalue" value="' + (encode_html: (self -> 'db_lockvalue')) + '"' + #endslash + '>\n';
				else: (self -> 'database') -> keyfield != '' && (self -> 'db_keyvalue') != '';
					#output += '<input type="hidden" name="' + (self -> 'keyparamname') + '" value="' + (encode_html: (self -> 'db_keyvalue')) + '"' + #endslash + '>\n';
				/if;
			/if;
		/if;
		
		
		if: !(local_defined: 'start') && !(local_defined: 'end');

			(local_defined: 'name') && !((self -> 'fields') >> #name) 	? 	return;
			
			(local_defined: 'name')		? local: 'from'=#name, 'to'=#name;
			!(local_defined: 'from') 		? local: 'from'=1;
			!(local_defined: 'to') 			? local: 'to'=(self -> 'fields') -> size;
			!(local_defined: 'type')		? local: 'type'=(self -> 'validfieldtypes');
			!(local_defined: 'excludetype')	? local: 'excludetype'=map;
			#type -> type == 'string' 		? #type = (map: #type);
			#excludetype -> type == 'string' ? #excludetype = (map: #excludetype);

			// only render form inputs if we are not only rendering the form tags
		
			// use field name if #from is a string
			#from -> type == 'string' ? #from = integer: ((self -> 'fields') -> (findindex: #from) -> first);
			#from == 0 ? #from = 1;
			// negative numbers count from the end
			#from < 0 ? #from = (self -> 'fields') -> size + #from;
	
			// use field name if #to is a string
			#to -> type == 'string' ? #to = integer: ((self -> 'fields') -> (findindex: #to) -> last);
			#to == 0 ? #to = (self -> 'fields') -> size;
			// negative numbers count from the end
			#to < 0 ? #to = (self -> 'fields') -> size + #to;

			// sanity check
			#from > #to ? #to = #from;
	
			local: 'template'=( (self -> 'template') != '' 
				? (self -> 'template') 		
				| '#label# #field##required#<br' + #endslash + '>\n' );
			local: 'buttontemplate'=( (self -> 'buttontemplate') != '' 
				? (self -> 'buttontemplate') 
				| (self -> 'template') != '' 
				? (self -> 'template')
				| '#field#\n' );
			local: 'requiredmarker'=(self -> 'required');
			local: 'defaultclass'=( (self -> 'class') != '' 
				? (self -> 'class') 		
				| '');
			local: 'errorclass'=( (self -> 'errorclass') != '' 
				? ' class="' + (self -> 'errorclass') + '"' 
				| ' style="color: red;"');
			
			if: (local_defined: 'legend');
				(self -> 'render_fieldset2_open') = true;
				#output += '<fieldset>\n'
					+ '<legend>' + #legend + '</legend>\n';
			/if;

			iterate: (self -> 'fields'), (local: 'fieldpair');
				#onefield = #fieldpair -> value;
				#fieldvalue = (#onefield -> (find: 'value'));
				#fieldvalue_array = #fieldvalue;
				if: #fieldvalue_array -> type != 'array';
					if: #fieldvalue_array >> '\r'; // Filemaker value list with multiple checked
						#fieldvalue_array = #fieldvalue_array -> (split: '\r');
					else: #fieldvalue_array >> ','; // Other database with multiple checked
						#fieldvalue_array = #fieldvalue_array -> (split: ',');
					else;
						#fieldvalue_array = array: #fieldvalue_array;
					/if;
				/if;
				if: #onefield >> 'options';
					#options = (#onefield -> find: 'options');
					// convert types for pair 
					iterate: #options, (local: 'option');
						if: #option -> type != 'pair';
							#option = (pair: #option = #option);
						/if;
						// name must be string to make sure comparsions work
						(#option -> name) = (string: #option -> name);
					/iterate;
				/if;
				
				if: loop_count >= #from 
					&& loop_count <= #to
					&& #type >> #onefield -> (find: 'type')
					&& !(#excludetype >> #onefield -> (find: 'type'));
					if: (self -> 'unsavedwarning') == '';
						#nowarning=true;
					else;
						#nowarning=#onefield -> (find: 'nowarning');
					/if;
					
					if: #onefield -> (find: 'template') -> size;
						#renderrow = #onefield -> (find: 'template');
					else: (map: 'submit', 'reset', 'image') >> #onefield -> (find: 'type');
						#renderrow=#buttontemplate;
					else;
						#renderrow=#template;
					/if;
					local: 'id'= string;
					if: (#onefield -> (find: 'id')) !='';
						#id = (#onefield -> (find: 'id'));
					else;
						#id = #formid + '_' + (#onefield -> (find: 'name')) + loop_count;
					/if;
					if: (self -> 'errors') -> size == 0 && #focusfield == '' && #onefield -> (find: 'focus');
						// give this field focus
						#focusfield = #id;
					/if;
					
                    local('widget'= #onefield -> find('widget'));

                    if(#widget == '');
                        // use the built-in template to renderrow
                        // set field label, with error marker if field validation failed
                        // if: (self -> 'exceptionfieldtypes') >> (#onefield -> (find: 'type')) && (#onefield -> (find: 'type')) != 'file';
                        //	#renderrow -> (replace: '#label#', '');
                        //else: 
                        if: (self -> 'errors') -> type == 'array' && (self -> 'errors') >> (#onefield -> (find: 'name'));
                            #renderrow -> (replace: '#label#', 
                                '<label for="' + #id + '" id="' + #id + '_label" ' + #errorclass + '>' + (#onefield -> find('label')) + '</label>');
                            if: #focusfield == '';
                                #focusfield = #id;
                            /if;
                        else;
                            #renderrow -> (replace: '#label#', '<label for="' + #id + '" id="' + #id + '_label">' + (#onefield -> find('label')) + '</label>');
                        /if;
                        
                        // set markers for required fields 
                        if: #onefield -> (find: 'required') && !((self -> 'exceptionfieldtypes') >> (#onefield -> (find: 'type')) );
                            #renderrow -> (replace: '#required#', (encode_smart: #requiredmarker));
                        else;
                            #renderrow -> (replace: '#required#', '');
                        /if;
                        #renderfield=string;
                        #renderfield_base = ' name="' + (encode_html: (#onefield -> (find: 'name'))) + '"'
                            + (#onefield >> 'class' ?  ' class="' + (#onefield -> (find: 'class')) + '"' 
                                | (#defaultclass != '' ? ' class="' + #defaultclass + '"') )
                            + ' id="' +  (encode_html: #id) + '"'
                            + (#onefield >> 'raw'	?  ' ' + (#onefield -> (find: 'raw')) )
                            + (#onefield -> (find: 'disabled') ? ' disabled="disabled"');
    
                        #fieldtype=(#onefield -> (find: 'type'));
                        if: #fieldtype == 'search' && client_type !>> 'WebKit';
                            // only show <input type=search" for WebKit based browsers like Safari
                            #fieldtype = 'text';
                        /if;
                        select: #fieldtype;
                        case: 'html';
                            #renderrow = #template;
                            #renderrow -> (replace: '#label#', '');
                            #renderrow -> (replace: '#required#', '');
                            #renderfield = #fieldvalue + '\n';
                        case: 'legend';
                            #renderrow = '';
                            if: (self -> 'render_fieldset_open');
                                #output += '</fieldset>\n';
                                (self -> 'render_fieldset_open') = false;
                            /if;
                            #output += '<fieldset' 
                                + (#onefield >> 'class' ?  ' class="' + (#onefield -> (find: 'class')) + '"' 
                                    | (#defaultclass != '' ? ' class="' + #defaultclass + '"') )
                                + ((#onefield -> (find: 'id') != '') ? ' id="' + #id + '"') 
                                + '>\n';
                            (self -> 'render_fieldset_open') = true;
                            #output += '<legend>' + (encode_html: #fieldvalue) + '</legend>\n';
                        case: 'fieldset';
                            #renderrow = '';
                            if: (self -> 'render_fieldset_open');
                                #output += '</fieldset>\n';
                                (self -> 'render_fieldset_open') = false;
                            /if;
                            if: #fieldvalue !== false;
                                (self -> 'render_fieldset_open') = true;
                                #output += '<fieldset' 
                                + (#onefield >> 'class' ?  ' class="' + (#onefield -> (find: 'class')) + '"' 
                                    | (#defaultclass != '' ? ' class="' + #defaultclass + '"') )
                                + ((#onefield -> (find: 'id') != '') ? ' id="' + #id + '"') 
                                + '>\n<legend>' + (encode_html: #fieldvalue) + '</legend>\n'; // must contain a legend
                            /if;
                        case: 'hidden';
                            #renderfield += '<input type="hidden"' 
                                + #renderfield_base
                                + ' value="' + (encode_html: #fieldvalue) + '"';
                            #renderfield += #endslash + '>';
                            #renderrow = '';
                            #output += #renderfield + '\n';
                        case: 'text';
                            #renderfield += '<input type="text"' 
                                + #renderfield_base
                                + ' value="' + (encode_html: #fieldvalue) + '"'
                                + (#onefield >> 'size' 	? ' size="' + (#onefield -> (find: 'size')) + '"' )
                                + (#onefield >> 'maxlength' 	? ' maxlength="' + (#onefield -> (find: 'maxlength')) + '"' );
                            if: !(self -> 'noscript') && (#onefield -> (find: 'hint')) != '';
                                #renderfield += ' onfocus="clearHint(this)" onblur="setHint(this, \'' (#onefield -> (find: 'hint')) '\')"';
                                #usehint -> (insert: (#onefield -> find: 'name') = #id);
                            /if;
                            if: !(self -> 'noscript') && !#nowarning;
                                #renderfield += ' onkeydown="dirtyvalue(this)" onkeyup="makedirty(this)"';
                            /if;
                            #renderfield += #endslash + '>';
                        case: 'search';
                            #renderfield += '<input type="search"' 
                                + #renderfield_base
                                + ' value="' + (encode_html: #fieldvalue) + '"'
                                + (#onefield >> 'size' 	? ' size="' + (#onefield -> (find: 'size')) + '"' );
                            if: (#onefield -> (find: 'hint')) != '';
                                #renderfield += ' placeholder="' + (encode_html: (#onefield -> (find: 'hint'))) + '"';
                            /if;
                            if: !(self -> 'noscript') && !#nowarning;
                                #renderfield += ' onkeydown="dirtyvalue(this)" onkeyup="makedirty(this)"';
                            /if;
                            #renderfield += #endslash + '>';
                        case: 'password';
                            #renderfield += '<input type="password"' 
                                + #renderfield_base
                                + ' value="' + (encode_html: #fieldvalue) + '"'
                                + (#onefield >> 'size' 	? ' size="' + (#onefield -> (find: 'size')) + '"' );
                            if: !(self -> 'noscript') && !#nowarning;
                                #renderfield += ' onkeydown="dirtyvalue(this)" onkeyup="makedirty(this)"';
                            /if;
                            #renderfield += #endslash + '>';
                        case: 'textarea';
                            #renderfield += '<textarea' 
                                + #renderfield_base
                                + (#onefield >> 'cols' 	? ' cols="' + (#onefield -> (find: 'cols')) + '"')
                                + (#onefield >> 'rows' 	? ' rows="' + (#onefield -> (find: 'rows')) + '"');
                            if: !(self -> 'noscript') && (#onefield -> (find: 'hint')) != '';
                                #renderfield += ' onfocus="clearHint(this)" onblur="setHint(this, \'' (#onefield -> (find: 'hint')) '\')"';
                                #usehint -> (insert: (#onefield -> find: 'name') = #id);
                            /if;
                            if: !(self -> 'noscript') && !#nowarning;
                                #renderfield += ' onkeydown="dirtyvalue(this)" onkeyup="makedirty(this)"';
                            /if;
                            #renderfield += '>'
                                + (encode_html: #fieldvalue) + '</textarea>';
                        case: 'checkbox';
                            local: 'optioncount'=integer;
                            #renderfield += '<div class="inputgroup'
                                + (#onefield >> 'class' ?  ' ' + (#onefield -> find('class'))
                                | (#defaultclass != '' ? ' ' + #defaultclass) ) 
                                + '" id="' + #id + '">\n';
                            iterate: #options, (local: 'option');
                                #optioncount += 1;
                                #renderfield += (#optioncount > 1 && (#onefield -> find: 'linebreak') ? '<br' + #endslash + '>') + '\n';
                                if: #option -> name == '-optgroup';
                                    #renderfield += (!(#onefield -> find: 'linebreak') && #optioncount > 1 ? '\n<br' + #endslash + '>');
                                    if: #option -> value != '-optgroup';
                                        #renderfield += #option -> value
                                            + (!(#onefield -> find: 'linebreak') ? '<br' + #endslash + '>\n');
                                    /if;
                                else;
                                    #renderfield +=  '<input type="checkbox"'
                                        + (string_replaceregexp: #renderfield_base, -find='id="(.+?)"', -replace=('id="\\1_' + #optioncount + '"'))
                                        + ' value="' + (encode_html: #option -> name) + '"';
                                    if: #option -> name != '' && #fieldvalue_array >> #option -> name;
                                        #renderfield +=' checked="checked"';
                                    /if;
                                    if: !(self -> 'noscript') && !#nowarning;
                                        #renderfield += ' onclick="makedirty();"';
                                    /if;
                                    #renderfield += #endslash + '> <label for="' + #id + '_' + #optioncount 
                                        + '" id="' + #id + '_' + #optioncount + '_label"';
                                    if: (self -> 'noscript') && !#nowarning;
                                        #renderfield += ' onclick="makedirty();"';
                                    /if;
                                    #renderfield += '>' + (#option -> value) + '</label> ';
                                /if;
                            /iterate;
                            #renderfield += '</div>\n';
                        case: 'radio';
                            local: 'optioncount'=integer;
                            #renderfield += '<div class="inputgroup'
                                + (#onefield >> 'class' ?  ' ' + (#onefield -> find('class'))
                                | (#defaultclass != '' ? ' ' + #defaultclass) ) 
                                + '" id="' + #id + '">\n';
                            iterate: #options, (local: 'option');
                                #optioncount += 1;
                                #renderfield += (#optioncount > 1 && (#onefield -> find: 'linebreak') ? '<br' + #endslash + '>') + '\n';
                                if: #option -> name == '-optgroup';
                                    #renderfield += (!(#onefield -> find: 'linebreak') && #optioncount > 1 ? '\n<br' + #endslash + '>');
                                    if: #option -> value != '-optgroup';
                                        #renderfield += #option -> value
                                            + (!(#onefield -> find: 'linebreak') ? '<br' + #endslash + '>\n');
                                    /if;
                                else;
                                    #renderfield += '<input type="radio"'
                                        + (string_replaceregexp: #renderfield_base, -find='id="(.+?)"', -replace=('id="\\1_' + #optioncount + '"'))
                                        + ' value="' + (encode_html: #option -> name) + '"';
                                    if: #option -> name != '' && #fieldvalue_array >> #option -> name;
                                        #renderfield +=' checked="checked"';
                                    /if;
                                    if: !(self -> 'noscript') && !#nowarning;
                                        #renderfield += ' onclick="makedirty();"';
                                    /if;
                                    #renderfield += #endslash + '> <label for="' + #id + '_' + #optioncount 
                                        + '" id="' + #id + '_' + #optioncount + '_label"';
                                    if: !(self -> 'noscript') && !#nowarning;
                                        #renderfield += ' onclick="makedirty();"';
                                    /if;
                                    #renderfield += '>' + (#option -> value) + '</label> ';
                                /if;
                            /iterate;
                            #renderfield += '</div>\n';
                        case: 'select';
                            #renderfield += '<select '
                                + #renderfield_base
                                + (#onefield -> (find: 'multiple') ? ' multiple')
                                + (#onefield >> 'size' 	? ' size="' + (#onefield -> (find: 'size')) + '"' );
                            if: !(self -> 'noscript') && !#nowarning;
                                if: #renderfield >> 'onchange="';
                                    #renderfield -> (replace: 'onchange="', 'onchange="makedirty();');
                                else;
                                    #renderfield += ' onchange="makedirty()"';
                                /if;
                            /if;
                            #renderfield += '>\n';
                            if: (#onefield -> (find: 'default')) != '' && (#onefield -> (find: 'size')) <= 1;
                                #renderfield += '<option'
                                    + ' value="">' + (encode_html: (#onefield -> (find: 'default'))) + '</option>\n';
                                #renderfield += '<option'
                                    + ' value=""></option>\n';
                            /if;
                            local: 'optgroup_open'=false;
                            iterate: #options, (local: 'option');
                                if: #option -> name == '-optgroup';
                                    if: #optgroup_open;
                                        #renderfield += '</optgroup>\n';
                                    /if;
                                    if: #option -> value != '-optgroup';
                                        #renderfield += '<optgroup label="' + (#option -> value) + '">\n';
                                        #optgroup_open = true;
                                    /if;
                                else;
                                    #renderfield += '<option'
                                        + ' value="' + (encode_html: #option -> name) + '"';
                                    if: #option -> name != '' && #fieldvalue_array >> #option -> name;
                                        #renderfield +=' selected="selected"';
                                    /if;
                                    #renderfield +=  '>' + (encode_html: #option -> value) + '</option>\n';
                                /if;
                            /iterate;
                            if: #optgroup_open;
                                #renderfield += '</optgroup>\n';
                            /if;
                            #renderfield += '</select>\n';
                        case: 'submit';
                            #renderfield += '<input type="submit"' 
                                + #renderfield_base
                                + ' value="' + (encode_html: #fieldvalue) + '"';
                            if: (self -> formmode) == 'add' 
                                && !(#onefield -> (find: 'disabled')) // already disabled
                                && (#onefield -> (find: 'originaltype') == 'savebutton' || #onefield -> (find: 'originaltype') == 'deletebutton'
                                || #onefield -> (find: 'name') == 'button_save' || #onefield -> (find: 'name') == 'button_delete');
                                #renderfield += ' disabled="disabled"';
                            /if;
                            if: !(self -> 'noscript') 
                                && (#onefield -> (find: 'name') == 'button_delete' 
                                    || #onefield -> (find: 'originaltype') == 'deletebutton' 
                                    || #onefield -> (find: 'confirmmessage') != '');
                                local: 'confirmmessage'=(#onefield -> (find: 'confirmmessage') != '' 
                                    ? #onefield -> (find: 'confirmmessage') | 'Really delete?');
                                #confirmmessage -> (replace: '"', '&quot;');
                                #confirmmessage -> (replace: '\'', '\\\'');
                                #renderfield += ' onclick="return confirm(\'' + #confirmmessage +  '\')"';
                            /if;
                            #renderfield += #endslash + '>';
                        case: 'reset';
                            #renderfield += '<input type="reset"' 
                                + #renderfield_base
                                + ' value="' + (encode_html: #fieldvalue) + '"';
                            if: !(self -> 'noscript') && #onefield -> (find: 'confirmmessage') != '';
                                local: 'confirmmessage'=#onefield -> (find: 'confirmmessage');
                                #confirmmessage -> (replace: '"', '&quot;');
                                #confirmmessage -> (replace: '\'', '\\\'');
                                #renderfield += ' onclick="if(confirm(\'' + #confirmmessage +  '\')){makeundirty();return true}else{return false};"';
                            else: !(self -> 'noscript');
                                #renderfield += ' onclick="makeundirty();"';
                            /if;
                            #renderfield += #endslash + '>';
                        case: 'image';
                            #renderfield += '<input type="image"' 
                                + #renderfield_base
                                + ' value="' + (encode_html: #fieldvalue) + '"';
                            if: (self -> formmode) == 'add' && 
                                (#onefield -> (find: 'originaltype') == 'savebutton' || #onefield -> (find: 'originaltype') == 'deletebutton'
                                || #onefield -> (find: 'name') == 'button_save' || #onefield -> (find: 'name') == 'button_delete');
                                #renderfield += ' disabled="disabled"';
                            /if;
                            if: !(self -> 'noscript')
                                && (#onefield -> (find: 'name') == 'button_delete' 
                                    || #onefield -> (find: 'originaltype') == 'deletebutton' 
                                    || #onefield -> (find: 'confirmmessage') != '');
                                local: 'confirmmessage'=(#onefield -> (find: 'confirmmessage') != '' 
                                    ? #onefield -> (find: 'confirmmessage') | 'Really delete?');
                                #confirmmessage -> (replace: '"', '&quot;');
                                #confirmmessage -> (replace: '\'', '\\\'');
                                #renderfield += ' onclick="return confirm(\'' + #confirmmessage +  '\')"';
                            /if;
                            #renderfield += #endslash + '>';
                        case: 'file';
                            #renderfield += '<input type="file"' 
                                + #renderfield_base;
                            if: !(self -> 'noscript') && !#nowarning;
                                if: #renderfield >> 'onchange="';
                                    #renderfield -> (replace: 'onchange="', 'onchange="makedirty();');
                                else;
                                    #renderfield += ' onchange="makedirty()"';
                                /if;
                            /if;
                            #renderfield += #endslash + '>';
                        /select;
                        #renderrow -> (replace: '#field#', #renderfield);
                    else;
                        // use a custom widget template to renderrow
                        local('e' = array);
                        if((self -> 'errors') -> type == 'array'
                            && (self -> 'errors') >> (#onefield -> find('name')));
                            iterate((self -> 'errors') -> find(#onefield -> find('name')), local('oe'));
                                #oe -> isa('pair') ? #e = #oe -> second;
                            /iterate;
                        /if;
                        // if field is required, use the required marker of the form
                        local('required' = string);
                        if(#onefield -> find('required'));
                             #required = self -> 'required';
                        /if;
                        local('tw') = \#widget;
                        #renderrow = #tw->run(
                            -params=array(
                                -name = #onefield -> find('name'),
                                -class = #onefield -> find('class'),
                                -cols = #onefield -> find('cols'),
                                -default = #onefield -> find('default'),
                                -disabled = #onefield -> find('disabled'),
                                -errmsg = #e,
                                -errorclass = #onefield -> find('errorclass'),
                                -fieldvalue_array = #fieldvalue_array,
                                -group = #onefield -> find('group'),
                                -groupclass = #onefield -> find('groupclass'),
                                -id = #id,
                                -label = #onefield -> find('label'),
                                -maxlength = #onefield -> find('maxlength'),
                                -multiple = #onefield -> find('multiple'),
                                -options = #options,
                                -placeholder = #onefield -> find('placeholder'),
                                -required = #required,
                                -rows = #onefield -> find('rows'),
                                -size = #onefield -> find('size'),
                                -type = #onefield -> find('type'),
                                -value = encode_html(#fieldvalue),
                                -encodenone
                        ));
                    /if;
					#output += #renderrow;
				/if; 
			/iterate;
			
				
		/if; //  !(local_defined: 'start') && !(local_defined: 'end');

		// Add just the needed scripts to support the client side functionality
		if(!(self -> 'noscript'));
			#output >> 'togglecontrol(' 
				? self -> (afterhandler: -endscript='function togglecontrol(obj){
					// toggles checkboxes and radios when clicking on label (for browsers that don´t support this already)
					switch (obj.type){
					case \'checkbox\':
						obj.checked=!obj.checked;
						break;
					case \'radio\':
						obj.checked=true;
						break;
					}
				}');
			#output >> 'setHint('
				? 		self -> (afterhandler: -endscript='function setHint(myField, hint) {
					if(myField.value==\'\') {
						if(myField.name.indexOf(\'off_\') != 0) {
							myField.name=\'off_\' + myField.name;
						}
						myField.value=hint;
						getStyleObject(myField.id).color=\'#aaa\';
					}
				}
				function clearHint(myField) {
					if(myField.name.indexOf(\'off_\') == 0) {
						myField.name=myField.name.substr(4);
						myField.value=\'\';
						getStyleObject(myField.id).color=\'black\';
					}
				}
				function getStyleObject(objectId) {
					if(document.getElementById && document.getElementById(objectId)) {
					return document.getElementById(objectId).style;
					} else {
					return false;
					}
				}');
		
			#output >> 'makedirty(' || #output >> 'validateform('
				? self -> (afterhandler: -endscript='
				var dirty=' + ((self -> 'errors') -> size ? 'true' | 'false') + ';
				var dirtycheckname=null;
				var dirtycheckvalue=null;
				var submitBlock=false;
				function validateform(myForm) {
					// perform validation of myForm here
					if(submitBlock){return false};
					makeundirty();
					return true;
				}
				
				function dirtyvalue(obj){ // to be called at keydown to track if a text field changes or if arrow keys/tab/cmd-keys are pressed
					 dirtycheckname = obj.name;
					 dirtycheckvalue = obj.value;
				}
				function makeundirty(){
					dirty=false; 
					dirtymarker();
					window.onbeforeunload=null;
				}
				function makedirty(obj){
					if(obj){ // if object is specified then we are tracking if the value changes through keydown/keyup 
						if (obj.value == dirtycheckvalue || obj.name != dirtycheckname) { // no change or tabbed to another field - return immediately
							return
						}
					}
					dirty=true; 
					dirtymarker();
				}
				function checkdirty(){
					if(dirty){
						return confirm(\'' + (self -> 'unsavedwarning') + '\')
					} else {return true}
				}
				
				function dirtymarker() {
					var obj = document.getElementById(\'' + (self -> 'unsavedmarker') + '\');
					if(dirty && obj){
						jscss(\'add\',obj,\'' + (self -> 'unsavedmarkerclass') + '\');
					}else if(obj) {
						jscss(\'remove\',obj,\'' + (self -> 'unsavedmarkerclass') + '\');
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
							o.className=!jscss(\'check\',o,c1)?o.className.replace(c2,c1): o.className.replace(c1,c2);
							break;
						case \'add\':
							if(!jscss(\'check\',o,c1)){o.className+=o.className?\' \'+c1:c1;}
							break;
						case \'remove\':
							var rep=o.className.match(\' \'+c1)?\' \'+c1:c1;
							o.className=o.className.replace(rep,\'\');
							break;
						case \'check\':
							return new RegExp(\'\\\\b\'+c1+\'\\\\b\').test(o.className);
							break;
					}
				}
				if(dirty) {makedirty()};');
				
				(self -> 'unsavedwarning') != '' 
					? self -> (afterhandler: -endscript='function beforeunload() {
					if(dirty) {return \'' + (self -> 'unsavedwarning') + '\';}
				}
				window.onbeforeunload=beforeunload;');
				
				#output >> 'submitOk'
					? self -> (afterhandler: -endscript='function submitOk(e) { // prevents submit-on-enter
					var keynum;
					var elTarget;
					var elType;
		
					// get keycode for the event 
					if(window.event) keynum = e.keyCode; // IE
					else if(e.which) keynum = e.which; // DOM
		
					// get target
					if (e.target) elTarget = e.target;
					else if (e.srcElement) elTarget = e.srcElement;
		
					if(elTarget.tagName.toLowerCase()  == \'input\') elType = elTarget.getAttribute(\'type\').toLowerCase();
					submitBlock=false;
					if (elType != \'submit\' && elType != \'image\' && elType != \'reset\') {
						// allow enter submit when submit button/image or reset button has focus
						if (keynum==13) submitBlock=true;
					}
					return true;
				}');
			/if; // noscript

		if: false && $knop_form_renderform_counter <= 1;
										self -> (afterhandler: -headscript=
											'function getStyleObject(objectId) {
												if(document.getElementById && document.getElementById(objectId)) {
												return document.getElementById(objectId).style;
												} else {
												return false;
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
														o.className=!jscss(\'check\',o,c1)?o.className.replace(c2,c1): o.className.replace(c1,c2);
														break;
													case \'add\':
														if(!jscss(\'check\',o,c1)){o.className+=o.className?\' \'+c1:c1;}
														break;
													case \'remove\':
														var rep=o.className.match(\' \'+c1)?\' \'+c1:c1;
														o.className=o.className.replace(rep,\'\');
														break;
													case \'check\':
														return new RegExp(\'\\\\b\'+c1+\'\\\\b\').test(o.className);
														break;
												}
											}
											
											function togglecontrol(obj){
												// toggles checkboxes and radios when clicking on label (for browsers that don´t support this already)
												switch (obj.type){
												case \'checkbox\':
													obj.checked=!obj.checked;
													break;
												case \'radio\':
													obj.checked=true;
													break;
												}
											}
											
											function setHint(myField, hint) {
												if(myField.value==\'\') {
													if(myField.name.indexOf(\'off_\') != 0) {
														myField.name=\'off_\' + myField.name;
													}
													myField.value=hint;
													getStyleObject(myField.id).color=\'#aaa\';
												}
											}
											function clearHint(myField) {
												if(myField.name.indexOf(\'off_\') == 0) {
													myField.name=myField.name.substr(4);
													myField.value=\'\';
													getStyleObject(myField.id).color=\'black\';
												}
											}
											var dirty=' + ((self -> 'errors') -> size ? 'true' | 'false') + ';
											var dirtycheckname=null;
											var dirtycheckvalue=null;
											var submitBlock=false;
							
											function validateform(myForm) {
												// perform validation of myForm here
												if(submitBlock){return false};
												makeundirty();
												return true;
											}
											
											function dirtyvalue(obj){ // to be called at keydown to track if a text field changes or if arrow keys/tab/cmd-keys are pressed
												 dirtycheckname = obj.name;
												 dirtycheckvalue = obj.value;
											}
											function makeundirty(){
												dirty=false; 
												dirtymarker();
												window.onbeforeunload=null;
											}
											function makedirty(obj){
												if(obj){ // if object is specified then we are tracking if the value changes through keydown/keyup 
													if (obj.value == dirtycheckvalue || obj.name != dirtycheckname) { // no change or tabbed to another field - return immediately
														return
													}
												}
												dirty=true; 
												dirtymarker();
											}
											function checkdirty(){
												if(dirty){
													return confirm(\'' + (self -> 'unsavedwarning') + '\')
												} else {return true}
											}
											function beforeunload() {
												if(dirty) {
													return \'' + (self -> 'unsavedwarning') + '\';
												}
											}
											
											function dirtymarker() {
												var obj = document.getElementById(\'' + (self -> 'unsavedmarker') + '\');
												if(dirty && obj){
													jscss(\'add\',obj,\'' + (self -> 'unsavedmarkerclass') + '\');
												}else if(obj) {
													jscss(\'remove\',obj,\'' + (self -> 'unsavedmarkerclass') + '\');
												}
											}
											' + ((self -> 'unsavedwarning') != '' ? 'window.onbeforeunload=beforeunload;') + '
											
											function submitOk(e) { // prevents submit-on-enter
												var keynum;
												var elTarget;
												var elType;
							
												// get keycode for the event 
												if(window.event) keynum = e.keyCode; // IE
												else if(e.which) keynum = e.which; // DOM
							
												// get target
												if (e.target) elTarget = e.target;
												else if (e.srcElement) elTarget = e.srcElement;
							
												if(elTarget.tagName.toLowerCase()  == \'input\') elType = elTarget.getAttribute(\'type\').toLowerCase();
												submitBlock=false;
												if (elType != \'submit\' && elType != \'image\' && elType != \'reset\') {
													// allow enter submit when submit button/image or reset button has focus
													if (keynum==13) submitBlock=true;
												}
												return true;
											}
											
											');
		/if;
		if: !(self -> 'noscript') && #usehint -> size > 0;
			local: 'hintscript'=string;
			// #usehint is a pair array with name=id
			iterate: #usehint, (local: 'hintfield');
				if: (self -> 'fields') >> #hintfield -> name;
					#onefield = (self -> 'fields') -> (find: #hintfield -> name) -> first -> value;
					#hintscript += 'setHint(document.getElementById(\'' + (encode_html: #hintfield -> value) + '\'), \'' 
						+ (#onefield -> (find: 'hint')) + '\');\n';
				/if;
			/iterate;
			
			self -> (afterhandler: -endscript=#hintscript);
		/if;
		if: !(self -> 'noscript') && #focusfield != '';
			self -> (afterhandler: -endscript='document.getElementById(\'' + #focusfield + '\').focus();document.getElementById(\'' + #focusfield + '\').select();');
		/if;

		if: (self -> 'render_fieldset_open') && (params -> size == 0 || (local_defined: 'end'));
			// inner fieldset is open
			(self -> 'render_fieldset_open') = false;
			#output += '</fieldset>\n';
		/if;
		if: (self -> 'render_fieldset2_open') && (local_defined: 'legend');
			// inner fieldset is open
			(self -> 'render_fieldset2_open') = false;
			#output += '</fieldset>\n';
		/if;

		if: #renderformEndTag;
			if: (self -> 'fieldset');
				#output += '</fieldset>\n';
			/if;
		
			// render closing form tag
			#output += '</form>';
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: @#output;
	/define_tag;

	define_tag: 'renderhtml', -description='Outputs form data as plain HTML, a specific field, a range of fields or all fields of a specific type. \
			Some form field types are excluded, such as submit, reset, file etc. \
			Use form -> setformat first to specify the html format, otherwise default format #label#: #field#<br> is used.\n\
			Parameters:\n\
			-name (optional) Render only the specified field\n\
			-from (optional) Render fields from the specified number index or field name\n\
			-to (optional) Render fields to the specified number index or field name\n\
			-type (optional) Only render fields of this or these types (string or array)\n\
			-excludetype (optional) Render fields except of this or these types (string or array)\n\
			-legend (optional) Groups the rendered fields in a fieldset and outputs a legend for the fieldset\n\
			-xhtml (optional flag) XHTML valid output',
		-optional='name', -copy,	// field name
		-optional='from', -copy, 	// number index or field name
		-optional='to', -copy, 		// number index or field name
		-optional='type', -copy,	// only output fields of this or these types (string or array)
		-optional='excludetype', -copy,	// do not output fields of this or these types (string or array)
		-optional='legend',			// groups the rendered fields in a fieldset and outputs a legend for the fieldset
		-optional='xhtml';			// boolean, if set to true adjust output for XHTML
		local: 'timer'=knop_timer; 
		
		local: 'output'=string, 
			'onefield'=map, 
			'renderfield'=string, 
			'renderfield_base'=string, 
			'renderrow'=string,
			'fieldvalue'=string,
			'fieldvalue_array'=array,
			'options'=array,
			'usehint'=array;

		
		// local var that adjust tag endings if rendered for XHTML
		local: 'endslash' = ((self -> (xhtml: params)) ? ' /' | '');

		(local_defined: 'name') && !((self -> 'fields') >> #name) 	? 	return;

		(local_defined: 'name')		? local: 'from'=#name, 'to'=#name;
		!(local_defined: 'from') 		? local: 'from'=1;
		!(local_defined: 'to') 			? local: 'to'=(self -> 'fields') -> size;
		!(local_defined: 'type')		? local: 'type'=(self -> 'validfieldtypes');
		!(local_defined: 'excludetype')	? local: 'excludetype'=map;
		#type -> type == 'string' 		? #type = (map: #type);
		#excludetype -> type == 'string' ? #excludetype = (map: #excludetype);

		// use field name if #from is a string
		#from -> type == 'string' ? #from = integer: ((self -> 'fields') -> (findindex: #from) -> first);
		#from == 0 ? #from = 1;
		// negative numbers count from the end
		#from < 0 ? #from = (self -> 'fields') -> size + #from;

		// use field name if #to is a string
		#to -> type == 'string' ? #to = integer: ((self -> 'fields') -> (findindex: #to) -> last);
		#to == 0 ? #to = (self -> 'fields') -> size;
		// negative numbers count from the end
		#to < 0 ? #to = (self -> 'fields') -> size + #to;

		//Sanity check
		#from > #to ? #to = #from;

		local: 'template'=( (self -> 'template') != '' 
			? (self -> 'template') 		
			| '#label#: #field#<br' + #endslash + '>\n' );
		local: 'buttontemplate'=( (self -> 'buttontemplate') != '' 
			? (self -> 'buttontemplate') 		
			| (self -> 'template') != '' 
			? (self -> 'template')
			| '#field#\n' );
		local: 'defaultclass'=( (self -> 'class') != '' 
			? (self -> 'class') 		
			| '');
		if: (local_defined: 'legend');
			#output += '<fieldset>\n'
				+ '<legend>' + #legend + '</legend>\n';
			(self -> 'render_fieldset2_open') = true;
		/if;
		iterate: (self -> 'fields'), (local: 'fieldpair');
			#onefield = #fieldpair -> value;
			#fieldvalue = (#onefield -> (find: 'value'));
			#fieldvalue_array = #fieldvalue;
			if: #fieldvalue_array -> type != 'array';
				if: #fieldvalue_array >> '\r'; // Filemaker value list with multiple checked
					#fieldvalue_array = #fieldvalue_array -> (split: '\r');
				else: #fieldvalue_array >> ','; // Other database with multiple checked
					#fieldvalue_array = #fieldvalue_array -> (split: ',');
				else;
					#fieldvalue_array = array: #fieldvalue_array;
				/if;
			/if;
			if: #onefield >> 'options';
				#options = (#onefield -> find: 'options');
				// convert types for pair 
				iterate: #options, (local: 'option');
					if: #option -> type != 'pair';
						#option = (pair: #option = #option);
					/if;
					// name must be string to make sure comparsions work
					(#option -> name) = (string: #option -> name);
				/iterate;
			/if;
			if: loop_count >= #from 
				&& loop_count <= #to
				&& #type >> #onefield -> (find: 'type')
				&& !(#excludetype >> #onefield -> (find: 'type'));

				if: #onefield -> (find: 'template') -> size;
					#renderrow = #onefield -> (find: 'template');
				else: (map: 'submit', 'reset', 'image') >> #onefield -> (find: 'type');
					#renderrow=#buttontemplate;
				else;
					#renderrow=#template;
				/if;

				if: (self -> 'exceptionfieldtypes') >> (#onefield -> (find: 'type'));
					#renderrow -> (replace: '#label#:', '');
					#renderrow -> (replace: '#label#', '');
				else: (#onefield -> (find: 'label')) != '';
					#renderrow -> (replace: '#label#', (#onefield -> (find: 'label') ));
				else: 
					#renderrow -> (replace: '#label#:', '');
					#renderrow -> (replace: '#label#', '');
				/if;
				if: (map: 'radio', 'checkbox', 'select') >> (#onefield -> (find: 'type'));
					#renderfield = string;
					iterate: #fieldvalue_array, local: 'onefieldvalue';
						if: loop_count > 1;
							#renderfield += ( (#onefield -> find: 'linebreak') ? '<br' + #endslash + '>\n' | ', ');
						/if;
						if: #options >> #onefieldvalue;
							// show the display text for a selected option
							#renderfield += (encode_break: (#options -> (find: #onefieldvalue) -> first -> value));
						else;
							// show the option value itself
							#renderfield += (encode_break: #onefieldvalue);
						/if;
					/iterate;
				else: (#onefield -> (find: 'type')) == 'html';
					#renderrow = #template;
					#renderrow -> (replace: '#label#:', '');
					#renderrow -> (replace: '#label#', '');
					#renderrow -> (replace: '#required#', '');
					#renderfield = #fieldvalue + '\n';
				else: (#onefield -> (find: 'type')) == 'legend';
					#renderrow = '';
					if: (self -> 'render_fieldset_open');
						#output += '</fieldset>\n';
						(self -> 'render_fieldset_open') = false;
					/if;
					#output += '<fieldset>\n';
					#output += '<legend>' + (encode_html: #fieldvalue) + '</legend>';
					(self -> 'render_fieldset_open') = true;
				else: (#onefield -> (find: 'type')) == 'fieldset';
					#renderrow = '';
					if: (self -> 'render_fieldset_open');
						#output += '</fieldset>\n';
						(self -> 'render_fieldset_open') = false;
					/if;
					if: #fieldvalue != false;
						#output += '<fieldset>\n<legend></legend>'; // must contain a legend
						(self -> 'render_fieldset_open') = true;
					/if;
				else;
					#renderfield = (encode_break: #fieldvalue);
				/if;
				#renderrow -> (replace: '#field#', #renderfield);
				#output += #renderrow;
			/if;
		/iterate;
		if: (local_defined: 'legend') && (self -> 'render_fieldset2_open');
			// inner fieldset is open
			(self -> 'render_fieldset2_open') = false;
			#output += '</fieldset>\n';
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: #output;
	/define_tag;

	define_tag: 'getvalue', -description='Returns the current value of a form field. Returns an array for repeated form fields. ',
		-required='name', -type='string',
		-optional='index', -type='integer', -copy;
		!local_defined('index') ? local('index' = 1);
		#index < 1 ? #index = 1;
		if: (self -> 'fields') >> #name;
			if(#index > (self -> 'fields') -> find(#name) -> size);
				return;
			/if;
			return: (self -> 'fields') -> (find: #name) -> get(#index) -> value -> (find: 'value');
		/if;
	/define_tag;

	define_tag: 'getlabel', -description='Returns the label for a form field. ',
		-required='name', -type='string';
		if: (self -> 'fields') >> #name;
			return: (self -> 'fields') -> (find: #name) -> first -> value -> (find: 'label');
		/if;
	/define_tag;

	define_tag: 'setvalue', -description='Sets the value for a form field. \
				Either form -> (setvalue: fieldname=newvalue) or form -> (setvalue: -name=fieldname, -value=newvalue)',
		-required='name',
		-optional='value',
		-optional='index', -type='integer', -copy;
		local: 'timer'=knop_timer; 
		// either -> (setvalue: 'fieldname'='newvalue') or -> (setvalue: -name='fieldname', -value='newvalue')
		local: '_name'=#name, '_value'=(local: 'value');
		!local_defined('index') ? local('index' = 1);
		#index < 1 ? #index = 1;
		if: #name -> type == 'pair';
			#_name = #name -> name;
			#_value = #name -> value;
		/if;
		if: (self -> 'fields') >> #_name;
			if(#index > (self -> 'fields') -> find(#_name) -> size);
				return;
			/if;
			// first remove value to break reference
			((self -> 'fields') -> get((self -> 'fields') -> (findindex: #_name) -> get(#index)) -> value) -> (remove: 'value');
			((self -> 'fields') -> get((self -> 'fields') -> (findindex: #_name) -> get(#index)) -> value) -> (insert: 'value'=#_value);
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;

	define_tag: 'removefield', -description='Removes all form elements with the specified name from the form',
		-required='name', -type='string';
		local: 'timer'=knop_timer; 
		(self -> 'fields') -> (removeall: #name);
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;
	
	define_tag: 'keys', -description='Returns an array of all field names';
		local: 'timer'=knop_timer; 
		local: 'output'=array;
		iterate: (self -> 'fields'), (local: 'fieldpair');
			#output -> (insert: #fieldpair -> name);
		/iterate;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: #output;
	/define_tag;


    define_tag('fields', -description='Returns a map of all non-special type field names and their parameters');
        local('timer' = knop_timer);
        local('output' = map);
        iterate((self -> 'fields'), local('fieldpair'));
            if(array('html', 'fieldset', 'legend') !>> #fieldpair -> name);
                #output -> insert(#fieldpair -> name = #fieldpair -> value);
            /if;
        /iterate;
        self -> 'tagtime_tagname' = tag_name;
        self -> 'tagtime' = integer(#timer); // cast to integer to trigger onconvert and to "stop timer"
        return(#output);
    /define_tag;


	define_tag: 'keyvalue'; 			return: (self -> 'db_keyvalue');		/define_tag;
	define_tag: 'lockvalue'; 			return: (self -> 'db_lockvalue');		/define_tag;
	define_tag: 'lockvalue_decrypted';
		(self -> 'database') -> type != 'database' ? return;
		return: (decrypt_blowfish: (self -> 'db_lockvalue'), -seed=(self -> 'database' -> 'lock_seed'));
	/define_tag;
	define_tag: 'database'; 			return: (self -> 'database');			/define_tag;

	define_tag: 'formmode', -description='Returns add or edit after for -> init has been called';
		local: 'timer'=knop_timer; 
		if: (self -> getbutton) == 'add';
			// this is needed to keep the right form mode after a failed add
			(self -> 'formmode') = 'add';
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
 		return: (self -> 'formmode');
 	/define_tag;

	define_tag: 'error_code';
		// custom error_code for knop_form
		if: (self -> 'error_code');
			return: integer: (self -> 'error_code');
		else: (self -> 'errors') -> type == 'array' && (self -> 'errors') -> size > 0;
			(self -> 'error_code') = 7101;
			return: (self -> 'error_code');
		else;
			return: 0;
		/if;
	/define_tag;


	
	define_tag: 'afterhandler', -description='Internal member tag. Adds needed javascripts through an atend handler that will be processed when the entire page is done. \n\
			Parameters:\n\
			-headscript (optional) A single script, will be placed before </head>  (or at top of page if </head> is missing)\n\
			-endscript (optional) Multiple scripts (no duplicates), will be placed before </body> (or at end of page if </body> is missing)',
		-optional='headscript', -type='string',
		-optional='endscript', -type='string';
		// adds needed javascripts through an atend handler that will be processed when the entire page is done

		if: !(var_defined: 'knop_afterhandler_data');
			var: 'knop_afterhandler_data'=map;
			define_atend: { // this will run after the page is done processing
				if: $knop_afterhandler_data >> 'headscript';
					// put before </head> or at beginning of page
					local: 'scriptdata'='<script language="javascript" type="text/javascript">\n/*<![CDATA[ */\n' 
						+ ($knop_afterhandler_data -> (find: 'headscript') -> join('\n')) 
						+ '\n/* ]]> */\n</script>\n';
					if: content_body >> '</head>';
						content_body -> (replace: '</head>', #scriptdata + '</head>');
					else;
						content_body = #scriptdata + content_body;
					/if;
				/if;
				if: $knop_afterhandler_data >> 'endscript';
					// put before </body> or at end of page
					local: 'scriptdata'='\n\n\n\n<script language="javascript" type="text/javascript">\n/* <![CDATA[ */\n' 
						+ ($knop_afterhandler_data -> (find: 'endscript') -> join('\n')) 
						+ '\n/* ]]> */\n</script>\n';
					if: content_body >> '</body>';
						content_body -> (replace: '</body>', #scriptdata + '</body>');
					else;
						content_body += #scriptdata;
					/if;
				/if;
			};
		/if;
		
		if: (local_defined: 'headscript');
			// add to current headscript
			if: $knop_afterhandler_data !>> 'headscript';
				$knop_afterhandler_data -> (insert: 'headscript' = array);
			/if;
			if: $knop_afterhandler_data -> (find: 'headscript') !>> #headscript;
				$knop_afterhandler_data -> (find: 'headscript') -> insert(#headscript);
			/if;
		/if;
		if: (local_defined: 'endscript');
			// add to current endscript
			if: $knop_afterhandler_data !>> 'endscript';
				$knop_afterhandler_data -> (insert: 'endscript' = array);
			/if;
			if: $knop_afterhandler_data -> (find: 'endscript') !>> #endscript;
				$knop_afterhandler_data -> (find: 'endscript') -> insert(#endscript);
			/if;
		/if;
	/define_tag;
/define_type;


?>
