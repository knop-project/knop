knop_lang
=========

.. class:: knop_lang

    A knop_lang object holds all language strings for all supported languages.
    Strings are stored under a unique text key, but the same key is of course used
    for the different language versions of the same string. Strings can be separated
    into different variables if it helps managing them for different contexts.
    
    When the language of a string object is set, that language is used for all
    subsequent requests for strings until another language is set. All other
    instances on the same page that don't have a language set will also use the same
    language.
    
    If no language is set, knop_lang uses the browser's preferred language if it's
    available in the knop_lang object, otherwise it defaults to the first language
    (unless a default language has been set for the instance).
    
    .. method:: _unknowntag(-language =?, -replace =?)

    .. method:: _unknowntag(language =?, replace =?)

        Returns the language string for the specified text key
        
        = shortcut for getstring.
        
        Parameters:
        	- language (optional)
        	  see getstring( -language).
        
        	- replace (optional)
        	  see getstring( -replace).
        
    .. method:: addlanguage(-language::string, -strings::map =?)

    .. method:: addlanguage(language::string, strings::map =?)

        Adds a map with language strings for an entire language. Replaces all existing language strings for that language.
        
        Parameters:
        	- language (required)
        	  The language to add.
        
        	- strings (required)
        	  Complete map of key = value for the entire language.
        
    .. method:: browserlanguage()

        Autodetects and returns the most preferred language out of all available languages as specified by the browser's accept-language q-value.
        
    .. method:: currentlanguage()

    .. method:: currentlanguage=(currentlanguage::string)

    .. method:: defaultlanguage()

    .. method:: defaultlanguage=(defaultlanguage::string)

    .. method:: getstring(-key::integer, -language::string =?, -replace =?)

    .. method:: getstring(key, language::string =?, replace =?)

        Returns a specific text string in the language that has previously been set for
        the instance.If no language has been set, the browser's preferred language will
        be used unless another instance on the same page has a language set using
        ->setlanguage.
        
        If the string is not available in the chosen language and -fallback was
        specified, the string for the language that was first specified for that key
        will be returned.
        
        Parameters:
        	- key (required)
        	  textkey to return the string for.
        
        	- language (optional)
        	  to return a string for a specified language (temporary override).
        
        	- replace (optional)
        	  single value or array of values that will be used as substitutions for placeholders #1#, #2# etc in the returned string, in the order they appear. Replacements can be compund expressions, which will be executed. Can also be map or pair array, and in that case the left hand element of the map/array will be replaced by the right hand element.
        
        
    .. method:: getstring(key::integer, -language::string =?, -replace =?)

    .. method:: getstring(key::string, -language::string =?, -replace =?)

    .. method:: insert(language::string, key::string, value::string)

        Adds an individual language string.
        
        Parameters:
        	- language (required)
        	  The language for the string.
        
        	- key (required)
        	  Textkey to store the string under. Replaces any existing key for the same language.
        
        	- value (required)
        	  The actual string (can also be compound expression). Can contain replacement tokens #1#, #2# etc.
        
    .. method:: keys()

        Returns array of all text keys in the string object.
        
    .. method:: keys=(keys)

    .. method:: languages(language =?)

        Returns an array of all available languages in the string object (out of the
        languages in the -language array if specified).
        
        Parameters:
        	- language (optional)
        	  string or array of strings.
        
    .. method:: onconvert()

    .. method:: oncreate(-default::string =?)

    .. method:: oncreate(default::string =?, fallback::boolean =?, debug::boolean =?)

        Creates a new instance of knop_lang.
        
        Parameters:
        	- default (optional)
        	  Default language.
        
        	- fallback (optional)
        	  If specified, falls back to default language if key is missing.
        
    .. method:: setlanguage(language::string)

        Sets the current language for the string object. Also affects other instances on the same page that do not have an explicit language set.
        
    .. method:: strings()

    .. method:: strings=(strings::map)

    .. method:: validlanguage(-language::string)

    .. method:: validlanguage(language::string)

        Checks if a specified language exists in the string object, returns true or false.
        
    .. method:: validlanguage(void)

    .. method:: version()

    .. method:: version=(version::date)

