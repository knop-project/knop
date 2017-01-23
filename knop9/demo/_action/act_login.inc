<?LassoScript


// load the field values from the form submission into the form
$loginform -> loadfields;


// authenticate the user
$s_user -> login(-username=($loginform -> getvalue('username')),
	-password=($loginform -> getvalue('password')));

// check if authentication was successful
if($s_user -> auth);
	// reload navigation to be able to access privileged pages
	$nav -> include('_config/cfg__nav.inc');
else;
	$message -> insert($lang_ui -> authfailed);
/if;

?>
