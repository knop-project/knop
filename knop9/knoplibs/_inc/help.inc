<?LassoScript
/*Insert Lasso code here*/
	'This is help.lasso'

local(mytype = string)
br



//knop_database->listmethods -> join(br)


//lassoapp_include_current('knop_cache.lasso')
/*
local(my_file = file('/lasso9/knop/knop_cache.lasso'))
#my_file->doWithClose => {
    #my_file->openRead
    #mytype = #my_file->readstring
}
//encode_html(#mytype)
hr
*/
//local(myregexp = regexp(-find = `^/\*\*\!$(.*?|\r)^**/$`, -input = #mytype, -ignorecase))
//local(myregexp = regexp(-find = `(/\*\*!((.|\n)*?)\*\*/)`, -input = #mytype, -ignorecase))
/*

//#myregexp -> findall
var(myresult = array)
while(#myregexp -> find) => {
	$myresult -> insert(#myregexp -> matchstring(2))
}
'<pre>'
$myresult -> join('\r')
'</pre>'
*/
?>
