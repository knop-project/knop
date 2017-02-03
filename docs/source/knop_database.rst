=============
knop_database
=============
.. type:: knop_database

   :parent: `knop_base`
   :import: `trait_serializable`

   .. member:: acceptDeserializedElement(d::serialization_element)

      :param serialization_element d:

   .. member:: action_statement()


   .. member:: action_statement=(action_statement::string)::string

      :param string action_statement:
      :rtype: `string`

   .. member:: addrecord(fields::array[, keyvalue, inlinename::string])

      :param array fields:
      :param keyvalue:
      :param string inlinename:

   .. member:: addrecord(-fields::array[, -keyvalue, -inlinename::string])

      :param array -fields:
      :param -keyvalue:
      :param string -inlinename:

   .. member:: affected_count()::integer

      :rtype: `integer`

   .. member:: affected_count=(affected_count::integer)::integer

      :param integer affected_count:
      :rtype: `integer`

   .. member:: affectedrecord_keyvalue()::string

      :rtype: `string`

   .. member:: affectedrecord_keyvalue=(affectedrecord_keyvalue::string)::string

      :param string affectedrecord_keyvalue:
      :rtype: `string`

   .. member:: capturesearchvars()


   .. member:: clearlock(lockvalue::string[, user])

      :param string lockvalue:
      :param user:

   .. member:: clearlock(-lockvalue::string[, -user])

      :param string -lockvalue:
      :param -user:

   .. member:: clearlocks(user)

      :param user:

   .. member:: clearlocks(-user)

      :param -user:

   .. member:: current_record()::integer

      :rtype: `integer`

   .. member:: current_record=(current_record::integer)::integer

      :param integer current_record:
      :rtype: `integer`

   .. member:: database()::string

      :rtype: `string`

   .. member:: database=(database::string)::string

      :param string database:
      :rtype: `string`

   .. member:: databaserows_map()::map

      :rtype: `map`

   .. member:: databaserows_map=(databaserows_map::map)::map

      :param map databaserows_map:
      :rtype: `map`

   .. member:: datasource_name()::string

      :rtype: `string`

   .. member:: datasource_name=(datasource_name::string)::string

      :param string datasource_name:
      :rtype: `string`

   .. member:: db_connect()::array

      :rtype: `array`

   .. member:: db_connect=(db_connect::array)::array

      :param array db_connect:
      :rtype: `array`

   .. member:: db_registry()


   .. member:: db_registry=(db_registry)

      :param db_registry:

   .. member:: deleterecord([keyvalue, lockvalue::string, user])

      :param keyvalue:
      :param string lockvalue:
      :param user:

   .. member:: deleterecord([-keyvalue, -lockvalue::string, -user])

      :param -keyvalue:
      :param string -lockvalue:
      :param -user:

   .. member:: description()::string

      :rtype: `string`

   .. member:: description=(description::string)::string

      :param string description:
      :rtype: `string`

   .. member:: error_code()


   .. member:: error_data()


   .. member:: error_data=(error_data::map)::map

      :param map error_data:
      :rtype: `map`

   .. member:: error_msg([error_code::integer])

      :param integer error_code:

   .. member:: errors_error_data()::map

      :rtype: `map`

   .. member:: errors_error_data=(errors_error_data::map)::map

      :param map errors_error_data:
      :rtype: `map`

   .. member:: field(fieldname::string[, recordindex::integer, index::integer])

      :param string fieldname:
      :param integer recordindex:
      :param integer index:

   .. member:: field_names([table::string, types::boolean])

      :param string table:
      :param boolean types:

   .. member:: field_names=(field_names::array)::array

      :param array field_names:
      :rtype: `array`

   .. member:: field_names_map()::map

      :rtype: `map`

   .. member:: field_names_map=(field_names_map::map)::map

      :param map field_names_map:
      :rtype: `map`

   .. member:: found_count()


   .. member:: found_count=(found_count::integer)::integer

      :param integer found_count:
      :rtype: `integer`

   .. member:: get(index::integer)

      :param integer index:

   .. member:: getrecord([keyvalue, keyfield::string, inlinename::string, lock::boolean, user, sql::string])

      :param keyvalue:
      :param string keyfield:
      :param string inlinename:
      :param boolean lock:
      :param user:
      :param string sql:

   .. member:: getrecord([-keyvalue, -keyfield::string, -inlinename::string, -lock::boolean, -user, -sql::string])

      :param -keyvalue:
      :param string -keyfield:
      :param string -inlinename:
      :param boolean -lock:
      :param -user:
      :param string -sql:

   .. member:: host()::array

      :rtype: `array`

   .. member:: host=(host::array)::array

      :param array host:
      :rtype: `array`

   .. member:: inlinename()


   .. member:: inlinename=(inlinename::string)::string

      :param string inlinename:
      :rtype: `string`

   .. member:: isfilemaker()::boolean

      :rtype: `boolean`

   .. member:: isfilemaker=(isfilemaker::boolean)::boolean

      :param boolean isfilemaker:
      :rtype: `boolean`

   .. member:: keyfield()


   .. member:: keyfield=(keyfield::string)::string

      :param string keyfield:
      :rtype: `string`

   .. member:: keyvalue()


   .. member:: keyvalue=(keyvalue)

      :param keyvalue:

   .. member:: lock_expires()::integer

      :rtype: `integer`

   .. member:: lock_expires=(lock_expires::integer)::integer

      :param integer lock_expires:
      :rtype: `integer`

   .. member:: lock_seed()::string

      :rtype: `string`

   .. member:: lock_seed=(lock_seed::string)::string

      :param string lock_seed:
      :rtype: `string`

   .. member:: lockfield()


   .. member:: lockfield=(lockfield::string)::string

      :param string lockfield:
      :rtype: `string`

   .. member:: lockvalue()


   .. member:: lockvalue=(lockvalue::string)::string

      :param string lockvalue:
      :rtype: `string`

   .. member:: lockvalue_encrypted()


   .. member:: lockvalue_encrypted=(lockvalue_encrypted::string)::string

      :param string lockvalue_encrypted:
      :rtype: `string`

   .. member:: maxrecords_value()


   .. member:: maxrecords_value=(maxrecords_value)

      :param maxrecords_value:

   .. member:: message()::string

      :rtype: `string`

   .. member:: message=(message::string)::string

      :param string message:
      :rtype: `string`

   .. member:: next()


   .. member:: not_unknownTag([...])

      :param ...:

   .. member:: oncreate(database::string, table::string[, host::array, username::string, password::string, keyfield::string, lockfield::string, user, validate::boolean])

      :param string database:
      :param string table:
      :param array host:
      :param string username:
      :param string password:
      :param string keyfield:
      :param string lockfield:
      :param user:
      :param boolean validate:

   .. member:: oncreate(-database::string, -table::string[, -host::array, -username::string, -password::string, -keyfield::string, -lockfield::string, -user, -validate::boolean])

      :param string -database:
      :param string -table:
      :param array -host:
      :param string -username:
      :param string -password:
      :param string -keyfield:
      :param string -lockfield:
      :param -user:
      :param boolean -validate:

   .. member:: oncreate(database::string, table::string[, -host::array, -username::string, -password::string, -keyfield::string, -lockfield::string, -user, -validate::boolean])

      :param string database:
      :param string table:
      :param array -host:
      :param string -username:
      :param string -password:
      :param string -keyfield:
      :param string -lockfield:
      :param -user:
      :param boolean -validate:

   .. member:: password()::string

      :rtype: `string`

   .. member:: password=(password::string)::string

      :param string password:
      :rtype: `string`

   .. member:: querytime()


   .. member:: querytime=(querytime::integer)::integer

      :param integer querytime:
      :rtype: `integer`

   .. member:: recorddata([recordindex::integer])

      :param integer recordindex:

   .. member:: recorddata=(recorddata::map)::map

      :param map recorddata:
      :rtype: `map`

   .. member:: records([inlinename::string])

      :param string inlinename:

   .. member:: records([-inlinename::string])

      :param string -inlinename:

   .. member:: records_array()


   .. member:: records_array=(records_array::staticarray)::staticarray

      :param staticarray records_array:
      :rtype: `staticarray`

   .. member:: reset()


   .. member:: resultset_count([inlinename::string])

      :param string inlinename:

   .. member:: resultset_count_map()::map

      :rtype: `map`

   .. member:: resultset_count_map=(resultset_count_map::map)::map

      :param map resultset_count_map:
      :rtype: `map`

   .. member:: saverecord(fields::array[, keyfield::string, keyvalue, lockvalue, keeplock::boolean, user, inlinename::string])

      :param array fields:
      :param string keyfield:
      :param keyvalue:
      :param lockvalue:
      :param boolean keeplock:
      :param user:
      :param string inlinename:

   .. member:: saverecord(-fields::array[, -keyfield::string, -keyvalue, -lockvalue, -keeplock::boolean, -user, -inlinename::string])

      :param array -fields:
      :param string -keyfield:
      :param -keyvalue:
      :param -lockvalue:
      :param boolean -keeplock:
      :param -user:
      :param string -inlinename:

   .. member:: scrubKeywords(input::trait_queriable)::trait_foreach

      :param trait_queriable input:
      :rtype: `trait_foreach`

   .. member:: scrubKeywords(input)

      :param input:

   .. member:: searchparams()


   .. member:: searchparams=(searchparams::array)::array

      :param array searchparams:
      :rtype: `array`

   .. member:: select(search::array, sql::string[, keyfield::string, keyvalue, inlinename::string])

      :param array search:
      :param string sql:
      :param string keyfield:
      :param keyvalue:
      :param string inlinename:

   .. member:: select([-search::array, -sql::string, -keyfield::string, -keyvalue, -inlinename::string])

      :param array -search:
      :param string -sql:
      :param string -keyfield:
      :param -keyvalue:
      :param string -inlinename:

   .. member:: serializationElements()


   .. member:: sethost(host::array)

      :param array host:

   .. member:: settable(table::string)

      :param string table:

   .. member:: shown_count()


   .. member:: shown_count=(shown_count::integer)::integer

      :param integer shown_count:
      :rtype: `integer`

   .. member:: shown_first()


   .. member:: shown_first=(shown_first::integer)::integer

      :param integer shown_first:
      :rtype: `integer`

   .. member:: shown_last()


   .. member:: shown_last=(shown_last::integer)::integer

      :param integer shown_last:
      :rtype: `integer`

   .. member:: size()


   .. member:: skiprecords_value()


   .. member:: skiprecords_value=(skiprecords_value::integer)::integer

      :param integer skiprecords_value:
      :rtype: `integer`

   .. member:: table()::string

      :rtype: `string`

   .. member:: table=(table::string)::string

      :param string table:
      :rtype: `string`

   .. member:: table_names()


   .. member:: timestampfield()::string

      :rtype: `string`

   .. member:: timestampfield=(timestampfield::string)::string

      :param string timestampfield:
      :rtype: `string`

   .. member:: timestampvalue()::string

      :rtype: `string`

   .. member:: timestampvalue=(timestampvalue::string)::string

      :param string timestampvalue:
      :rtype: `string`

   .. member:: user()


   .. member:: user=(user)

      :param user:

   .. member:: username()::string

      :rtype: `string`

   .. member:: username=(username::string)::string

      :param string username:
      :rtype: `string`

