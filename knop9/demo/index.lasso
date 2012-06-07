<?lassoscript

// Specify the root path to this solution. The path should begin and end with "/".
// Specify just "/" if the solution is at the virtual host root instead of in a sub folder.
// Normally this is specified by the urlhandler if everything is set up properly
if(!var_defined( 'siteroot'));
	var('siteroot'='/');
/if;


// global configuration
include( $siteroot + '_config/cfg__global.inc');

// configure language strings
include( $siteroot + '_config/cfg__lang.inc');


// Configure navigation
include( $siteroot + '_config/cfg__nav.inc');

// From now on, all includes are handled by the $nav object.

// PART 1 - Handle what happened on the page we came from. This is specified by the action path.
// If no action path is specified by the -action parameter, nothing happens here.

// First load the configuration for the action path
$nav -> include('actionconfig');
// Now execute the application logics for the action path
$nav -> include('action');


// PART 2 - Prepare the output for the page we are showing, specified by the path.

// First load the configuration for the path.
// It will not be loaded again if it has already been loaded as action config, to avoid overriding the result of the action.
$nav -> include('config'); // config is a special keyword for -> include

// Run some code that is common for all pages and that needs to be run after the action.
$nav -> include('_library/lib__global.inc'); // -> include is called with a specific filename

// Run page logics to prepare what will be displayed for the current path.
$nav -> include('library');


// Page output begins here, so from here on we could use a template include for better separation of logic and presentation

?><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
        "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">

<html>
<head>
	<title>Knop Demo - [$nav -> label]</title>
	<link rel="stylesheet" href="[$siteroot]css/nav.css" type="text/css">
	<link rel="stylesheet" href="[$siteroot]css/grid.css" type="text/css">
	<link rel="stylesheet" href="[$siteroot]css/form.css" type="text/css">
	<link rel="stylesheet" href="[$siteroot]css/general.css" type="text/css">
</head>

<body>

[/* Show navigation menu */]
<div id="menu">

[$nav -> renderhtml]

</div>


[/* content div starts here. Give it a top padding that depends on the number of menu levels that are shown on the current page. */]
<div id="content" style="padding-top: [2 + (($nav -> 'renderhtml_levels') - 1) * 3]em">

[/* Show page contents */

$nav -> include('content');

if( $message -> size);
	/* Show message box to display messages from action logics or other. Messages are stored in an array so multiple messages can be shown in the same box. */]
	<p class="message">
		[iterate( $message, var( 'messageitem'));
			loop_count > 1 ? '<br>\n';
			if( $messageitem -> type == 'pair');
				// if message item is a pair, the left side of the pair is a class name to use to format this message text
				$messageitem = ('<span class="' + ($messageitem -> name) + '">' + ($messageitem -> value) + '</span>');
			else;
				$messageitem;
			/if;
		/iterate]
	</p>
[/if]

</div>




[if($debug);
	/* show debug information */]
	<div class="debug">
	<b>Debug information</b><br>
	[
	$trace -> size ? 'General trace: <br>' + $trace -> join('<br>') + '<br>';
//	$nav -> trace(-html);
	if(var_defined('list'));
		'Sort params: ' + $list -> sortparams -> join('<br>');
		'<br>';
		'Sort params SQL: ' + $list -> sortparams(-sql);
		'<br>';
//		$list -> trace(-html);
		'Grid language trace: ' + $list -> lang -> trace( -html);
	/if;

//	var_defined('f') ? $f -> trace(-html);
	$d -> trace(-html);
	$s_user -> trace(-html);
	'id_user: ' + ($s_user -> id_user);
	'<br>';
	$lang_ui -> trace(-html);
	$lang_buttons -> trace(-html);
	]
	</div>
[/if]
</body>
</html>
