<?LassoScript

// create grid object for the record list
var: 'list'=(knop_grid: 
		-database=$d, 
		-nav=$nav, 
		-quicksearch=$lang_ui -> name,
		-langobject=$lang_ui,
		-language=$s_lang,
		-numbered);

// add columns to the list
$list -> (addfield: 
		-label=$lang_ui -> firstname, 
		-dbfield='firstname', 
		-name='f', 
		-url='advanced/edit', 
		-width=150, 
		-quicksearch, 
		-defaultsort);
$list -> (addfield: 
		-label=$lang_ui -> lastname, 
		-dbfield='lastname', 
		-name='l', 
		-width=150, 
		-quicksearch);
$list -> (addfield: 
		-label=$lang_ui -> email,
		-name='email', 
		-url='mailto:#value#',
		-width=150,
		-nosort);
$list -> (addfield: 
		-label=$lang_ui -> active, 
		-name='enabled', 
		-width=80, 
		-template=(map: 
			1='<span style="color: green;">' + $lang_ui -> yes + '</span>', 
			-default='<span style="color: red;">&bull;</span>'));
$list -> (addfield: 
		-label='Compound', 
		-name='enabled', 
		-width=150, 
		-template={return: (date: (field: 'moddate')) -> (format: $lang_ui -> dateformat_short)});

?>
