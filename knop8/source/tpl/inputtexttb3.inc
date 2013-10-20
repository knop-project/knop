[
log_critical('loading inputtexttb3');
define_tag('inputtexttb3',
    -namespace='tpl_',
    -description='Description',
    -required='name', -copy,
    -optional='value', -copy,
    -optional='id', -copy,
    -optional='class', -copy,
    -optional='title', -copy,
    -optional='errmsg', -copy,
    -optional='errorclass', -copy
);
    local('output' = string);

    local('t_name' = ' name="' + #name + '"');
    local('for');

    if(local_defined('id'));
        #for = ' for="' + #id + '"';
        local('t_id' = ' id="' + #id + '"');
    else;
        local('t_id');
    /if;
    local_defined('value') ? #value = ' value="' + #value + '"' | local('value');
    local_defined('class') ? #class = ' class="' + #class + '"' | local('class');
    !local_defined('title') ? local('title');
    !local_defined('errmsg') ? local('errmsg');
    !local_defined('errorclass') ? local('errorclass');

    #output = '
<div class="control-group'+(#errmsg->size && #errorclass != '' ? ' '+#errorclass)+'">
    <label class="control-label"' + #for + '>' + #label + '</label>
    <div class="controls">
        <input type="text"' + #t_name + #value + #t_id + '>
' + (#errmsg->size ? '        <span class="help-inline">'+#errmsg->join(' ')+'</span>
') + '    </div>
</div>
';

    return(#output);
/define_tag;
]