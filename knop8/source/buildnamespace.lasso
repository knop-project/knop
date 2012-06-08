<?LassoScript
/*

Run this file to build the namespace file from the source files and place it in LassoLibraries for the LassoSite. 
Run it again to rebuild and reload the namepace. 

The syntax is checked before replacing the previous namespace file to prevent accidents. 


Lasso needs write permission outside of root. 

The individual files should be saved as UTF-8 with LF linebreaks. 

*/
auth_admin;
var: 'namespace'='knop',
	'syntaxok'=true,
	'typename'=string,
	'type_changenotes'=string,
	'changenotes'=map;


var: 'filedata'=string, 'output'=bom_utf8 + 
'[/* \n\n\tOn-Demand library for namespace '$namespace'\n\tNamespace file built date ' + (date -> format: '%Q %T') + ' by http://' + server_name + response_filepath 
+ '\n\tMontania System AB\n\n*/]\n\n';

iterate: (array: 
	'_ctag/util.inc',
	'_ctype/base.inc', 
	'_ctype/database.inc', 
	'_ctype/form.inc', 
	'_ctype/grid.inc',
	'_ctype/lang.inc', 
	'_ctype/nav.inc', 
	'_ctype/user.inc', 
	), (var: 'file');
	if: $syntaxok;
		if: $file >> 'util.inc';
		$typename = $namespace + ' custom tags in ' + ($file - '_ctag/');
		else;
		$typename = $namespace + '_' + ($file - '_ctype/' - '.inc');
		/if;
		'Loading file ' + $file + ' 'file_currenterror; ' '; (error_code != 0 ? error_msg); ' ';
		$filedata = file_read: $file;
		$filedata -> (removeleading: bom_utf8);
		' - checking syntax ';
		protect;
			tag->(compile: $filedata);
			handle_error;
				$syntaxok = false;
				'Error<pre style="color: red"><b>' $file '</b>\n';
				error_msg;
				'</pre>';
			loop_abort;
			/handle_error;
			'No error<br>';
			$output += '[\n//------------------------------------------------------------------\n\
						//    Begin ' + $typename + '\n\
						//------------------------------------------------------------------\n\n]' + $filedata + '[\n\
						//------------------------------------------------------------------\n\
						//    End ' + $typename + '\n\
						//------------------------------------------------------------------\n\n\
						//##################################################################\n\n]';
		/protect;
		
		$type_changenotes=(string_findregexp: $filedata, -find='(?si)/\\*\\s*CHANGE NOTES[\\n\\r](.*?)\\*/');
		if: $type_changenotes -> size >= 2;
			$changenotes -> insert($typename = $type_changenotes -> get(2));
		/if;
		
	/if;
/iterate;
var('changenotes_new'=$changenotes);

