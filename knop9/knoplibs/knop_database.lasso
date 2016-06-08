<?Lasso
//log_critical('loading knop_database from LassoApp')

/**!
knop_database
Custom type to interact with databases. Supports both MySQL and FileMaker datasources
Lasso 9 version
**/
define knop_database => type {
	/*

	CHANGE NOTES

	2013-06-21	JC	Added method clearlock. Will remove the lock only for the requested record. Requires a lockvalue and a valid user.
	2012-05-02	JC	Changed date type calls to use Lasso 9 style format or asdecimal. Will speed processing up
	2013-03-21	JC	Changed remaining iterate to query
	2013-03-21	JC	Making sure that capturesearchvars run on the first resultset when called using select
	2012-12-10	JC	Bug fix, making sure maxrecords is always an integer even when fed all or 'all'
	2012-07-02	JC	Replaced all old style if, inline and loop with code blocks
	2012-07-02	JC	Commented out method varname to be used from knop_base instead
	2012-07-02	JC	Fixed erroneous handling of addlock and clearlocks
	2012-06-22	JC	Fixed bug that would allow capturesearchvars to populate lockfield values despite the lock being obsolete
	2012-01-19	JC	Fixing bug in regards to keyfield in saverecord and getrecord
	2012-01-15	JC	Added support for -host param in inlines
	2011-12-22	JC	Fixing bug when calling user as knop_user object
	2011-09-05	JC	Changed encode_sql to knop_encodesql_full for LIKE queries
	2011-01-27	JC	Added support for L-Debug debug
	2011-01-27	JC	Added support for affected_count. Will return the number of rows an sql update or delete affects
	2010-10-25	JC	Change in handling of keyfield to deal with Lasso 9 inline treatment
	2010-08-03	JC	All calls implemented and tested. Except trace that need to wait for debug code to be implemented
	2010-08-02	JC	Changed all regexp to use Lasso 9 adjusted expression
	2010-07-30	JC	All tags rewritten for Lasso 9 and no syntax errors on initialization
	2010-07-28	JC	Started on first version written directly for for Lasso 9

	TODO
	Test with different versions of calls. Like -keyfield etc
	Read up on how to use traits
	Keep a check on that the tweaked version of inline code either is implemented by Kyle or becomes a part of this distribution
	field_names(-type) will not work pending that support is created by Kyle (2010-09-23)
	*/

	parent knop_base

	data public version = '2012-05-02'

	data public description::string = 'Custom type to interact with databases. Supports both MySQL and FileMaker datasources'

	// instance variables
	// these variables are set once
	data public database::string = string
	data public table::string = string
//	data public table_realname::string = string 	// table aliases are no longer supported
	data private username::string = string
	data private password::string = string
	data private db_connect::array = array
	data private host::array = array
	data public datasource_name::string = string
	data public isfilemaker::boolean = false
	data public lock_expires::integer = 1800 	// seconds before a record lock expires
	data public lock_seed::string		 		// encryption seed for the record lock
//	data error_lang::knop_lang = knop_lang( -default = 'en', -fallback)
	data public user::any = string					// knop_user that will be used for record locking
	data public databaserows_map::map = map		// map to hold databaserows for each inlinename

	// Lasso 9 specific
	data private db_registry

	// these variables are set for each query
	data public inlinename::string = string 			// the inlinename that holds the result of the latest db operation
	data public keyfield::string = string
	data public keyvalue::string = ''
	data public affectedrecord_keyvalue::string = '' 	// keyvalue of last added or updated record (not reset by other db actions)
	data public lockfield::string = string
	data public lockvalue::string = ''
	data public lockvalue_encrypted::string = ''
	data public timestampfield::string = string 		// for optimistic locking
	data public timestampvalue::string = string
	data public searchparams::array = array 		// the resulting pair array used in the database action
	data public querytime::integer = integer 			// query time in ms
	data public recorddata::map = map 				// for single record results, a map of all returned db fields
	data public error_data::map = map 				// additional data for certain errors
	data public message::string = string 			// user message for normal result
	data public current_record::integer = integer 		// index of the current record to get field values from a specific record
	data public field_names_map::map = map
	data public resultset_count_map::map = map 		// resultset_count stored for each inlinename


	// these vars have directly corresponding Lasso tags
	data public action_statement::string = string
	data public found_count::integer = integer
	data public shown_first::integer = integer
	data public shown_last::integer = integer
	data public shown_count::integer = integer
	data public field_names::array = array
	data public records_array::staticarray = staticarray
	data public maxrecords_value::any = 50
	data public skiprecords_value::integer = 0

	data public errors_error_data::map = map(7010, 7012, 7013, 7016, 7018, 7019) 				// these error codes can have more info in error_data map

	// these vars doesn't have directly corresponding Lasso tags but should have...
	data public affected_count::integer = 0

/**!

**/
	public oncreate(
		database::string,
		table::string,
		host::array = array,
		username::string = '',
		password::string = '',
		keyfield::string = 'keyfield',
		lockfield::string = 'lockfield',
		user::any = '',
		validate::boolean = false	// validate the database connection info (adds the overhead of making a test connection to the database)
	) => {
//debug => {

		// conserve error
		error_push
		handle => { error_pop }

		// store params as instance variables
		.'database' = #database
		.'table' = #table
		.'host' = #host
		.'username' = #username
		.'password' = #password
		.'keyfield' = #keyfield
		.'lockfield' = #lockfield
		.'user' = #user

		.'lock_seed' = knop_seed
		.'db_registry' = database_registry
		local(dbhost = .'db_registry' -> getDatabaseHost( #database))

		#dbhost -> size > 0 ?
			.'datasource_name' = #dbhost -> find('datasource_name')

		// validate database name to make sure it exists in Lasso
		if(#validate) => {
			fail_if(.'datasource_name' -> size == 0, 1010, 'No Datasource Module for that database')
		}

		// build inline connection array
		.'db_connect' -> insert('-database' = #database)
		.'db_connect' -> insert('-table' = #table)
		#host -> size > 0 ? .'db_connect' -> insert('-host' = #host)
		#username -> size > 0 ? .'db_connect' -> insert('-username' = #username)
		#password -> size > 0 ? .'db_connect' -> insert('-password' = #password)

		if(#validate) => {
			// validate db connection
			inline(.'db_connect') => {
				fail_if( error_code != 0, error_code, 'Error on validate: ' + error_msg)
			}
		}

		(.'datasource_name' >> 'Filemaker' ? .'isfilemaker' = true)

//	} // end debug
	}

	public oncreate(
		-database::string,
		-table::string,
		-host::array = array,
		-username::string = '',
		-password::string = '',
		-keyfield::string = 'keyfield',
		-lockfield::string = 'lockfield',
		-user::any = '',
		-validate::boolean = false
	) => {.onCreate(#database, #table, #host, #username, #password, #keyfield, #lockfield, #user, #validate)}

	public oncreate(
		database::string,
		table::string,
		-host::array = array,
		-username::string = '',
		-password::string = '',
		-keyfield::string = 'keyfield',
		-lockfield::string = 'lockfield',
		-user::any = '',
		-validate::boolean = false
	) => {.onCreate(#database, #table, #host, #username, #password, #keyfield, #lockfield, #user, #validate)}



/**!
	Shortcut to field
**/
	public _unknownTag(...) => {
		local(name = string(currentCapture -> calledName))
		if( .'field_names_map' >> #name) => {
			return (.field(#name))
		else

			log_critical('knop_database _unknownTag called without corresponding field name: ' + #name)
//			debug(.type + ' -> ' + #name + ' not known.')
//			.'_debug_trace' -> insert(.type + '->' + tag_name + ' not known.')
		}
		return 'unknown called with ' + #name + ' ' + #rest
	}

/**!
	Called when a knop_database object is stored in a session
**/
	public serializationElements() => {
//log_critical('knop_database serializationElements called')

		local(ret = map)
		#ret -> insert(pair('database', .'database'))
		#ret -> insert(pair('table', .'table'))
		#ret -> insert(pair('host', .'host'))
		#ret -> insert(pair('username', .'username'))
		#ret -> insert(pair('password', .'password'))
		#ret -> insert(pair('db_connect', .'db_connect'))
		#ret -> insert(pair('datasource_name', .'datasource_name'))
		#ret -> insert(pair('isfilemaker', .'isfilemaker'))
		#ret -> insert(pair('lock_expires', .'lock_expires'))
		#ret -> insert(pair('lock_seed', .'lock_seed'))
		#ret -> insert(pair('user', .'user'))

		return array(serialization_element('items', #ret))

	}

/**!
	Called when a knop_database object is retrieved from a session
**/
	public acceptDeserializedElement(d::serialization_element)  => {
//debug => {

		if(#d->key == 'items') => {

			local(ret = #d -> value)

			.'database' = (#ret-> find('database'))
			.'table' = (#ret-> find('table'))
			.'host' = (#ret-> find('host'))
			.'username' = (#ret-> find('username'))
			.'password' = (#ret-> find('password'))
			.'db_connect' = (#ret-> find('db_connect'))
			.'datasource_name' = (#ret-> find('datasource_name'))
			.'isfilemaker' = (#ret-> find('isfilemaker'))
			.'lock_expires' = (#ret-> find('lock_expires'))
			.'lock_seed' = (#ret-> find('lock_seed'))
			.'user' = (#ret-> find('user'))

		}

// 	} // end debug
	}


/**!
sethost
Creates or changes the DB inline host setting.
**/
	public sethost(
		host::array
	) => {

		.'error_code' = 0
		.'error_msg' = string

		.'host' = #host
		.'db_connect' -> removeall('-host')
		.'db_connect' -> insert( '-host' = #host)

	} // END sethost



/**!
settable
Changes the current table for a database object. Useful to be able to create database objects faster by copying an existing object and just change the table name. This is a little bit faster than creating a new instance from scratch, but no table validation is performed. Only do this to add database objects for tables within the same database as the original database object.
**/
	public settable(
		table::string
	) => {
//debug => {

		#table = #table -> asCopy

		.'error_code' = 0
		.'error_msg' = string

		.'table' = #table
		.'db_connect' -> removeall('-table')
		.'db_connect' -> insert( '-table' = #table)

// 	} // end debug
	} // END settable

/**!
select
perform database query, either Lasso-style pair array or SQL statement.
->recorddata returns a map with all the fields for the first found record. If multiple records are returned, the records can be accessed either through ->inlinename or ->records_array.
Parameters:
	-search (optional array) Lasso-style search parameters in pair array
	-sql (optional string) Raw sql query
	-keyfield (optional) Overrides default keyfield, if any
	-keyvalue (optional)
	-inlinename (optional) Defaults to autocreated inlinename
**/
	public select(
		search::array = array,
		sql::string = '',
		keyfield::string = '',
		keyvalue::any = '',
		inlinename::string = 'inline_' + knop_unique9 // inlinename defaults to a random string
	) => debug => {

//	debug => {

//		handle
//			debug('Done with ' + .type + ' -> ' + tag_name)
//		/handle
		// conserve error
		error_push
		handle => { error_pop }


		local(_search = .scrubKeywords(#search) -> asarray)
		#sql = #sql -> ascopy
		#keyvalue = #keyvalue -> ascopy
		#inlinename = #inlinename -> ascopy

		// clear all search result vars
		.reset

		#sql -> size > 0 && .'isfilemaker' ?
			fail( 7009, .error_msg(7009)) // sql can not be used with filemaker

		.'inlinename' = #inlinename

		#_search -> removeall( '-inlinename')
		#_search -> insert('-inlinename' = .'inlinename')

		// remove all database actions from the search array
		#_search -> removeall( '-search') & removeall( '-add') & removeall( '-delete') & removeall( '-update')
			& removeall( '-sql') & removeall( '-nothing') & removeall( '-show')
			& removeall( '-database') // table is ok to override

		if(#sql -> size > 0 && (regexp(-input = #sql,
					-find = `\bLIMIT\b`,
					-ignorecase = true) -> findcount) > 0) => {

//			debug(tag_name + ': grabbing -maxrecords and -skiprecords from search array')

			// store maxrecords and skiprecords for later use
			if(#_search >> '-maxrecords') => {
				local(maxrecords_value = #_search -> find('-maxrecords') -> last -> value)
				#maxrecords_value == 'all' or #maxrecords_value == all ? #maxrecords_value = 4234980
				.'maxrecords_value' = integer(#maxrecords_value)
//				debug(tag_name + ': -maxrecords value found in search array ' + .'maxrecords_value')
			}
			if(#_search >> '-skiprecords') => {
				.'skiprecords_value' = #_search -> find('-skiprecords') -> last -> value
//				debug(tag_name + ': -skiprecords value found in search array ' + .'skiprecords_value')
			}
			// remove skiprecords from the actual search parameters since it will conflict with LIMIT
			#_search -> removeall('-skiprecords')
		}

		if(#keyfield -> size == 0) => {
			#keyfield = .'keyfield'
		}

		if(#keyfield -> size > 0) => {
			#_search -> removeall( '-keyfield')
			if(!.'isfilemaker' && #keyvalue != '') => {
				#_search -> insert( '-keyfield' = #keyfield)
			}
			if(#keyvalue != '') => {
				#_search -> removeall( '-keyvalue')
				if(.'isfilemaker') => {
					#_search -> insert( '-op' = 'eq')
					#_search -> insert( #keyfield = #keyvalue)
				else
					#_search -> insert('-keyvalue' = #keyvalue)
				}
			}
		}

		// add sql action or normal search action
		if(#sql -> size > 0) => {
			#_search -> insert('-sql' = #sql)
		else
			#_search -> insert('-search')
		}

		// perform database query, put connection parameters last to override any provided by the search parameters
		local(querytimer = knop_timer)
		debug('Knop_database select inline') => {
			inline(#_search, .'db_connect') => {
				.'querytime' = integer(#querytimer)
				.'searchparams' = #_search
	//			debug -> sql(action_statement)
	//			debug(found_count + ' found')
				resultset(1) => {
					.capturesearchvars
				}
			}
		}

//		debug(tag_name + ': found ' string(.'found_count') + ' records in ' + string(.'querytime') + ' ms, tag time, ' + .'error_msg' + ' ' + string(.'error_code'))

// 	} // end debug
	} // END select

	public select(
		-search::array = array,
		-sql::string = '',
		-keyfield::string = '',
		-keyvalue::string = '',
		-inlinename::string = 'inline_' + knop_unique9 // inlinename defaults to a random string
	) => .select(#search, #sql, #keyfield, #keyvalue, #inlinename)


/**!
Add a new record to the database. A random string keyvalue will be generated unless a -keyvalue is specified.
Parameters:
	-fields (required array) Lasso-style field values in pair array
	-keyvalue (optional) If -keyvalue is specified, it must not already exist in the database. Specify -keyvalue = false to prevent generating a keyvalue.
	-inlinename (optional) Defaults to autocreated inlinename.
**/
	public addrecord(
		fields::array,
		keyvalue::string = knop_unique9,
		inlinename::string = 'inline_' + knop_unique9
	) => {
//debug => {
		// conserve error
		error_push
		handle => { error_pop }


		local(_fields = .scrubKeywords(#fields) -> asarray)

		#keyvalue = #keyvalue -> ascopy
		#inlinename = #inlinename -> ascopy

		// clear all search result vars
		.reset

		// remove all database actions from the field array
		#_fields -> removeall( '-search') & removeall( '-add') & removeall( '-delete') & removeall( '-update')
			& removeall( '-sql') & removeall( '-nothing') & removeall( '-show')
			& removeall( '-database') // table is ok to override

		inline(.'db_connect') => { // connection wrapper

			if(#keyvalue -> size > 0 && .'keyfield' -> size > 0) => {
				// look for existing keyvalue
				inline(-op = 'eq',.'keyfield' = #keyvalue,
					-maxrecords = 1,
					-returnfield = .'keyfield',
					-search) => {
					if(found_count > 0) => {
						.'error_code' = 7017 // duplicate keyvalue
					else
						.'keyvalue' = #keyvalue
					}
				}
			}

			if(.'error_code' == 0) => {
				// proceed to add record

				if(.'keyfield' -> size > 0) => {
					#_fields -> removeall(.'keyfield')
					#_fields -> removeall('-keyfield') & removeall('-keyvalue')
					#_fields -> insert('-keyfield' = .'keyfield')
					#_fields -> insert(.'keyfield' = .'keyvalue')
				}

				// inlinename defaults to a random string
				.'inlinename' = #inlinename
				#_fields -> removeall('-inlinename')
				#_fields -> insert('-inlinename' = .'inlinename')

				local(querytimer = knop_timer)
				inline(#_fields, -add) => {
					.'querytime' = integer(#querytimer)
					.'searchparams' = #_fields

					.capturesearchvars
					if(error_code != 0) => {
						log_critical('knop_database add inline error ' + error_code + ' : ' + error_msg)
						.'keyvalue' = ''
					}
				}
			}
		} // inline


//		debug(tag_name + ': keyvalue ' + .'keyvalue')

// 	} // end debug
	} // END addrecord

	public addrecord(
		-fields::array,
		-keyvalue::string = knop_unique9,
		-inlinename::string = 'inline_' + knop_unique9
	) => .addrecord(#fields, #keyvalue, #inlinename)


/**!
getrecord Returns a single specific record from the database, optionally locking the record.
If the keyvalue matches multiple records, an error is returned.
Parameters:
	-keyvalue (optional) Uses a previously set keyvalue if not specified. If no keyvalue is available, an error is returned unless -sql is used.
	-keyfield (optional) Temporarily override of keyfield specified at oncreate
	-inlinename (optional) Defaults to autocreated inlinename
	-lock (optional flag) If flag is specified, a record lock will be set
	-user (optional) The user who is locking the record (required if using lock)
	-sql (optional) SQL statement to use instead of keyvalue. Must include the keyfield (and lockfield if locking is used).
**/
	public getrecord(
		keyvalue::any = .'keyvalue',
		keyfield::string = string(.'keyfield'),
		inlinename::string = 'inline_' + knop_unique9,
		lock::boolean = false,
		user::any = .'user',
		sql::string = ''
	) => {
//debug => {

		// conserve error
		error_push
		handle => { error_pop }

		local(lockvalue = null)
		local(lock_timestamp = null)
		local(lock_user = null)
		local(keyvalue_temp = null)

		#keyfield = string(#keyfield)
		.'keyfield' = #keyfield
		#keyvalue = string(#keyvalue)
		.'keyvalue' = #keyvalue
		#inlinename = #inlinename -> ascopy
		local(id_user = string)
//		#user = #user
		.'user' = #user
		#sql = #sql -> ascopy

		#sql -> size > 0 && .'isfilemaker' ?
			fail( 7009, .error_msg(7009)) // sql can not be used with filemaker

		// clear all search result vars
		.reset

		fail_if(#keyfield -> size == 0, 7002, .error_msg(7002)) // Keyfield not specified
		if(#lock) => {
			fail_if(.'lockfield' -> size == 0, 7003, .error_msg(7003)) // Lockfield must be specified to get record with lock
//			if(#user -> size == 0 && (.'user' -> size > 0 || .'user' -> isa(::knop_user))) => {
//				// use user from database object
//				#user = .'user'
//			}
			fail_if(#user -> size  == 0 && !(#user -> isa(::knop_user)), 7004, .error_msg(7004)) // User must be specified to get record with lock
//			.'debug_trace' -> insert(tag_name ': user is type ' + (#user -> type) + ', isa(user) = ' + (#user -> isa(::knop_user)) )
			if(#user -> isa(::knop_user)) => {
				#id_user = #user -> id_user
				fail_if(#id_user -> size == 0, 7004, .error_msg(7004)) // User must be logged in to get record with lock
			else
				#id_user = #user
			}
//			.'debug_trace' -> insert(tag_name ': user id is ' + #user)
		}
		if(#sql -> size == 0 && string(#keyvalue) -> size == 0) => {
			.'error_code' = 7007 // keyvalue missing
		}

		if(.'error_code' == 0) => {
			inline(.'db_connect') => { // connection wrapper

				if(#sql -> size) => {
					.select(-sql = #sql, -inlinename = #inlinename)
					#keyvalue = .'keyvalue'
				else
					.select(-keyfield = #keyfield, -keyvalue = #keyvalue, -inlinename = #inlinename)
				}

				if(.field_names !>> #keyfield) => {
					.'error_code' = 7020 // Keyfield not present in query
				}

				if(.field_names !>> .'lockfield' && #lock) => {
					.'error_code' = 7021 // Lockfield not present in query
				}

				if(.'found_count' == 0 && .'error_code' == 0) => {
					.'error_code' = -1728
				else(.'found_count' > 1 &&.'error_code' == 0)
					.reset
					.'error_code' = 7008 // keyvalue not unique
				}

				// handle record locking
				if(.'error_code' == 0 && #lock) => {
					// check for current lock
					if(.'lockvalue' -> size > 0) => {
						// there is a lock already set, check if it has expired or if it is the same user
						#lockvalue = .'lockvalue' -> split('|')
						#lock_timestamp = date(#lockvalue -> last or null)
						#lock_user = #lockvalue -> first
						if((date - #lock_timestamp) -> asInteger < .'lock_expires'
							&& #lock_user != #id_user) => {
							// the lock is still valid and it is locked by another user
							// this is not a real error, more a warning condition
							.'error_code' = 7010
							.'error_data' = map('user' = #lock_user, 'timestamp' = #lock_timestamp)
							.'keyvalue' = ''
//							debug(tag_name ': record ' + #keyvalue + ' was already locked by ' + #lock_user + '.')
						}
					}

					if(.'error_code' == 0) => {
						// go ahead and lock record
						.'lockvalue' = #id_user + '|' + (date -> asdecimal)
						.'lockvalue_encrypted' = string(encode_base64(encrypt_blowfish(.'lockvalue', -seed = .'lock_seed')))
						#keyvalue_temp = #keyvalue
						if(.'isfilemaker') => {
							// find internal keyvalue
							inline(-op = 'eq', #keyfield = #keyvalue,
								-search) => {
								if(found_count == 1) => {
									#keyvalue_temp = keyfield_value
//									.'debug_trace' -> insert(tag_name + ': will set record lock for FileMaker record id ' + keyfield_value + ' ' + error_msg + ' ' + error_code)
								else
//									debug(tag_name + ': could not get record id for FileMaker record, ' found_count + ' found ' + error_msg + ' ' + error_code)
								}
							}
						}

						inline(-keyfield = #keyfield,
							-keyvalue = #keyvalue_temp,
							.'lockfield' = .'lockvalue',
							-update) => {
							if(error_code) => {
								.'error_code' = 7012 // could not set record lock
								.'error_data' = map('error_code' = error_code, 'error_msg' = error_msg)
								.'lockvalue' = string
								.'lockvalue_encrypted' = string
								.'keyvalue' = string
//								debug(tag_name + ': could not set record lock. ' + error_msg + ' ' + error_code)
							else
								// lock was set ok
//								.'debug_trace' -> insert(tag_name + ': set record lock ' + .'lockvalue' + ' ' + .'lockvalue_encrypted')
//stdoutnl('knop_database getrecord lock ' + .'user' -> type)
								if(.'user' -> isa(::knop_user)) => {
									// tell user it has locked a record in this db object
									.'user' -> addlock(.varname)
//stdoutnl('knop_database getrecord lock ' + .'user' -> 'dblocks')
								}
							}
						} // inline
					}
				}

			} //inline
		}

// 	} // end debug
	} // END getrecord

	public getrecord(
		keyvalue::any = .'keyvalue',
		-keyfield::string = string(.'keyfield'),
		-inlinename::string = 'inline_' + knop_unique9,
		-lock::boolean = false,
		-user::any = .'user',
		-sql::string = ''
	) => .getrecord(#keyvalue, #keyfield, #inlinename, #lock, #user, #sql)

	public getrecord(
		-keyvalue::any = .'keyvalue',
		-keyfield::string = string(.'keyfield'),
		-inlinename::string = 'inline_' + knop_unique9,
		-lock::boolean = false,
		-user::any = .'user',
		-sql::string = ''
	) => .getrecord(#keyvalue, #keyfield, #inlinename, #lock, #user, #sql)

/**!
saverecord Updates a specific database record.
Parameters:
	-fields (required array) Lasso-style field values in pair array
	-keyfield (optional) Keyfield is ignored if lockvalue is specified
	-keyvalue (optional) Keyvalue is ignored if lockvalue is specified
	-lockvalue (optional) Either keyvalue or lockvalue must be specified
	-keeplock (optional flag) Avoid clearing the record lock when saving. Updates the lock timestamp.
	-user (optional) If lockvalue is specified, user must be specified as well
	-inlinename (optional) Defaults to autocreated inlinename.
**/
	public saverecord(
		fields::array,
		keyfield::string = string(.'keyfield'),
		keyvalue::string = string(.'keyvalue'),
		lockvalue::string = '',
		keeplock::boolean = false,
		user::any = .'user',
		inlinename::string = 'inline_' + knop_unique9
	) => {
//debug => {
		// conserve error
		error_push
		handle => { error_pop }

		local(lock = null)
		local(lock_timestamp = null)
		local(lock_user = null)

		local(_fields = .scrubKeywords(#fields) -> asarray)

		#keyfield = #keyfield -> ascopy
		#keyvalue = #keyvalue -> ascopy
		#lockvalue = #lockvalue -> ascopy
//		#user = #user -> ascopy
		#inlinename = #inlinename -> ascopy

		local(id_user = #user)

		.'keyfield' = #keyfield
		.'keyvalue' = #keyvalue

		// clear all search result vars
		.reset

		fail_if((#keyvalue -> size == 0 && #lockvalue -> size == 0), 7005, .error_msg(7005)) // Either keyvalue or lockvalue must be specified for update or delete
		fail_if(#keyvalue -> size > 0 && #keyfield -> size == 0, 7002, .error_msg(7002)) // Keyfield not specified

		if(#lockvalue -> size > 0) => {
			fail_if(.'lockfield' -> size == 0, 7003, .error_msg(7003)) // Lockfield not specified

			fail_if(#user -> size == 0 && !(#user -> isa(::knop_user)), 7004, .error_msg(7004))
//			.'debug_trace' -> insert(tag_name ': user is type ' + (#user -> type) + ', isa(user) = ' + (#user -> isa(::knop_user)) )
			if(#user -> isa(::knop_user)) => {
				#id_user = #user -> id_user
				fail_if(#id_user -> size == 0, 7004, .error_msg(7004)) // User must be logged in to get record with lock
			}
//			.'debug_trace' -> insert(tag_name ': user id is ' + #user)
		}

		// remove all database actions from the field array
		#_fields -> removeall( '-search') & removeall( '-add') & removeall( '-delete') & removeall( '-update')
			& removeall( '-sql') & removeall( '-nothing') & removeall( '-show')
			& removeall( '-database') // table is ok to override

		inline(.'db_connect') => { // connection wrapper

			// handle record locking
			if(.'error_code' == 0 && #lockvalue -> size > 0) => {

				// first check if record was locked by someone else, and that lock is still valid
				#lock = string(decrypt_blowfish(decode_base64(#lockvalue), -seed = .'lock_seed')) -> split('|')
				#lock_timestamp = date(#lock -> last or null)
				#lock_user = #lock -> first
				if((date - #lock_timestamp) -> asInteger < .'lock_expires'
					&& #lock_user != #id_user) => {
					// the lock is still valid and it is locked by another user
					.'error_code' = 7010
					.'error_data' = map('user' = #lock_user, 'timestamp' = #lock_timestamp)
				}

				// check that the current lock is still valid
				if(.'error_code' == 0) => {
					inline(-op = 'eq', .'lockfield' = #lock -> join('|'),
						-maxrecords = 1,
						-returnfield = .'lockfield',
						-returnfield = #keyfield,
						-search) => {
						if(error_code == 0 && found_count != 1) => {
							// lock is not valid any more
							.'error_code' = 7011 // Update failed, record lock not valid any more
						else(error_code != 0)
							.'error_code' = 7018 // Update error
							.'error_data' = map('error_code' = error_code, 'error_msg' = error_msg)
//							debug(tag_name + ': Error when checking current lock ' + error_msg)
						else
							// lock OK, grab keyvalue for update
							local('keyvalue' = field(#keyfield))
						}
					}
				}

				if(.'error_code' == 0) => {
					// go ahead and release record lock by clearing the field value in the update fields array
					#_fields -> removeall(.'lockfield')
					if(#keeplock) => {
						// update the lock timestamp
						.'lockvalue' = #id_user + '|' + (date -> asdecimal)
						.'lockvalue_encrypted' = string(encode_base64(encrypt_blowfish(.'lockvalue', -seed = .'lock_seed')))
						#_fields -> insert(.'lockfield' = .'lockvalue')
					else
						#_fields -> insert(.'lockfield' = '')
					}
				}

			}

			if(.'error_code' == 0 && #keyvalue -> size > 0) => {
				if(.'isfilemaker') => {
					inline(-op = 'eq', #keyfield = #keyvalue, -search) => {
						if(found_count == 1) => {
							#_fields -> insert('-keyvalue' = keyfield_value)
//							.'debug_trace' -> insert(tag_name + ': FileMaker record id ' + keyfield_value)
						}
					}
				else
					#_fields -> insert('-keyfield' = #keyfield)
					#_fields -> insert('-keyvalue' = #keyvalue)
				}
			}

			if((#_fields >> '-keyfield' && #_fields -> find('-keyfield') -> first -> value -> size > 0 || .'isfilemaker')
				&& #_fields >> '-keyvalue' && #_fields -> find('-keyvalue') -> first -> value -> size > 0) => {
				// ok to update
			else
				.'error_code' = 7006 // Update failed, keyfield or keyvalue missing'
			}

			// update record
			if(.'error_code' == 0) => {

				// inlinename defaults to a random string
				.'inlinename' = #inlinename
				#_fields -> removeall('-inlinename')
				#_fields -> insert('-inlinename' = .'inlinename')

				local(querytimer = knop_timer)
				inline(#_fields, -update) => {
					.'querytime' = integer(#querytimer)
					.'searchparams' = #_fields
					.capturesearchvars
				}
			}
		} //inline

// 	} // end debug
	} // END saverecord

	public saverecord(
		-fields::array,
		-keyfield::string = string(.'keyfield'),
		-keyvalue::string = string(.'keyvalue'),
		-lockvalue::string = '',
		-keeplock::boolean = false,
		-user::any = .'user',
		-inlinename::string = 'inline_' + knop_unique9
	) => {
		return .saverecord(#fields, #keyfield, #keyvalue, #lockvalue, #keeplock, #user, #inlinename) // END saverecord
	}

/**!
deleterecord Deletes a specific database record.
Parameters:
	-keyvalue (optional) Keyvalue is ignored if lockvalue is specified
	-lockvalue (optional) Either keyvalue or lockvalue must be specified
	-user (optional) If lockvalue is specified, user must be specified as well.
**/
	public deleterecord(
		keyvalue::string = .'keyvalue',
		lockvalue::string = '',
		user::any = .'user'
	) => {
//debug => {
		// conserve error
		error_push
		handle => { error_pop }


		local(lock = null)
		local(lock_timestamp = null)
		local(lock_user = null)
		local(fields = array)

		#keyvalue = #keyvalue -> ascopy
		#lockvalue = #lockvalue -> ascopy
		#user = #user -> ascopy

		// clear all search result vars
		.reset

		fail_if((#keyvalue -> size == 0 && #lockvalue -> size == 0), 7005, .error_msg(7005)) // Either keyvalue or lockvalue must be specified for update or delete
		fail_if(#keyvalue -> size > 0 && .'keyfield' -> size == 0, 7002,  .error_msg(7002)) // Keyfield not specified

		if(#lockvalue -> size > 0) => {
			fail_if(.'lockfield' -> size == 0, 7003, .error_msg(7003)) // Lockfield not specified

			fail_if(#user -> size == 0 && !(#user -> isa(::knop_user)), 7004, .error_msg(7004))
//			.'debug_trace' -> insert(tag_name ': user is type ' + (#user -> type) + ', isa(user) = ' + (#user -> isa(::knop_user)) )
			if(#user -> isa(::knop_user)) => {
				#user = #user -> id_user
				fail_if(#user -> size == 0, 7004, .error_msg(7004)) // User must be logged in to get record with lock
			}
//			.'debug_trace' -> insert(tag_name ': user id is ' + #user)
		}

		inline(.'db_connect') => { // connection wrapper

			// handle record locking
			if(.'error_code' == 0 && #lockvalue -> size > 0) => {

				// first check if record was locked by someone else, and that lock is still valid
				#lock = string(decrypt_blowfish(decode_base64(#lockvalue), -seed = .'lock_seed')) -> split('|')
				#lock_timestamp = date(#lock -> last or null)
				#lock_user = #lock -> first
				if((date - #lock_timestamp) -> asInteger < .'lock_expires'
					&& #lock_user != #user) => {
					// the lock is still valid and it is locked by another user
					.'error_code' = 7010
					.'error_data' = map('user' = #lock_user, 'timestamp' = #lock_timestamp)
				}

				// check that the current lock is still valid
				if(.'error_code' == 0) => {
					inline(-op = 'eq', .'lockfield' = #lock -> join('|'),
						-maxrecords = 1,
						-returnfield = .'lockfield',
						-returnfield = .'keyfield',
						-search) => {
						if(error_code == 0 && found_count != 1) => {
							// lock is not valid any more
							.'error_code' = 7011 // Delete failed, record lock not valid any more
						else(error_code != 0)
							.'error_code' = 7019 // Delete error
							.'error_data' = map('error_code' = error_code, 'error_msg' = error_msg)
						else
							// lock OK, grab keyvalue for delete
							local('keyvalue' = field(.'keyfield'))
						}
					}
				}

			}

			if(.'error_code' == 0 && #keyvalue -> size > 0) => {
				if(.'isfilemaker') => {
					inline(-op = 'eq', .'keyfield' = #keyvalue, -search) => {
						if(found_count == 1) => {
							#fields -> insert('-keyvalue' = keyfield_value)
//							.'debug_trace' -> insert(tag_name + ': FileMaker record id ' + keyfield_value)
						}
					}
				else
					#fields -> insert('-keyfield' = .'keyfield')
					#fields -> insert('-keyvalue' = #keyvalue)
				}
			}

//			.'debug_trace' -> insert(tag_name + ': will delete record with params ' + #fields)

			if((#fields >> '-keyfield' && #fields -> find('-keyfield') -> first -> value -> size > 0 || .'isfilemaker')
				&& #fields >> '-keyvalue' && #fields -> find('-keyvalue') -> first -> value -> size > 0) => {
				// ok to delete
			else(.'error_code' == 0)
				.'error_code' = 7006 // Delete failed, keyfield or keyvalue missing'
			}

			// delete record
			if(.'error_code' == 0) => {

				local(querytimer = knop_timer)
				inline(#fields, -delete) => {
					.'querytime' = integer(#querytimer)
					.'searchparams' = #fields
					.capturesearchvars
				}
			}
		} //inline

// 	} // end debug
	} // END deleterecord

	public deleterecord(
		-keyvalue::string = .'keyvalue',
		-lockvalue::string = '',
		-user::any = .'user'
	) => .deleterecord(#keyvalue, #lockvalue, #user)

/**!
clearlocks Release all record locks for the specified user, suitable to use when showing record list.
Parameters:
	-user (required) The user to unlock records for.
**/
	public clearlocks(
		user::any
	) => {
//debug => {
		// conserve error
		error_push
		handle => { error_pop }

		local(id_user = #user)

		fail_if(.'lockfield' -> size == 0, 7003,  .error_msg(7003)) //  Lockfield not specified
		fail_if((#user -> size == 0 && !(#user -> isa(::knop_user))), 7004, .error_msg(7004)) // User not specified

		if(#user -> isa(::knop_user)) => {
			#id_user = #user -> id_user
			fail_if(#id_user -> size == 0, 7004, .error_msg(7004)) // User must be logged in to clear locks
		}

		if(.'isfilemaker') => {
			inline(.'db_connect',
				-maxrecords = all,
				.'lockfield' = '"' + #id_user + '|"',
				-search) => {
				if(found_count > 0) => {
//					debug(tag_name + ': clearing locks for ' + #user + ' in ' + found_count + ' FileMaker records ' + error_msg + ' ' + error_code)

					records => {
						inline(-keyvalue = keyfield_value,
							.'lockfield' = '',
							-update) => {
							if(error_code) => {
								.'error_code' = 7013 // Clearlocks failed
								.'error_data' = map('error_code' = error_code, 'error_msg' = error_msg)
//								debug(tag_name + ': error when clearing lock on FileMaker record ' + keyfield_value + ' ' + error_msg + ' ' + error_code)
								return
							}
						}
					}
				else(error_code)
					.'error_code' = 7013 // Clearlocks failed
					.'error_data' = map('error_code' = error_code, 'error_msg' = error_msg)
				}
			} //inline
		else
			inline(.'db_connect',
				-sql = 'UPDATE `' + .'table' + '` SET `' + .'lockfield'
					+ '`=""  WHERE `' + .'lockfield'
					+ '` LIKE "' + knop_encodesql_full(#id_user) + '|%"') => {
				if(error_code != 0) => {
					.'error_code' = 7013 // Clearlocks failed
					.'error_data' = map('error_code' = error_code, 'error_msg' = error_msg)
				}
			}
//			debug(tag_name + ': clearing all locks for ' + #user + ' ' + .'error_msg' + ' ' + .'error_code')
		}


// 	} // end debug
	} // END clearlocks

	public clearlocks(
		-user::any
	) => .clearlocks(#user)

	public clearlock(
		lockvalue::string,
		user::any = .'user'
	) => {

		// conserve error
		error_push
		handle => { error_pop }


		#user = #user -> ascopy

		fail_if(.'lockfield' -> size == 0, 7003, .error_msg(7003)) // Lockfield not specified

		fail_if(#user -> size == 0 && !(#user -> isa(::knop_user)), 7004, .error_msg(7004))
		if(#user -> isa(::knop_user)) => {
			#user = #user -> id_user
			fail_if(#user -> size == 0, 7004, .error_msg(7004)) // User must be logged in to get record with lock
		}

		local(lock = string(decrypt_blowfish(decode_base64(#lockvalue), -seed = .'lock_seed')))

		if(.'isfilemaker') => {
			inline(.'db_connect',
				-maxrecords = 1,
				.'lockfield' = #lock,
				-search) => {
				if(found_count > 0) => {
					records => {
						inline(-keyvalue = keyfield_value,
							.'lockfield' = '',
							-update) => {
							if(error_code) => {
								.'error_code' = 7013 // Clearlock failed
								.'error_data' = map('error_code' = error_code, 'error_msg' = error_msg)
								return
							}
						}
					}
				else(error_code)
					.'error_code' = 7013 // Clearlock failed
					.'error_data' = map('error_code' = error_code, 'error_msg' = error_msg)
				}
			} //inline
		else
			inline(.'db_connect',
				-sql = 'UPDATE `' + .'table' + '` SET `' + .'lockfield'
					+ '`=""  WHERE `' + .'lockfield'
					+ '` = "' + knop_encodesql_full(#lock) + '"') => {
				if(error_code != 0) => {
					.'error_code' = 7013 // Clearlock failed
					.'error_data' = map('error_code' = error_code, 'error_msg' = error_msg)
				}
			}
		}

	} // END clearlock

	public clearlock(
		-lockvalue::string,
		-user::any = .'user'
	) => .clearlock(#lockvalue, #user)

	public action_statement() => .'action_statement'

	public found_count() => .'found_count'

	public shown_count() => .'shown_count'

	public shown_first() => .'shown_first'

	public shown_last() => .'shown_last'

	public maxrecords_value() => .'maxrecords_value'

	public skiprecords_value() => .'skiprecords_value'

	public keyfield() => .'keyfield'

	public keyvalue() => .'keyvalue'

	public lockfield() => .'lockfield'

	public lockvalue() => .'lockvalue'

	public lockvalue_encrypted() => .'lockvalue_encrypted'

	public querytime() => .'querytime'

	public inlinename() => .'inlinename'

	public searchparams() => .'searchparams'

	public resultset_count(
		inlinename::string = .'inlinename'
	) => .'resultset_count_map' -> find(#inlinename)

/**!
recorddata A map containing all fields, only available for single record results.
**/
	public recorddata(
		recordindex::integer = .'current_record'
	) => {
//debug => {

		#recordindex = #recordindex -> ascopy

		#recordindex < 1 ? #recordindex = 1
		if(#recordindex == 1) => {
			// return default (i.e. first) record
			return(.'recorddata')
		else(.'records_array' -> size >= #recordindex)
			local(recorddata = map)
			with fieldname in .field_names do {
				#recorddata -> insert(#fieldname = (.'records_array' -> get(#recordindex)
					-> get(.'field_names_map' -> find(#fieldname))))
			}
			return #recorddata
		else
			return map
		}

// 	} // end debug
	} // END recorddata

	public records_array() => .'records_array'

/**!
field_names Returns an array of the field names from the last database query. If no database query has been performed, a "-show" request is performed.
Parameters:
	-table (optional) Return the field names for the specified table
	-types (optional flag) If specified, returns a pair array with fieldname and corresponding Lasso data type.
**/
	public field_names(
		table::string = .table,
		types::boolean = false
	) => {
//debug => {

		local(field_names = .'field_names')

		if(#field_names -> size == 0 || #types) => {
			#field_names = array
			if(#types) => {
				local(types_mapping = map('text' = 'string', 'number' = 'decimal', 'date/time' = 'date'))
			}
			inline(.'db_connect', -table = #table, -show) => {
				if(#types) => {
					loop(field_name(-count)) => {
						#field_names -> insert(field_name(loop_count) = #types_mapping -> find(field_name(loop_count, -type)))
					}
				else
					#field_names = field_names -> asarray
				}
			}
		}
		return(#field_names) // NOTE was return(@#field_names) in 8.5. Why?

// 	} // end debug
	} // END field_names

/**!
table_names Returns an array with all table names for the database.
**/
	public table_names() => {
//debug => {

		local(table_names = array)
		inline(.'db_connect') => {
			database_tablenames(.'database') => {
				#table_names -> insert(database_tablenameitem)
			}
		}
		return(#table_names) // NOTE was return(@#table_names) in 8.5. Why?

// 	} // end debug
	} // END table_names

/**!
error_data Returns more info for those errors that provide such.
**/
	public error_data() => {

		if(.'errors_error_data' >> .error_code) => {
			return(.'error_data')
		else
			return(map)
		}

	} // END error_data

	public size() => .'shown_count'

	public get(
		index::integer
	) => {

		return(knop_databaserow(
			(.'records_array' -> get(#index)),
			.'field_names'))

	} // END get

/**!
records Returns all found records as a knop_databaserows object.
**/
	public records(
		inlinename::string = .'inlinename'
	) => {
//debug => {

		if(.'databaserows_map' !>> #inlinename) => {
			// create knop_databaserows on demand
			.'databaserows_map' -> insert(#inlinename = knop_databaserows(
					.'records_array',
					.'field_names')
				)
		}
		return(.'databaserows_map' -> find(#inlinename)) // NOTE was return(@(.'databaserows_map' -> find(#inlinename))) in 8.5. Why?


// 	} // end debug
	} // END records

	public records(
		-inlinename::string = .'inlinename'
	) => {
		return .records(#inlinename)

	} // END records

/**!
field A shortcut to return a specific field from a single record result.
**/
	public field(
		fieldname::string,
		recordindex::integer = .current_record,
		index::integer = 1
	) => {
//debug => {

		#recordindex < 1 ? #recordindex = 1

		if(#recordindex == 1 && #index == 1) => {
			// return first field occurrence from the default (i.e. first) record
			return(.'recorddata' -> find(#fieldname))
		else(.'field_names_map' >> #fieldname
			&& #recordindex >= 1
			&& #recordindex <= .'records_array' -> size)
			// return specific record
			if(#index == 1) => {
				// return first ocurrence of field name through the index map - this is faster
				return(.'records_array' -> get(#recordindex) -> get(.'field_names_map' -> find(#fieldname)))
			else
				// return another occurrence of the field - this is slightly slower
				local(indexmatches = .'field_names' -> findposition(#fieldname))
				if(#index >= 1 && #index <= #indexmatches -> size) => {
					return(.'records_array' -> get(#recordindex) -> get(#indexmatches -> get(#index)))
				}
			}
		}

// 	} // end debug
	} // END field

/**!
next Increments the record pointer, returns true if there are more records to show, false otherwise.
Useful as an alternative to a regular records loop:
	$database -> select;
	while($database -> next);
		$database -> field( \'name\');\'<br>\';
	/while;.
**/
	public next() => {
		if(.'current_record' < .'shown_count') => {
			.'current_record' += 1
			return(true)
		else
			// reset record pointer
			.'current_record' = 0
			return(false)
		}

	} // END next

/*
trace This tag depends on knop_base and is for the moment not operational.

	public trace(
		html::boolean = false
	) => {

		return('This tag depends on knop_base and is for the moment not operational')
//		local(endslash = .xhtml(params) ? ' /' | '') Pending implementation of knop_base
		local(endslash = '')

		local(eol = #html || #endslash -> size ? '<br' + #endslash + '>\n' | '\n')

		return(#eol + 'Debug trace for database $' + .varname + ' (' .'database' + '.' + (.'table') + ')' +  #eol
			+ (.'debug_trace' -> join(#eol)) + #eol)

	} // END trace

*/

	// =========== Internal member tags ===============

/*
reset Internal, resets all search result vars.
*/
	private reset() => {

		// reset all search result vars
		.'action_statement' = string
		.'found_count' = integer
		.'shown_first' = integer
		.'shown_last' = integer
		.'shown_count' = integer
		.'field_names' = array
		.'records_array' = staticarray
		.'maxrecords_value' = integer
		.'skiprecords_value' = integer

		.'inlinename' = string
		.'keyvalue' = string
		.'lockvalue' = string
		.'lockvalue_encrypted' = string
		.'timestampfield' = string
		.'timestampvalue' = string
		.'searchparams' = array
		.'querytime' = integer
		.'recorddata' = map
		.'message' = string
		.'current_record' = 0
		.'field_names_map' = map

		.'error_code' = 0
		.'error_msg' = string

	} // END reset

/**!
capturesearchvars Internal.
**/
	private capturesearchvars() => {
//debug => {

		// capture various result variables like found_count, shown_first, shown_last, shown_count
		// searchresultvars
		.'action_statement' = action_statement
		.'found_count' = found_count
		.'shown_first' = shown_first
		.'shown_last' = shown_last
		.'shown_count' = shown_count
		.'field_names' = field_names -> asarray
		.'records_array' = records_array

		// added by Jolle 2011-01-27
		.'affected_count' = knop_affected_count

		!(.'maxrecords_value' > 0) ? .'maxrecords_value' = maxrecords_value
		!(.'skiprecords_value' > 0) ? .'skiprecords_value' = skiprecords_value

		.'resultset_count_map' -> insert(.'inlinename' = resultset_count)
		local(loopcount = 1)
		with fieldname in field_names do {
			.'field_names_map' !>> #fieldname
				? .'field_names_map' -> insert(#fieldname = #loopcount)
			#loopcount++
		}

		.'error_code' = error_code
		error_code && error_msg -> size ? .'error_msg' = error_msg

		// handle queries that use LIMIT
		if(!.'isfilemaker' && (regexp(-input = action_statement,
					-find = `\sLIMIT\s`,
					-ignorecase = true)) -> findcount) => {
//			.'debug_trace' -> insert(tag_name + ': old found_count, shown_first and shown_last ' + .'found_count' + ' '+ .'shown_first' + ' '+ .'shown_last')
			.'found_count' = knop_foundrows
			// adjust shown_first and shown_last
			.'shown_first' = (.'found_count' ? .'skiprecords_value' + 1 | 0)
			.'shown_last' = math_min((.'skiprecords_value' + .'maxrecords_value'), .'found_count')
//			.'debug_trace' -> insert(tag_name + ': new found_count, shown_first and shown_last ' + .'found_count' + ' '+ .'shown_first' + ' '+ .'shown_last')
		}

		// capture some variables for single record results
		if(found_count <= 1  // -update gives found_count 0 but still has one record result
			&& error_code == 0) => {
			if(.'keyfield' -> size > 0 && string(field(.'keyfield')) -> size) => {
				.'keyvalue' = field(.'keyfield')
			else(.'keyfield' -> size > 0 && .'keyvalue'-> size == 0 && !(.'isfilemaker'))
//				.'keyvalue' = (keyfield_value != void ? keyfield_value | string)
				.'keyvalue' = string(keyfield_value)
			}
			if(lasso_currentaction == 'add' || lasso_currentaction == 'update') => {
				.'affectedrecord_keyvalue' = .'keyvalue'
			}

			if(.'lockfield' -> size > 0) => {
				.'lockvalue' = string(field(.'lockfield'))
				local(lockvalue) = .'lockvalue' -> split('|')
				local(lock_timestamp) = date(#lockvalue -> last or null)
					if((date - #lock_timestamp) -> asinteger >= .'lock_expires') => {
						.'lockvalue' = string
						.'lockvalue_encrypted' = string
					else;
						.'lockvalue_encrypted' = string(encode_base64(encrypt_blowfish(string(field(.'lockfield')), -seed = .'lock_seed')))
					}

			}
		}

		if(error_code == 0) => {
			// populate recorddata with field values from the first found record
			with fieldname in field_names do {
				.'recorddata' !>> #fieldname
					? .'recorddata' -> insert(#fieldname  =  field(#fieldname) )
			}
		else
//			debug(tag_name + ': ' + error_msg)
		}

//		debug( tag_name + ': found_count ' + string(.'found_count') + ' ' + .'keyfield' + ' '+ string(field(.'keyfield')) + ' keyfield_value ' + string(keyfield_value) + ' keyvalue ' + string(.'keyvalue'))

// 	} // end debug
	} // END capturesearchvars

// temp storage here pending the creation of knop_base

/**!
varname Returns the name of the variable that this type instance is stored in.
**/
/* used from knop_base instead
	public varname() => {
//debug => {

		.'instance_unique' == null ? .'instance_unique' = knop_unique9

		if(.'instance_varname' == null) => {
			// look for the var name and store it in instance variable

			with varname in vars -> keys do => {
				if(var(#varname) -> type == .type
					&& (var(#varname) -> 'instance_unique') == .'instance_unique')
					.'instance_varname' = string(#varname)
//					loop_abort
				/if
			}
		}

		return(.'instance_varname')

// 	} // end debug
	} // END varname
*/

	public error_code() => .'error_code'

	public error_msg(
		error_code::integer = .'error_code'
	) => {
//debug => {

		local('error_lang_custom' = .'error_lang')
//pending		local('error_lang' = knop_lang('en', true))

		local('errorcodes' = map(
			0 = 'No error',
			-1728 = 'No records found', // standard Lasso error code

			// database errors 7000
			7001 ='The specified table was not found',
			7002 = 'Keyfield not specified',
			7003 = 'Lockfield not specified',
			7004 = 'User not specified for record lock',
			7005 = 'Either keyvalue or lockvalue must be specified for update or delete',
			7006 = 'Keyfield or keyvalue missing',
			7007 = 'Keyvalue missing',
			7008 = 'Keyvalue not unique',
			7009 = '-sql can not be used with FileMaker',
			7010 = 'Record locked by another user', // see error_data
			7011 = 'Record lock not valid any more',
			7012 = 'Could not set record lock', // see error_data
			7013 = 'Failed to clear record locks', // see error_data
			7016 = 'Add error', // see error_data
			7017 = 'Add failed, duplicate key value',
			7018 = 'Update error', // see error_data
			7019 = 'Delete error', // see error_data
			7020 = 'Keyfield not present in query',
			7021 = 'Lockfield not present in query',

			// form errors 7100
			7101 ='Form validation failed',
			7102 = 'Unsupported field type',
			7103 = 'Form->process requires that a database object is defined for the form',
			7104 = 'Copyfield must copy to a different field name',

			// grid errors 7200

			// lang errors 7300

			// nav errors 7400

			// user errors 7500
			7501 = 'Authentication failed',
			7502 = 'Username or password missing',
			7503 = 'Client fingerprint has changed'

			))
//pending		#error_lang -> addlanguage(-language = 'en', -strings = #errorcodes)
/* pending
		// add any custom error strings
		local(custom_language = null);
		iterate(#error_lang_custom -> 'strings');
			if(#error_lang -> 'strings' !>> loop_value -> name);
				// add entire language at once
				#error_lang -> addlanguage(-language = loop_value -> name, -strings = loop_value -> value);
			else;
				// add one string at a time
				#custom_language = loop_value -> value
				iterate(#custom_language);
					#error_lang -> insert(-language = loop_value -> name,
						-key = loop_value -> name,
						-value = loop_value -> value);
				/iterate;
			/if;
		/iterate;
**/
		if(#errorcodes >> #error_code) => {
			// return error message defined by this tag
			if(false) => {
//pending			if(#error_lang -> keys >> #error_code)
//pending				return(#error_lang -> getstring(#error_code))
			else
				return(#errorcodes -> find(#error_code))
			}
		else
			if(.'error_msg' -> size > 0) => {
				// return literal error message
				return(.'error_msg')
			else
				// test for error known by lasso
				error_code = #error_code
				// return Lasso error message
				return(error_msg)
			}
		}



// 	} // end debug
	} // END error_msg

    trait {
      import trait_serializable
    }

	protected scrubKeywords(input::trait_queriable)::trait_forEach => {
		local(ret = array)
		with i in #input
		do {
			if(#i->isa(::keyword)) => {
				#ret->insert(pair('-'+#i->name->asString, .scrubKeywords(#i->value)))
			else (#i->isa(::pair))
				#ret->insert(pair(#i->first, .scrubKeywords(#i->second)))
			else (#i->isa(::trait_forEach))
				local(tst = .scrubKeywords(#i))
				#tst->size > 0?
					#ret->insert(#tst)
			else (#i->isa(::string) && #i->beginsWith('-'))
				#ret->insert(pair(#i, true))
			else
				#ret->insert(#i)
			}
		}
		return #ret->asStaticArray
	}
	protected scrubKeywords(input) => #input


} // END knop_database



/**!
knop_databaserows
Custom type to return all record rows from knop_database. Used as output for knop_database->records
Lasso 9 version
**/
define knop_databaserows => type {
	/*

	CHANGE NOTES
	2010-07-30	JC	Started on first version written directly for for Lasso 9

	*/

	data public version = '2010-07-30'

	data public description::string = 'Custom type to interact with databases. Supports both MySQL and FileMaker datasources'

	// instance variables
	data public records_array::staticarray = staticarray
	data public field_names::array = array
	data public field_names_map::map = map
	data public current_record::integer = 0

/**!
oncreate
Create a record rows object.
Parameters:
	-records_array (array) Array of arrays with field values for all fields for each record of all found records
	-field_names (array) Array with all the field names
**/
	public oncreate(
		records_array::staticarray,
		field_names::array
	) => {
//debug => {

		.'records_array' = #records_array
		.'field_names' = #field_names

		// store indexes to first occurrence of each field name for faster access
		local(loopcount = 1)
		with fieldname in #field_names do {
			.'field_names_map' !>> #fieldname
				? .'field_names_map' -> insert(#fieldname = #loopcount)
			#loopcount++
		}

// 	} // end debug
	} // END oncreate

/**!
onconvert Output the current record as a plain array of field values.
**/
	public onconvert(
		recordindex::integer = .'current_record'
	) => {
//debug => {

		#recordindex < 1 ? #recordindex = 1
		if(#recordindex >= 1 && #recordindex <= (.'records_array' -> size)) => {
			return(.'records_array' -> get(#recordindex))
		}

// 	} // end debug
	} // END onconvert

	public size() => .'records_array' -> size

	public get(
		index::integer
	) => {

		return(knop_databaserow(-record_array = (.'records_array' -> get(#index)), -field_names = .'field_names'))

	} // END get

/**!
field Return an individual field value.
**/
	public field(
		fieldname::string,
		recordindex::integer = .'current_record',
		index::integer = 1
	) => {
//debug => {


		#recordindex < 1 ? #recordindex = 1

		if(.'field_names_map' >> #fieldname
			&& #recordindex >= 1
			&& #recordindex <= .'records_array' -> size) => {
			// return specific record
			if(#index==1) => {
				// return first ocurrence of field name through the index map - this is faster
				return(.'records_array' -> get(#recordindex) -> get(.'field_names_map' -> find(#fieldname)))
			else
				// return another occurrence of the field - this is slightly slower
				local(indexmatches = .'field_names' -> findposition(#fieldname))
				if(#index >= 1 && #index <= #indexmatches -> size) => {
					return(.'records_array' -> get(#recordindex) -> get(#indexmatches -> get(#index)))
				}
			}
		}

// 	} // end debug
	} // END field

/**!
summary_header Returns true if the specified field name has changed since the previous record, or if we are at the first record.
**/
	public summary_header(
		fieldname::string
	) => {
//debug => {

		local(recordindex = .'current_record')
		#recordindex < 1 ? #recordindex = 1

		if(#recordindex == 1 // first record
			|| .field(#fieldname) != .field(#fieldname, -recordindex = (#recordindex - 1)) ) => { // different than previous record (look behind)
			return(true)
		else
			return(false)
		}

// 	} // end debug
	} // END summary_header

/**!
summary_footer Returns true if the specified field name will change in the following record, or if we are at the last record.
**/
	public summary_footer(
		fieldname::string
	) => {
//debug => {

		local(recordindex = .'current_record')
		#recordindex < 1 ? #recordindex = 1

		if(#recordindex == .'records_array' -> size // last record
			|| .field(#fieldname) != .field(#fieldname, -recordindex = (#recordindex + 1)) ) => { // different than next record (look ahead)
			return(true)
		else
			return(false)
		}

// 	} // end debug
	} // END summary_footer

/**!
next Increments the record pointer, returns true if there are more records to show, false otherwise..
**/
	public next() => {

		if(.'current_record' < .'records_array' -> size) => {
			.'current_record' += 1
			return(true)
		else
			// reset record pointer
			.'current_record' = 0
			return(false)
		}

	} // END next

} // END knop_databaserows

/**!
knop_databaserow
Custom type to return individual record rows from knop_database. Used as output for knop_database->get
Lasso 9 version
**/
define knop_databaserow => type {
	/*

	CHANGE NOTES
	2010-07-30	JC	Started on first version written directly for for Lasso 9

	*/

	data public version = '2010-07-30'

	// instance variables
	data public record_array::staticarray = staticarray
	data public field_names::array = array

/**!
oncreate
Create a record row object.
Parameters:
	-record_array (array) Array with field values for all fields for the record
	field_names (array) Array with all the field names, should be same size as -record_array
**/
	public oncreate(
		record_array::staticarray,
		field_names::array
	) => {

		.'record_array' = #record_array
		.'field_names' = #field_names

		return .'record_array'
	} // END oncreate
	public oncreate(
		-record_array::staticarray,
		-field_names::array
	) => {

		return .oncreate(#record_array, #field_names)
	} // END oncreate


/**!
onconvert Output the record as a plain array of field values.
**/
	public onconvert() => .'record_array'

/**!
field Return an individual field value.
**/
	public field(
		fieldname::string,
		index::integer = 1
	) => {
//debug => {


		if(.'field_names' >> #fieldname) => {
			// return any occurrence of the field
			local('indexmatches' = .'field_names' -> findposition(#fieldname))
			if(#index >= 1 && #index <= #indexmatches -> size) => {
				return(.'record_array' -> get(#indexmatches -> get(#index)))
			}
		}

// 	} // end debug
	} // END field


} // END knop_databaserow

//log_critical('loading knop_database done')

?>