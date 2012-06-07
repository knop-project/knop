<?LassoScript

	// find out the current skiprecords value based on the -page parameter and $maxrecords
	$skiprecords = $list -> page_skiprecords($maxrecords);

	// build search params
	// first set some basic search parameters
	var('searchparams'=array(-maxrecords=$maxrecords, -skiprecords=$skiprecords, -uselimit));

	// then add sort parameters, if any
	$searchparams -> merge($list -> sortparams);

	// then add search parameters, if any
	$searchparams -> merge($list -> quicksearch);
	
	// get list of records
	$d -> select($searchparams);



	// clear any record locks 
	$s_user -> clearlocks;

?>
