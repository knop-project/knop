<?LassoScript
/*
	This file allows the developer to select and reload knop types through a web browser.

	CHANGE NOTES

	2012-06-07	SP	Split Knop type loader into LassoApp and web root versions.
	2012-06-07	JC	Enhanced the knop_base preload check and moved it to load inside the protect block.
	2012-06-07	SP	HTML wrapping and check to see if knop_base was preloaded. If not load it.
	2012-05-18	JC	Initial release as help for Steve.
*/

// reload types

local(basepath = '/lasso9/knop9/')

local(message = array)
// load knop_base if it is not selected
local(reloadarray = action_param('reloadfile') -> split('\r'))

#reloadarray->size > 0
	&& #reloadarray !>> 'knop_base.lasso'
	&& !(::knop_base -> istype)
? #reloadarray -> insertfirst('knop_base.lasso')

iterate(#reloadarray) => {
	protect => {
		handle_error => {
			#message -> insert('failed reloading ' + loop_value + '. Error: ' + error_msg)
		}
		lassoapp_include_current('/'+loop_value->trim&)
		error_code == 0 ? #message -> insert('Reloaded ' + loop_value)
	}
}
if(#message -> size > 0)
	'<p style="background-color:LawnGreen">'
	#message -> join('<br>')
	'</p>'
/if
?><!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<title>Knop Type Loader - LassoApp version</title>
</head>
<body>
<p>
This file allows the developer to select and reload Knop types through a web browser.
</p>
<hr>
<form method="post" action="">
	<label id="knop_base_label" for="knop_base"><input type="checkbox" id="knop_base" value="knop_base.lasso" name="reloadfile"> Knop Base (must be loaded before all other Knop types)</label>
<br>
	<label id="knop_cache_label" for="knop_cache"><input type="checkbox" id="knop_cache" value="knop_cache.lasso" name="reloadfile"> Knop Cache</label>
<br>
	<label id="knop_database_label" for="knop_database"><input type="checkbox" id="knop_database" value="knop_database.lasso" name="reloadfile"> Knop Database</label>
<br>
	<label id="knop_form_label" for="knop_form"><input type="checkbox" id="knop_form" value="knop_form.lasso" name="reloadfile"> Knop Form</label>
<br>
	<label id="knop_grid_label" for="knop_grid"><input type="checkbox" id="knop_grid" value="knop_grid.lasso" name="reloadfile"> Knop Grid</label>
<br>
	<label id="knop_lang_label" for="knop_lang"><input type="checkbox" id="knop_lang" value="knop_lang.lasso" name="reloadfile"> Knop Lang</label>
<br>
	<label id="knop_nav_label" for="knop_nav"><input type="checkbox" id="knop_nav" value="knop_nav.lasso" name="reloadfile"> Knop Nav</label>
<br>
	<label id="knop_nav_label" for="knop_nav"><input type="checkbox" id="knop_nav" value="knop_user.lasso" name="reloadfile"> Knop User</label>
<br>
	<label id="knop_nav_label" for="knop_nav"><input type="checkbox" id="knop_nav" value="knop_utils.lasso" name="reloadfile"> Knop Utils</label>
<br>

	<br>
	<input type="submit" value="Reload" name="button_save">
</form>
</body>
</html>