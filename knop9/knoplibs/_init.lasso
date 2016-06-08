[
	/* =====================================================
	Pull in core methods
	This is done in-order so if you wish to load any before others then shuffle the order of the array as desired.
	===================================================== */
	local(coremethods = array(
//			'debug.type',
			'knop_utils',
			'knop_base',
			'knop_cache',
			'knop_lang',
			'knop_database',
			'knop_form',
			'knop_grid',
			'knop_nav',
			'knop_user'
		)
	)

	(not lasso_tagExists('debug')) ? #coremethods -> insertfirst('debug.type')
	// Courtesy of Ke Carlton, www.l-debug.org. L-Debug for Lasso 9 All rights reserved — K Carlton 2011-2013

	with i in #coremethods do => {
		protect => {
			handle_error => {
				log_critical('Load failure on ' + #i + ' ' + error_msg)
			}
			log_critical('Prepping to load ' + #i)
			lassoapp_include(#i+'.lasso')
			log_critical('Done with ' + #i)
		}
	}

	error_reset

]