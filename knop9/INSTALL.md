Installation of Knop demo for Lasso 9.x
=======================================

1. __Install Knop demo files__

	Copy the files in the `demo` folder into the web root of a virtual host. If you prefer you can put the files in a subfolder, but in that case you need to configure the site root according to instructions below.  Regardless `demo/_urlhandler.lasso` must always be at the web root.

2. __Install the atbegin file for virtual URLs__

	Copy the file `LassoStartup/urlhandler_atbegin.lasso` into the LassoStartup directory for any instance `/private/var/lasso/instances/INSTANCE_NAME/LassoStartup`.

3. __Install the Knop libraries as a LassoApp__

	Lasso 9 vastly improves upon the compilation of LassoApps over Lasso 8.  For complete details of LassoApps in Lasso 9, read the following articles.
	
	[Building and Deploying LassoApps](http://www.lassosoft.com/LDC-2012-Building-and-Deploying-Lasso-Apps)

	[Language Guide - LassoApps](http://www.lassosoft.com/Language-Guide-Lasso-Apps)

	For a __development__ or __testing__ environment, it is recommended to use the [directory of files](http://www.lassosoft.com/Language-Guide-Lasso-Apps#heading19) packaging method for the Knop LassoApp.  This is the slowest of the three packaging methods because the files must be compiled through the "just in time" (JIT) compiler, then loaded into memory.  However it provides the greatest flexibility and ease of use for developers who want to edit and redefine their types often, then reload them to test them.

	For deployment into a __production__ environment, it is recommended to use the [compiled binary](http://www.lassosoft.com/Language-Guide-Lasso-Apps#heading21) method because it saves the JIT compiler step and significantly decreases loading time.  Furthermore, for security and to prevent someone from loading or reloading the Knop types through a web browser, you should secure the virtual URL `/lasso9/knoplibs/` and remove the file `knoplibs/index[html].lasso`.

	Copy the directory `/knoplibs/` and its files into the LassoApps folder into any instance directory `/private/var/lasso/instances/INSTANCE_NAME/LassoApps`.

	If you decide to experiment with modifications of Knop, then we recommend creating one Lasso instance for each version of Knop.

	To automatically load the Knop types, restart the instance.

4. __Reload Knop types (for development and testing)__

	To manually reload specific Knop types, visit the appropriate URL for your virtual host, e.g:

	<http://myhostname/lasso9/knoplibs/>

	Check the types that you want to load or reload, and submit the form.  The types that you selected to load will display in a list.
	
Web server configuration
------------------------
To use virtual URLs, the web server needs to be configured so that extensionless URLs are sent to Lasso.  Then in turn Lasso will execute the file `LassoStartup/urlhandler_atbegin.lasso`, which in turn will load `demo/_urlhandler.lasso`.  We assume that you know how to configure virtual hosts and your hosts file, as well as any DNS records if needed.  We also assume that you have mod_rewrite installed.

Open the file `apache/apache.conf`, and copy the directives from that file into your VirtualHost directive.  Restart Apache.

If you can't set up the web server to support extensionless URLs, you can configure the demo solution to use parameter based navigation instead.  See "Navigation method" below.

Set up the MySQL demo database
------------------------------
1. Create a MySQL database named "knopdemo".

2. Load the file `databases/knopdemo.sql` into MySQL and execute the query.  This will create a customer table and populate it with sample data.

3. In Lasso Admin for the instance, configure access for the database.

4. Edit the file `demo/_config/cfg__global.inc` with the database username and password used in the previous step.

(Optional) The `databases/` folder also contains a FileMaker 5/6 version of the database to demonstrate that Knop works transparently with FileMaker databases as well. Point the Knop example to the FileMaker database by changing the database name to `knopdemo_fm` in `demo/_config/cfg__global.inc`.

Configure Knop site root
------------------------
In `demo/index.lasso` the variable `$siteroot` is set to "/". Configure it to whatever path you have put the demo solution in, or "/" if you copied the demo files in the web root.  It should have a leading and trailing slash (or just a single slash).

The `$siteroot` variable is set in the file `demo/_urlhandler.lasso` so make the same change there.

Default file
------------
`demo/index.lasso` is the central hub file for the entire demo solution. Make sure Apache is configured such that `index.lasso` is a default file name.

	<IfModule dir_module>
		DirectoryIndex index.lasso index.las index.html index.htm
	</IfModule>

Navigation method
-----------------
The navigation method for the demo is initially set to 'path', which uses virtual URLs. If you can't use virtual URLs, you can change the default navigation method by configuring the variable `navmethod` and setting it to the value of 'param' in `demo/_config/cfg__global.inc`.

Upgrading Knop
--------------
To upgrade Knop, overwrite the Knop libraries in the appropriate location, then either restart the instance or use the Knop type reloader (see "Reload Knop types" above).

Install L-Debug
===============
__IMPORTANT:__ Do not run L-Debug in production environments or anywhere that critical information can be revealed to unauthorized persons.  Use some level of security.

1. Download L-Debug by using SVN:

	`svn export svn://svn.zeroloop.com/l-debug/tags/9/stable/debug.type.lasso`

2. Move the file into the LassoStartup folder for your Knop instance, e.g.:

	`/private/var/lasso/instances/default/LassoStartup/debug.type.lasso`

3. Restart the instance.

4. To activate L-Debug, use the following command:

		[debug->activate]
	
	The above line of code is in `demo/_config/cfg__global.inc`, and can be uncommented.

You may wish to add more debug points within the Knop types.  You can insert debug points for all methods except oncreate by merely inserting "=> debug" after the method's signature.

	public mymethod(
		...
	) => debug => {
		...
	}

For oncreate methods, you can add a debug point by wrapping its code block with curly brackets "{...}".

	public oncreate(
		...
	) => {
		debug => {
			...
		}
	}

Or you can use the shortcut and return self.

	public oncreate(
		...
	) => debug => {
			...
		return self
	}

Either way, oncreate is a special case.  Lasso uses oncreate methods to determine what is returned or is cast as the item created.
