knop_cache
==========

.. class:: knop_cache

    A thread object acting as base to the different Knop cache methods.
    Methods:
    
    	- add 
    	  Stores a cache for the supplied name
    	  Parameters:
    
    		* name type = required, string,
    
    		* content required, any kind of content,
    
    		* expires optional, integer. Defaults to 600 seconds
    
    	- get 
    	  Retrieves a cached content
          Parameter: name type = required, string
    
    	- getall 
    	  Returns all cached content as a raw map. Useful for debugging
    
    	- remove 
    	  Deletes a cached object
    	  Parameter: name type = required, string
    
    	- clear 
    	  Removes all cached content
    
    .. method:: active_tick()

    .. method:: add(name::string, content, expires::integer =?)

    .. method:: caches()

    .. method:: caches=(caches)

    .. method:: clear()

    .. method:: get(name::string)

    .. method:: getall()

    .. method:: purged()

    .. method:: purged=(purged)

    .. method:: remove(name::string)

    .. method:: version()

    .. method:: version=(version::date)

.. method:: knop_cachedelete(-type::string, -session::string =?, -name::string =?)

.. method:: knop_cachedelete(type::string, session::string =?, name::string =?)

    Deletes the cache for the specified type (and optionally name).
    
    Parameters:
    	- type (required string)
    	  Page variables of the specified type will be deleted from cache.
    
    	- session (optional string)
    	  The name of an existing session storing the cache to be deleted.
    
    	- name (optional string)
    	  Extra name parameter used to isolate the cache storage from other sites on
    	  the same virtual hosts.
    
.. method:: knop_cachefetch(-type::string, -session::string =?, -name::string =?, -maxage::date =?)

.. method:: knop_cachefetch(type::string, session::string =?, name::string =?, maxage::date =?)

    Recreates page variables from previously cached instances of the specified type,
    returns true if successful or false if there was no valid existing cache for the
    specified type. Caches are stored in a global variable named by host name and
    document root to isolate the storage of different hosts.
    
    Knop_cachefetch calls the thread object :class:`knop_cache` and can be replaced
    by direct calls to :class:`knop_cache` if you don't want to get cached objects
    from a session.
    
    Parameters:
    	- type (required string) 
    	  Page variables of the specified type will be stored in cache.
    
    	- session (optional string)
    	  The name of an existing session to use for cache storage instead of the global storage.
    
    	- name (optional string)
    	  Extra name parameter to be able to isolate the cache storage from other sites on the same virtual hosts.
    
    	- maxage (optional date)
    	  Cache data older than the date/time specified in -maxage will not be used.
    
.. method:: knop_cachestore(-type::string, -expires::integer =?, -session::string =?, -name::string =?)

.. method:: knop_cachestore(type::string, expires::integer =?, session::string =?, name::string =?)

    Stores all instances of page variables of the specified type in a cache object.
    Caches are stored in a global variable named by host name and document root to
    isolate the storage of different hosts.
    
    Knop_cachestore calls the thread object :class:`knop_cache` and can be replaced
    by direct calls to :class:`knop_cache` if you don't want to store the cache in a
    session.
    
    Parameters:
    	- type (required string) 
        
            Page variables of the specified type will be stored in cache. Data types
            can be specified with or without namespace.
    
    	- expires (optional integer)
        
            The number of seconds that the cached data should be valid. Defaults to
            600 (10 minutes).
    
    	- session (optional string)
        
            The name of an existing session to use for cache storage instead of the
            global storage.
    
    	- name (optional string)
        
            Extra name parameter to be able to isolate the cache storage from other
            sites on the same virtual hosts, or caches for different uses.
    
