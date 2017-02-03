========
knop_nav
========
.. type:: knop_nav

   :parent: `knop_base`
   :import: `trait_serializable`

   .. member:: acceptDeserializedElement(d::serialization_element)

      :param serialization_element d:

   .. member:: actionconfigfile()


   .. member:: actionconfigfile_didrun()::string

      :rtype: `string`

   .. member:: actionconfigfile_didrun=(actionconfigfile_didrun::string)::string

      :param string actionconfigfile_didrun:
      :rtype: `string`

   .. member:: actionfile()


   .. member:: actionpath()


   .. member:: actionpath=(actionpath::string)::string

      :param string actionpath:
      :rtype: `string`

   .. member:: addchildren(path::string, children::knop_nav)

      :param string path:
      :param knop_nav children:

   .. member:: addchildren(-path::string, -children::knop_nav)

      :param string -path:
      :param knop_nav -children:

   .. member:: asstring()


   .. member:: children([path])

      :param path:

   .. member:: children(-path)

      :param -path:

   .. member:: class()::string

      :rtype: `string`

   .. member:: class=(class::string)::string

      :param string class:
      :rtype: `string`

   .. member:: configfile()


   .. member:: contentfile()


   .. member:: currentclass()::string

      :rtype: `string`

   .. member:: currentclass=(currentclass::string)::string

      :param string currentclass:
      :rtype: `string`

   .. member:: currentmarker()::string

      :rtype: `string`

   .. member:: currentmarker=(currentmarker::string)::string

      :param string currentmarker:
      :rtype: `string`

   .. member:: data([-path::string, -type::string])

      :param string -path:
      :param string -type:

   .. member:: data(path::string, type::string)

      :param string path:
      :param string type:

   .. member:: default()::string

      :rtype: `string`

   .. member:: default=(default::string)::string

      :param string default:
      :rtype: `string`

   .. member:: directorytree([basepath::string, firstrun::boolean])

      :param string basepath:
      :param boolean firstrun:

   .. member:: directorytreemap()::map

      :rtype: `map`

   .. member:: directorytreemap=(directorytreemap::map)::map

      :param map directorytreemap:
      :rtype: `map`

   .. member:: dotrace()::boolean

      :rtype: `boolean`

   .. member:: dotrace=(dotrace::boolean)::boolean

      :param boolean dotrace:
      :rtype: `boolean`

   .. member:: error_lang()::knop_lang

      :rtype: `knop_lang`

   .. member:: error_lang=(error_lang::knop_lang)::knop_lang

      :param knop_lang error_lang:
      :rtype: `knop_lang`

   .. member:: filename(type::string[, path::string])

      :param string type:
      :param string path:

   .. member:: filename(-type::string[, -path::string])

      :param string -type:
      :param string -path:

   .. member:: filename(type::string[, -path::string])

      :param string type:
      :param string -path:

   .. member:: filenaming()::string

      :rtype: `string`

   .. member:: filenaming=(filenaming::string)::string

      :param string filenaming:
      :rtype: `string`

   .. member:: fileroot()::string

      :rtype: `string`

   .. member:: fileroot=(fileroot::string)::string

      :param string fileroot:
      :rtype: `string`

   .. member:: findnav(path::array, navitems::array)

      :param array path:
      :param array navitems:

   .. member:: getargs([index::integer])

      :param integer index:

   .. member:: getargs(-index::integer)

      :param integer -index:

   .. member:: getlocation([setpath::string, refresh::boolean])

      :param string setpath:
      :param boolean refresh:

   .. member:: getlocation(-setpath::string[, -refresh::boolean])

      :param string -setpath:
      :param boolean -refresh:

   .. member:: getlocation_didrun()::boolean

      :rtype: `boolean`

   .. member:: getlocation_didrun=(getlocation_didrun::boolean)::boolean

      :param boolean getlocation_didrun:
      :rtype: `boolean`

   .. member:: getnav([path])

      :param path:

   .. member:: getnav(-path)

      :param -path:

   .. member:: haschildren(navitem::map)

      :param map navitem:

   .. member:: haschildren(-navitem::map)

      :param map -navitem:

   .. member:: include(file::string[, path::string])

      :param string file:
      :param string path:

   .. member:: include(-file::string[, -path::string])

      :param string -file:
      :param string -path:

   .. member:: insert(key::string[, label, default, url, title, id, template, children, param, class, filename, disabled::boolean, after, target, data, hide::boolean, raw::string, divider::boolean, dropdownheader::boolean])

      :param string key:
      :param label:
      :param default:
      :param url:
      :param title:
      :param id:
      :param template:
      :param children:
      :param param:
      :param class:
      :param filename:
      :param boolean disabled:
      :param after:
      :param target:
      :param data:
      :param boolean hide:
      :param string raw:
      :param boolean divider:
      :param boolean dropdownheader:

   .. member:: insert(-key::string[, -label, -default, -url, -title, -id, -template, -children, -param, -class, -filename, -disabled::boolean, -after, -target, -data, -hide::boolean, -raw::string, -divider::boolean, -dropdownheader::boolean])

      :param string -key:
      :param -label:
      :param -default:
      :param -url:
      :param -title:
      :param -id:
      :param -template:
      :param -children:
      :param -param:
      :param -class:
      :param -filename:
      :param boolean -disabled:
      :param -after:
      :param -target:
      :param -data:
      :param boolean -hide:
      :param string -raw:
      :param boolean -divider:
      :param boolean -dropdownheader:

   .. member:: label([path::string])

      :param string path:

   .. member:: label(-path::string)

      :param string -path:

   .. member:: library(file::string[, path])

      :param string file:
      :param path:

   .. member:: library(-file::string[, -path])

      :param string -file:
      :param -path:

   .. member:: libraryfile()


   .. member:: linkparams(navitem::map)

      :param map navitem:

   .. member:: linkparams(-navitem::map)

      :param map -navitem:

   .. member:: navitems()::array

      :rtype: `array`

   .. member:: navitems=(navitems::array)::array

      :param array navitems:
      :rtype: `array`

   .. member:: navmethod()::string

      :rtype: `string`

   .. member:: navmethod=(navmethod::string)::string

      :param string navmethod:
      :rtype: `string`

   .. member:: oncreate([-template::string, -class::string, -currentclass::string, -currentmarker::string, -default::string, -root::string, -fileroot::string, -navmethod::string, -filenaming::string, -trace::boolean])

      :param string -template:
      :param string -class:
      :param string -currentclass:
      :param string -currentmarker:
      :param string -default:
      :param string -root:
      :param string -fileroot:
      :param string -navmethod:
      :param string -filenaming:
      :param boolean -trace:

   .. member:: oncreate(template::string[, class::string, currentclass::string, currentmarker::string, default::string, root::string, fileroot::string, navmethod::string, filenaming::string, trace::boolean])

      :param string template:
      :param string class:
      :param string currentclass:
      :param string currentmarker:
      :param string default:
      :param string root:
      :param string fileroot:
      :param string navmethod:
      :param string filenaming:
      :param boolean trace:

   .. member:: path([path::string])

      :param string path:

   .. member:: path(-path::string)

      :param string -path:

   .. member:: path=(path::string)::string

      :param string path:
      :rtype: `string`

   .. member:: pathargs()::string

      :rtype: `string`

   .. member:: pathargs=(pathargs::string)::string

      :param string pathargs:
      :rtype: `string`

   .. member:: patharray()


   .. member:: patharray=(patharray::array)::array

      :param array patharray:
      :rtype: `array`

   .. member:: pathmap()


   .. member:: pathmap=(pathmap::map)::map

      :param map pathmap:
      :rtype: `map`

   .. member:: renderbreadcrumb([delimiter::string, home::boolean, skipcurrent::boolean, plain::boolean])

      :param string delimiter:
      :param boolean home:
      :param boolean skipcurrent:
      :param boolean plain:

   .. member:: renderbreadcrumb([-delimiter::string, -home::boolean, -skipcurrent::boolean, -plain::boolean])

      :param string -delimiter:
      :param boolean -home:
      :param boolean -skipcurrent:
      :param boolean -plain:

   .. member:: renderhtml([items::array, keyval::array, flat::boolean, toplevel::boolean, xhtml::boolean, patharray, levelcount::integer, bootstrap::boolean])

      :param array items:
      :param array keyval:
      :param boolean flat:
      :param boolean toplevel:
      :param boolean xhtml:
      :param patharray:
      :param integer levelcount:
      :param boolean bootstrap:

   .. member:: renderhtml([-items::array, -keyval::array, -flat::boolean, -toplevel::boolean, -xhtml::boolean, -patharray, -levelcount::integer, -bootstrap::boolean])

      :param array -items:
      :param array -keyval:
      :param boolean -flat:
      :param boolean -toplevel:
      :param boolean -xhtml:
      :param -patharray:
      :param integer -levelcount:
      :param boolean -bootstrap:

   .. member:: renderhtml_levels()::integer

      :rtype: `integer`

   .. member:: renderhtml_levels=(renderhtml_levels::integer)::integer

      :param integer renderhtml_levels:
      :rtype: `integer`

   .. member:: rendernav([-active::string])

      :param string -active:

   .. member:: root()::string

      :rtype: `string`

   .. member:: root=(root::string)::string

      :param string root:
      :rtype: `string`

   .. member:: sanitycheck()


   .. member:: scrubKeywords(input::trait_queriable)::trait_foreach

      :param trait_queriable input:
      :rtype: `trait_foreach`

   .. member:: scrubKeywords(input)

      :param input:

   .. member:: serializationElements()


   .. member:: setformat([template::string, class::string, currentclass::string, currentmarker::string])

      :param string template:
      :param string class:
      :param string currentclass:
      :param string currentmarker:

   .. member:: setformat([-template::string, -class::string, -currentclass::string, -currentmarker::string])

      :param string -template:
      :param string -class:
      :param string -currentclass:
      :param string -currentmarker:

   .. member:: setlocation(path::string)

      :param string path:

   .. member:: setlocation(-path::string)

      :param string -path:

   .. member:: template()::string

      :rtype: `string`

   .. member:: template=(template::string)::string

      :param string template:
      :rtype: `string`

   .. member:: url([path::string, params, urlargs::string, getargs::boolean, except, topself::knop_nav, autoparams::boolean, ...])

      :param string path:
      :param params:
      :param string urlargs:
      :param boolean getargs:
      :param except:
      :param knop_nav topself:
      :param boolean autoparams:
      :param ...:

   .. member:: url([-path::string, -params, -urlargs::string, -getargs::boolean, -except, -topself::knop_nav, -autoparams::boolean, ...])

      :param string -path:
      :param -params:
      :param string -urlargs:
      :param boolean -getargs:
      :param -except:
      :param knop_nav -topself:
      :param boolean -autoparams:
      :param ...:

   .. member:: urlmap()


   .. member:: urlmap=(urlmap::map)::map

      :param map urlmap:
      :rtype: `map`

   .. member:: urlparams()::array

      :rtype: `array`

   .. member:: urlparams=(urlparams::array)::array

      :param array urlparams:
      :rtype: `array`
