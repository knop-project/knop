<?LassoScript
// Use some kind of security to prevent l-debug running where it should not.
// Uncomment the next line to activate l-debug, assuming you have installed it.
// client_getparams >> 'debug' && server_name == 'knop8' ? debug->activate;

// general configuration
var: 'maxrecords'=20, 
	'skiprecords'=0,
	'navmethod'='path',	// path or param
	'message'=array,		// message shown at end of page
	'message_form'=array,	// message shown before save buttons in form
	'debug'=false,
	'trace'=array;


// Configure databases
// One database object for each table that we are using in the solution
var: 'd'=(knop_database: -database='knopdemo', -table='customer', 
	-username='knop', -password='knop', // examples only
	-keyfield='keyfield', -lockfield='lockfield');


// Configure user
var: 's_user'=(knop_user: -userdb=$d, -userfield='email', -passwordfield='password'),
	's_lang'=null;

session_start: -name='knopdemo';
session_addvar: -name='knopdemo', 's_user', 's_lang';




if: server_name >> 'param'; // for demonstration purposes, set up a hostname that contains "param" to see how it runs with parameter based navigation
	$navmethod='param';
/if;


?>