.. type:: knop_databaserow


   .. member:: field(fieldname::string[, index::integer])

      :param string fieldname:
      :param integer index:

   .. member:: field_names()::array

      :rtype: `array`

   .. member:: field_names=(field_names::array)::array

      :param array field_names:
      :rtype: `array`

   .. member:: onconvert()


   .. member:: oncreate(record_array::staticarray, field_names::array)

      :param staticarray record_array:
      :param array field_names:

   .. member:: oncreate(-record_array::staticarray, -field_names::array)

      :param staticarray -record_array:
      :param array -field_names:

   .. member:: record_array()::staticarray

      :rtype: `staticarray`

   .. member:: record_array=(record_array::staticarray)::staticarray

      :param staticarray record_array:
      :rtype: `staticarray`

.. type:: knop_databaserows


   .. member:: current_record()::integer

      :rtype: `integer`

   .. member:: current_record=(current_record::integer)::integer

      :param integer current_record:
      :rtype: `integer`

   .. member:: description()::string

      :rtype: `string`

   .. member:: description=(description::string)::string

      :param string description:
      :rtype: `string`

   .. member:: field(fieldname::string[, recordindex::integer, index::integer])

      :param string fieldname:
      :param integer recordindex:
      :param integer index:

   .. member:: field_names()::array

      :rtype: `array`

   .. member:: field_names=(field_names::array)::array

      :param array field_names:
      :rtype: `array`

   .. member:: field_names_map()::map

      :rtype: `map`

   .. member:: field_names_map=(field_names_map::map)::map

      :param map field_names_map:
      :rtype: `map`

   .. member:: get(index::integer)

      :param integer index:

   .. member:: next()


   .. member:: onconvert([recordindex::integer])

      :param integer recordindex:

   .. member:: oncreate(records_array::staticarray, field_names::array)

      :param staticarray records_array:
      :param array field_names:

   .. member:: records_array()::staticarray

      :rtype: `staticarray`

   .. member:: records_array=(records_array::staticarray)::staticarray

      :param staticarray records_array:
      :rtype: `staticarray`

   .. member:: size()


   .. member:: summary_footer(fieldname::string)

      :param string fieldname:

   .. member:: summary_header(fieldname::string)

      :param string fieldname:
