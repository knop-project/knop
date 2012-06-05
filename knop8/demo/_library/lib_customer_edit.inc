<?LassoScript

// initiate form to capture keyvalue, set formmode etc. 
if: $f -> error_code == 0; // there was no error in the action
	$f -> (init: -keyvalue=($nav -> (getargs: 1)));
/if;

if: $f -> error_code == 0 && $f -> formmode == 'edit';
	// an existing record is requested, load field data from database
	$d -> getrecord( ($f -> keyvalue));
	$f -> (loadfields: -database);	
	
else;
	// load field data from form
	$f -> loadfields;

	if: $f -> formmode == 'add';
		// modify form buttons since the form will be used to add a new record
		$f -> (addfield: 
				-type='addbutton', 
				-value=$lang_ui -> createnew,
				-class='button first', 
				-after='button_save');
		$f -> (removefield: -name='button_save');
		$f -> (setformat: -legend = $lang_ui -> createnewcustomer);
	/if;
/if;


?>
