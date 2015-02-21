<!DOCTYPE html>
<html>
  <head>
    <title>Build Knop for Lasso 8</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap -->
    <link href="../demo/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <style type="text/css" title="text/css">
<!--
body {
  padding-top: 50px;
}
.starter-template {
  padding: 40px 15px;
  text-align: center;
}
-->
    </style>
  </head>
  <body>
    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".nav-collapse">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="#">Knop Project</a>
        <div class="nav-collapse collapse">
          <ul class="nav navbar-nav">
            <li class="active"><a href="/knop8/source/buildnamespace.lasso">Build</a></li>
            <li><a href="https://github.com/knop-project/knop/">GitHub</a></li>
            <li><a href="https://github.com/knop-project/knop/issues/">Issue Tracker</a></li>
            <li><a href="https://groups.google.com/forum/#!forum/knop-project">Subscribe to Mail List</a></li>
            <li><a href="http://lasso.2283332.n4.nabble.com/Knop-Framework-Discussion-f3157831.html">Mail List Archive</a></li>
            <li><a href="/docs/help.lasso">Help</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </div>

    <div class="container">

      <div class="starter-template">
        <h1>Knop for Lasso 8 Control Panel</h1>
      </div>
      <div class="row">
        <div class="col-lg-12">
          <form action="[response_filepath]" method="post">
            <div class="radio">
              <label>
                <input type="radio" name="build_option" id="build_option1" value="reload">
                Reload Knop
              </label>
            </div>
            <div class="radio">
              <label>
                <input type="radio" name="build_option" id="build_option2" value="local">
                Build Knop in <code>/knop8/LassoLibraries/</code>
              </label>
            </div>
            <div class="radio">
              <label>
                <input type="radio" name="build_option" id="build_option2" value="site">
                Build Knop in <code>[Admin_LassoServicePath + '/LassoLibraries/']</code> and reload
              </label>
            </div>
            <button type="submit" class="btn btn-primary" name="submit" id="submit" value="submit">Release the Hounds!</button>
          </form>
   
