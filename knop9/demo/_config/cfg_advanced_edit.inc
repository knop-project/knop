<?LassoScript

	// initiate empty array to hold options for select field
	var( 'options'=array);

	// create form object
	var( 'f'=knop_form(
			-formaction=($nav -> url( 'advanced')), // action attribute for the html form
			-method='post',
			-database=$d,
			-actionpath='advanced/edit',	// framework action path
			-legend=$lang_ui -> editcustomer,
			-unsavedmarker='dirtymarker',
			-unsavedwarning=$lang_ui -> unsavedwarning,
			-entersubmitblock));

	// add form fields
	$f -> addfield(
			-type='text',
			-name='f',
			-dbfield='firstname',
			-label=$lang_ui -> firstname,
			-hint=$lang_ui -> specifyaname,
			-size=40,
			-focus);
	$f -> addfield(
			-type='text',
			-name='lastname',
			-label=$lang_ui -> lastname,
			-required,
			-size=40);
	$f -> addfield(
			-type='password',
			-name='password',
			-label=$lang_ui -> password);

	$f -> addfield(
			-type='legend', // creates a fieldset as well
			-value=$lang_ui -> settings);
	$f -> addfield(
			-type='checkbox',
			-name='enabled',
			-options=array( 1=$lang_ui -> active),
			-nowarning);
	$f -> addfield(
			-type='select',
			-size=5,
			-name='email',
			-label=$lang_ui -> mailcheck,
			-options=$options,
			-default=$lang_ui -> chooseone,
			-linebreak,
			-raw='style="width: 200px"');
	$f -> addfield(
			-type='fieldset',
			-value=false); // fieldset with value false closes the current fieldset

	// Create a div that will highlight when the form has unsaved changes
	$f -> addfield(
			-type='html',
			-value='<div id="dirtymarker">');

	// add form buttons
	$f -> addfield(
			-type='savebutton',
			-value=$lang_buttons -> save,
			-class='button first');
	$f -> addfield(
			-type='deletebutton',
			-value=$lang_buttons -> delete,
			-confirmmessage=$lang_ui -> confirmdeletecustomer,
			-class='button');
	$f -> addfield(
			-type='cancelbutton',
			-value=$lang_buttons -> cancel,
			-class='button');
	$f -> addfield(
			-type='reset',
			-value=$lang_buttons -> reset,
			-confirmmessage=$lang_ui -> confirmresetform,
			-class='button');

	$f -> addfield(
			-type='html',
			-value='<br></div>');

// fill options array afterwords, just to demonstrate that the form field will be updated automatically since options are stored as reference in the form field.
$options -> merge(array( '-optgroup'=$lang_ui -> somethings, 1=$lang_ui -> option1, 2=$lang_ui -> option2, 3=$lang_ui -> option3));


?>
