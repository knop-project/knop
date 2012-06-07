Installation of Knop demo for Lasso 8.x
=======================================

Install Knop demo files
-----------------------
1. Copy `LassoLibraries/knop.lasso` to the LassoLibraries folder in either the LassoSite or in the Lasso application folder.

	If you decide to experiment with modifications of Knop, then we recommend creating one Lasso site for each version of Knop, one for your original and one each for each experimental version.

	You do not need to restart Lasso server.

2. Put `LassoStartup/urlhandler_atbegin.lasso` in LassoStartup at the same scope as in the previous step.

3. Copy the files in the `demo` folder into the web root of a virtual host. If you prefer you can put the files in a subfolder, but in that case you need to configure the site root according to instructions below.  Regardless `demo/_urlhandler.lasso` must always be at the web root.

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

Building Knop from .inc source files
------------------------------------
TODO