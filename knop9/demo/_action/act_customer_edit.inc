<?LassoScript

	// process form 
	// "the easy way"
	
	$f -> process;
	if( $f -> error_code);
		// remain on the same path to show form again
		$nav -> setlocation( $nav -> actionpath);
		
		// show error message
		$message -> insert( $f -> error_msg + ' ' + $f -> error_code);
	/if;

?>
