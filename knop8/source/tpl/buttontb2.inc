[
log_critical('loading buttontb2');
define_tag('buttontb2',
    -namespace='tpl_',
    -description='This widget template renders a button horizontally and uses Twitter Bootstrap 2 as its framework.',
    -required='name',
    -optional='class',
    -optional='disabled',
    -optional='errmsg', -type='array',
    -optional='group',
    -optional='groupclass',
    -optional='id',
    -optional='type',
    -optional='value'
);
    local('output' = string);

    local('t_name' = ' name="' + #name + '"');
    local('t_id');

    local_defined('class') && #class != '' ? local('t_class' = ' class="' + #class + '"') | local('t_class');
    local_defined('disabled') && #disabled != false ? local('t_disabled' = ' disabled="disabled"') | local('t_disabled');
    !local_defined('errmsg') ? local('errmsg' = array);
    !local_defined('group') ? local('group' = false);
    !local_defined('groupclass') ? local('groupclass');
    if(local_defined('id'));
        #t_id = ' id="' + #id + '"';
    /if;
    local_defined('type') ? local('t_type' = ' type="' + #type + '"') | local('t_type' = ' type="button"');
    local_defined('value') ? local('t_value' = ' value="' + #value + '"') | local('t_value');

    // use "macros" to create strings for slugs
    local('ec' = (#errmsg->size && #errorclass != '' ? ' '+#errorclass));
    local('em' = (#errmsg->size ? '        <span class="help-inline">'+#errmsg->join(' ') + '</span>
'));
    local('go' = (#group ? '
<div class="' + #groupclass + #ec + '">'));
    local('gc' = (#group ? '</div>
'));
    
    // Generate the HTML output
    #output = #go + '
    <button' + #t_name + #t_disabled + #t_id + #t_type + #t_class + #t_value + '>' + #value + '</button>' + #gc;

    return(#output);
/define_tag;
]
