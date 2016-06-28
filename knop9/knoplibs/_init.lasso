[
	/* =====================================================
	Pull in core methods
	This is done in-order so if you wish to load any before others then shuffle the order of the array as desired.
	===================================================== */
	local(coremethods = array(
			'debug.type.lasso',
			'knop_utils.lasso',
			'knop_base.lasso',
			'knop_cache.lasso',
			'knop_lang.lasso',
			'knop_database.lasso',
			'knop_form.lasso',
			'knop_grid.lasso',
			'knop_nav.lasso',
			'knop_user.lasso'
		)
	)

	// (not lasso_tagExists('debug')) ? #coremethods -> insertfirst('debug.type.lasso')
	// Courtesy of Ke Carlton, www.l-debug.org. L-Debug for Lasso 9 All rights reserved — K Carlton 2011-2013

	with file in #coremethods do protect => {
		local(s) = micros
		handle => {
			stdoutnl(
				error_msg + ' (' + ((micros - #s) * 0.000001)->asstring(-precision=3) + ' seconds)'
			)
		}
	
		stdout('\t' + #file + ' - ')

		web_request
		? library(include_path + #file)
		| lassoapp_include(#file)
	
	}	

]