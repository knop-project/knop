<?LassoScript

	// find out the current skiprecords value based on the -page parameter and $maxrecords
	$skiprecords = $list -> page_skiprecords($maxrecords);

	// build search params
	// first set some basic search parameters
	var( 'searchparams'=array( -maxrecords=$maxrecords, -skiprecords=$skiprecords));

    // use -uselimit only for non-filemaker data sources
    !$d->'isfilemaker' ? $searchparams->insert(-uselimit);

	// then add sort parameters, if any
	$searchparams -> merge($list -> sortparams);

	// then add search parameters, if any
	$searchparams -> merge($list -> quicksearch);


	// get list of records
	$d -> select($searchparams);
	
	
	// check if the -page value was out of bounds
	if( $list -> page > $list -> lastpage);
		// skiprecords too big, search again with corrected skip value
		// calculate last page
		$list -> 'page' = $list -> lastpage;
		$skiprecords = $list -> page_skiprecords($maxrecords);
		$searchparams -> removeall(-skiprecords) & insert( -skiprecords=$skiprecords);
		$d -> select($searchparams);
	/if;



	// clear any record locks
	$s_user -> clearlocks;


?>
