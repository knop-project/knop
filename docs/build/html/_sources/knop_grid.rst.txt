=========
knop_grid
=========
.. type:: knop_grid

   :parent: `knop_base`

   .. member:: addfield([name::string, label::string, dbfield::string, width::integer, class, raw, url, keyparamname::string, defaultsort, nosort::boolean, template, quicksearch])

      :param string name:
      :param string label:
      :param string dbfield:
      :param integer width:
      :param class:
      :param raw:
      :param url:
      :param string keyparamname:
      :param defaultsort:
      :param boolean nosort:
      :param template:
      :param quicksearch:

   .. member:: addfield([-name::string, -label::string, -dbfield::string, -width::integer, -class::string, -raw, -url::string, -keyparamname::string, -defaultsort, -nosort::boolean, -template, -quicksearch])

      :param string -name:
      :param string -label:
      :param string -dbfield:
      :param integer -width:
      :param string -class:
      :param -raw:
      :param string -url:
      :param string -keyparamname:
      :param -defaultsort:
      :param boolean -nosort:
      :param -template:
      :param -quicksearch:

   .. member:: addurlarg(field::string[, value])

      :param string field:
      :param value:

   .. member:: class()::string

      :rtype: `string`

   .. member:: class=(class::string)::string

      :param string class:
      :rtype: `string`

   .. member:: database()


   .. member:: database=(database)

      :param database:

   .. member:: dbfieldmap()::map

      :rtype: `map`

   .. member:: dbfieldmap=(dbfieldmap::map)::map

      :param map dbfieldmap:
      :rtype: `map`

   .. member:: defaultsort()::string

      :rtype: `string`

   .. member:: defaultsort=(defaultsort::string)::string

      :param string defaultsort:
      :rtype: `string`

   .. member:: error_lang()


   .. member:: error_lang=(error_lang)

      :param error_lang:

   .. member:: fields()::array

      :rtype: `array`

   .. member:: fields=(fields::array)::array

      :param array fields:
      :rtype: `array`

   .. member:: footer()::string

      :rtype: `string`

   .. member:: footer=(footer::string)::string

      :param string footer:
      :rtype: `string`

   .. member:: insert([name::string, label::string, dbfield::string, width::integer, class, raw, url, keyparamname::string, defaultsort, nosort::boolean, template, quicksearch])

      :param string name:
      :param string label:
      :param string dbfield:
      :param integer width:
      :param class:
      :param raw:
      :param url:
      :param string keyparamname:
      :param defaultsort:
      :param boolean nosort:
      :param template:
      :param quicksearch:

   .. member:: insert([-name::string, -label::string, -dbfield::string, -width::integer, -class::string, -raw, -url::string, -keyparamname::string, -defaultsort, -nosort::boolean, -template, -quicksearch])

      :param string -name:
      :param string -label:
      :param string -dbfield:
      :param integer -width:
      :param string -class:
      :param -raw:
      :param string -url:
      :param string -keyparamname:
      :param -defaultsort:
      :param boolean -nosort:
      :param -template:
      :param -quicksearch:

   .. member:: lang()


   .. member:: lang=(lang)

      :param lang:

   .. member:: lastpage()


   .. member:: nav()


   .. member:: nav=(nav)

      :param nav:

   .. member:: nosort()


   .. member:: nosort=(nosort)

      :param nosort:

   .. member:: numbered()


   .. member:: numbered=(numbered)

      :param numbered:

   .. member:: onassign(value)

      :param value:

   .. member:: oncreate(database::knop_database[, nav, quicksearch, rawheader::string, class::string, id::string, nosort, language::string, numbered, rowsorting::boolean, quicksearch_btnclass])

      :param knop_database database:
      :param nav:
      :param quicksearch:
      :param string rawheader:
      :param string class:
      :param string id:
      :param nosort:
      :param string language:
      :param numbered:
      :param boolean rowsorting:
      :param quicksearch_btnclass:

   .. member:: oncreate(-database::knop_database[, -nav, -quicksearch, -rawheader::string, -class::string, -id::string, -nosort, -language::string, -numbered, -rowsorting::boolean, -quicksearch_btnclass])

      :param knop_database -database:
      :param -nav:
      :param -quicksearch:
      :param string -rawheader:
      :param string -class:
      :param string -id:
      :param -nosort:
      :param string -language:
      :param -numbered:
      :param boolean -rowsorting:
      :param -quicksearch_btnclass:

   .. member:: page()::integer

      :rtype: `integer`

   .. member:: page=(page::integer)::integer

      :param integer page:
      :rtype: `integer`

   .. member:: page_skiprecords(maxrecords::integer)

      :param integer maxrecords:

   .. member:: qs_id()::string

      :rtype: `string`

   .. member:: qs_id=(qs_id::string)::string

      :param string qs_id:
      :rtype: `string`

   .. member:: qsr_id()::string

      :rtype: `string`

   .. member:: qsr_id=(qsr_id::string)::string

      :param string qsr_id:
      :rtype: `string`

   .. member:: quicksearch([sql::boolean, contains::boolean, value::boolean, removedotbackticks::boolean])

      :param boolean sql:
      :param boolean contains:
      :param boolean value:
      :param boolean removedotbackticks:

   .. member:: quicksearch([-sql::boolean, -contains::boolean, -value::boolean, -removedotbackticks::boolean])

      :param boolean -sql:
      :param boolean -contains:
      :param boolean -value:
      :param boolean -removedotbackticks:

   .. member:: quicksearch_fields()::array

      :rtype: `array`

   .. member:: quicksearch_fields=(quicksearch_fields::array)::array

      :param array quicksearch_fields:
      :rtype: `array`

   .. member:: quicksearch_form()


   .. member:: quicksearch_form=(quicksearch_form)

      :param quicksearch_form:

   .. member:: quicksearch_form_reset()


   .. member:: quicksearch_form_reset=(quicksearch_form_reset)

      :param quicksearch_form_reset:

   .. member:: quicksearch_string()::string

      :rtype: `string`

   .. member:: quicksearch_string=(quicksearch_string::string)::string

      :param string quicksearch_string:
      :rtype: `string`

   .. member:: rawheader()::string

      :rtype: `string`

   .. member:: rawheader=(rawheader::string)::string

      :param string rawheader:
      :rtype: `string`

   .. member:: renderfooter([numbered])

      :param numbered:

   .. member:: renderfooter([-numbered])

      :param -numbered:

   .. member:: renderheader([start::boolean, startwithfooter::boolean, bootstrap::boolean])

      :param boolean start:
      :param boolean startwithfooter:
      :param boolean bootstrap:

   .. member:: renderheader([-start::boolean, -startwithfooter::boolean, -bootstrap::boolean])

      :param boolean -start:
      :param boolean -startwithfooter:
      :param boolean -bootstrap:

   .. member:: renderhtml([inlinename, numbered, startwithfooter::boolean, bootstrap::boolean])

      :param inlinename:
      :param numbered:
      :param boolean startwithfooter:
      :param boolean bootstrap:

   .. member:: renderhtml([-inlinename, -numbered, -startwithfooter::boolean, -bootstrap::boolean])

      :param -inlinename:
      :param -numbered:
      :param boolean -startwithfooter:
      :param boolean -bootstrap:

   .. member:: renderlisting([inlinename])

      :param inlinename:

   .. member:: rowsorting()


   .. member:: rowsorting=(rowsorting)

      :param rowsorting:

   .. member:: sortdescending()


   .. member:: sortdescending=(sortdescending)

      :param sortdescending:

   .. member:: sortfield()::string

      :rtype: `string`

   .. member:: sortfield=(sortfield::string)::string

      :param string sortfield:
      :rtype: `string`

   .. member:: sortparams([sql::boolean, removedotbackticks::boolean])

      :param boolean sql:
      :param boolean removedotbackticks:

   .. member:: sortparams([-sql::boolean, -removedotbackticks::boolean])

      :param boolean -sql:
      :param boolean -removedotbackticks:

   .. member:: tbl_id()::string

      :rtype: `string`

   .. member:: tbl_id=(tbl_id::string)::string

      :param string tbl_id:
      :rtype: `string`

   .. member:: urlargs([except, prefix, suffix])

      :param except:
      :param prefix:
      :param suffix:

   .. member:: version()


   .. member:: version=(version)

      :param version:
