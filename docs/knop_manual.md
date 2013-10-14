Knop Manual
===========
![Knop Logo](https://github.com/knop-project/knop/raw/master/docs/img/knop_logo_800.png)

Knop is an open source web application framework using Lasso 8 or 9.  Lasso is a programming language from [LassoSoft](http://www.lassosoft.com/).

Installation and configuration of Knop
--------------------------------------
For installation and configuration of Knop for each version of Lasso, please see its appropriate directory.

* [Knop for Lasso 8.x](../knop8/)
* [Knop for Lasso 9.x](../knop9/)

Support
-------
Technical support is provided by the community of Knop developers and users.

An email discussion list is provided by Montania SE.  To subscribe, send email to <knop-feed@lists.montania.se>

The Knop mailing list archive is available on [Nabble](http://lasso.2283332.n4.nabble.com/Knop-Framework-Discussion-f3157831.html).

To file a bug report, please use the [Knop Project Issue Tracker](https://github.com/knop-project/knop/issues).

The [Knop API Reference](help.lasso) describes all the Knop types and their methods.

Framework usage
---------------
Various factors contribute to a programmer's decision to use a framework for their solutions.

###Advantages

* Higher productivity
	
	Using a framework lets you focus more on the core functionality of the web site or application, and worry less about the nitty details. It becomes easier to reuse code and modules. You get more done in less time.

* Higher quality

	A framework becomes increasingly tested over time. The risk for silly and basic errors is reduced since the framework takes care of the basic functions. You can focus on the important things. You chase fewer bugs.

* Features

	A framework already has many of the bells and whistles you want to add to a web site, but don't have time or budget to even think about. You get many things for free.

###Disadvantages

* Less flexibility

	By using a framework you are more or less bound to the framework's view of the world. It can be problematic to do things in other ways than the framework has intended, or things that go beyond what the framework offers.

* Performance hit

	A framework puts you a little bit above the low level code.  There is always some degree of tradeoff between efficient development and raw performance. Higher abstraction level costs CPU cycles.

Goals of Knop
-------------
* __Be flexible__ - Let the developer use the bits they want, allow for customizations and special needs.
* __Be lean__ - Stay lightweight, beware of feature bloat, take advantage of native Lasso features as much as possible.

	<http://gettingreal.37signals.com/ch15_Beware_the_Bloat_Monster.php>

* __Be focused__ - Cover a few main areas where a framework is the most useful, and do it well, Don't try to solve every need.
* __Be helpful__ - Don't get in the way.
* __Follow standards__ - Encourage the use of modern standards-based and semantically correct HTML and CSS for presentation.
* __Encourage a rich user experience__ - Use client side scripting as progressive enhancement to improve user experience and application responsiveness, but do not rely on client side scripting for critical functionality. Use AJAX techniques where really motivated.

What is Knop?
-------------
Knop is mainly two things:

1. A set of custom types that implements the core functionality of the Knop modules.
2. A defined application flow and file structure to support the site's functionality and application logic.

You can choose to only use selected parts of Knop. For example you can use just `knop_form` to handle forms, or you can use just `knop_database` to get a richer database abstraction than what Lasso's native inlines offer. But if you use all of Knop, this is what you get:

* A number of modules implemented as custom types that handle the core functions of the framework.
* A defined structure to handle the logic of a web site, to handle page requests, act on form submissions, and show the resulting page. A Knop site or application is handled through a single control file, similar to the "one-file" structure.
* A defined folder and file structure for the includes needed to handle and support the application logic.
* Support for a modular architecture, where a self contained module can be easily plugged into an existing site.
* Basic templates for HTML and CSS.
* Support for URL handling with virtual (abstracted) URLs.

Knop examples
-------------
Before we get into the details of Knop, let's look at a couple of demonstrations on how Knop can be used. One of the Knop modules is a form generator. `Knop_form` is a custom type, just as the other Knop modules. It is used to create HTML forms and to help process the form submission.

###Example 1 - A Simple Form

This code sample demonstrates how to create and show an HTML form.

	// 1-simple-form.lasso
	// Create a new form object
	// Usually we put this into a Knop config include file
	var('form'=knop_form);
	
	// Add text fields and a submit button
	$form -> addfield(-type='text', -name='firstname', -label='First name');
	$form -> addfield(-type='text', -name='lastname', -label='Last name');
	$form -> addfield(-type='textarea', -name='message', -label='Message');
	$form -> addfield(-type='submit', -name='button_send', -value='Send message');
	
	// Show the form on the page
	<form action="1-simple-form-response.lasso">
	[$form -> renderform]

To take care of the form input, the response page also needs to know about the form, so we first have to define the same form object again (of course we normally define the form object in an include file, but for this demonstration we just repeat the form definition in the response file).

	// 1-simple-form-response.lasso
	// Create the same form object again
	var('form'=knop_form);
	$form -> addfield(-type='text', -name='firstname', -label='First name');
	$form -> addfield(-type='text', -name='lastname', -label='Last name');
	$form -> addfield(-type='textarea', -name='message', -label='Message');
	$form -> addfield(-type='submit', -name='button_send', -value='Send message');
	
	// Load field values from the submission
	$form -> loadfields;
	
	// Look at the fielvalues
	$form -> updatefields;

The output from `$form -> updatefields` is a pair array, and one of the nice things with a pair array is that it can be used as dynamic input in an inline. This is very handy and can be used for example like this:

	// Use the form input in an inline, for example like this:
	inline(-database=...,
		$form -> updatefields,
		-add);
	/inline;

###Example 2 - A Form Talks To A Database

Now we are going to combine two Knop modules to see how they can interact. We will create a database object that the form will interact with. We will also specify an HTML form action in the form object to make it self-contained so a complete HTML form can be rendered easily. Finally we'll hook the database object up to the form object. This is where the fun begins.

In this example we have moved the configuration to an include file so that it can be easily reused and to avoid duplicating code used in the previous form-response model.  We will include this file in this example.

	// 2-form-and-database-config.lasso
	// Create a database object
	var('db'=knop_database(-database='knopdemo', -table='customer', -keyfield='id'));
	
	// Create a form object
	var('form'=knop_form(-formaction='2-form-and-database-response.lasso', -database=$db));
	
	// Add text fields and a submit button
	$form -> addfield(-type='text', -name='firstname', -label='First name');
	$form -> addfield(-type='text', -name='lastname', -label='Last name');
	$form -> addfield(-type='textarea', -name='message', -label='Message');
	$form -> addfield(-type='addbutton', -value='Send message');

Next the input page is a simplified version of Example 1, since we've moved the configuration to an include and made the form object self-contained.

	// 2-form-and-database.lasso
	// Include the database and form objects config
	include('2-form-and-database-config.lasso');
	
	// Show the form on the page, this time the form object is a complete html form
	$form -> renderform;

The response page is really simple. To handle the form submission, Knop requires only a single line of code.

	[
	// 2-form-and-database-response.lasso
	// Configure database and form objects in an include
	include('2-form-and-database-config.lasso');
	
	// Handle the form submission
	$form -> process;
	
	// Show the result
	]
	[$form -> renderhtml(-excludetype='submit')]
	Adding record [$db -> error_msg]

The preceding examples demonstrate a few of the basic principles of some common Knop operations.  In the next section, we'll go deeper into each of the Knop modules and provide more code examples.

Knop modules
------------
The Knop modules are implemented as a number of custom types supported by a few custom tags.  Some of the custom types can interact with each other.

The Knop custom types are described as follows.

###Knop_nav

`Knop_nav` is the heart of a Knop site. It defines the site's structure and navigation. It also keeps track of and validates the visitors current location on a site. It is used to control the application logic of the website or application, keeps track of and processes all include files, generates the navigation menu (a nested ul/li list as default) and breadcrumb, parses the current URL, and generates URLs for site internal href links. `Knop_nav` is the engine room for a site and acts as the main dispatcher for requests and actions.

`Knop_nav` supports both fully virtual URLs (using an atbegin-based URL handler) as well as parameter based URLs for situations where virtual URLs can't be used.

Example of a virtual URL (path based navigation)

`http://myhost.com/mypath/tothe/page/`

Example of a parameter based URL

`http://myhost.com/?mypath/tothe/page/`

The two navigation methods result in URLs that look almost the same, the only difference is the "?" after the hostname. Switching between navigation methods is just a matter of changing a parameter of the navigation object, so it's very easy to deploy a Knop based site regardless of whether it will be hosted on a server that supports virtual URLs.

The visitor's current location is called "path" and the current action (if any) is identified by "actionpath".

* Knop path = "where we are" (the page we are coming to).
* Knop actionpath = "what to do" (the page we came from).

`Knop_nav` can interact with `knop_grid`.

####Example 3 - Knop navigation

The following example demonstrates how to create a `knop_nav` object, add navigation items, then render the navigation to the page.

	// Create the parent nav object.
	var('nav'=knop_nav(-navmethod='param', -currentmarker=' »'));
	
	// Define the site structure
	$nav -> insert(-key='home', -label='Home Page');
	
	// Create a child nav object
	var('subnav'=knop_nav);
	$subnav -> insert(-key='latest', -label='Latest News');
	$subnav -> insert(-key='archive', -label='News Archive');
	
	// Insert the child nav object into its parent nav object
	$nav -> insert(-key='news', -label='News', -children=$subnav);
	
	// Determine current location so the nav object knows where we are
	$nav -> getlocation;
	
	// Generate navigation menu
	$nav -> renderhtml;
	
	// Generate a breadcrumb
	$nav -> renderbreadcrumb;
	]
	<h1>The current page is [$nav -> label]</h1>
	<p>The current framework path is [$nav -> path]</p>

###Knop_database

`Knop_database` is a database abstraction layer that sits on top of Lasso's own database abstraction. It supports both regular Lasso inlines and SQL syntax. MySQL and FileMaker databases are supported currently.

`Knop_database` provides convenient access to basic CRUD operations (Create, Read, Update, Delete) and has built-in support for record locking, safe random keyvalues and duplicate prevention. A found set of records can either be iterated, or Lasso's native records tag can be used to access the found set. `Knop_database` can maintain a persistent pointer to a specific record, much like Active Record.

`Knop_database` primarily uses pair arrays as field specifications (which makes it easy to integrate with standard Lasso inlines) but can also use SQL statements for some of the operations.  When interacting with knop\_form and `knop_grid`, pair arrays are normally used to exchange field data and other search parameters.  The use of pair arrays for standard inlines is one way to provide greater flexibility.

`Knop_database` can interact with `knop_form`, `knop_grid`, and `knop_user` (for record locking).

####Example 4 - Knop database

The following examples demonstrate how to use `knop_database` to output some fields from a specific database record.

	<?LassoScript
	// initiate the database object (normally in a config file)
	var('db_news'=knop_database(-database='acme',
		-table='news',
		-username='*****',
		-password='*****',
		-keyfield='id');
	
	// perform a database search to grab the record (normally in a lib file)
	$db_news -> getrecord(-keyvalue=185);
	
	// show some fields from the database record (normally in a content file)
	?>
	
	<h3>[$db_news -> field('title')]</h3>
	<p>
	[encode_break($db_news -> field('text'))]
	</p>

The getrecord statement in the above snippet can be simplified slightly since the first parameter is the keyvalue.

	// The .  The following statements have equivalent results.
	$db_news -> getrecord(-keyvalue=185);
	$db_news -> getrecord(185);

You can also use SQL statements.

	// Complex SQL queries can be used to get a single record.
	$db_news -> getrecord(-sql='SELECT * FROM news LEFT JOIN ...');
	
	// A general select can be used as well to return multiple records.
	// The data from the first found record will be available as ->field.
	$db_news -> select(-sql='SELECT * FROM news LEFT JOIN ...');

There are multiple methods to output a record listing.

	// 1. A standard records loop (fastest)
	records(-inlinename=($db_news -> inlinename));
		field('title');'<br>';
	/records;
	
	// 2. Iterate the database object
	iterate($db_news, var('record'));
		$record -> field('title');'<br>';
	/iterate;
	
	// 3. Use the record pointer
	while($db -> nextrecord); // increment the record pointer
	// (nextrecord returns true as long as there are more records to show)
	// fetch data from the record the record pointer currently points at
		$db -> field('title');'<br>';
	/while;

###Knop_form

Forms are one of the most tedious things to handle manually in a web application. First the form fields should be shown on the edit page. They need labels, proper styling and different properties. They may also need initial values to show in the form fields. The values can either be static, come from a database lookup, or from a previous submission of the same form if there was an input error that needs to be corrected.  In the latter case, the erroneous fields or labels need some highlighting to guide the user. Finally the form submission must be handled by validating the user's input and then storing the form data in a database.

All these tasks are a perfect target to make things easier for the developer.

First we define the form and give it a form action. Next we add the fields and other elements such as submit buttons that the form should contain. The fields can have the same properties as regular HTML form fields.  They can have additional properties to define the options of a select menu, define the checkbox options of a checkbox field set, define interaction with databases, and other purposes.

Then we populate the form fields with data. It can come from either a form submission or from a database lookup. In the case of a database lookup, the corresponding database field has been declared as a property for each form field.

If we want we can set a template for the form to define how the form should be presented in HTML, or just let it use the default template.

Finally we render the form on the page. We can render the entire form at once, or specific fields at a time.  We can even set different templates for every field to have the flexibility needed to accommodate the form in just about any HTML context.

The form object even generates some javascript for us that will warn the user if he navigates away from a "dirty" page (a page that has unsaved changes), as well as other useful features.

The next step is that the user submits the form. Now the form object makes its second entry by taking care of the form submission. Since all form fields are defined in the form object, it knows where to put each field when we tell it to load data from the form. Since it knows what kind of data is allowed in each field, the form object can validate itself with a single call.

If the validation comes across an input error, the form object prepares to show itself again but this time with the erroneous inputs highlighted.

If the validation passed, the form object comes back to our help once again and provides us with a complete pair array with field name and value pairs (the form fields knew what database fields they correspond to, remember?) which we can feed right into an inline to add or update a database record, or we can get an SQL string that we can put in an SQL statement of our liking.

`Knop_form` can interact with `knop_database`.

See previous Examples 1 and 2 for code samples of `knop_form`.

###Knop_grid

This custom type is used to display record listings with sortable columns, pagination, detail link to edit a record, filtering/quicksearch, and so on. It requires a reference to a `knop_database` object because they are so tightly related. It can highlight the affected record when returning to the listing after adding or editing a record.

We can also give it a reference to a `knop_nav` object, to get the right pagination links and other things. It can also provide a basic "Quicksearch" functionality integrated with the record listing.

Quicksearch and the sort headings generate pair arrays or SQL snippets to interact with `knop_database`. Sort parameters and the quicksearch query is automatically propagated through a `knop_form`, so the same set of records is selected after editing a record.

`Knop_grid` supports the use of simple SQL JOINs.

`Knop_grid` must interact with `knop_database` and can optionally interact with `knop_nav`.

####Example 5 - Knop grid

The following examples demonstrate how to use `knop_grid`.

	// Configuration
	// Create a database object
	var('db'=knop_database(-database='knopdemo', -table='customer', -keyfield='id'));
	
	// Create a grid object
	var('grid'=knop_grid(-database=$db));
	$grid -> addfield(-name='firstname', -label='First Name');
	$grid -> addfield(-name='lastname', -label='Last Name');
	
	// Prepare page output
	// Perform a search
	$db -> select($grid -> sortparams);
	
	// Generate the grid
	$grid -> renderhtml;

This example shows how to use `knop_grid` with MySQL JOIN.  See this thread in the list archive.

[Using knop_grid with JOIN](http://lasso.2283332.n4.nabble.com/grid-with-join-tt3159065.html)

	// Configuration
	// Create a database object
	var('d'=knop_database(-database='mydb', -table='mytable', -keyfield='id'));
	
	// create grid object for the record list
	var('grid')=knop_grid(-database=$d, -nav=$nav);
	
	// add columns to the list
	$grid -> addfield(
		-label=$lang_ui -> firstname,
		-dbfield='users.firstname',
		-template={return(field('firstname'))},
		-name='f',
		-url='admin/users/edit',
		-quicksearch);
	$grid -> addfield(
		-label=$lang_ui -> lastname,
		-dbfield='users.lastname',
		-template={return(field('lastname'))},
		-name='ln',
		-quicksearch,
		-defaultsort);
	$grid -> addfield(
		-label='Group Name',
		-dbfield='groups.name',
		-template={return(field('name'))},
		-name='gn',
		-quicksearch);

	// Prepare page output
	var('sql') = "
	SELECT
		users.id as id,
		users.keyfield as keyfield,
		users.firstname as firstname,
		users.lastname as lastname,
		groups.name as name
	FROM users, groups
	WHERE
		users.group_id = groups.id
	";

	// Perform a search
	// find out the current skiprecords value based on the -page parameter and $maxrecords
	$skiprecords = $grid -> page_skiprecords($maxrecords);

	// build search params
	// first set some basic search parameters
	var('searchparams'=array(
		-maxrecords=$maxrecords,
		-skiprecords=$skiprecords,
		-uselimit));

	if($grid->quicksearch->size);
		$sql += "
		AND ";
		$sql += $grid->quicksearch(-sql,-contains);
	/if;
	
	$sql += $grid->sortparams(-sql);
	
	// get list of records
	$d->select(-sql=$sql, $searchparams);

	// Generate the grid
	$grid -> renderhtml;

###Knop_lang

This custom type handles language strings for multilingual presentation of the user interface. A `knop_lang` object holds the language strings for all supported languages. Strings are stored under a unique text key, but the same key is of course used for the different language versions of the same string.

Language strings can be grouped into different `knop_lang` object instances (variables) for ease of managing them.

When the language of a `knop_lang` object is set, that language is used for all subsequent requests for strings until another language is set. The selected language is shared between all `knop_lang` objects on the same page for that visitor, unless another language has been set specifically for an individual `knop_lang` object.

If no specific language is set on the page, `knop_lang` uses the browser's most preferred language if it's available in the `knop_lang` object, otherwise it defaults to the first language (unless a default language has been set for the `knop_lang` object).

The strings in a `knop_lang` object can contain replacement placeholders which insert dynamic text when retrieving a string. The strings can also be a Lasso compound expression which will be evaluated at runtime when the string is retrieved.

####Example 6 - Knop language

The following examples demonstrate how to use `knop_lang`.

	var('lang_messages'=knop_lang(-default='en'));
	$lang_messages -> addstring(-key='welcome', -value='Welcome to the home page', -language='en');
	$lang_messages -> addstring(-key='welcome', -value='Välkommen till hemsidan', -language='sv');
	$lang_messages -> addstring(-key='loggedin', -value='You are logged in as #1# #2#', -language='en');
	$lang_messages -> addstring(-key='loggedin', -value='Du är inloggad som #1# #2#', -language='sv');
	
	// call
	$lang_messages -> getstring('welcome');
	
	// change language
	$lang_messages -> setlanguage('sv');
	$lang_messages -> welcome;
	
	// call with replacements
	$lang_messages -> getstring(-key='loggedin',
		-replace=array(field('firstname'), field('lastname')));

You can use config files to configure language strings with `-> addlanguage`.

	lang -> addlanguage(-language='en', -strings=map(
		'quicksearch_showall' = 'Show all',
		'quicksearch_search' = 'Search',
		'linktext_edit' = '(edit)',
		'linktitle_showunsorted' = 'Show unsorted',
		'linktitle_changesort' = 'Change sort order to',
		...));

Knop uses `knop_lang` internally to handle text strings. By providing access to the internal lang object that a Knop module uses, it is easy to add custom localizations or modified strings also to the core Knop modules without actually altering Knop itself. As an example if you want to localize an instance of `knop_grid` to another language on the fly, you can first find out what strings that need to be localized by calling $grid -> lang -> keys. This gives you an array of all string keys that are used across all defined languages.

Then you can just add the new language like this (for quasi Danish), since the ->lang member tag returns a reference to the internal `knop_lang` object:

	$grid -> lang -> addlanguage(-language='da', -strings=map(
	'quicksearch_showall' = 'Finn alt',
	'quicksearch_search' = 'Søk',
	...

###Knop_user

The `Knop_user` custom type handles user authentication, maintains information about the user, and keeps track of permissions for the user.

Authenticating a user checks the login credentials against a specified table, with support for one-way encrypted passwords (with salt) and delays between repeated login attempts to prevent brute force attacks. User authentication can also be performed through custom code outside of `knop_user`.

`Knop_user` prevents session sidejacking by comparing a client fingerprint between each page request.

`Knop_user` is the only Knop custom type that is intended to be stored in a session variable, and actually relies on this.

When a user is being authenticated, all available fields from the user table are stored in the `knop_user` variable so user information can be retrieved easily throughout the session. Any additional custom data for the user can also be stored manually in the `knop_user` variable.

`knop_user` can keep track of user permissions by storing arbitrary permission information in the `knop_user` variable. `knop_user` enhances `knop_database` objects by keeping track of record locks set by the user, and releasing record locks, for example, when navigating to a list of records without saving an edited record.

####Example 7 - Knop user

The following example demonstrates how to use `knop_user`.

	var('session_user'=knop_user(-userdb=$users));
	session_start(-name='test');
	session_addvar(-name='test', 'session_user');
	$session_user -> login(-username=action_param('u'), -password=action_param('p'));
	if($session_user -> auth);
		if($session_user -> groups >> 'admin');
			$session_user -> setpermission('candelete');
		/if;
	else;
		'Authentication failed, ' + ($session_user -> error_msg);
		abort;
	/if;
	'Welcome, ' + ($session_user -> firstname) + '! ';
	if($session_user -> getpermission('candelete'));
		'You are allowed to delete records.';
	/if;

Knop file structure
-------------------
A Knop site is built around a single file (for example index.lasso) that acts as a "control center" or main dispatcher, similar to the "Onefile" concept. The main files are of the following types:

* Config - (page specific configuration) configures the request handler, configures the business logic
* Action - request handler, manipulates data
* Library - user interface logic, prepares information to display to the user
* Content - display the information to the user

Files are named with a prefix that tells what kind of file it is (`cfg_`, `act_`, `lib_`, and `cnt_`), then the Knop path with forward slashes ("/") replaced by underscores ("\_"). A few special files are named with a double underscore after the prefix. Files are grouped by their type into folders named `_config`, `_action`, `_library`, and `_content`.

Example file structure:

	_config/
		cfg__global.inc
		cfg__nav.inc
		cfg_customer_edit.inc
		cfg_customer_list.inc
		cfg_news_archive.inc
		cfg_news_latest.inc
	_action/
		act_customer_edit.inc
		act_customer_list.inc
		act_news_archive.inc
		act_news_latest.inc
	_library/
		lib_customer_edit.inc
		lib_customer_list.inc
		lib_news_archive.inc
		lib_news_latest.inc
	_content/
		cnt_customer_edit.inc
		cnt_customer_list.inc
		cnt_news_archive.inc
		cnt_news_latest.inc
	index.lasso

Knop application flow
---------------------
To explain the application flow of Knop, let's assume we have a web application where the user submits a form and we will walk through the processing of the form submission.  Please refer to the diagram.

![Knop application flow diagram](https://github.com/knop-project/knop/raw/master/docs/img/knop_application_flow_diagram.png)

Every page request has one or two vital parameters:

* path (required)
	
	This is the visitor's current location in the application. The path tells the application "where we are".

* actionpath (optional)
	
	If the current page request is the result of a form submission, the application needs to know what to do with the input. The actionpath tells the application "what do to".

	Don't confuse the actionpath with the "action" HTML attribute of the form tag itself!

###Loading a form for editing or adding a record

When a form is first loaded, Knop loads the files for the path in the order of config, library, then content.  (This is indicated in the diagram by the region below the dashed line.)  The config file contains the definition of the form object and its fields, as well as any validation rules.  The library file executes logic to either generate a keyfield value for adding a new record or load an existing record.  Finally the page template is included—inserting  navigation menus, sidebars, and content from the content file—and the result is displayed to the user.

###Handle a form submission

Steps 1 - 4 are represented in the diagram by the region above the dashed line, and steps 5 - 8 below the dashed line.

1. Determine the __path__ and __actionpath__.  The actionpath is where the submission comes from and is defined by `knop_nav -> getlocation`.
2. Load the __config__ for actionpath.  The config file defines the form, its fields, and validation rules, of the page we came from. This is critical in order to handle the form submission.
3. Perform the actual __action__ by loading form data, validating input, and executing the logic needed in response to the form submission.
4. Was the action successful, in other words was the form validation OK, the database action performed without errors, and any other customizations.
	
	__Yes:__ Proceed to Step 5.
	
	__No:__ Set the "path" to "actionpath", reusing the config from Step 2 (config does not need to load again), and for showing the form again.  Skip to Step 6.

5. Load the __config__ for "path" to define which form, grid, or custom object to display.
6. Execute the __library__ file for "path" to prepare the page output.
7. Include the page template to build the page's HTML with navigation menu, content area, sidebars, and other objects.
8. The template includes the __content__ for "path" to generate the actual page content.
9. The finished page is served to browser.

All the include files that are needed to handle the application flow are chosen automatically by `knop_nav`.

Other Knop Features
-------------------
###Debugging

All Knop modules can log debug information internally using the method `->trace`.  The module's trace can be output to reveal what is happening, e.g. `[$nav->trace(-html)]`.

In addition Knop provides integration with [L-Debug](http://www.l-debug.org/), a Lasso debugging tool created and maintained by Ke Carlton.  L-Debug has two versions, one each for Lasso 8 and 9, just like Knop.  See the documentation for each version of Knop for installation instructions.

* [Knop for Lasso 8.x](../knop8/INSTALL.md#install-l-debug)
* [Knop for Lasso 9.x](../knop9/INSTALL.md#install-l-debug)

###Caching

Caching can be used to reduce the overhead from any configuration that is mostly static, used globally, and normally doesn't change, such as navigation, database objects, and language strings.  Configuring all of this repeatedly on every page load is a waste of resources.

`knop_cachestore` stores all page variables of the specified type in a global variable. It does this by iterating through all page variables and checking their type, then copying the variables that have a matching type. This way the cache is populated mostly automatically and transparently. There is almost nothing to configure and it just works. `knop_cachefetch` tries to recreate all the cached page variables of the specified type from the global variable, if there's a cached version available. It returns `true` if it was successful and `false` if there wasn't a cached copy available. If there wasn't a cache available, no page variables are created and the configuration needs to be set up from scratch. This is easy to do by using `knop_cachefetch` in a condition around the normal configuration.

The idea is to call `knop_cachefetch` first to try to have all knop object instances recreated as page variables, and if `knop_cachefetch` returns `false`, then configure the knop objects the normal way, and call `knop_cachestore` to cache them for the next page load.

The default cache expiration is 10 minutes (600 seconds). This means that instead of setting up the configuration repeatedly for every single page load for every user, the configuration only needs to be loaded once every 10 minutes by a single user for the benefit of all others.

Here are some timing examples to indicate how much `knop_cache` can help:

Without caching:

* Created langauge strings 23 ms
* Created database objects 73 ms
* Created navigation 142 ms

With caching:

* Created langauge strings 5 ms
* Created database objects 8 ms
* Created navigation 7 ms

The cache can be forced to refresh simply by adding a condition to cache_fetch:

	if($cache_refresh || ! knop_cachefetch(-type='knop_database'));

If `$cache_refresh` is `true` in this example, then the cache will be ignored and the configuration will be set up again.

The caching can also be done per visitor by specifying a session name to use for cache storage. The specified session must be started before using the `knop_cache` tags with session. `knop_cachestore` adds the session variable `$_knop_cache` to the session. Using session to store the cached data is useful, for example, for navigation, where the configuration can be different for each visitor.

####Example 8 - Knop cache

	if(!knop_cachefetch(-type='knop_nav', -session=$session_name));
		var('nav'=knop_nav(
			-default=($lang_nav_key -> hem),
			-root=$siteroot,
			-navmethod=$navmethod));
		$nav -> insert(-key=($lang_nav_key -> hem),
			-label=($lang_nav_label -> hem),
			-url='/');
			knop_cachestore(-type='knop_nav', -expires=1200, -session=$session_name);
	/if;

The global variable used for caching is named uniquely for the current site (based on `server_name` and `response_localpath - response_filepath`).  It's also possible to specify a `-name` to further isolate the cache storage, if needed (for example if multiple sites are running in the same virtual root and hostname). The global variable is accessed using thread locking to provide a thread safe caching mechanism.

###Multiple Ways To Work With Site Modules

Knop's framework folder structure is actually quite liberal. It lets you collect all files in a `_knop` directory to be able to centralize modules so they can be shared between different sites. It also lets you modularize parts of a solution in separate `_mod` directories.

The defined Knop directory tree consists of folders with the names `_knop`, `_config`, `_action`, `_library`, `_content`, or with names that begin with `_mod_`.

Knop looks for framework include files in no less than ten locations for each file naming convention you specify using the `-filenaming` parameter for the `knop_nav->oncreate` method. For the framework path `customer/edit`, the actual name and location of the library file can be any of the following.

####A) `-filenaming='prefix'` (default if `-filenaming` is not specified)

	1. _mod_customer/lib_customer_edit.inc	// modular prefixed with module name
	2. _mod_customer/lib_edit.inc			// modular
	3. _mod_customer/_library/lib_customer_edit.inc	 // modular separated, prefixed with module name
	4. _mod_customer/_library/lib_edit.inc	// modular separated
	5. _library/lib_customer_edit.inc		// collective ("all modules together") separated
	
	6. _knop/_mod_customer/lib_customer_edit.inc
	7. _knop/_mod_customer/lib_edit.inc
	8. _knop/_mod_customer/_library/lib_customer_edit.incname
	9. _knop/_mod_customer/_library/lib_edit.inc
	10. _knop/_library/lib_customer_edit.inc

####B) `-filenaming ='suffix'`

	_library/customer_edit_lib.inc

####C) `-filenaming='extension'`
	_library/customer_edit.lib

###Knop And MVC

Knop translates to the Model-View-Controller pattern in the following way:

__Model__

The domain-specific representation of the information on which the application operates

* Config and Library, together with a database

__View__

Renders the model into a form suitable for interaction, typically a user interface element

* Content

__Controller__

Processes and responds to events, typically user actions, and may invoke changes on the model

* Config and Action

Why "Knop"?
-----------
"Knop" is Swedish for knot, and a knot is what keeps a lasso together. A good knot makes a good lasso experience.

The meaning is the same as English knot, which is both used for the speed of boats or airplanes (one nautical mile, or 1852 meters, per hour), or a knot on a rope. The speed measurement comes from the rope knot meaning, where they measured how many knots on a rope passed in a given time when they measured the speed of ships in the old days.

The word stems from the Dutch word _knoop_ with the same meaning, which is also related to _knopp_ (knob in English).

Knop is pronounced "kuh-NOOP" with a sounding "k" and a long "o" just as in groove.

Credits
-------
Greg Willits' PageBlocks manual has been a valuable inspiration when specifying some of the components of Knop.

Johan Sölve of Montania System AB created and developed Knop into a mature and stable web application framework.

Jolle Carlestam and Tim Taplin wrote major portions of Knop to run on Lasso 9.

Steve Piercy wrote documentation and migrated the Knop Project to GitHub.

From the folks at LassoSoft: Jono Guthrie and Kyle Jessup for collaborating with the Knop Project to improve Lasso, and thus Knop; Sean Stephens for listening and responding to our concerns; and Rachel Guthrie for steadfast encouragement and support.

License
-------
The majority of the code in Knop is supplied under this license:

Apache License, Version 2.0

<http://www.apache.org/licenses/LICENSE-2.0.html>

The documentation portion of Knop (the rendered contents of the "docs" directory of a software distribution or checkout) is supplied under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License as described by <http://creativecommons.org/licenses/by-nc-sa/3.0/us/>

Copyright notice
----------------
Copyright 2012 Knop Project

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
