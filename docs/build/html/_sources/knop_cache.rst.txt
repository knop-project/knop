==========
knop_cache
==========
.. method:: knop_cachedelete(type::string[, session::string, name::string])

   :param string type:
   :param string session:
   :param string name:

.. method:: knop_cachedelete(-type::string[, -session::string, -name::string])

   :param string -type:
   :param string -session:
   :param string -name:

.. method:: knop_cachefetch(type::string[, session::string, name::string, maxage::date])

   :param string type:
   :param string session:
   :param string name:
   :param date maxage:

.. method:: knop_cachefetch(-type::string[, -session::string, -name::string, -maxage::date])

   :param string -type:
   :param string -session:
   :param string -name:
   :param date -maxage:

.. method:: knop_cachestore(type::string[, expires::integer, session::string, name::string])

   :param string type:
   :param integer expires:
   :param string session:
   :param string name:

.. method:: knop_cachestore(-type::string[, -expires::integer, -session::string, -name::string])

   :param string -type:
   :param integer -expires:
   :param string -session:
   :param string -name:

.. thread:: knop_cache


   .. member:: active_tick()


   .. member:: add(name::string, content[, expires::integer])

      :param string name:
      :param content:
      :param integer expires:

   .. member:: caches()


   .. member:: caches=(caches)

      :param caches:

   .. member:: clear()


   .. member:: get(name::string)

      :param string name:

   .. member:: getall()


   .. member:: purged()


   .. member:: purged=(purged)

      :param purged:

   .. member:: remove(name::string)

      :param string name:

   .. member:: version()


   .. member:: version=(version)

      :param version:
