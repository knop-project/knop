<?LassoScript
log_critical('loading knop_user from LassoApp')

/**!
knop_user
Purpose:
- Maintain user identity and authentication
- Handle database record locking more intelligently, also to be able to release all unused locks for a user
- Authenticating user login
- Restricting access to data
- displaying specific navigation options depending on type of user

lets add some date handling in there too like time of last login
and probably the IP that the user logged in from.


Some options to handle what happens when a user logs in again whilst already logged in.
ie one could:
disallow second login (with a message explaining why)
automatically log the first session out (with a message indicating what happened)
send a message to first session: "Your username is attempting to log in again, do you wish to close this session, or deny the second login attempt?"
allow multiple logins (from the same IP address)
allow multiple logins from any IP address

All of these could be useful options, depending of the type of app.

And different types of user (ie normal, admin) could have different types of treatment.

Handling for failed login attempts:
Option to set how many tries can be attempted;
Option to lock users out permanently after x failed attempts?
Logging (to database) of failed logins / successful logins

Password recovery system (ie emailing a time sensitive link to re-set password)
By "password recovery" I'm not thinking "email my password" (hashed passwords can't be emailed...) but rather to email a short lived link that gives the user an opportunity to change his password. How is this different from "password reset"?
Yes, that is an accurate description of what I had in mind, except for the bit about emailing a short-lived link.  Instead I imagined having the user reset their password 100% on the web site through the use of "Security Questions", much like banks employ.

I like the idea of more info attached to the user. Like login attempts, locking a user temporarily after too many failed attempts etc.


The setup is more or less that I have users and groups.

I'm thinking that Knop shouldn't do any session handling by itself, but the knop_user variable would be stored in the app's session as any other variable. Knop should stay as lean as possible...

Other things to handle:
Prevent session sidejacking by storing and comparing the user's ip and other identifying properties.
Provide safe password handling with strong one-way salted encryption.

consider having a separate table for auditing all user actions, including logging in, logging out, the basic CRUD actions, searches

The object have to handle situations where no user is logged in. A guest can still have rights to some actions. Modules that can be viewed. Forms that could be sent in etc.
That the added functions don't slow down the processing. We already have a lot of time consuming overhead in Knop.



Features:
1. Authentication and credentials
- Handle the authentication process
- Keep track of if a user is properly logged in
- Optionally keep track of multiple logins to same account
- Prevent sidejacking
- Optionally handle encrypted/hashed passwords (with salt)
- Prevent brute force attacks (delay between attempts etc)
- Handle general information about the user
- Provide accessors for user data

2. Permissions and access control
- Keep track of what actions a user is allowed to perform (the "verbs")
- Tie into knop_nav to be able to filter out locations based on permissions

3. Record locks
- Handle clearing of record locks from knop_database

4. Audit trail/logging
- Optionally log login/logout actions
- Provide hooks to be able to log other user actions

Future additions:
- Keep track of what objects and resources a user is allowed to act on (the "nouns")
- Provide filtering to use in database queries
- What groups a user belongs to
- Mechanism to update user information, password etc
- Handle password recovery


Permissions can be read, create, update, delete, or application specific (for example publish)

**/
define knop_user => type {
/*
CHANGE NOTES
	2012-07-02	JC	Replaced all old style if, inline and loop with code blocks
	2012-07-02	JC	Fixed erroneous handling of addlock and clearlocks
	2012-05-19	JC	Made sure id_user is always of type string
	2012-05-18	JC	Reactivated _unknownTag
	2012-05-18	JC	Changed login so it accepts byte params for username and password
	2012-01-17	JC	Added removedata to remove field data from the data map
	2011-12-22	JC	Fixed bug that prevented clearlocks from working
	2011-12-22	JC	Added allowsidejacking as a boolean param. When true will disregard any client_fingerprint anomalies. Default false
	2010-10-25	JC	knop_user now works in first generation tests
	2010-10-25	JC	Adding support code to enable serialization of a knop_user object
	2010-10-24	JC	Compiles in Lasso 9. Still not functional. Some internal methods moved to knop_utils for broader access
	2010-10-23	JC	Started Lasso 9 implementation
*/
	parent knop_base

	data public version = '2012-05-18'
	data public description = 'Custom type to handle user identification and authentication'

	data public fields::array = array()



	data public id_user::any = ''
	data public validlogin::boolean = false
	data public groups::array = array
	data public data::map = map // map with arbitrary user information (name, address etc)
	data public permissions::map = map
	data public loginattempt_date::date = date(0) // to keep track of delays multiple login attempts
	data public loginattempt_count::integer = integer // number of failed login attempts

	data public userdb::knop_database = null // database object for user authentication
	data public useridfield::string
	data public userfield::string
	data public passwordfield::string
	data public saltfield::string
	data public costfield::string
	data public costsize::integer = 20
	data public cost::boolean = false
	data public encrypt::boolean = false
	data public encrypt_cipher::string = 'RIPEMD160' // digest encryption method

	data public logdb::knop_database // database object for logging
	data public logeventfield::string // the event to be logged
	data public loguserfield::string // the user who is performing the logged action
	data public logobjectfield::string // what object is affected by the logged action
	data public logdatafield::string // details about the logged action

	data public singleuser::boolean
	data public uniqueid::string = '' // To track multiple logins on the same account (this is to be stored and compared server side)
	data private client_fingerprint::string = '' // combination of ip, useragent etc to be able to track sidejacking
	data private allowsidejacking::boolean = false // when set to true no sidejacking control will be done. Default false
	data public dblocks::set = set // a list of all database objects that have been locked by this user
//	data public error_lang::knop_lang = knop_lang(-default = 'en', -fallback)

/**!
Parameters:\n\
	-encrypt (optional flag or string) Use encrypted passwords. If a value is specified then that cipher will be used instead of the default RIPEMD160. If -saltfield is specified then the value of that field will be used as salt.\n\
	-singleuser (optional flag) Multiple logins to the same account are prevented (not implemented)
**/

	public oncreate(
		userdb::knop_database,
		encrypt::any = '',
		cost::any = '',
		useridfield::string = 'id',
		userfield::string = 'username',
		passwordfield::string = 'password',
		saltfield::string = 'saltfield',
		costfield::string = 'costfield',
		logdb::any = null,
		loguserfield::string = 'id_user',
		logeventfield::string = 'event',
		logobjectfield::string = 'id_object',
		logdatafield::string = 'data',
		singleuser::boolean = false,
		allowsidejacking::boolean = false
	) => {

//		local(timer = knop_timer)

		.'userfield' = #userfield
		.'useridfield' = #useridfield
		.'passwordfield' = #passwordfield
		.'saltfield' = #saltfield
		.'costfield' = #costfield
		.'loguserfield' = #loguserfield
		.'logeventfield' = #logeventfield
		.'logobjectfield' = #logobjectfield
		.'logdatafield' = #logdatafield

		// the following params are stored as reference, so the values of the params can be altered after adding a field simply by changing the referenced variable.
		// Not working in Lasso 9 Need a new method for that
		.'userdb' = #userdb
		#logdb -> isa('knop_database') ? .'logdb' = #logdb

		if(#encrypt -> isa('boolean')) => {
			.'encrypt' = #encrypt
		else(#encrypt -> size > 0 && cipher_list( -digest) >> #encrypt)
			.'encrypt' = true
			.'encrypt_cipher' = #encrypt
		}

		if(#cost -> isa('boolean')) => {
			.'cost' = #cost
		else(#cost -> isa('integer'))
			.'cost' = true
			.'costsize' = #cost
		else(#costfield != '')
			.'cost' = true
		}

		.'singleuser' = #singleuser
//		..'tagtime_tagname'=tag_name
//		..'tagtime'=integer(#timer) // cast to integer to trigger onconvert and to "stop timer"


	}

	public oncreate(
		-userdb::knop_database,
		-encrypt::any = '',
		-cost::any = '',
		-useridfield::string = 'id',
		-userfield::string = 'username',
		-passwordfield::string = 'password',
		-saltfield::string = 'saltfield',
		-costfield::string = 'costfield',
		-logdb::any = null,
		-loguserfield::string = 'id_user',
		-logeventfield::string = 'event',
		-logobjectfield::string = 'id_object',
		-logdatafield::string = 'data',
		-singleuser::boolean = false,
		-allowsidejacking::boolean = false
	) => .oncreate(#userdb, #encrypt, #cost, #useridfield, #userfield, #passwordfield, #saltfield, #costfield, #logdb, #loguserfield, #logeventfield, #logobjectfield, #logdatafield, #singleuser, #allowsidejacking)

/* might not be needed since client_fingerprint_expression is turned into a method instead
/**!
	Recreates transient variables after coming back from a session
** /
	public ondeserialize() => {
		// MARK: Why is client_fingerprint_expression considered a transient variable?
//		.'properties' -> first -> insert('client_fingerprint_expression' = {return(encrypt_md5(string(client_ip) + client_type))})
	}
*/

	public _unknownTag(...) => {
		local(name = string(currentCapture->calledName))
		.'data' >> #name ? return (.'data' -> find(#name))

		return 'unknown called with ' + #name + ' ' + #rest
	}

/**!
	Called when a knop_user object is stored in a session
**/
	public serializationElements() => {
//		local('timer' = knop_timer)

		local(ret = map)

		#ret -> insert(pair('id_user', .'id_user'))
		#ret -> insert(pair('validlogin', .'validlogin'))

		#ret -> insert(pair('groups', .'groups'))
		#ret -> insert(pair('data', .'data'))
		#ret -> insert(pair('permissions', .'permissions'))
		#ret -> insert(pair('loginattempt_date', .'loginattempt_date'))
		#ret -> insert(pair('loginattempt_count', .'loginattempt_count'))

		#ret -> insert(pair('userdb', .'userdb')) // do we need the db object in the session?
		#ret -> insert(pair('useridfield', .'useridfield'))
		#ret -> insert(pair('userfield', .'userfield'))
		#ret -> insert(pair('passwordfield', .'passwordfield'))
		#ret -> insert(pair('saltfield', .'saltfield'))
		#ret -> insert(pair('costfield', .'costfield'))
		#ret -> insert(pair('costsize', .'costsize'))
		#ret -> insert(pair('cost', .'cost'))
		#ret -> insert(pair('encrypt', .'encrypt'))
		#ret -> insert(pair('encrypt_cipher', .'encrypt_cipher'))

		(.'logdb' -> isa('knop_database') ? #ret -> insert(pair('logdb', .'logdb'))) // do we need the db object in the session?
		#ret -> insert(pair('logeventfield', .'logeventfield'))
		#ret -> insert(pair('loguserfield', .'loguserfield'))
		#ret -> insert(pair('logobjectfield', .'logobjectfield'))
		#ret -> insert(pair('logdatafield', .'logdatafield'))

		#ret -> insert(pair('singleuser', .'singleuser'))
		#ret -> insert(pair('uniqueid', .'uniqueid'))
		#ret -> insert(pair('client_fingerprint', .'client_fingerprint'))
		#ret -> insert(pair('allowsidejacking', .'allowsidejacking'))
		#ret -> insert(pair('dblocks', .'dblocks'))
//		#ret -> insert(pair('error_lang', .'error_lang')) // do we need the lang object in the session?

		return array(serialization_element('items', #ret))


	}

/**!
	Called when a knop_user object is retrieved from a session
**/
	public acceptDeserializedElement(d::serialization_element)  => {
		if(#d->key == 'items') => {

			local(ret = #d -> value)

			.'id_user' = (#ret-> find('id_user'))
			.'validlogin' = (#ret-> find('validlogin'))

			.'groups' = (#ret-> find('groups'))
			.'data' = (#ret-> find('data'))
			.'permissions' = (#ret-> find('permissions'))
			.'loginattempt_date' = (#ret-> find('loginattempt_date'))
			.'loginattempt_count' = (#ret-> find('loginattempt_count'))

			.'userdb' = (#ret-> find('userdb'))
			.'useridfield' = (#ret-> find('useridfield'))
			.'userfield' = (#ret-> find('userfield'))
			.'passwordfield' = (#ret-> find('passwordfield'))
			.'saltfield' = (#ret-> find('saltfield'))
			.'costfield' = (#ret-> find('costfield'))
			.'costsize' = (#ret-> find('costsize'))
			.'cost' = (#ret-> find('cost'))
			.'encrypt' = (#ret-> find('encrypt'))
			.'encrypt_cipher' = (#ret-> find('encrypt_cipher'))

			((#ret-> find('logdb')) -> isa('knop_database') ? .'logdb' = (#ret-> find('logdb')))
			.'logeventfield' = (#ret-> find('logeventfield'))
			.'loguserfield' = (#ret-> find('loguserfield'))
			.'logobjectfield' = (#ret-> find('logobjectfield'))
			.'logdatafield' = (#ret-> find('logdatafield'))

			.'singleuser' = (#ret-> find('singleuser'))
			.'uniqueid' = (#ret-> find('uniqueid'))
			.'client_fingerprint' = (#ret-> find('client_fingerprint'))
			.'allowsidejacking' = (#ret-> find('allowsidejacking'))
			.'dblocks' = (#ret-> find('dblocks'))
//			.'error_lang' = (#ret-> find('error_lang'))
		}

	}

/**!
	Checks if user is authenticated, returns true/false
**/
	public auth() => {

		local('validlogin' = .'validlogin')
		local('client_fingerprint_now' = string)

		if(#validlogin && .'allowsidejacking' == false) => {
			// check client_fingerprint to prevent sidejacking
			#client_fingerprint_now = .client_fingerprint_expression

			if(#client_fingerprint_now != .'client_fingerprint') => {
				#validlogin = false
//				..'_debug_trace' -> insert('auth: Client fingerprint has changed - this looks like session sidejacking. Logging out.')
				.'error_code' = 7503
				.logout
				// log this
				log_critical('auth: Client fingerprint has changed - this looks like session sidejacking. Logging out. ' + #client_fingerprint_now + ' | ' + .'client_fingerprint')
			}
			// TODO: if singleuser, check uniqueid
		}

		return(#validlogin)

	}


/**!
Log in user. On successful login, all fields on the user record will be available by -> getdata.\n\
			Parameters:\n\
			-username (required) Optional if -force is specified\n\
			-password (required) Optional if -force is specified\n\
			-searchparams (optional) Extra search params array to use in combination with username and password\n\
			-force (optional) Supply a user id for a manually authenticated user if custom authentication logics is needed
**/
	public login(
		username::any = '',
		password::any = '',
		searchparams::array = array,
		force::string = ''
	) => {
//	debug => {

//*

		#searchparams = #searchparams -> ascopy

		local(_username = string(#username))
		local(_password = string(#password))

		if(#force -> size == 0 && (#_username -> size == 0 || #_password -> size == 0)) => {
			fail(-9956, 'knop_user -> login requires -username and -password, or -force')
		}

		local('db' = .'userdb')
		local('validlogin' = false)

		if(#force -> size > 0) => {
//			..'_debug_trace' -> insert('login: Manually authenticating user id ' + #force)
			#validlogin = true
			.'id_user' = #force

		else
			if(#_username -> size > 0 && #_password -> size > 0) => {

				if(.'loginattempt_count' >= 5) => {
					// login delay since last attempt was made
//					..'_debug_trace' -> insert('login: Too many login attempts, wait until ' + (2 * .'loginattempt_count') + ' seconds has passed since last attempt.')
					while(((date - .'loginattempt_date') -> second) <  (2 * .'loginattempt_count') // at least 5 seconds, longer the more attempts
						&& loop_count < 100) // rescue sling
						sleep(200)
					/while
				}
				// authenticate user against database (username must be unique)
//				..'_debug_trace' -> insert('knop_user -> login: Authenticating user')
				if(#db -> 'isfilemaker') => {
					#searchparams -> merge(array(-op='eq', .'userfield '= '="' + #_username + '"'))
				else
					#searchparams -> merge(array(-op='eq', .'userfield' = #_username))
				}

				#db -> select(#searchparams)
//				..'_debug_trace' -> insert('knop_user -> login: Searching user db, ' (#db -> found_count) + ' found ' + (#db -> error_msg) + ' ' + (#db -> action_statement))

				if(#db -> found_count == 1
					&& #db -> field(.'userfield') == #_username) => { // double check the username
					// one match, continue by checking the password with case sensitive comparsion

					if(.'encrypt' && .'cost' && .'saltfield' -> size) => {
						// use encryption with cost & salt
//						..'_debug_trace' -> insert('knop_user -> login: ' + 'Checking password with cost and salted encryption')

						if(knop_crypthash(#_password,
							-hash = string(#db -> field(.'passwordfield')),
							-salt = knop_blowfish(-string = #db -> field(.'saltfield'), -mode = 'D'),
							-cost = (.'costfield' -> size ? integer(#db -> field(.'costfield')) | .'costsize'), -cipher = (.'encrypt_cipher')) == true) => {

							#validlogin = true

						}

					else(.'encrypt' && .'saltfield' -> size)

//						..'_debug_trace' -> insert('knop_user -> login: ' + 'Checking password with only salted encryption')
						if(bytes(#db -> field(.'passwordfield'))
							== bytes(knop_encrypt(#_password, -salt = #db -> field(.'saltfield' ), -cipher = .'encrypt_cipher' ))) => {
							#validlogin = true
						}
					else(.'encrypt')
						// use encryption with no salt
//						..'_debug_trace' -> insert('knop_user -> login: ' + 'Checking password with encryption, no salt')
						if(bytes(#db -> field(.'passwordfield'))
							== bytes(knop_encrypt(#_password, -salt = '', -cipher = .'encrypt_cipher'))) => {
							#validlogin = true
						}
					else
//						..'_debug_trace' -> insert('knop_user -> login: ' + 'Checking plain text password')
						if(bytes(#db -> field(.'passwordfield'))
							== bytes(#_password)) => {
							#validlogin = true
						}
					}
				}

				if(#validlogin) => {

//					..'_debug_trace' -> insert('knop_user -> login: ' + 'id_user: ' + #db -> field(.'useridfield'))
					// store user id
					.'id_user' = string(#db -> field(.'useridfield'))
					// store all user record fields in data map
					.'data' = #db -> recorddata

				}
			} // #_username and #_password
		} // #force

		if(#validlogin) => {

//			..'_debug_trace' -> insert('knop_user -> login: ' + 'Valid login')
			.'loginattempt_count' = 0
			.'error_code' = 0 // No error
			// set validlogin to true
			.validlogin = true
			// log the action TODO
			// store client_fingerprint
			.'client_fingerprint' = .client_fingerprint_expression
			// if singleuser, store uniqueid in server side storage

		else(!(local('username') -> size && local('password') -> size))
			.'error_code' = 7502 // Username or password missing
			.logout
		else
			// TODO:
			// - block username for a while after too many attempts
			.'loginattempt_count' += 1
			.'loginattempt_date' = date // keep track of when last login attempt happened
//			..'_debug_trace' -> insert('knop_user -> login: ' + 'Invalid login (' +  .'loginattempt_count' + ' attempts)')
			.'error_code' = 7501 // Authentication failed
			.logout
			// exit
		}

//*/
//	} // end debug
	}

	public login(
		-username::any = '',
		-password::any = '',
		-searchparams::array = array,
		-force::string = ''
	) => .login(string(#username), string(#password), #searchparams, #force)


/**!
	Logout the user
**/
	public logout() => {

		.'validlogin' = false
		.'id_user' = ''
		.'data' = map
		.'permissions' = map

		// clear all record locks
		.clearlocks
		// log the action

	}

/**!
	Get field data from the data map
**/
	public getdata(
		field::string
	) => {

		.'data' >> #field ? return(.'data' -> find(#field))

	}

/**!
	Remove field data from the data map
**/
	public removedata(
		field::string
	) => {
		.'data' >> #field ? .'data' -> remove(#field)
	}

/**!
	Return the user id
**/
	public id_user() => {

		if(.auth) => {
			return(.'id_user')
		else
			return(false)
		}
	}

/**!
	Set field data in the data map. Either -> setdata(-field=\'fieldname\', -value=\'value\') or -> setdata(\'fieldname\'=\'value\')
**/
	public setdata(
		field::any,
		value::any = ''
	) => {

		if(#field -> isa('pair')) => {
			#value = #field -> value
			#field = #field -> name
		}

		fail_if(#value == '', -1, 'knop_user -> setdata requires a value parameter')
		.'data' -> insert(string(#field) = #value -> ascopy)

	}

/**!
Returns true if user has permission to perform the specified action, false otherwise
**/
	public getpermission(
		permission::string
	) => {

		if(.auth && .'permissions' >> #permission) => {
			return(.'permissions' -> find(#permission))
		else
			return(false)
		}

	}

/**!
Sets the user\'s permission to perform the specified action (true or false, or just the name of the permission
**/
	public setpermission(
		permission::string,
		value::any = ''
	) => {

		if(#value == true || # value -> size > 0) => { // any non-false value is regarded as true
			.'permissions' -> insert(#permission=true)
		else(#value == false) // explicit false
			.'permissions' -> insert(#permission = false)
		else // no value specified is regarded as true
			.'permissions' -> insert(#permission = true)
		}

	}

/**!
Called by database object, adds the name of a database object that has been locked by this user.
**/
	public addlock(
		dbname::any
	) => {
stdoutnl('knop_user addlock called ' + #dbname)
//stdoutnl('knop_user addlock check ' + var(#dbname) -> type)
		if(var(#dbname) -> isa(::knop_database)) => {
//			..'_debug_trace' -> insert('knop_user -> addlock: adding database name  ' + #dbname)
			.'dblocks' -> insert(#dbname)
		}
stdoutnl('knop_user addlock dblocks ' + .'dblocks')
	}

	public addlock(
		-dbname::any
	) => .addlock(#dbname)


/**!
Clears all database locks that has been set by this user.
**/
	public clearlocks() => {
//stdoutnl('knop_user clearlocks called ' + .'dblocks')

		if(.auth) => {
//			..'_debug_trace' -> insert('knop_user -> clearlocks: ' + .'dblocks' -> join(', '))
			local(cleared_dbs = array)
//			iterate(.'dblocks') => {
			with locks in .'dblocks' do => {
				local(thislock =  var(#locks))

//				if(var(loop_value) -> isa(::knop_database)) => {
				protect => {
					handle_error => {
						log_critical('Error on clearlocks ' + error_msg)
					}
					#thislock -> clearlocks(.'id_user')
					#cleared_dbs -> insert(#locks)
				}
			}
			// remove all locks that has been cleared
			with dbs in #cleared_dbs do => {
				.'dblocks' -> remove(#dbs)
			}
		}

	}

/**!
Returns all keys for the stored user data.
**/
	public keys() => .'data' -> keys


/**!
Returns an encrypted fingerprint based on client_ip and client_type.
**/
	public client_fingerprint_expression() => encrypt_md5(string(client_ip) + client_type)

    trait {
      import trait_serializable
    }

}

log_critical('loading knop_user done')


?>