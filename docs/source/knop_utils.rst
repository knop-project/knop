==========
knop_utils
==========
.. method:: knop_affected_count()


.. method:: knop_blowfish(string::string, mode::string[, key::string])

   :param string string:
   :param string mode:
   :param string key:

.. method:: knop_blowfish(string::string, -mode::string, -key::string)

   :param string string:
   :param string -mode:
   :param string -key:

.. method:: knop_blowfish(-string::string, -mode::string)

   :param string -string:
   :param string -mode:

.. method:: knop_client_param(param::string[, -count::boolean])

   :param string param:
   :param boolean -count:

.. method:: knop_client_param(param::string, method::string[, -count::boolean])

   :param string param:
   :param string method:
   :param boolean -count:

.. method:: knop_client_param(param::string, index::integer[, method::string, -count::boolean])

   :param string param:
   :param integer index:
   :param string method:
   :param boolean -count:

.. method:: knop_client_params([method::string])

   :param string method:

.. method:: knop_client_params([-method::string])

   :param string -method:

.. method:: knop_crypthash(string[, cost::integer, saltLength::integer, hash::string, salt, cipher::string, map::boolean])

   :param string:
   :param integer cost:
   :param integer saltLength:
   :param string hash:
   :param salt:
   :param string cipher:
   :param boolean map:

.. method:: knop_crypthash(string[, -cost::integer, -saltLength::integer, -hash::string, -salt, -cipher::string, -map::boolean])

   :param string:
   :param integer -cost:
   :param integer -saltLength:
   :param string -hash:
   :param -salt:
   :param string -cipher:
   :param boolean -map:

.. method:: knop_encodesql_full(text::string)

   :param string text:

.. method:: knop_encrypt(data[, salt, cipher::string])

   :param data:
   :param salt:
   :param string cipher:

.. method:: knop_encrypt(data[, -salt, -cipher::string])

   :param data:
   :param -salt:
   :param string -cipher:

.. method:: knop_foundrows()


.. method:: knop_IDcrypt(value::integer[, seed::string])

   :param integer value:
   :param string seed:

.. method:: knop_IDcrypt(value::string[, seed::string])

   :param string value:
   :param string seed:

.. method:: knop_math_decToHex(base10::integer)

   :param integer base10:

.. method:: knop_math_hexToDec(base16::string)

   :param string base16:

.. method:: knop_normalize_slashes(path::string)

   :param string path:

.. method:: knop_response_filepath()


.. method:: knop_seed()


.. method:: knop_stripbackticks(input::string)

   :param string input:

.. method:: knop_stripbackticks(input::bytes)

   :param bytes input:

.. method:: knop_stripbackticks(input)

   :param input:

.. method:: knop_unique()


.. method:: knop_unique9([pre::string])

   :param string pre:

.. method:: knop_unique9([-prefix::string])

   :param string -prefix:

.. type:: knop_timer


   .. member:: asstring()


   .. member:: micros()::boolean

      :rtype: `boolean`

   .. member:: micros=(micros::boolean)::boolean

      :param boolean micros:
      :rtype: `boolean`

   .. member:: oncreate()


   .. member:: oncreate(micros::boolean)

      :param boolean micros:

   .. member:: oncreate(-micros::boolean)

      :param boolean -micros:

   .. member:: resolution()


   .. member:: time()


   .. member:: timer()::integer

      :rtype: `integer`

   .. member:: timer=(timer::integer)::integer

      :param integer timer:
      :rtype: `integer`

   .. member:: version()


   .. member:: version=(version)

      :param version:

   .. member:: +(rhs::integer)

      :param integer rhs:

   .. member:: -(rhs::integer)

      :param integer rhs:
