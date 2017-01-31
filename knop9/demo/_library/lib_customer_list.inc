<?LassoScript

	// find out the current skiprecords value based on the -page parameter and $maxrecords
	$skiprecords = $list -> page_skiprecords($maxrecords);

	// build search params
	// first set some basic search parameters
	var('searchparams'=array(-maxrecords=$maxrecords, -skiprecords=$skiprecords));

    // use -uselimit only for non-filemaker data sources
    !$d->'isfilemaker' ? $searchparams->insert(-uselimit);

	// then add sort parameters, if any
	$searchparams -> merge($list -> sortparams);

	// then add search parameters, if any
	$searchparams -> merge($list -> quicksearch);
	
	// get list of records
	$d -> select(-search=$searchparams);



	// clear any record locks 
	$s_user -> clearlocks;

?>
