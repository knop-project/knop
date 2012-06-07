<?LassoScript

if($s_user -> auth);
	// log out the user
	$s_user -> logout;
	$message -> insert($lang_ui -> youhaveloggedout);
	
	// reload navigation to prevent access to privileged pages
	$nav -> include('_config/cfg__nav.inc');
/if;


?>
