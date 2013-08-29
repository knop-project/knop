<?LassoScript
/*
	Help file to reload selected knop types. Useful while editing type code

	CHANGE NOTES

	2012-06-07	JC	Enhanced the knop_base preloaded check and moved it to load inside the protect block.
	2012-06-07	SP	HTML wrapping and check to see if knop_base was preloaded. If not load it.
	2012-05-18	JC	Initial release as help for Steve.
*/
auth_admin

$pagescripts -> insert('<script language="javascript" type="text/javascript">

	$(function(){

		$("#reloadForm").submit(function(event) {
			event.preventDefault();
			$("#message").html("Reload request sent").show();
			var cnt = $(this).serializeArray();
			$("#message").load("' + lassoapp_link('/ajax.xhr') + '",cnt
			,function() {
				$.each($("#reloadForm :checkbox"), function() {
					$(this).removeAttr("checked");
				});

			});
		});



	});
</script>')
?>
<div class="container">

	<header class="jumbotron subhead" id="overview">
		<h1>Knop for 9</h1>
		<p class="lead">A lightweight framework for <a href="http://lassosoft.com/" target="_blank">Lasso 9</a>.</p>
	</header>


	<section id="admin">
		<div class="page-header">
			<h1>Admin <small>Reloading, reference and help for the Knop types and methods</small></h1>
		</div>
		<div class="row">
			<div class="span4">
				<h3><a data-toggle="modal" href="#reloadModal">Reload</a></h3>
				<p>Allows you to reload selected Knop types, or rather the files they are defined in.
					Useful while working with Knop development. After a reload Lasso 9 will acknowledge the reloaded type and use the changed code from there on.</p>
				<a data-toggle="modal" href="#reloadModal" class="btn btn-primary btn-large">Reload Knop files &#62;&#62; </a>
			</div>
			<div class="span4">
				<h3><a href="#reloadModal">Reference</a></h3>
				<p>Pending implementation.<br>
				Will provide an local reference guide to all the Knop types and methods.</p>
			</div>
			<div class="span4">
				<h3><a href="#help">Help</a></h3>
				<p>Online resources found at other places:<br>
					<a href="https://github.com/knop-project/knop" target="_blank">https://github.com/knop-project/knop</a><br>
					An email discussion list is provided by Montania SE.  To subscribe, send email to <a href="mailto:knop-feed@lists.montania.se">knop-feed@lists.montania.se</a><br>
					The Knop mailing list archive is available on <a href="http://lasso.2283332.n4.nabble.com/Knop-Framework-Discussion-f3157831.html">Nabble</a>.<br>
					To file a bug report, please use the <a href="https://github.com/knop-project/knop/issues">Knop Project Issue Tracker</a>.
				</p>
			</div>
		</div> <!-- /row -->
		<div class="alert alert-info"><strong>Note!</strong> The information and functions provided here are only for authorized Lasso 9 admin operators.</div>
	</section>

	<footer class="footer" id="foot">
		<p class=""><?= $version ?></p>
	</footer>

</div> <!-- /container -->
<div id="reloadModal" class="modal hide fade" style="display: none; ">
	<form id="reloadForm" method="post" action="">
		<input type="hidden" value="reload" name="-action">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal">×</button>
			<h3>Reload selected files</h3>
		</div>
		<div class="modal-body">
			<p>Select the files that you want Lasso to reload.<br><strong>Note! It is only useful to reload files if you're using the plain directory version of the Knop LassoApp. If you're using the precompiled binary version, reloading a type will do nothing.</strong></p>
			<label id="knop_base_label" for="knop_base"><input type="checkbox" id="knop_base" value="knop_base.lasso" name="reloadfile"> Knop Base</label>
			<label id="knop_cache_label" for="knop_cache"><input type="checkbox" id="knop_cache" value="knop_cache.lasso" name="reloadfile"> Knop Cache</label>
			<label id="knop_database_label" for="knop_database"><input type="checkbox" id="knop_database" value="knop_database.lasso" name="reloadfile"> Knop Database</label>
			<label id="knop_form_label" for="knop_form"><input type="checkbox" id="knop_form" value="knop_form.lasso" name="reloadfile"> Knop Form</label>
			<label id="knop_grid_label" for="knop_grid"><input type="checkbox" id="knop_grid" value="knop_grid.lasso" name="reloadfile"> Knop Grid</label>
			<label id="knop_lang_label" for="knop_lang"><input type="checkbox" id="knop_lang" value="knop_lang.lasso" name="reloadfile"> Knop Lang</label>
			<label id="knop_nav_label" for="knop_nav"><input type="checkbox" id="knop_nav" value="knop_nav.lasso" name="reloadfile"> Knop Nav</label>
			<label id="knop_nav_label" for="knop_user"><input type="checkbox" id="knop_user" value="knop_user.lasso" name="reloadfile"> Knop User</label>
			<label id="knop_nav_label" for="knop_utils"><input type="checkbox" id="knop_utils" value="knop_utils.lasso" name="reloadfile"> Knop Utils</label>
			<label id="ldebug_label" for="ldebug"><input type="checkbox" id="ldebug" value="debug.type.lasso" name="reloadfile"> L-Debug</label>


		</div>
		<div class="modal-footer">
			<span id="message"></span>
			<a href="#" class="btn" data-dismiss="modal">Close</a>
			<input type="submit" class="btn btn-primary" id value="Reload" name="button_save">
		</div>
	</form>
</div>
