<?LassoScript

// configure navigation, i.e. the site's structure

// create main navigation object
var( 'nav'=knop_nav(
		-default='customer',
		-root=$siteroot,
		-navmethod=$navmethod));

var( 'subnav_temp'=null, 'subnav2_temp'=null);

// create nav object for children items
$subnav_temp = knop_nav;
$subnav_temp -> insert(
		-key='list',
		-label=$lang_ui -> customerlist);
$subnav_temp -> insert(
		-key='edit',
		-label=$lang_ui -> editcustomer);

// add nav item with children items
$nav -> insert(
		-key='customer',
		-label=$lang_ui -> customerssimple,
		-children=$subnav_temp,
		-default='list');

// create nav object for children items
$subnav_temp = knop_nav;
$subnav_temp -> insert(
		-key='list',
		-label=$lang_ui -> customerlist);
$subnav_temp -> insert(
		-key='edit',
		-label=$lang_ui -> editcustomer);

if( $s_user -> auth);
	// add nav item with children items
	$nav -> insert(
			-key='advanced',
			-label=$lang_ui -> customersadvanced,
			-children=$subnav_temp,
			-default='list');
/if;

$nav -> insert(
		-key='article',
		-label=$lang_ui -> articles,
		-disabled);

$nav -> insert(
		-key='sitemap',
		-label=$lang_ui -> sitemap);


if( $s_user -> auth);
	$nav -> insert(
			-key='login',
			-label=$lang_ui -> mypage);
else;
	$nav -> insert(
			-key='login',
			-label=$lang_ui -> login);
/if;

$nav -> insert(
		-key='booking',
		-label=$lang_ui -> booking,
		-url='/calendar',
		-after='people');


$nav -> insert(
		-key='logout',
		-hide);


// determine current location so we know what the current path and actionpath is
$nav -> getlocation;


// dynamically disable certain nav elements - before action

if( !(string($nav -> 'path') -> beginswith('customer/edit'))
	&& !(($nav -> 'actionpath') -> beginswith('customer/edit')));
	// check for disable also in lib__global
	$nav -> getnav('customer/edit') -> insert('disabled' = true);
/if;

if( !(string($nav -> 'path') -> beginswith('advanced/edit'))
	&& !(($nav -> 'actionpath') -> beginswith('advanced/edit')));
	// check for disable also in lib__global
	$nav -> getnav('advanced/edit') -> insert('disabled' = true);
/if;

?>
