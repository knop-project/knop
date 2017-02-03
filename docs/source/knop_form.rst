=========
knop_form
=========
.. type:: knop_form

   :parent: `knop_base`
   :import: `trait_serializable`

   .. member:: acceptDeserializedElement(d::serialization_element)

      :param serialization_element d:

   .. member:: actionpath()


   .. member:: actionpath=(actionpath)

      :param actionpath:

   .. member:: adderror(fieldname)

      :param fieldname:

   .. member:: addfield(type::string[, name::string, label, value, id, dbfield, hint, options, default, size, maxlength, rows, cols, class, labelclass, raw, helpblock, confirmmessage, validate, filter, after, required, nowarning, op::string, logical_op::string, multiple, linebreak, focus, disabled])

      :param string type:
      :param string name:
      :param label:
      :param value:
      :param id:
      :param dbfield:
      :param hint:
      :param options:
      :param default:
      :param size:
      :param maxlength:
      :param rows:
      :param cols:
      :param class:
      :param labelclass:
      :param raw:
      :param helpblock:
      :param confirmmessage:
      :param validate:
      :param filter:
      :param after:
      :param required:
      :param nowarning:
      :param string op:
      :param string logical_op:
      :param multiple:
      :param linebreak:
      :param focus:
      :param disabled:

   .. member:: addfield(-type[, -name, -label, -value, -id, -dbfield, -hint, -options, -multiple, -linebreak, -default, -size::integer, -maxlength::integer, -rows::integer, -cols::integer, -focus, -class, -labelclass, -disabled, -raw, -helpblock, -confirmmessage, -required, -validate, -filter, -nowarning, -op::string, -logical_op::string, -after])

      :param -type:
      :param -name:
      :param -label:
      :param -value:
      :param -id:
      :param -dbfield:
      :param -hint:
      :param -options:
      :param -multiple:
      :param -linebreak:
      :param -default:
      :param integer -size:
      :param integer -maxlength:
      :param integer -rows:
      :param integer -cols:
      :param -focus:
      :param -class:
      :param -labelclass:
      :param -disabled:
      :param -raw:
      :param -helpblock:
      :param -confirmmessage:
      :param -required:
      :param -validate:
      :param -filter:
      :param -nowarning:
      :param string -op:
      :param string -logical_op:
      :param -after:

   .. member:: afterhandler([headscript::string, endscript::string])

      :param string headscript:
      :param string endscript:

   .. member:: backtickthis(n)

      :param n:

   .. member:: buttontemplate()::string

      :rtype: `string`

   .. member:: buttontemplate=(buttontemplate::string)::string

      :param string buttontemplate:
      :rtype: `string`

   .. member:: class()::string

      :rtype: `string`

   .. member:: class=(class::string)::string

      :param string class:
      :rtype: `string`

   .. member:: clearfields()


   .. member:: clientparams()::staticarray

      :rtype: `staticarray`

   .. member:: clientparams=(clientparams::staticarray)::staticarray

      :param staticarray clientparams:
      :rtype: `staticarray`

   .. member:: copyfield(name, newname)

      :param name:
      :param newname:

   .. member:: database()


   .. member:: database=(database)

      :param database:

   .. member:: db_keyvalue()


   .. member:: db_keyvalue=(db_keyvalue)

      :param db_keyvalue:

   .. member:: db_lockvalue()


   .. member:: db_lockvalue=(db_lockvalue)

      :param db_lockvalue:

   .. member:: enctype()


   .. member:: enctype=(enctype)

      :param enctype:

   .. member:: end_rendered()


   .. member:: end_rendered=(end_rendered)

      :param end_rendered:

   .. member:: entersubmitblock()


   .. member:: entersubmitblock=(entersubmitblock)

      :param entersubmitblock:

   .. member:: error_code()


   .. member:: error_lang()


   .. member:: error_lang=(error_lang)

      :param error_lang:

   .. member:: errorclass()::string

      :rtype: `string`

   .. member:: errorclass=(errorclass::string)::string

      :param string errorclass:
      :rtype: `string`

   .. member:: errors()


   .. member:: errors=(errors)

      :param errors:

   .. member:: exceptionfieldtypes()::map

      :rtype: `map`

   .. member:: exceptionfieldtypes=(exceptionfieldtypes::map)::map

      :param map exceptionfieldtypes:
      :rtype: `map`

   .. member:: fields()::array

      :rtype: `array`

   .. member:: fields=(fields::array)::array

      :param array fields:
      :rtype: `array`

   .. member:: fieldset()


   .. member:: fieldset=(fieldset)

      :param fieldset:

   .. member:: fieldsource()


   .. member:: fieldsource=(fieldsource)

      :param fieldsource:

   .. member:: formaction()


   .. member:: formaction=(formaction)

      :param formaction:

   .. member:: formbutton()


   .. member:: formbutton=(formbutton)

      :param formbutton:

   .. member:: formid()


   .. member:: formid=(formid)

      :param formid:

   .. member:: formmode()


   .. member:: formmode=(formmode)

      :param formmode:

   .. member:: getbutton()


   .. member:: getlabel(name::string)

      :param string name:

   .. member:: getvalue(name::string[, index::integer])

      :param string name:
      :param integer index:

   .. member:: getvalue(name::string[, -index::integer])

      :param string name:
      :param integer -index:

   .. member:: id()


   .. member:: id=(id)

      :param id:

   .. member:: init([get, post, keyvalue])

      :param get:
      :param post:
      :param keyvalue:

   .. member:: init([-get, -post, -keyvalue])

      :param -get:
      :param -post:
      :param -keyvalue:

   .. member:: isvalid()


   .. member:: keyparamname()::string

      :rtype: `string`

   .. member:: keyparamname=(keyparamname::string)::string

      :param string keyparamname:
      :rtype: `string`

   .. member:: keys()


   .. member:: keyvalue()


   .. member:: legend()


   .. member:: legend=(legend)

      :param legend:

   .. member:: loadfields([params, post, get, inlinename, database])

      :param params:
      :param post:
      :param get:
      :param inlinename:
      :param database:

   .. member:: loadfields([-params, -post, -get, -inlinename, -database])

      :param -params:
      :param -post:
      :param -get:
      :param -inlinename:
      :param -database:

   .. member:: lockvalue()


   .. member:: lockvalue_decrypted()


   .. member:: method()


   .. member:: method=(method)

      :param method:

   .. member:: name()


   .. member:: name=(name)

      :param name:

   .. member:: noautoparams()


   .. member:: noautoparams=(noautoparams)

      :param noautoparams:

   .. member:: noscript()


   .. member:: noscript=(noscript)

      :param noscript:

   .. member:: not_unknownTag([index::integer])

      :param integer index:

   .. member:: onconvert()


   .. member:: oncreate([formaction, method, name, id, raw, actionpath, fieldset::boolean, legend, entersubmitblock, noautoparams, template::string, buttontemplate::string, required::string, class::string, errorclass::string, unsavedmarker::string, unsavedmarkerclass::string, unsavedwarning::string, keyparamname::string, noscript, database])

      :param formaction:
      :param method:
      :param name:
      :param id:
      :param raw:
      :param actionpath:
      :param boolean fieldset:
      :param legend:
      :param entersubmitblock:
      :param noautoparams:
      :param string template:
      :param string buttontemplate:
      :param string required:
      :param string class:
      :param string errorclass:
      :param string unsavedmarker:
      :param string unsavedmarkerclass:
      :param string unsavedwarning:
      :param string keyparamname:
      :param noscript:
      :param database:

   .. member:: oncreate([-formaction, -method, -name, -id, -raw, -actionpath, -fieldset::boolean, -legend, -entersubmitblock, -noautoparams, -template::string, -buttontemplate::string, -required::string, -class::string, -errorclass::string, -unsavedmarker::string, -unsavedmarkerclass::string, -unsavedwarning::string, -keyparamname::string, -noscript, -database])

      :param -formaction:
      :param -method:
      :param -name:
      :param -id:
      :param -raw:
      :param -actionpath:
      :param boolean -fieldset:
      :param -legend:
      :param -entersubmitblock:
      :param -noautoparams:
      :param string -template:
      :param string -buttontemplate:
      :param string -required:
      :param string -class:
      :param string -errorclass:
      :param string -unsavedmarker:
      :param string -unsavedmarkerclass:
      :param string -unsavedwarning:
      :param string -keyparamname:
      :param -noscript:
      :param -database:

   .. member:: process([user, lock, keyvalue])

      :param user:
      :param lock:
      :param keyvalue:

   .. member:: raw()


   .. member:: raw=(raw)

      :param raw:

   .. member:: removefield(name::string)

      :param string name:

   .. member:: removefield(-name::string)

      :param string -name:

   .. member:: render_fieldset2_open()


   .. member:: render_fieldset2_open=(render_fieldset2_open)

      :param render_fieldset2_open:

   .. member:: render_fieldset_open()


   .. member:: render_fieldset_open=(render_fieldset_open)

      :param render_fieldset_open:

   .. member:: renderform([name::string, from, to, type, excludetype, legend, onlyformcontent::boolean, bootstrap::boolean])

      :param string name:
      :param from:
      :param to:
      :param type:
      :param excludetype:
      :param legend:
      :param boolean onlyformcontent:
      :param boolean bootstrap:

   .. member:: renderform([-name::string, -from, -to, -type, -excludetype, -legend, -start::boolean, -end::boolean, -onlyformcontent::boolean, -bootstrap::boolean])

      :param string -name:
      :param -from:
      :param -to:
      :param -type:
      :param -excludetype:
      :param -legend:
      :param boolean -start:
      :param boolean -end:
      :param boolean -onlyformcontent:
      :param boolean -bootstrap:

   .. member:: renderformend()


   .. member:: renderformstart([...])

      :param ...:

   .. member:: renderhtml([name::string, from, to, type, excludetype, legend::string])

      :param string name:
      :param from:
      :param to:
      :param type:
      :param excludetype:
      :param string legend:

   .. member:: renderhtml([-name, -from, -to, -type, -excludetype, -legend::string])

      :param -name:
      :param -from:
      :param -to:
      :param -type:
      :param -excludetype:
      :param string -legend:

   .. member:: required()::string

      :rtype: `string`

   .. member:: required=(required::string)::string

      :param string required:
      :rtype: `string`

   .. member:: reseterrors()


   .. member:: resetfields()


   .. member:: search_type()


   .. member:: search_type=(search_type)

      :param search_type:

   .. member:: searchfields([sql::boolean, params::boolean])

      :param boolean sql:
      :param boolean params:

   .. member:: searchfields([-sql::boolean, -params::boolean])

      :param boolean -sql:
      :param boolean -params:

   .. member:: serializationElements()


   .. member:: setformat([template::string, buttontemplate::string, required::string, legend::string, class::string, errorclass::string, unsavedmarker::string, unsavedmarkerclass::string, unsavedwarning::string])

      :param string template:
      :param string buttontemplate:
      :param string required:
      :param string legend:
      :param string class:
      :param string errorclass:
      :param string unsavedmarker:
      :param string unsavedmarkerclass:
      :param string unsavedwarning:

   .. member:: setformat([-template::string, -buttontemplate::string, -required::string, -legend::string, -class::string, -errorclass::string, -unsavedmarker::string, -unsavedmarkerclass::string, -unsavedwarning::string])

      :param string -template:
      :param string -buttontemplate:
      :param string -required:
      :param string -legend:
      :param string -class:
      :param string -errorclass:
      :param string -unsavedmarker:
      :param string -unsavedmarkerclass:
      :param string -unsavedwarning:

   .. member:: setparam(name::string, param::string, value[, index::integer])

      :param string name:
      :param string param:
      :param value:
      :param integer index:

   .. member:: setparam(-name::string, -param::string, -value[, -index::integer])

      :param string -name:
      :param string -param:
      :param -value:
      :param integer -index:

   .. member:: setvalue(name[, value, index::integer])

      :param name:
      :param value:
      :param integer index:

   .. member:: start_rendered()


   .. member:: start_rendered=(start_rendered)

      :param start_rendered:

   .. member:: template()::string

      :rtype: `string`

   .. member:: template=(template::string)::string

      :param string template:
      :rtype: `string`

   .. member:: unsavedmarker()


   .. member:: unsavedmarker=(unsavedmarker)

      :param unsavedmarker:

   .. member:: unsavedmarkerclass()


   .. member:: unsavedmarkerclass=(unsavedmarkerclass)

      :param unsavedmarkerclass:

   .. member:: unsavedwarning()::string

      :rtype: `string`

   .. member:: unsavedwarning=(unsavedwarning::string)::string

      :param string unsavedwarning:
      :rtype: `string`

   .. member:: updatefields([sql::boolean])

      :param boolean sql:

   .. member:: validate()


   .. member:: validfieldtypes()::map

      :rtype: `map`

   .. member:: validfieldtypes=(validfieldtypes::map)::map

      :param map validfieldtypes:
      :rtype: `map`
