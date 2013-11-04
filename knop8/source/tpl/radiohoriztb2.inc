[
log_critical('loading radiohoriztb2');
define_tag('radiohoriztb2',
    -namespace='tpl_',
    -description='This widget template renders an input of type radio and uses Twitter Bootstrap 2 as its framework.',
    -required='name',
    -optional='class',
    -optional='default',
    -optional='disabled',
    -optional='errmsg', -type='array',
    -optional='errorclass',
    -optional='fieldvalue_array',
    -optional='group',
    -optional='groupclass',
    -optional='id',
    -optional='label',
    -optional='options',
    -optional='required',
    -optional='value'
);
    local('output' = string);

    local('t_name' = ' name="' + #name + '"');
    local('for');
    local('t_id');

    local_defined('class') && #class != '' ? local('t_class' = ' class="' + #class + '"') | local('t_class');
    !local_defined('default') ? local('default');
    local_defined('disabled') && #disabled != false ? local('t_disabled' = ' disabled="disabled"') | local('t_disabled');
    !local_defined('errmsg') ? local('errmsg' = array);
    !local_defined('errorclass') ? local('errorclass');
    !local_defined('fieldvalue_array') ? local('fieldvalue_array'=array);
    !local_defined('group') ? local('group' = false);
    !local_defined('groupclass') ? local('groupclass');
    !local_defined('label') ? local('label') = #name;
    !local_defined('options') ? local('options');
    !local_defined('required') ? local('required');
    local_defined('value') ? local('t_value' = ' value="' + #value + '"') | local('t_value');

    // use "macros" to create strings for slugs
    local('ec' = (#errmsg->size && #errorclass != '' ? ' '+#errorclass));
    local('em' = (#errmsg->size ? '        <span class="help-inline">'+#errmsg->join(' ') + '</span>
'));
    local('go' = (#group ? '
<div class="' + #groupclass + #ec + '">
'));
    local('gc' = (#group ? '</div>
'));

    local('t_radios' = string);
    iterate(#options, local('option'));
        local('t_id' = ' id="' + #id + '_' + loop_count + '"');
        local('t_value' = ' value="' + encode_html(#option->name) + '"');
        local('checked' = string);
        if(#option->name != '' && #fieldvalue_array >> #option->name);
            #checked = ' checked="checked"';
        /if;
        #t_radios += '
<label class="radio inline">
    <input type="radio"' + #t_name + #t_class + #t_disabled + #t_id + #t_value + #checked + '>' + #option->value + '
</label>
';
    /iterate;

    // Generate the HTML output
    #output = #go + '<div class="control-label">' + #label + #required + '</div>
<div class="span3">
' + #t_radios + #em + '
</div>
' + #gc;
    return(#output);
/define_tag;
]
