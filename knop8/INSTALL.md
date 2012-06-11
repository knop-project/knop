Installation of Knop demo for Lasso 8.x
=======================================

Install Knop demo files
-----------------------
1. Copy `LassoLibraries/knop.lasso` to the LassoLibraries folder in either the LassoSite or in the Lasso application folder.

	If you decide to experiment with modifications of Knop, then we recommend creating one Lasso site for each version of Knop, one for your original and one each for each experimental version.

	You do not need to restart Lasso server.

2. Put `LassoStartup/urlhandler_atbegin.lasso` in LassoStartup at the same scope as in the previous step.

3. Copy the files in the `demo` folder into the web root of a virtual host. If you prefer you can put the files in a subfolder, but in that case you need to configure the site root according to instructions below.  Regardless `demo/_urlhandler.lasso` must always be at the web root.

4. Copy the file `../docs/help.lasso` into the web root.  To view the Knop API, visit the URL for your virtual host, e.g.

	<http://myhostname/help.lasso>

Web server configuration
------------------------
To use virtual URLs, the web server needs to be configured so that extensionless URLs are sent to Lasso.  Then in turn Lasso will execute the file `LassoStartup/urlhandler_atbegin.lasso`, which in turn will load `demo/_urlhandler.lasso`.  We assume that you know how to configure virtual hosts and your hosts file, as well as any DNS records if needed.  We also assume that you have mod_rewrite installed.

Open the file `apache/apache.conf`, and copy the directives from that file into your VirtualHost directive.  Restart Apache.

If you can't set up the web server to support extensionless URLs, you can configure the demo solution to use parameter based navigation instead.  See "Navigation method" below.

Set up the MySQL demo database
------------------------------
1. Create a MySQL database named "knopdemo".

2. Load the file `databases/knopdemo.sql` into MySQL and execute the query.  This will create a customer table and populate it with sample data.

3. In Lasso SiteAdmin, configure access for the database and table.

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

Lasso SiteAdmin configuration
-----------------------------
The extension `.inc` may need to be added to the File Tags Extensions list in SiteAdmin > Setup > Site > File Extensions.

Navigation method
-----------------
The navigation method for the demo is initially set to 'path', which uses virtual URLs. If you can't use virtual URLs, you can change the default navigation method by configuring the variable `navmethod` and setting it to the value of 'param' in `demo/_config/cfg__global.inc`.

Upgrading Knop
--------------
To upgrade Knop, overwrite the knop.lasso in the appropriate scope, then execute this Lasso code to use the new version without restarting Lasso:

	namespace_unload('knop_');

Alternative methods to install Knop
===================================
Knop can be installed by several methods.  The easiest is to copy the file `knop.lasso` into your LassoSite's LassoLibraries directory.

Building Knop from .inc source files
------------------------------------
The source code for each custom type is stored in separate files in the `source/_ctype/` directory, and the utility tags used by Knop are stored in one file in the `source/_ctag/` directory.  The file `knop.lasso` is essentially a concatenation of the source files and change notes.

To help manage the single namespace file, `source/buildnamespace.lasso` can be used. When run it will check the syntax of each of the source files, and if all of them are OK, they are placed into a single namespace file in the current LassoSite's LassoLibraries folder.  Finally the namespace is unloaded and then loaded again.  This is a really neat way to take advantage of the namespaces without suffering from the nightmare of maintaining the custom types in one single huge namespace file.

Lasso needs permission to write to the LassoLibraries directory in the current site, and to do this Lasso needs write permission outside of root, i.e. the path '///' must be added in server admin.

To build `knop.lasso` from source:
1. Put the directory `source` somewhere in the web root.
2. Run `source/buildnamespace.lasso` in the web browser. This will create `knop.lasso` in the LassoLibraries folder of the current LassoSite.

Other methods
-------------
1. Include each file separately in your solution.
2. Put each file in LassoStartup and restart Lasso.
3. Put all files in a single namespace file with the name knop.lasso and put that in LassoLibraries in either the LassoSite or globally for the server.
4. In Lasso 8.5 and later (actually 8.1.1 and later) you can put each source file separately in a folder named "knop" in LassoLibraries. The files must be directly in the namespace folder, there can be no sub folders. This method does not work with Lasso 8.0 or 8.1.

Putting the knop files in LassoLibraries as an ondemand library according to method 3 or 4 above has the advantage that the tags and types are loaded into memory for best performance, but can still be updated without restarting Lasso. To do so unload the namespace using `[namespace_unload('knop_')]`, and then the next call to any knop tag or type will load the namespace into memory again from the source files.

Install L-Debug
===============
1. Download L-Debug by using SVN:

	`svn export svn://svn.zeroloop.com/L-Debug/tags/public/stable/debug.ctyp`

2. Open the file and at the very top, add one line of code as indicated below.

		define_type:'Debug','Array',-prototype,-priority='replace',
			-namespace='knop_', // insert this line
			-description = '

3. Save and close the file.

4. Move the file into the LassoStartup folder for your Knop LassoSite.

5. Restart the LassoSite.

6. To activate L-Debug, use the following command:

		[knop_debug->activate]
	
	The above line of code is in `demo/_config/cfg__global.inc`, and can be uncommented.
	
	Note that the typical Knop output for the trace method will be replaced by the L-Debug output.