if: $syntaxok;
	// add tag to return change notes
	$output += '[define_tag(\'changenotes\', -description=\'This tag is created on the fly by buildnamespace.lasso\',
		-namespace=\'' + $namespace + '_\',
		-optional=\'type\', -optional=\'date\', -copy);
		local(\'output\'=string, \'changenotes\'=map(';
		iterate($changenotes, var('changenote'));
			$output += '\'' + $changenote -> name + '\'=\''
				+ ($changenote -> value -> replace('\\', '\\\\') & replace('\'', '\\\'') &)
				+ '\',';
		/iterate;
		$output += '));
		if(local_defined(\'type\'));return(#changenotes -> find(#type));else;
		!local_defined(\'date\') ? local(\'date\'=date(\'1900-01-01\')) | #date = date(#date);
		iterate(#changenotes, local(\'changenote\'));
			#output += #changenote -> name + \'\\n\';
			iterate(#changenote ->value -> split(\'\\n\'), local(\'changenote_row\'));
				if(date(#changenote_row -> split(regexp(\'\\\\s\')) -> first) >= #date);
					#output += #changenote_row + \'\\n\';
				/if;
			/iterate;
			#output += \'\\n\';
		/iterate;
		return(@#output);/if;
		/define_tag]';
				

	// check the entire file
	protect;
		'Checking syntax for finished namespace file<br>';
		tag->(compile: $output);
		handle_error;
			$syntaxok = false;
			'<pre style="color: red">';
			error_msg;
			'</pre>';
		/handle_error;
	/protect;
/if;

if: $syntaxok;
	'<b style="color: green">Syntax OK</b><br>Unloading namespace '$namespace'<br>';
	namespace_unload: $namespace + '_';
	var: 'path'=Admin_LassoServicePath;
	$path += '/LassoLibraries/'$namespace'.lasso';
	
	
	// Look for new or modified change notes
	var('oldfile'=file_read($path));
	var('oldchangenotes'=(string_findregexp: $oldfile, -find='(?si)define_type[(:]\\s*\'(.*?)\'.*?/\\*\\s*CHANGE NOTES[\\n\\r](.*?)\\*/'));
	var('oldchangenotes_map'=map,
		'oldtype'=string,
		'newchangenotes'=array);
	iterate($oldchangenotes, var('oldchangenotes_item'));
		if(loop_count % 3 == 2);
			$oldtype=$oldchangenotes_item;
		else(loop_count % 3 == 0);
			$oldchangenotes_map -> insert('knop_' + $oldtype = $oldchangenotes_item -> split('\n'));
		/if;
	/iterate;
	
	iterate($changenotes_new, var('type_changenote'));
		$type_changenote ->name; '<br>';
		iterate($type_changenote -> value -> split('\n'), var('changenote'));
		// 'comparing <br>' + $changenote + '<br>with<br>' + $oldchangenotes_map -> find($type_changenote -> name) -> get(loop_count)+ '<br>';
			if($oldchangenotes_map -> find($type_changenote -> name) !>> $changenote);
			// 'NEW: ' + $changenote ; '<br>';
			/if;
		/iterate;
		'<hr>';
	/iterate;
	
	// End Look for new or modified change notes
	
	
	
	'Writing to file ' + $path + '<br>';
	file_create: $path, -fileoverwrite;
	'create: 'file_currenterror; ' '; (error_code != 0 ? error_msg); '<br>';
	file_write: $path, $output, -fileoverwrite;
	'write: 'file_currenterror; ' '; (error_code != 0 ? error_msg); '<br>';
	
	'Loading namespace '$namespace + ' ' + (date -> (format: '%Q %T')) + ' ';
	namespace_load: $namespace+'_';
	'<br>';
	
	var('fullpath'=response_localpath);
	$fullpath -> removetrailing($fullpath -> split('/') -> last);
	
	if: file_exists: $fullpath + 'LassoLibraries/';
		// for development workflow - ignore
		$path = $fullpath + 'LassoLibraries/'$namespace'.lasso';
		'Writing to file ' + $path + '<br>';
		file_create: $path, -fileoverwrite;
		'create: 'file_currenterror; ' '; (error_code != 0 ? error_msg); '<br>';
		file_write: $path, $output, -fileoverwrite;
		'write: 'file_currenterror; ' '; (error_code != 0 ? error_msg); '<br>';
	/if;
	

else;
	'<b style="color: red">Stopping build due to syntax error</b>, keeping old namespace file ' (date -> (format: '%Q %T')) ' <br>';
/if;
'Tag exists: ' + lasso_tagexists: 'knop_form';

var: 'servername'=server_name;
$servername -> (removeleading: 'dev.') & (removeleading: 'www.') & (removeleading: 'preview.');
$servername = $servername -> (split: '.') -> first + ' ' + Site_Name;

$__html_reply__ = '<html><head><title>' + ($syntaxok ? 'OK ' | '*** Syntax error ') + $servername + '</title></head><body>' + $__html_reply__;
?>

</body>
</html>