<?LassoScript
/*
Run this file to:
* reload Knop
* build the namespace file from the source files and place it locally in /knop/LassoLibraries/
* build the namespace file from the source files and place it locally in in the LassoSite and reload the namepace.

The syntax is checked before replacing the previous namespace file to prevent accidents.

Lasso needs write permission outside of root.

The individual files should be saved as UTF-8 with LF linebreaks.

*/
if(action_param('submit') == 'submit');
    local('bo' = action_param('build_option'));
    var: 'namespace'='knop',
        'syntaxok'=true,
        'typename'=string,
        'type_changenotes'=string,
        'changenotes'=map;
    if(#bo == 'reload');
        '<p>Unloading namespace ' + $namespace + '</p>';
        namespace_unload($namespace + '_');
        '<p>Loading namespace ' + $namespace + ' ' + date -> format('%Q %T') + ': ';
        namespace_load($namespace+'_');
         '</p>';
    else;
        // build Knop
        auth_admin;
       
        var('filedata'=string,
            'output'=bom_utf8 + '[/* \n\n\tOn-Demand library for namespace ' + $namespace + '\n\tNamespace file built date ' + date -> format('%Q %T') + ' by http://' + server_name + response_filepath + '\n\tMontania System AB\n\n*/]\n\n');
       
        iterate(array(
            '_ctag/util.inc',
            '_ctype/base.inc',
            '_ctype/database.inc',
            '_ctype/form.inc',
            '_ctype/grid.inc',
            '_ctype/lang.inc',
            '_ctype/nav.inc',
            '_ctype/user.inc'), var('file'));
            if($syntaxok);
                if($file >> 'util.inc');
                    $typename = $namespace + ' custom tags in ' + ($file - '_ctag/');
                else;
                    $typename = $namespace + '_' + ($file - '_ctype/' - '.inc');
                /if;
                '<p>Loading file ' + $file + ' ' + file_currenterror + ' ' + (error_code != 0 ? error_msg) + ' ';
                $filedata = file_read($file);
                $filedata -> removeleading(bom_utf8);
                ' - checking syntax</p>';
                protect;
                    tag->compile($filedata);
                    handle_error;
                        $syntaxok = false;
                        'Error <code>' $file '\n';
                        error_msg;
                        '</code>';
                        loop_abort;
                    /handle_error;
                    '<p>No error</p>';
                    $output += '[\n//------------------------------------------------------------------\n\
//    Begin ' + $typename + '\n\
//------------------------------------------------------------------\n\n]' + $filedata + '[\n\
//------------------------------------------------------------------\n\
//    End ' + $typename + '\n\
//------------------------------------------------------------------\n\n\
//##################################################################\n\n]';
                /protect;
                $type_changenotes = string_findregexp($filedata, -find='(?si)/\\*\\s*CHANGE NOTES[\\n\\r](.*?)\\*/');
                if($type_changenotes -> size >= 2);
                    $changenotes -> insert($typename = $type_changenotes -> get(2));
                /if;
            /if;
        /iterate;
        var('changenotes_new'=$changenotes);

        if($syntaxok);
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
                '<p>Checking syntax for finished namespace file</p>';
                tag->compile($output);
                handle_error;
                    $syntaxok = false;
                    '<p><code>';
                    error_msg;
                    '</code></p>';
                /handle_error;
            /protect;
        /if;
       
        if($syntaxok);
            '<p><span class="label label-success">Syntax OK</span></p>';
            if(#bo == 'site');
                '<p>Unloading namespace ' + $namespace + '</p>';
                namespace_unload($namespace + '_');
                var('path' = Admin_LassoServicePath);
            else;
                var('path' = response_path);
                $path->removetrailing('/source/');
            /if;
            $path += '/LassoLibraries/' + $namespace + '.lasso';
            if(file_exists($path));
                // Look for new or modified change notes
                var('oldfile' = file_read($path));
                var('oldchangenotes' = string_findregexp($oldfile, -find='(?si)define_type[(:]\\s*\'(.*?)\'.*?/\\*\\s*CHANGE NOTES[\\n\\r](.*?)\\*/'));
                var('oldchangenotes_map' = map,
                    'oldtype' = string,
                    'newchangenotes' = array);
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
            /if;

            '<p>Writing to file: ' + $path + '</p>';
            file_create($path, -fileoverwrite);
            '<p>create: ' + file_currenterror + ' ' + (error_code != 0 ? error_msg) + '</p>';
            file_write($path, $output, -fileoverwrite);
            '<p>write: ' + file_currenterror + ' ' + (error_code != 0 ? error_msg) + '</p>';

            if(#bo == 'site');
                '<p>Loading namespace ' + $namespace + ' ' + date -> format('%Q %T') + '</p>';
                namespace_load($namespace + '_');

                var('fullpath' = response_localpath);
                $fullpath -> removetrailing($fullpath -> split('/') -> last);
                if(file_exists($fullpath + 'LassoLibraries/'));
                    // for development workflow - ignore
                    $path = $fullpath + 'LassoLibraries/' + $namespace + '.lasso';
                    '<p>Writing to file: ' + $path + '</p>';
                    file_create($path, -fileoverwrite);
                    '<p>create: ' + file_currenterror + ' ' + (error_code != 0 ? error_msg) + '</p>';
                    file_write($path, $output, -fileoverwrite);
                    '<p>write: ' + file_currenterror + ' ' + (error_code != 0 ? error_msg) + '</p>';
                /if;
            /if;
        else;
            '<p><span class="label label-danger">Stopping build due to syntax error</span>, keeping old namespace file ' + date -> format('%Q %T') + '</p>';
        /if;
        '<p>Tag exists: ' + lasso_tagexists('knop_form') + '</p>';
/* 
        var('servername' = server_name);
        $servername -> removeleading('dev.') & removeleading('www.') & removeleading('preview.');
        $servername = $servername -> split('.') -> first + ' ' + Site_Name;
        $__html_reply__ = '<html><head><title>' + ($syntaxok ? 'OK ' | '*** Syntax error ') + $servername + '</title></head><body>' + $__html_reply__;
 */
    /if;
/if;
?>
        </div>
      </div>
    </div><!-- /.container -->

    <!-- JavaScript plugins (requires jQuery) -->
    <script src="//code.jquery.com/jquery.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="../demo/bootstrap/dist/js/bootstrap.min.js"></script>

    <!-- Optionally enable responsive features in IE8. Respond.js can be obtained from https://github.com/scottjehl/Respond -->
    <script src="../demo/bootstrap/assets/js/respond.min.js"></script>

  </body>
</html>
