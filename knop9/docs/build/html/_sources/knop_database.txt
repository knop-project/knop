knop_database
=============

.. class:: knop_database

    Custom type to interact with databases. Supports both MySQL and FileMaker datasources
    Lasso 9 version
    
    .. method:: _unknowntag(...)

        Shortcut to field
        
    .. method:: acceptDeserializedElement(d::serialization_element)

        Called when a knop_database object is retrieved from a session
        
    .. method:: action_statement()

    .. method:: action_statement=(action_statement::string)

    .. method:: addrecord(-fields::array, -keyvalue::string =?, -inlinename::string =?)

    .. method:: addrecord(fields::array, keyvalue::string =?, inlinename::string =?)

        Add a new record to the database. A random string keyvalue will be generated
        unless a -keyvalue is specified.
        
        Parameters:
        	- fields (required array)
        
        		Lasso-style field values in pair array
        
        	- keyvalue (optional)
        
        		If -keyvalue is specified, it must not already exist in the database. Specify -keyvalue = false to prevent generating a keyvalue.
        
        	- inlinename (optional)
        
        		Defaults to autocreated inlinename.
        
        
    .. method:: affected_count()

    .. method:: affected_count=(affected_count::integer)

    .. method:: affectedrecord_keyvalue()

    .. method:: affectedrecord_keyvalue=(affectedrecord_keyvalue::string)

    .. method:: capturesearchvars()

        capturesearchvars Internal.
        
    .. method:: clearlocks(-user)

    .. method:: clearlocks(user)

        Release all record locks for the specified user, suitable to use when showing
        record list.
        
        Parameters:
        	- user (required)
        
        		The user to unlock records for.
        
    .. method:: current_record()

    .. method:: current_record=(current_record::integer)

    .. method:: database()

    .. method:: database=(database::string)

    .. method:: databaserows_map()

    .. method:: databaserows_map=(databaserows_map::map)

    .. method:: datasource_name()

    .. method:: datasource_name=(datasource_name::string)

    .. method:: db_connect()

    .. method:: db_connect=(db_connect::array)

    .. method:: db_registry()

    .. method:: db_registry=(db_registry)

    .. method:: deleterecord(-keyvalue::string =?, -lockvalue::string =?, -user =?)

    .. method:: deleterecord(keyvalue::string =?, lockvalue::string =?, user =?)

        Deletes a specific database record.
        
        Parameters:
        	- keyvalue (optional)
        
        		Keyvalue is ignored if lockvalue is specified
        
        	- lockvalue (optional)
        
        		Either keyvalue or lockvalue must be specified
        
        	- user (optional)
        
        		If lockvalue is specified, user must be specified as well.
        
    .. method:: description()

    .. method:: description=(description::string)

    .. method:: error_code()

        varname Returns the name of the variable that this type instance is stored in.
        
    .. method:: error_data()

        Returns more info for those errors that provide such.
        
    .. method:: error_data=(error_data::map)

    .. method:: error_msg(error_code::integer =?)

    .. method:: errors_error_data()

    .. method:: errors_error_data=(errors_error_data::map)

    .. method:: field(fieldname::string, recordindex::integer =?, index::integer =?)

        A shortcut to return a specific field from a single record result.
        
    .. method:: field_names(table::string =?, types::boolean =?)

        Returns an array of the field names from the last database query. If no database
        query has been performed, a "-show" request is performed.
        
        Parameters:
        	- table (optional)
        
        		Return the field names for the specified table
        
        	- types (optional flag)
        
        		If specified, returns a pair array with fieldname and corresponding Lasso data type.
        
        
    .. method:: field_names=(field_names::array)

    .. method:: field_names_map()

    .. method:: field_names_map=(field_names_map::map)

    .. method:: found_count()

    .. method:: found_count=(found_count::integer)

    .. method:: get(index::integer)

    .. method:: getrecord(-keyvalue::string =?, -keyfield::string =?, -inlinename::string =?, -lock::boolean =?, -user =?, -sql::string =?)

    .. method:: getrecord(keyvalue::string =?, keyfield::string =?, inlinename::string =?, lock::boolean =?, user =?, sql::string =?)

        Returns a single specific record from the database, optionally locking the 
        record. If the keyvalue matches multiple records, an error is returned.
        
        Parameters:
        	- keyvalue (optional)
        
        		Uses a previously set keyvalue if not specified. If no keyvalue is available, an error is returned unless -sql is used.
        
        	- keyfield (optional)
        
        		Temporarily override of keyfield specified at oncreate
        
        	- inlinename (optional)
        
        		Defaults to autocreated inlinename
        
        	- lock (optional flag)
        
        		If flag is specified, a record lock will be set
        
        	- user (optional)
        
        		The user who is locking the record (required if using lock)
        
        	- sql (optional)
        
        		SQL statement to use instead of keyvalue. Must include the keyfield (and lockfield if locking is used).
        
        
    .. method:: host()

    .. method:: host=(host::array)

    .. method:: inlinename()

    .. method:: inlinename=(inlinename::string)

    .. method:: isfilemaker()

    .. method:: isfilemaker=(isfilemaker::boolean)

    .. method:: keyfield()

    .. method:: keyfield=(keyfield::string)

    .. method:: keyvalue()

    .. method:: keyvalue=(keyvalue::string)

    .. method:: lock_expires()

    .. method:: lock_expires=(lock_expires::integer)

    .. method:: lock_seed()

    .. method:: lock_seed=(lock_seed::string)

    .. method:: lockfield()

    .. method:: lockfield=(lockfield::string)

    .. method:: lockvalue()

    .. method:: lockvalue=(lockvalue::string)

    .. method:: lockvalue_encrypted()

    .. method:: lockvalue_encrypted=(lockvalue_encrypted::string)

    .. method:: maxrecords_value()

    .. method:: maxrecords_value=(maxrecords_value)

    .. method:: message()

    .. method:: message=(message::string)

    .. method:: next()

        Increments the record pointer, returns true if there are more records to show,
        false otherwise.
        
        Useful as an alternative to a regular records loop::
        
        	$database -> select;
        	while($database -> next);
        		$database -> field( \'name\');\'<br>\';
        	/while;
        
    .. method:: oncreate(-database::string, -table::string, -host::array =?, -username::string =?, -password::string =?, -keyfield::string =?, -lockfield::string =?, -user =?, -validate::boolean =?)

    .. method:: oncreate(database::string, table::string, -host::array =?, -username::string =?, -password::string =?, -keyfield::string =?, -lockfield::string =?, -user =?, -validate::boolean =?)

    .. method:: oncreate(database::string, table::string, host::array =?, username::string =?, password::string =?, keyfield::string =?, lockfield::string =?, user =?, validate::boolean =?)

    .. method:: password()

    .. method:: password=(password::string)

    .. method:: querytime()

    .. method:: querytime=(querytime::integer)

    .. method:: recorddata(recordindex::integer =?)

        A map containing all fields, only available for single record results.
        
    .. method:: recorddata=(recorddata::map)

    .. method:: records(-inlinename::string =?)

    .. method:: records(inlinename::string =?)

        Returns all found records as a knop_databaserows object.
        
    .. method:: records_array()

    .. method:: records_array=(records_array::staticarray)

    .. method:: reset()

    .. method:: resultset_count(inlinename::string =?)

    .. method:: resultset_count_map()

    .. method:: resultset_count_map=(resultset_count_map::map)

    .. method:: saverecord(-fields::array, -keyfield::string =?, -keyvalue::string =?, -lockvalue::string =?, -keeplock::boolean =?, -user =?, -inlinename::string =?)

    .. method:: saverecord(fields::array, keyfield::string =?, keyvalue::string =?, lockvalue::string =?, keeplock::boolean =?, user =?, inlinename::string =?)

        Updates a specific database record.
        
        Parameters:
        	- fields (required array)
        
        		Lasso-style field values in pair array
        
        	- keyfield (optional)
        
        		Keyfield is ignored if lockvalue is specified
        
        	- keyvalue (optional)
        
        		Keyvalue is ignored if lockvalue is specified
        
        	- lockvalue (optional)
        
        		Either keyvalue or lockvalue must be specified
        
        	- keeplock (optional flag)
        
        		Avoid clearing the record lock when saving. Updates the lock timestamp.
        
        	- user (optional)
        
        		If lockvalue is specified, user must be specified as well
        
        	- inlinename (optional)
        
        		Defaults to autocreated inlinename.
        
        
    .. method:: scrubKeywords(input)

    .. method:: scrubKeywords(input::trait_queriable)

    .. method:: searchparams()

    .. method:: searchparams=(searchparams::array)

    .. method:: select(-search::array =?, -sql::string =?, -keyfield::string =?, -keyvalue::string =?, -inlinename::string =?)

    .. method:: select(search::array =?, sql::string =?, keyfield::string =?, keyvalue =?, inlinename::string =?)

        perform database query, either Lasso-style pair array or SQL statement.
        ->recorddata returns a map with all the fields for the first found record. If
        multiple records are returned, the records can be accessed either through 
        ->inlinename or ->records_array.
        
        Parameters:
        	- search (optional array)
        	
        		Lasso-style search parameters in pair array
        
        	- sql (optional string)
        	
        		Raw sql query
        
        	- keyfield (optional)
        	 
        	 	Overrides default keyfield, if any
        
        	- keyvalue (optional)
        
        	- inlinename (optional)
        
        		Defaults to autocreated inlinename
        
        
    .. method:: serializationElements()

        Called when a knop_database object is stored in a session
        
    .. method:: sethost(host::array)

        Creates or changes the DB inline host setting.
        
    .. method:: settable(table::string)

        Changes the current table for a database object. Useful to be able to create
        database objects faster by copying an existing object and just change the table
        name. This is a little bit faster than creating a new instance from scratch, but
        no table validation is performed. Only do this to add database objects for 
        tables within the same database as the original database object.
        
    .. method:: shown_count()

    .. method:: shown_count=(shown_count::integer)

    .. method:: shown_first()

    .. method:: shown_first=(shown_first::integer)

    .. method:: shown_last()

    .. method:: shown_last=(shown_last::integer)

    .. method:: size()

    .. method:: skiprecords_value()

    .. method:: skiprecords_value=(skiprecords_value::integer)

    .. method:: table()

    .. method:: table=(table::string)

    .. method:: table_names()

        Returns an array with all table names for the database.
        
    .. method:: timestampfield()

    .. method:: timestampfield=(timestampfield::string)

    .. method:: timestampvalue()

    .. method:: timestampvalue=(timestampvalue::string)

    .. method:: user()

    .. method:: user=(user)

    .. method:: username()

    .. method:: username=(username::string)

    .. method:: version()

    .. method:: version=(version)

.. class:: knop_databaserows

    Custom type to return all record rows from knop_database. Used as output for knop_database->records
    Lasso 9 version
    
    .. method:: current_record()

    .. method:: current_record=(current_record::integer)

    .. method:: description()

    .. method:: description=(description::string)

    .. method:: field(fieldname::string, recordindex::integer =?, index::integer =?)

        Return an individual field value.
        
    .. method:: field_names()

    .. method:: field_names=(field_names::array)

    .. method:: field_names_map()

    .. method:: field_names_map=(field_names_map::map)

    .. method:: get(index::integer)

    .. method:: next()

        Increments the record pointer, returns true if there are more records to show, false otherwise.
        
    .. method:: onconvert(recordindex::integer =?)

        Output the current record as a plain array of field values.
        
    .. method:: oncreate(records_array::staticarray, field_names::array)

        Create a record rows object.
        
        Parameters:
        	- records_array (array)
        
        		Array of arrays with field values for all fields for each record of all found records
        
        	- field_names (array)
        
        		Array with all the field names
        
    .. method:: records_array()

    .. method:: records_array=(records_array::staticarray)

    .. method:: size()

    .. method:: summary_footer(fieldname::string)

        Returns true if the specified field name will change in the following record, or
        if we are at the last record.
        
    .. method:: summary_header(fieldname::string)

        Returns true if the specified field name has changed since the previous record,
        or if we are at the first record.
        
    .. method:: version()

    .. method:: version=(version::date)

.. class:: knop_databaserow

    Custom type to return individual record rows from knop_database. Used as output for knop_database->get
    Lasso 9 version
    
    .. method:: description()

    .. method:: description=(description::string)

    .. method:: field(fieldname::string, index::integer =?)

        Return an individual field value.
        
    .. method:: field_names()

    .. method:: field_names=(field_names::array)

    .. method:: onconvert()

        Output the record as a plain array of field values.
        
    .. method:: oncreate(-record_array::staticarray, -field_names::array)

    .. method:: oncreate(record_array::staticarray, field_names::array)

        Create a record row object.
        
        Parameters:
        	- record_array (array)
        
        		Array with field values for all fields for the record
        
        	- field_names (array)
        
        		Array with all the field names, should be same size as -record_array
        
    .. method:: record_array()

    .. method:: record_array=(record_array::staticarray)

    .. method:: version()

    .. method:: version=(version::date)

