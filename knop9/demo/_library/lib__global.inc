<?LassoScript

// dynamically disable certain nav elements - after action

if( !(string($nav -> 'path') -> beginswith('customer/edit')));
	// check for disable also in lib__global
	$nav -> getnav('customer/edit') -> insert('disabled' = true);
/if;

if( !(string($nav -> 'path') -> beginswith( 'advanced/edit')));
	// check for disable also in lib__global
	$nav -> getnav('advanced/edit') -> insert('disabled' = true);
/if;


?>
