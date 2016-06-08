<?LassoScript
/*
	Ajax target page for the Knop Framework admin section

	CHANGE NOTES

	2012-06-25	JC	Initial release.
*/

auth_admin

match(web_request -> param('-action')) => {
	case('reload')
		local(page_content = lassoapp_include('_inc/reload.inc'))
	case('help')
		local(page_content = lassoapp_include('_inc/help.inc'))
	case
		local(page_content = 'The requested action was not understood')
}
#page_content
?>