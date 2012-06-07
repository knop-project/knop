<?LassoScript

// create grid object for records list
var('list'=knop_grid(
		-database=$d,
		-nav=$nav));

// add columns to the list
$list -> addfield(
		-label='First name',
		-dbfield='firstname',
		-name='f',
		-url='customer/edit',
		-width=150);
$list -> addfield(
		-label='Last name',
		-name='lastname',
		-width=150);
$list -> addfield(
		-label='E-mail',
		-name='email',
		-width=150);

?>
