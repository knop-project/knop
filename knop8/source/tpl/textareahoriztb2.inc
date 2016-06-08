[
log_critical('loading textareahoriztb2');
define_tag('textareahoriztb2',
    -namespace='tpl_',
    -description='This widget template renders a textarea horizontally and uses Twitter Bootstrap 2 as its framework.',
    -required='name',
    -optional='class',
    -optional='cols',
    -optional='disabled',
    -optional='errmsg', -type='array',
    -optional='errorclass',
    -optional='group',
    -optional='groupclass',
    -optional='id',
    -optional='label',
    -optional='maxlength',
    -optional='placeholder',
    -optional='required',
    -optional='rows',
    -optional='size',
    -optional='value'
);
    local('output' = string);

    local('t_name' = ' name="' + #name + '"');
    local('for');
    local('t_id');

    local_defined('class') && #class != '' ? local('t_class' = ' class="' + #class + '"') | local('t_class');
    local_defined('cols') && #cols != '' ? local('t_cols' = ' cols="' + #cols + '"') | local('t_cols');
    local_defined('disabled') && #disabled != false ? local('t_disabled' = ' disabled="disabled"') | local('t_disabled');
    !local_defined('errmsg') ? local('errmsg' = array);
    !local_defined('errorclass') ? local('errorclass');
    !local_defined('group') ? local('group' = false);
    !local_defined('groupclass') ? local('groupclass');
    if(local_defined('id'));
        #for = ' for="' + #id + '"';
        #t_id = ' id="' + #id + '"';
    /if;
    !local_defined('label') ? local('label') = #name;
    local_defined('maxlength') && #maxlength != '' ? local('t_maxlength' = ' maxlength="' + #maxlength + '"') | local('t_maxlength');
    local_defined('placeholder') && #placeholder != '' ? local('t_placeholder' = ' placeholder="' + #placeholder + '"') | local('t_placeholder');
    !local_defined('required') ? local('required');
    local_defined('rows') && #rows != '' ? local('t_rows' = ' rows="' + #rows + '"') | local('t_rows');

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
    <label class="control-label"' + #for + '>' + #label + #required + '</label>
    <div class="controls">
        <textarea' + #t_name + #t_class + #t_disabled + #t_id + #t_cols + #t_rows + #t_placeholder + '>' + #value + '</textarea>' + #em + '
    </div>
' + #gc;

    return(#output);
/define_tag;
]
