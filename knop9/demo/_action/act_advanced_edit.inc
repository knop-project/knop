<?LassoScript

	// process form
	// "the more complicated way"

	// first load field data from form submission
	$f -> loadfields;

$trace -> insert($f -> updatefields);

	if( $f -> getbutton == 'cancel');
		// do nothing
	else( $f -> getbutton == 'save' && $f -> isvalid);

		$d -> saverecord( -fields=($f -> updatefields),
			-lockvalue=($f -> lockvalue),
			-user=$s_user);

	else( $f -> getbutton == 'add' && $f -> isvalid);

		$d -> addrecord( -fields=($f -> updatefields),
			-keyvalue=($f -> keyvalue));

	else( $f -> getbutton == 'delete');

		$d -> deleterecord( -lockvalue=($f -> lockvalue),
			-user=$s_user);

	/if;

	if(( !($f -> isvalid) || $f -> error_code)
		&& ($f -> getbutton == 'add' || $f -> getbutton == 'save'));
		// remain on the same path to show form again
		$nav -> setlocation( $nav -> actionpath);
		// show error message
		$message -> insert( $f -> error_msg + ' ' + $f -> error_code);
	/if;

	if( $d -> error_code);
		$message -> insert($d -> error_msg + ' ' + $d -> error_code);
		if( $d -> error_data);
		    $message -> insert($d -> error_data);
		/if;
	/if;
?>
