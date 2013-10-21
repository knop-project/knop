[
log_critical('loading inputtexttb3');
define_tag('inputtexttb3',
    -namespace='tpl_',
    -description='This widget template renders an input of type text and uses Twitter Bootstrap 3 as its framework.',
    -required='name',
    -optional='class',
    -optional='errmsg', -type='array',
    -optional='errorclass',
    -optional='id',
    -optional='label',
    -optional='placeholder',
    -optional='required',
//    -optional='title',
    -optional='value'
);
    local('output' = string);

    local('t_name' = ' name="' + #name + '"');
    local('for');
    local('t_id');

    local_defined('class') && #class != '' ? local('t_class' = ' class="' + #class + '"') | local('t_class');
    !local_defined('errmsg') ? local('errmsg' = array);
    !local_defined('errorclass') ? local('errorclass');
    if(local_defined('id'));
        #for = ' for="' + #id + '"';
        #t_id = ' id="' + #id + '"';
    /if;
    !local_defined('label') ? local('label') = #name;
    local_defined('placeholder') && #placeholder != '' ? local('t_placeholder' = ' placeholder="' + #placeholder + '"') | local('t_placeholder');
    !local_defined('required') ? local('required');
    
//    !local_defined('title') ? local('title');
    local_defined('value') ? local('t_value' = ' value="' + #value + '"') | local('t_value');

    // use "macros" to create strings for slugs
    local('ec' = (#errmsg->size && #errorclass != '' ? ' '+#errorclass));
    local('em' = (#errmsg->size ? '        <span class="help-inline">'+#errmsg->join(' ') + '</span>
'));
    
    // Generate the HTML output
    #output = '
<div class="control-group'+ #ec + '">
    <label class="control-label"' + #for + '>' + #label + #required + '</label>
    <div class="controls">
        <input type="text"' + #t_name + #t_value + #t_id + #t_class + #t_placeholder + '>' + #em + '
    </div>
</div>
';

    return(#output);
/define_tag;
]
