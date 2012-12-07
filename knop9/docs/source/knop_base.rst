knop_base
=========

.. class:: knop_knoptype

    All Knop custom types should have this type as parent type. 
    This is to be able to identify all registered knop types.
    
    .. method:: isknoptype()

    .. method:: isknoptype=(isknoptype)

.. class:: knop_base

    Base data type for Knop framework. Contains common member tags. Used as 
    boilerplate when creating the other types. All member tags and instance 
    variables in this type are available in the other knop types as well.
    
    .. method:: _debug_trace()

    .. method:: _debug_trace=(_debug_trace::array)

    .. method:: debug_trace()

    .. method:: debug_trace=(debug_trace::array)

    .. method:: error_code()

    .. method:: error_code=(error_code)

    .. method:: error_lang()

    .. method:: error_lang=(error_lang)

    .. method:: error_msg(error_code::integer =?)

    .. method:: error_msg=(error_msg)

    .. method:: help(html::boolean =?, xhtml::boolean =?)

    .. method:: instance_unique()

    .. method:: instance_unique=(instance_unique)

    .. method:: instance_varname()

    .. method:: instance_varname=(instance_varname)

    .. method:: tagtime()

    .. method:: tagtime=(tagtime::integer)

    .. method:: tagtime_tagname()

    .. method:: tagtime_tagname=(tagtime_tagname::tag)

    .. method:: varname()

    .. method:: version()

    .. method:: version=(version)

    .. method:: xhtml(params =?)

