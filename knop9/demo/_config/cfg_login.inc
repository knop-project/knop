<?LassoScript

// Create login form

var( 'loginform'=knop_form( 
			-formaction=($nav -> url), // real URL path
			-method='post', 
			-actionpath=($nav -> path),	// framework action path
			-legend=$lang_ui -> login));
			
$loginform -> addfield( -name='username', -label=$lang_ui -> username, -type='text', -focus);
$loginform -> addfield( -name='password', -label=$lang_ui -> password, -type='password');
$loginform -> addfield( -name='button_login', -type='submit', -value=$lang_ui -> login);


?>
