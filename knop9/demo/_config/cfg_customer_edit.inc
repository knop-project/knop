<?LassoScript

	// create form object
	var('f'=knop_form(
			-formaction=$nav -> url('customer'), // action attribute for the html form
			-method='post',
			-database=$d,
			-actionpath=('customer/edit'),	// framework action path
			-legend='Edit customer',
			-fieldset));

	// add form fields
	$f -> addfield(
			-type='text',
			-name='firstname',
			-dbfield='firstname',
			-label='First Name',
			-size=40);
	$f -> addfield(
			-type='text',
			-name='lastname',
			-label='Last Name',
			-required,
			-size=40);
	$f -> addfield(
			-type='text',
			-name='email',
			-label='E-mail',
			-size=40);
	$f -> addfield(
			-type='password',
			-name='password',
			-label='Password');
	$f -> addfield(
			-type='select',
			-size=1,
			-name='enabled',
			-options=array('-optgroup'='First', 1='Active', 2='Disabled', 3='yada'),
			-nowarning);

	// add form buttons
	$f -> addfield(
			-type='savebutton',
			-value='Save',
			-class='button first');
	$f -> addfield(
			-type='deletebutton',
			-value='Delete',
			-confirmmessage='Do you really want to delete this customer?',
			-class='button');
	$f -> addfield(
			-type='cancelbutton',
			-value='Cancel',
			-class='button');

$trace -> insert($f -> 'actionpath');

?>
