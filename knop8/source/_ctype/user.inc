<?LassoScript

define_type: 'user',
	'knop_base',
	-namespace='knop_';
//	-prototype;

	local: 'version'='2009-09-18',
		'descripion'='Custom type to handle user identification and authentication';

/*

CHANGE NOTES
2012-01-16	SP	Added ->removedata to remove field from the data map.  Thanks to Ric Lewis.
2009-09-18	JS	Syntax adjustments for Lasso 9
2009-06-23	JS	->encrypt now uses default encrypt_cipher from the custom type instead of a hard coded default
2009-02-26	JS	->login: further correction on the search for login with FileMaker, to reduce the risk for false duplicates
2009-02-26	JS	->login: Added optional -searchparams to be able to add more conditions to the login search, for example to exclude users that are not enabled. 
2008-12-02	JS	->encrypt: Changed to -hex cipher instead of encode_base64
2008-11-05	JS	->getdata: corrected a check that prevented the tag from returning anything
2008-11-05	JC	->login: A failed login attempt now results in a logout instead of keeping any old authentication
2008-11-05	JC	->getpermission will always return falseif a user is not logged in
2008-11-05	JC	->logout: The permissions map is now cleared when logging out
2008-11-04	JC	->encrypt: changed incorrect encrypt_cipher to encrypt_digest
2008-09-10	JS	Added ondeserialize to make client_fingerprint_expression survive session
2008-07-17	JS	Implemented ->setpermission and ->getpermission
2008-07-17	JS	Added client_fingerprint_expression as compound expression so it can be configurable by changing the instant variable
2008-05-20	JS	->login: Added delay between more than 5 failed login attempts 
2008-05-08	JS	->login: improved the search for FileMaker datasources to make it work for email address as username
2008-02-08	JS	Added ->keys
2008-02-03	JS	-> login: Corrected storage of id_user
2007-11-27	JS	Coded an incomplete version
2007-06-13	JS	Created the data type

// TODO: 
Make it possible for knop_user to work independently of a knop_database object by creating a custom user lookup - see http://listsearch.com/Lasso/Thread/index.lasso?20528
userdb reference is broken, probably when stored in session. Can this be fixed?
Make client_fingerprint configurable by specifying a compound expression at oncreate
Add support for role based permisions

*/


/*
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

*/

	local: 'id_user'=null,
		'validlogin'=false,
		'groups'=array,
		'data'=map,						// map with arbitrary user information (name, address etc)
		'permissions'=map,
		'loginattempt_date'=(date: 0),	// to keep track of delays multiple login attempts
		'loginattempt_count'=integer,	// number of failed login attempts

		'userdb'=null,					// database object for user authentication
		'useridfield'='id',	
		'userfield'='username',	
		'passwordfield'='password',
		'saltfield'=null,
		'encrypt'=false,
		'encrypt_cipher'='RIPEMD160',	// digest encryption method

		'logdb'=null,					// database object for logging
		'logeventfield'='event',		// the event to be logged
		'loguserfield'='id_user',		// the user who is performing the logged action
		'logobjectfield'='id_object',	// what object is affected by the logged action
		'logdatafield'='data',			// details about the logged action

		'singleuser'=false,
		'uniqueid'=null,				// To track multiple logins on the same account (this is to be stored and compared server side)
		'client_fingerprint'=null,		// combination of ip, useragent etc to be able to track sidejacking
		'client_fingerprint_expression'={return(encrypt_md5(string(client_ip) + client_type))},
		'dblocks'=array,				// a list of all database objects that have been locked by this user 
		'error_lang'=(knop_lang: -default='en', -fallback),
		;

	define_tag: 'oncreate', -description='Parameters:\n\
			-encrypt (optional flag or string) Use encrypted passwords. If a value is specified then that cipher will be used instead of the default RIPEMD160. If -saltfield is specified then the value of that field will be used as salt.\n\
			-singleuser (optional flag) Multiple logins to the same account are prevented (not implemented)',
		-required='userdb', -type='database',
		-optional='encrypt',
		-optional='useridfield', -type='string',
		-optional='userfield', -type='string',
		-optional='passwordfield', -type='string',
		-optional='saltfield', -type='string',
		-optional='logdb', -type='database',
		-optional='loguserfield', -type='string',
		-optional='logeventfield', -type='string',
		-optional='logdatafield', -type='string',
		-optional='singleuser';
		
		local: 'timer'=knop_timer; 

		local_defined('userfield') ? (self -> 'userfield') = #userfield;
		local_defined('useridfield') ? (self -> 'useridfield') = #useridfield;
		local_defined('passwordfield') ? (self -> 'passwordfield') = #passwordfield;
		local_defined('saltfield') ? (self -> 'saltfield') = #saltfield;
		local_defined('loguserfield') ? (self -> 'loguserfield') = #loguserfield;
		local_defined('logeventfield') ? (self -> 'logeventfield') = #logeventfield;
		local_defined('logdatafield') ? (self -> 'logdatafield') = #logdatafield;

		// the following params are stored as reference, so the values of the params can be altered after adding a field simply by changing the referenced variable. 
		local_defined('userdb') ? (self -> 'userdb') = @#userdb;
		local_defined('logdb') ? (self -> 'logdb') = @#logdb;

		if: (local_defined: 'encrypt') && #encrypt != false;
			(self -> 'encrypt') = true;
			if: #encrypt -> size && (Cipher_List: -digest) >> #encrypt; // a valid digest cipher was specified
				(self -> 'encrypt_cipher') = #encrypt;
			/if;
		else;
			(self -> 'encrypt') = false;
		/if;
		(self -> 'singleuser') = (local_defined: 'singleuser') && #singleuser != false;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;


	define_tag: 'ondeserialize', -description='Recreates transient variables after coming back from a session';
		// MARK: Why is client_fingerprint_expression considered a transient variable?
		self -> properties -> first -> insert('client_fingerprint_expression'={return(encrypt_md5(string(client_ip) + client_type))});
	/define_tag;

/*
	define_tag: 'onassign', -description='Internal, needed to restore references when ctype is defined as prototype',
		-required='value';
		// recreate references here
		iterate: (array: 
			'userdb',
			'logdb'), (local: 'param');
			(self -> #param) = @(#value -> #param);
		/iterate;
	/define_tag;
// */	
	
	define_tag: '_unknowntag', -description='Shortcut to getdata';
		if: (self -> 'data') >> tag_name;
			return: (self -> 'data') -> (find: tag_name);
		else;
			//fail: -9948, self -> type + '->' + tag_name + ' not known.';
			(self -> '_debug_trace') -> insert(self -> type + '->' + tag_name + ' not known.');
		/if;
	/define_tag;

	define_tag: 'auth', -description='Checks if user is authenticated, returns true/false';
		local: 'timer'=knop_timer; 

		local: 'validlogin'=false, 'client_fingerprint_now'=string;
		// check validlogin
		#validlogin = (self -> 'validlogin');
		if: #validlogin;
			// check client_fingerprint to prevent sidejacking
			#client_fingerprint_now = (self -> 'client_fingerprint_expression') -> invoke;
			if: #client_fingerprint_now != (self -> 'client_fingerprint');
				#validlogin = false;
				(self -> '_debug_trace') -> insert(tag_name + ': Client fingerprint has changed - this looks like session sidejacking. Logging out.');
				(self -> 'error_code') = 7503;
				self -> logout;
				// TODO: log this
			/if;
			// TODO: if singleuser, check uniqueid
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
		return: #validlogin;
	/define_tag;


	define_tag: 'login', -description='Log in user. On successful login, all fields on the user record will be available by -> getdata.\n\
			Parameters:\n\
			-username (required) Optional if -force is specified\n\
			-password (required) Optional if -force is specified\n\
			-searchparams (optional) Extra search params array to use in combination with username and password\n\
			-force (optional) Supply a user id for a manually authenticated user if custom authentication logics is needed',
		-optional='username',
		-optional='password',
		-optional='searchparams', -type='array', -copy,
		-optional='force';
		local: 'timer'=knop_timer; 

		if(!local_defined('force') && (!local_defined('username') || !local_defined('password')));
			fail(-9956, self -> type + '->' + tag_name + ' requires -username and -password, or -force');
		/if;
		
		local: 'db'=@(self -> 'userdb'),
			'validlogin'=false;
		

		if(local_defined('force') && string(#force) -> size && #force != false);
			(self -> '_debug_trace') -> insert(tag_name + ': ' + 'Manually authenticating user id ' + #force);
			#validlogin = true;
			(self -> 'id_user') = #force;

		else;
			!local_defined('searchparams') ? local('searchparams'=array);
			if((local('username') -> size && local('password') -> size));
				if((self -> 'loginattempt_count') >= 5);
					// login delay since last attempt was made 
					(self -> '_debug_trace') -> insert(tag_name + ': Too many login attempts, wait until ' + (2 * (self -> 'loginattempt_count')) + ' seconds has passed since last attempt.');
					while(((date - (self -> 'loginattempt_date')) -> second) <  (2 * (self -> 'loginattempt_count')) // at least 5 seconds, longer the more attempts
						&& loop_count < 100); // rescue sling
						sleep(200);
					/while;
				/if;
				// authenticate user against database (username must be unique)
				(self -> '_debug_trace') -> (insert: tag_name + ': ' + 'Authenticating user');
				if(#db -> 'isfilemaker');
					#searchparams -> merge(array(-op='eq', (self -> 'userfield') = '="' + #username + '"'));
				else;
					#searchparams -> merge(array(-op='eq', (self -> 'userfield') = #username));
				/if;
				#db -> select(#searchparams);
				(self -> '_debug_trace') -> (insert: tag_name + ': ' + 'Searching user db, ' (#db -> found_count) + ' found ' + (#db -> error_msg) + ' ' + (#db -> action_statement));
				if: #db -> found_count == 1
					&& #db -> (field: (self -> 'userfield')) == #username; // double check the username
					// one match, continue by checking the password with case sensitive comparison
					if: (self -> 'encrypt') && (self -> 'saltfield') -> size;
						// use encryption with salt
						(self -> '_debug_trace') -> (insert: tag_name + ': ' + 'Checking password with salted encryption');
						if: bytes: (#db -> (field: (self -> 'passwordfield'))) 
							== bytes: (self -> (encrypt: #password, -salt=#db -> (field: (self -> 'saltfield') ), -cipher=(self -> 'encrypt_cipher') ));
							#validlogin=true;
						/if;
					else: (self -> 'encrypt');
						// use encryption with no salt
						(self -> '_debug_trace') -> (insert: tag_name + ': ' + 'Checking password with encryption, no salt');
						if: bytes: (#db -> (field: (self -> 'passwordfield'))) 
							== bytes: (self -> (encrypt: #password, -cipher=(self -> 'encrypt_cipher')));
							#validlogin=true;
						/if;
					else;
						(self -> '_debug_trace') -> (insert: tag_name + ': ' + 'Checking plain text password');
						if: bytes: (#db -> (field: (self -> 'passwordfield'))) 
							== bytes: #password;
							#validlogin=true;
						/if;
					/if;
				/if;
				if(#validlogin);
					(self -> '_debug_trace') -> (insert: tag_name + ': ' + 'id_user: ' + #db -> (field: (self -> 'useridfield')));
					// store user id
					(self -> 'id_user') = #db -> (field: (self -> 'useridfield'));
					// store all user record fields in data map
					(self -> 'data') = #db -> recorddata;
				/if;
			/if; // #username and #password
		/if; // #force

		if: #validlogin; 
			(self -> '_debug_trace') -> (insert: tag_name + ': ' + 'Valid login');
			(self -> 'loginattempt_count') = 0;
			(self -> 'error_code') = 0; // No error
			// set validlogin to true
			(self -> 'validlogin')=true;
			// log the action TODO
			// store client_fingerprint
			(self -> 'client_fingerprint') = (self -> 'client_fingerprint_expression') -> invoke;
			// if singleuser, store uniqueid in server side storage
		else(!(local('username') -> size && local('password') -> size));
			(self -> 'error_code') = 7502; // Username or password missing
			self -> logout;
		else;
			// TODO:
			// - block username for a while after too many attempts
			(self -> 'loginattempt_count') += 1;
			(self -> 'loginattempt_date') = date; // keep track of when last login attempt happened
			(self -> '_debug_trace') -> (insert: tag_name + ': ' + 'Invalid login (' +  (self -> 'loginattempt_count') + ' attempts)');
			(self -> 'error_code') = 7501; // Authentication failed
			self -> logout;
			// exit
		/if;

		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;
	
	
	define_tag: 'logout'; 
		local: 'timer'=knop_timer; 
		// set validlogin to false
		(self -> 'validlogin')=false;
		(self -> 'id_user') = null;
		(self -> 'data') = map;
		(self -> 'permissions') = map;
		
		// clear all record locks
		self -> clearlocks;
		// log the action

		(self -> '_debug_trace') -> (insert: tag_name + ': ' + 'Logged out');
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;

	define_tag: 'getdata', -description='Get field data from the data map.',
		-required='field';
		if: (self -> 'data') >> #field;
			return: (self -> 'data') -> (find: #field);
		else;
			(self -> '_debug_trace') -> insert(tag_name + ': ' + #field + ' not known');
		/if;
	/define_tag;

	define_tag: 'removedata', -description='Remove field from the data map.',
		-required='field';
		if: (self -> 'data') >> #field;
			(self -> 'data') -> (remove: #field);
		else;
			(self -> '_debug_trace') -> insert(tag_name + ': ' + #field + ' not known');
		/if;
	/define_tag;

	define_tag: 'id_user', -description='Return the user id';
		if: self -> auth;
			return: (self -> 'id_user');
		else;
			return: false;
		/if;
	/define_tag;

	define_tag: 'setdata', -description='Set field data in the data map. Either -> (setdata: -field=\'fieldname\', -value=\'value\') or -> (setdata: \'fieldname\'=\'value\')',
		-required='field', -copy,	// can also be a pair with field=value
		-optional='value', -copy;
		local: 'timer'=knop_timer; 
		if: #field -> isa('pair');
			local: 'value'=#field -> value;
			#field = #field -> name;
		/if;
		fail_if: !(local_defined: 'value'), -1, (self -> type) '->setdata requires a value parameter';
		(self -> 'data') -> insert(#field = #value);
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;
	
	define_tag: 'getpermission', -description='Returns true if user has permission to perform the specified action, false otherwise',
		-required='permission';
		if((self -> auth) && (self -> 'permissions') >> #permission);
			return((self -> 'permissions') -> find(#permission));
		else;
			return(false);
		/if;
	/define_tag;

	define_tag: 'setpermission', -description='Sets the user\'s permission to perform the specified action (true or false, or just the name of the permission)',
		-required='permission',
		-optional='value';
		if(local_defined('value') && #value != false); // any non-false value is regarded as true
			(self -> 'permissions') -> insert(#permission=true);
		else(local_defined('value') && #value == false); // explicit false
			(self -> 'permissions') -> insert(#permission=false);
		else; // no value specified is regarded as true
			(self -> 'permissions') -> insert(#permission=true);
		/if;
	/define_tag;


	define_tag: 'addlock', -description='Called by database object, adds the name of a database object that has been locked by this user.',
		-required='dbname';
		if: (self -> 'dblocks') !>> #dbname && (var: #dbname) -> (isa: 'database');
			(self -> '_debug_trace') -> insert(tag_name + ': adding database name  ' + #dbname);
			(self -> 'dblocks') -> (insert: #dbname);
		/if;
	/define_tag;

	define_tag: 'clearlocks', -description='Clears all database locks that has been set by this user';
		local: 'timer'=knop_timer; 
		if: (self -> auth);
			(self -> '_debug_trace') -> (insert: tag_name + ': ' + (self -> 'dblocks') -> (join: ', '));
			iterate: (self -> 'dblocks'), local: 'dbname';
				if: (var: #dbname) -> (isa: 'database');
					(var: #dbname) -> (clearlocks: -user=(self -> 'id_user'));
					#dbname = null;
				/if;
			/iterate;
			// remove all locks that has been cleared
			(self -> 'dblocks') -> (removeall: null);
			(self -> '_debug_trace') -> (insert: tag_name + ': done, remaining locks: ' + (self -> 'dblocks') -> (join: ', '));
		/if;
		self -> 'tagtime_tagname'=tag_name;
		self -> 'tagtime'=integer: #timer; // cast to integer to trigger onconvert and to "stop timer"
	/define_tag;


	define_tag: 'encrypt', -description='Internal use. Encrypts the input using digest encryption, optionally with salt. ',
		-required='data', -copy,
		-optional='salt',
		-optional='cipher';
		local: 'output'=string;
		!(local_defined: 'cipher') ? local: 'cipher'=self -> 'encrypt_cipher';
		if: (local_defined: 'salt');
			#data = #salt + #data;
		/if;
		if: (Cipher_List: -digest) !>> #cipher;
			// fall back to default digest cipher
			#cipher = 'MD5';
		/if;
		#output = (cipher_digest: #data, -digest=#cipher, -hex);
		return: #output;
	/define_tag;
	
	define_tag: 'keys', -description='Returns all keys for the stored user data';
		return: (self -> 'data') -> keys;
	/define_tag;

/define_type;



?>
