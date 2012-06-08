[
	/* =====================================================
	Pull in core methods
	This is done in-order so if you wish to load any before others then shuffle the order of the array as desired.
	===================================================== */
	local(coremethods = array(
			'knop_base',
			'knop_cache',
			'knop_database',
			'knop_form',
			'knop_grid',
			'knop_lang',
			'knop_nav',
			'knop_user',
			'knop_utils'
		)
	)
	with i in #coremethods do => { lassoapp_include(#i+'.lasso')  }
]