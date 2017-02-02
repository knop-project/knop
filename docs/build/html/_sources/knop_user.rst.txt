=========
knop_user
=========
.. type:: knop_user

   :parent: `knop_base`
   :import: `trait_serializable`

   .. member:: acceptDeserializedElement(d::serialization_element)

      :param serialization_element d:

   .. member:: addlock(dbname)

      :param dbname:

   .. member:: addlock(-dbname)

      :param -dbname:

   .. member:: allowsidejacking()::boolean

      :rtype: `boolean`

   .. member:: allowsidejacking=(allowsidejacking::boolean)::boolean

      :param boolean allowsidejacking:
      :rtype: `boolean`

   .. member:: auth()


   .. member:: clearlocks()


   .. member:: client_fingerprint()::string

      :rtype: `string`

   .. member:: client_fingerprint=(client_fingerprint::string)::string

      :param string client_fingerprint:
      :rtype: `string`

   .. member:: client_fingerprint_expression()


   .. member:: cost()::boolean

      :rtype: `boolean`

   .. member:: cost=(cost::boolean)::boolean

      :param boolean cost:
      :rtype: `boolean`

   .. member:: costfield()::string

      :rtype: `string`

   .. member:: costfield=(costfield::string)::string

      :param string costfield:
      :rtype: `string`

   .. member:: costsize()::integer

      :rtype: `integer`

   .. member:: costsize=(costsize::integer)::integer

      :param integer costsize:
      :rtype: `integer`

   .. member:: data()::map

      :rtype: `map`

   .. member:: data=(data::map)::map

      :param map data:
      :rtype: `map`

   .. member:: dblocks()::set

      :rtype: `set`

   .. member:: dblocks=(dblocks::set)::set

      :param set dblocks:
      :rtype: `set`

   .. member:: description()


   .. member:: description=(description)

      :param description:

   .. member:: encrypt()::boolean

      :rtype: `boolean`

   .. member:: encrypt=(encrypt::boolean)::boolean

      :param boolean encrypt:
      :rtype: `boolean`

   .. member:: encrypt_cipher()::string

      :rtype: `string`

   .. member:: encrypt_cipher=(encrypt_cipher::string)::string

      :param string encrypt_cipher:
      :rtype: `string`

   .. member:: fields()::array

      :rtype: `array`

   .. member:: fields=(fields::array)::array

      :param array fields:
      :rtype: `array`

   .. member:: getdata(field::string)

      :param string field:

   .. member:: getpermission(permission::string)

      :param string permission:

   .. member:: getpermission(permissions::array[, -any::boolean, -all::boolean])

      :param array permissions:
      :param boolean -any:
      :param boolean -all:

   .. member:: groups()::array

      :rtype: `array`

   .. member:: groups=(groups::array)::array

      :param array groups:
      :rtype: `array`

   .. member:: id_user()


   .. member:: id_user=(id_user)

      :param id_user:

   .. member:: keys()


   .. member:: logdatafield()::string

      :rtype: `string`

   .. member:: logdatafield=(logdatafield::string)::string

      :param string logdatafield:
      :rtype: `string`

   .. member:: logdb()::knop_database

      :rtype: `knop_database`

   .. member:: logdb=(logdb::knop_database)::knop_database

      :param knop_database logdb:
      :rtype: `knop_database`

   .. member:: logeventfield()::string

      :rtype: `string`

   .. member:: logeventfield=(logeventfield::string)::string

      :param string logeventfield:
      :rtype: `string`

   .. member:: login(username::string, password[, searchparams::array, force])

      :param string username:
      :param password:
      :param array searchparams:
      :param force:

   .. member:: login([-username, -password, -searchparams::array, -force])

      :param -username:
      :param -password:
      :param array -searchparams:
      :param -force:

   .. member:: loginattempt_count()::integer

      :rtype: `integer`

   .. member:: loginattempt_count=(loginattempt_count::integer)::integer

      :param integer loginattempt_count:
      :rtype: `integer`

   .. member:: loginattempt_date()::date

      :rtype: `date`

   .. member:: loginattempt_date=(loginattempt_date::date)::date

      :param date loginattempt_date:
      :rtype: `date`

   .. member:: logobjectfield()::string

      :rtype: `string`

   .. member:: logobjectfield=(logobjectfield::string)::string

      :param string logobjectfield:
      :rtype: `string`

   .. member:: logout()


   .. member:: loguserfield()::string

      :rtype: `string`

   .. member:: loguserfield=(loguserfield::string)::string

      :param string loguserfield:
      :rtype: `string`

   .. member:: not_unknownTag([...])

      :param ...:

   .. member:: oncreate(userdb::knop_database[, encrypt, cost, useridfield::string, userfield::string, passwordfield::string, saltfield::string, costfield::string, logdb, loguserfield::string, logeventfield::string, logobjectfield::string, logdatafield::string, singleuser::boolean, allowsidejacking::boolean])

      :param knop_database userdb:
      :param encrypt:
      :param cost:
      :param string useridfield:
      :param string userfield:
      :param string passwordfield:
      :param string saltfield:
      :param string costfield:
      :param logdb:
      :param string loguserfield:
      :param string logeventfield:
      :param string logobjectfield:
      :param string logdatafield:
      :param boolean singleuser:
      :param boolean allowsidejacking:

   .. member:: oncreate(-userdb::knop_database[, -encrypt, -cost, -useridfield::string, -userfield::string, -passwordfield::string, -saltfield::string, -costfield::string, -logdb, -loguserfield::string, -logeventfield::string, -logobjectfield::string, -logdatafield::string, -singleuser::boolean, -allowsidejacking::boolean])

      :param knop_database -userdb:
      :param -encrypt:
      :param -cost:
      :param string -useridfield:
      :param string -userfield:
      :param string -passwordfield:
      :param string -saltfield:
      :param string -costfield:
      :param -logdb:
      :param string -loguserfield:
      :param string -logeventfield:
      :param string -logobjectfield:
      :param string -logdatafield:
      :param boolean -singleuser:
      :param boolean -allowsidejacking:

   .. member:: passwordfield()::string

      :rtype: `string`

   .. member:: passwordfield=(passwordfield::string)::string

      :param string passwordfield:
      :rtype: `string`

   .. member:: permissions()::map

      :rtype: `map`

   .. member:: permissions=(permissions::map)::map

      :param map permissions:
      :rtype: `map`

   .. member:: removedata(field::string)

      :param string field:

   .. member:: saltfield()::string

      :rtype: `string`

   .. member:: saltfield=(saltfield::string)::string

      :param string saltfield:
      :rtype: `string`

   .. member:: serializationElements()


   .. member:: setdata(field::string, value)

      :param string field:
      :param value:

   .. member:: setdata(valuepair::pair)

      :param pair valuepair:

   .. member:: setpermission(permission::string[, value])

      :param string permission:
      :param value:

   .. member:: singleuser()::boolean

      :rtype: `boolean`

   .. member:: singleuser=(singleuser::boolean)::boolean

      :param boolean singleuser:
      :rtype: `boolean`

   .. member:: uniqueid()::string

      :rtype: `string`

   .. member:: uniqueid=(uniqueid::string)::string

      :param string uniqueid:
      :rtype: `string`

   .. member:: userdb()::knop_database

      :rtype: `knop_database`

   .. member:: userdb=(userdb::knop_database)::knop_database

      :param knop_database userdb:
      :rtype: `knop_database`

   .. member:: userfield()::string

      :rtype: `string`

   .. member:: userfield=(userfield::string)::string

      :param string userfield:
      :rtype: `string`

   .. member:: useridfield()::string

      :rtype: `string`

   .. member:: useridfield=(useridfield::string)::string

      :param string useridfield:
      :rtype: `string`

   .. member:: validlogin()::boolean

      :rtype: `boolean`

   .. member:: validlogin=(validlogin::boolean)::boolean

      :param boolean validlogin:
      :rtype: `boolean`

   .. member:: version()


   .. member:: version=(version)

      :param version:
