knop_user
=========

.. class:: knop_user

    Purpose:
    	- Maintain user identity and authentication
    
    	- Handle database record locking more intelligently, also to be able to release all unused locks for a user
    
    	- Authenticating user login
    
    	- Restricting access to data
    
    	- Displaying specific navigation options depending on type of user
    
    lets add some date handling in there too like time of last login
    and probably the IP that the user logged in from.
    
    
    Some options to handle what happens when a user logs in again whilst already logged in.
    ie one could:
    
    	- disallow second login (with a message explaining why)
    
    	- automatically log the first session out (with a message indicating what happened)
    
    	- send a message to first session: "Your username is attempting to log in again, do you wish to close this session, or deny the second login attempt?"
    
    	- allow multiple logins (from the same IP address)
    
    	- allow multiple logins from any IP address
    
    All of these could be useful options, depending of the type of app.
    
    And different types of user (ie normal, admin) could have different types of treatment.
    
    Handling for failed login attempts:
    
    	- Option to set how many tries can be attempted;
    	- Option to lock users out permanently after x failed attempts?
    	- Logging (to database) of failed logins / successful logins
    
    Password recovery system (ie emailing a time sensitive link to re-set password)
    By "password recovery" I'm not thinking "email my password" (hashed passwords can't be emailed...) but rather to email a short lived link that gives the user an opportunity to change his password. How is this different from "password reset"?
    Yes, that is an accurate description of what I had in mind, except for the bit about emailing a short-lived link.  Instead I imagined having the user reset their password 100% on the web site through the use of "Security Questions", much like banks employ.
    
    I like the idea of more info attached to the user. Like login attempts, locking a user temporarily after too many failed attempts etc.
    
    
    The setup is more or less that I have users and groups.
    
    I'm thinking that Knop shouldn't do any session handling by itself, but the knop_user variable would be stored in the app's session as any other variable. Knop should stay as lean as possible...
    
    Other things to handle:
    
    	- Prevent session sidejacking by storing and comparing the user's ip and other identifying properties.
    
    	- Provide safe password handling with strong one-way salted encryption.
    
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
    
    
    .. method:: _unknowntag(...)

    .. method:: acceptDeserializedElement(d::serialization_element)

        Called when a knop_user object is retrieved from a session
        
    .. method:: addlock(-dbname)

    .. method:: addlock(dbname)

        Called by database object, adds the name of a database object that has been locked by this user.
        
    .. method:: allowsidejacking()

    .. method:: allowsidejacking=(allowsidejacking::boolean)

    .. method:: auth()

        Checks if user is authenticated, returns true/false
        
    .. method:: clearlocks()

        Clears all database locks that has been set by this user.
        
    .. method:: client_fingerprint()

    .. method:: client_fingerprint=(client_fingerprint::string)

    .. method:: client_fingerprint_expression()

        Returns an encrypted fingerprint based on client_ip and client_type.
        
    .. method:: cost()

    .. method:: cost=(cost::boolean)

    .. method:: costfield()

    .. method:: costfield=(costfield::string)

    .. method:: costsize()

    .. method:: costsize=(costsize::integer)

    .. method:: data()

    .. method:: data=(data::map)

    .. method:: dblocks()

    .. method:: dblocks=(dblocks::set)

    .. method:: description()

    .. method:: description=(description)

    .. method:: encrypt()

    .. method:: encrypt=(encrypt::boolean)

    .. method:: encrypt_cipher()

    .. method:: encrypt_cipher=(encrypt_cipher::string)

    .. method:: fields()

    .. method:: fields=(fields::array)

    .. method:: getdata(field::string)

        Get field data from the data map
        
    .. method:: getpermission(permission::string)

        Returns true if user has permission to perform the specified action, false otherwise
        
    .. method:: groups()

    .. method:: groups=(groups::array)

    .. method:: id_user()

        Return the user id
        
    .. method:: id_user=(id_user)

    .. method:: keys()

        Returns all keys for the stored user data.
        
    .. method:: logdatafield()

    .. method:: logdatafield=(logdatafield::string)

    .. method:: logdb()

    .. method:: logdb=(logdb::knop_database)

    .. method:: logeventfield()

    .. method:: logeventfield=(logeventfield::string)

    .. method:: login(-username =?, -password =?, -searchparams::array =?, -force::string =?)

    .. method:: login(username =?, password =?, searchparams::array =?, force::string =?)

        Log in user. On successful login, all fields on the user record will be available by -> getdata.
        
        Parameters:
        	- username (required)
        	  Optional if -force is specified
        
        	- password (required)
        	  Optional if -force is specified
        
        	- searchparams (optional)
        	  Extra search params array to use in combination with username and password
        
        	- force (optional)
        	  Supply a user id for a manually authenticated user if custom authentication logics is needed
        
    .. method:: loginattempt_count()

    .. method:: loginattempt_count=(loginattempt_count::integer)

    .. method:: loginattempt_date()

    .. method:: loginattempt_date=(loginattempt_date::date)

    .. method:: logobjectfield()

    .. method:: logobjectfield=(logobjectfield::string)

    .. method:: logout()

        Logout the user
        
    .. method:: loguserfield()

    .. method:: loguserfield=(loguserfield::string)

    .. method:: oncreate(-userdb::knop_database, -encrypt =?, -cost =?, -useridfield::string =?, -userfield::string =?, -passwordfield::string =?, -saltfield::string =?, -costfield::string =?, -logdb =?, -loguserfield::string =?, -logeventfield::string =?, -logobjectfield::string =?, -logdatafield::string =?, -singleuser::boolean =?, -allowsidejacking::boolean =?)

    .. method:: oncreate(userdb::knop_database, encrypt =?, cost =?, useridfield::string =?, userfield::string =?, passwordfield::string =?, saltfield::string =?, costfield::string =?, logdb =?, loguserfield::string =?, logeventfield::string =?, logobjectfield::string =?, logdatafield::string =?, singleuser::boolean =?, allowsidejacking::boolean =?)

        Parameters:
        	- encrypt (optional flag or string)
        	  Use encrypted passwords. If a value is specified then that cipher will be used
        	  instead of the default RIPEMD160. If -saltfield is specified then the value of
        	  that field will be used as salt.
        
        	- singleuser (optional flag)
        	  Multiple logins to the same account are prevented (not implemented)
        
    .. method:: passwordfield()

    .. method:: passwordfield=(passwordfield::string)

    .. method:: permissions()

    .. method:: permissions=(permissions::map)

    .. method:: removedata(field::string)

        Remove field data from the data map
        
    .. method:: saltfield()

    .. method:: saltfield=(saltfield::string)

    .. method:: serializationElements()

        Called when a knop_user object is stored in a session
        
    .. method:: setdata(field, value =?)

        Set field data in the data map. Either -> setdata(-field='fieldname', -value='value') or -> setdata('fieldname'='value')
        
    .. method:: setpermission(permission::string, value =?)

        Sets the user\'s permission to perform the specified action (true or false, or just the name of the permission
        
    .. method:: singleuser()

    .. method:: singleuser=(singleuser::boolean)

    .. method:: uniqueid()

    .. method:: uniqueid=(uniqueid::string)

    .. method:: userdb()

    .. method:: userdb=(userdb::knop_database)

    .. method:: userfield()

    .. method:: userfield=(userfield::string)

    .. method:: useridfield()

    .. method:: useridfield=(useridfield::string)

    .. method:: validlogin()

    .. method:: validlogin=(validlogin::boolean)

    .. method:: version()

    .. method:: version=(version)

