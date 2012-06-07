[
log_critical('Knop urlhandler_atbegin.lasso handler loading');
	protect;
	/*
		atbegin handler for URL design
		
	If /_urlhandler.lasso exists at the site root it will be executed, otherwise nothing special happens
	*/
	define_atbegin(
		{		 
			if(file_exists('/_urlhandler.lasso'));
				namespace_using('_page_'); // force normal page context
					include('/_urlhandler.lasso');
			/namespace_using;
		/if;
		// continue normal page execution
		}
	);

	handle_error;
		log_critical('Knop atbegin handler error ' + error_msg);
	/handle_error;
	/protect;
log_critical('Knop atbegin handler loaded');
]