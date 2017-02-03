=========
knop_base
=========
.. type:: knop_base

   Base data type for Knop framework. Contains common member tags. Used as boilerplate when creating the other types. All member tags and instance variables in this type are available in the other knop types as well.

   .. member:: debug_trace()::array

      :rtype: `array`

   .. member:: debug_trace=(debug_trace::array)::array

      :param array debug_trace:
      :rtype: `array`

   .. member:: error_code()

   .. member:: error_code=(error_code)

      Returns either proprietary error code or standard Lasso error code.

      :param error_code: Accepts an integer.

   .. member:: error_lang()


   .. member:: error_lang=(error_lang)

      Returns a reference to the language object used for error codes, to be able to add localized error messages to any Knop type (except :type:`knop_lang` and :type:`knop_base`).

      :param error_lang:

   .. member:: error_msg([error_code::integer])

      Returns either a Knop or standard Lasso error message.

      :param integer error_code: Optional integer, either for Knop or Lasso.

   .. member:: error_msg=(error_msg)

      Returns either a Knop or standard Lasso error message.

      :param error_msg: Accepts either a Knop or standard Lasso error message.

   .. member:: help([html::boolean, xhtml::boolean])

      :param boolean html:
      :param boolean xhtml:

   .. member:: instance_unique()


   .. member:: instance_unique=(instance_unique)

      :param instance_unique:

   .. member:: instance_varname()


   .. member:: instance_varname=(instance_varname)

      :param instance_varname:

   .. member:: tagtime_tagname()::tag

      :rtype: `tag`

   .. member:: tagtime_tagname=(tagtime_tagname::tag)::tag

      :param tag tagtime_tagname:
      :rtype: `tag`

   .. member:: varname()


   .. member:: xhtml([params])

      :param params:

   .. member:: _debug_trace()::array

      :rtype: `array`

   .. member:: _debug_trace=(_debug_trace::array)::array

      :param array _debug_trace:
      :rtype: `array`

.. type:: knop_knoptype

   All Knop custom types should have this type as parent type. This is to be able to identify all registered knop types.

   .. member:: isknoptype()


   .. member:: isknoptype=(isknoptype)

      :param isknoptype:
