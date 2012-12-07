knop_utils
==========

.. class:: knop_timer

    Utility type to provide a simple timer
    Usage::
    
    	Initialise  var(timer = knop_timer)
    	Read        $timer
    	Math        100 + $timer or $timer + 100
    		  		100 - $timer or $timer - 100
    
    For other integer handling wrap it in integer first
    ``integer($timer)``
    
    .. method:: +(rhs::integer)

    .. method:: -(rhs::integer)

    .. method:: asstring()

    .. method:: micros()

    .. method:: micros=(micros::boolean)

    .. method:: oncreate()

    .. method:: oncreate(-micros::boolean)

    .. method:: oncreate(micros::boolean)

    .. method:: resolution()

    .. method:: time()

    .. method:: timer()

    .. method:: timer=(timer::integer)

    .. method:: version()

    .. method:: version=(version::date)

.. method:: knop_affected_count()

    Adding a affected_count method pending a native implementation in Lasso 9
    Used in sql updates, deletes etc returning number of rows affected by the change
    
.. method:: knop_blowfish(-string::string, -mode::string)

.. method:: knop_blowfish(string::string, -mode::string, -key::string)

.. method:: knop_blowfish(string::string, mode::string, key::string =?)

.. method:: knop_client_param(param::string, -count::boolean =?)

    Returns the value of a client GET/POST parameter
    
    Example usage::
    
    	knop_client_param('my');
    	knop_client_param('my', 2);
    	knop_client_param('my', 'get');
    	knop_client_param('my', 2, 'post');
    	knop_client_param('my', -count);
    	knop_client_param('my', 'get', -count);
    
    Inspired by Bil Corrys lp_client_param
    Lasso 9 version by Jolle Carlestam
    
.. method:: knop_client_param(param::string, index::integer, method::string =?, -count::boolean =?)

.. method:: knop_client_param(param::string, method::string, -count::boolean =?)

.. method:: knop_client_params(-method::string =?)

.. method:: knop_client_params(method::string =?)

    Returns a static array of GET/POST parameters passed from the client.
    An optional param "method" can direct it to return only post or get params
    
    Example usage::
    
    	knop_client_params;
    	knop_client_params('post');
    	knop_client_params(-method = 'get');
    
    Based on same code as action_params but without the inline sensing parts.
    
.. method:: knop_crypthash(string::string, -cost::integer =?, -saltlength::integer =?, -hash::string =?, -salt =?, -cipher::string =?, -map::boolean =?)

.. method:: knop_crypthash(string::string, cost::integer =?, saltlength::integer =?, hash::string =?, salt =?, cipher::string =?, map::boolean =?)

.. method:: knop_encodesql_full(text::string)

.. method:: knop_encrypt(data, -salt =?, -cipher::string =?)

.. method:: knop_encrypt(data, salt =?, cipher::string =?)

    Encrypts the input using digest encryption, optionally with salt.
    
.. method:: knop_foundrows()

.. method:: knop_IDcrypt(value::integer, seed::string =?)

    Encrypts or Decrypts integer values
    
.. method:: knop_IDcrypt(value::string, seed::string =?)

.. method:: knop_math_dectohex(base10::integer)

    Returns a base16 string given a base10 integer.
    
.. method:: knop_math_hexToDec(base16::string)

    Returns a base10 integer given a base16 string.
    
.. method:: knop_normalize_slashes(path::string)

.. method:: knop_response_filepath()

    Safer than using Lasso 9 response_filepath when dealing wit hone file systems on Apache
    
.. method:: knop_seed()

.. method:: knop_stripbackticks(input)

.. method:: knop_stripbackticks(input::bytes)

.. method:: knop_stripbackticks(input::string)

    Remove backticks (`) from a string to make it safe for MySQL object names
    
.. method:: knop_unique()

    Original version
    Returns a very unique but still rather short random string. Can in most cases be replaced by the Lasso 9 version of lasso_unique since it's safer than the pre 9 version.
    
.. method:: knop_unique9(-prefix::string =?)

.. method:: knop_unique9(pre::string =?)

