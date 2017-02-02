=========
knop_lang
=========
.. type:: knop_lang


   .. member:: addlanguage(language::string[, strings::map])

      :param string language:
      :param map strings:

   .. member:: addlanguage(-language::string[, -strings::map])

      :param string -language:
      :param map -strings:

   .. member:: asstring()


   .. member:: browserlanguage()


   .. member:: currentlanguage()::string

      :rtype: `string`

   .. member:: currentlanguage=(currentlanguage::string)::string

      :param string currentlanguage:
      :rtype: `string`

   .. member:: defaultlanguage()::string

      :rtype: `string`

   .. member:: defaultlanguage=(defaultlanguage::string)::string

      :param string defaultlanguage:
      :rtype: `string`

   .. member:: fallback()::boolean

      :rtype: `boolean`

   .. member:: fallback=(fallback::boolean)::boolean

      :param boolean fallback:
      :rtype: `boolean`

   .. member:: getstring(key[, language::string, replace, always::boolean])

      :param key:
      :param string language:
      :param replace:
      :param boolean always:

   .. member:: getstring(key[, -language::string, -replace, -always::boolean])

      :param key:
      :param string -language:
      :param -replace:
      :param boolean -always:

   .. member:: getstring(-key[, -language::string, -replace, -always::boolean])

      :param -key:
      :param string -language:
      :param -replace:
      :param boolean -always:

   .. member:: insert(language::string, key::string, value::string)

      :param string language:
      :param string key:
      :param string value:

   .. member:: keys()


   .. member:: keys=(keys)

      :param keys:

   .. member:: languages([language])

      :param language:

   .. member:: oncreate([-default::string, -fallback::boolean])

      :param string -default:
      :param boolean -fallback:

   .. member:: oncreate(default::string, fallback::boolean)

      :param string default:
      :param boolean fallback:

   .. member:: setlanguage(language::string)

      :param string language:

   .. member:: strings()::map

      :rtype: `map`

   .. member:: strings=(strings::map)::map

      :param map strings:
      :rtype: `map`

   .. member:: validlanguage(language::string)

      :param string language:

   .. member:: validlanguage(-language::string)

      :param string -language:

   .. member:: validlanguage(void)

      :param void:

   .. member:: version()


   .. member:: version=(version)

      :param version:

   .. member:: _unknowntag([language, replace])

      :param language:
      :param replace:

   .. member:: _unknowntag([-language, -replace])

      :param -language:
      :param -replace:
