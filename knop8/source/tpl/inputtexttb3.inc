[
log_critical('loading inputtexttb3');
define_tag('inputtexttb3',
    -namespace='tpl_',
    -description='This widget template renders an input of type text and uses Twitter Bootstrap 3 as its framework.',
    -required='name',
    -optional='value',
    -optional='id',
    -optional='class',
    -optional='label',
//    -optional='title',
    -optional='errmsg', -type='array',
    -optional='errorclass'
);
    local('output' = string);

    local('t_name' = ' name="' + #name + '"');
    local('for');
    local('t_id');

    if(local_defined('id'));
        #for = ' for="' + #id + '"';
        #t_id = ' id="' + #id + '"';
    /if;
    local_defined('value') ? local('t_value' = ' value="' + #value + '"') | local('t_value');
    local_defined('class') && #class != '' ? local('t_class' = ' class="' + #class + '"') | local('t_class');
    !local_defined('label') ? local('label') = #name;
//    !local_defined('title') ? local('title');
    !local_defined('errmsg') ? local('errmsg' = array);
    !local_defined('errorclass') ? local('errorclass');

    // use "macros" to create strings for slugs
    local('ec' = (#errmsg->size && #errorclass != '' ? ' '+#errorclass));
    local('em' = (#errmsg->size ? '        <span class="help-inline">'+#errmsg->join(' ') + '</span>
'));
    
    // Generate the HTML output
    #output = '
<div class="control-group'+ #ec + '">
    <label class="control-label"' + #for + '>' + #label + '</label>
    <div class="controls">
        <input type="text"' + #t_name + #t_value + #t_id + #t_class + '>' + #em + '
    </div>
</div>
';

    return(#output);
/define_tag;
]
