<?LassoScript
/*
	Help file to reload selected knop types. Useful while editing type code

	CHANGE NOTES

	2012-06-07	JC	Enhanced the knop_base preloaded check and moved it to load inside the protect block.
	2012-06-07	SP	HTML wrapping and check to see if knop_base was preloaded. If not load it.
	2012-05-18	JC	Initial release as help for Steve.
*/

// reload of types

local(message = array('Called ' + date))
local(reloadarray = string(web_request -> param('reloadfile', '\r')))
#reloadarray -> replace('\r\n','\r')
#reloadarray -> replace('\n','\r');
#reloadarray = #reloadarray -> split('\r')

// load knop_base if it is not selected
#reloadarray->size > 0
	&& #reloadarray !>> 'knop_base.lasso'
	&& !(::knop_base -> istype)
? #reloadarray -> insertfirst('knop_base.lasso')

with reloaditem in #reloadarray do => {
	protect => {
		handle_error => {
			#message -> insert('failed reloading ' + #reloaditem + '. Error: ' + error_msg)
		}
		lassoapp_include_current('/'+ #reloaditem -> trim&)
		error_code == 0 ? #message -> insert('Reloaded ' + #reloaditem)
	}
}
if(#message -> size > 0)
	#message -> join('<br>')
/if
?>
