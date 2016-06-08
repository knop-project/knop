<?LassoScript
/*
	Navigation page for the Knop Framework admin section

	CHANGE NOTES

	2012-07-05	JC	Loaded version as variable
	2012-06-25	JC	Initial release.
*/

auth_admin

log_critical('Amtac tag loader index called')
local(page = web_request -> queryParams -> first -> name)

var(version = lassoapp_include('version.lasso') + ' for ' + lasso_version)

var(pagescripts = array)

match(#page) => {
	case('reload')
		local(page_content = lassoapp_include('_inc/reload.inc'))
	case('help')
		local(page_content = lassoapp_include('_inc/help.inc'))
	case('version')
		local(page_content = $version)
	case
		local(page_content = lassoapp_include('_inc/index.inc'))
}
?><!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<title><?= server_name ?> - Knop Admin section</title>
	<link href="<?= lassoapp_link('/res/css/bootstrap.min.css') ?>" rel="stylesheet">
	<link href="<?= lassoapp_link('/res/css/bootstrap-responsive.min.css') ?>" rel="stylesheet">
	<link href="<?= lassoapp_link('/res/css/sitestyle.css') ?>" rel="stylesheet">
</head>
<body>
<p>
<?= #page_content ?>
</p>
</body>
<script type="text/javascript" src="<?= lassoapp_link('/res/js/jquery-1.7.2.js') ?>"></script>
<script type="text/javascript" src="<?= lassoapp_link('/res/js/bootstrap.min.js') ?>"></script>
<script type="text/javascript" src="<?= lassoapp_link('/res/js/sitejs.js') ?>"></script>
<?= $pagescripts -> join('\n') ?>
</html>