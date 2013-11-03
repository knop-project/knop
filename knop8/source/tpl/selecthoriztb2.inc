[
log_critical('loading selecthoriztb2');
define_tag('selecthoriztb2',
    -namespace='tpl_',
    -description='This widget template renders an input of type select and uses Twitter Bootstrap 3 as its framework.',
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
    -optional='multiple',
    -optional='options',
    -optional='required',
    -optional='size',
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
    if(local_defined('id'));
        #for = ' for="' + #id + '"';
        #t_id = ' id="' + #id + '"';
    /if;
    !local_defined('label') ? local('label') = #name;
    local_defined('multiple') && #multiple != '' ? local('t_multiple' = ' multiple') | local('t_multiple');
    !local_defined('options') ? local('options');
    !local_defined('required') ? local('required');
    local_defined('size') && #size != '' ? local('t_size' = ' size="' + #size + '"') | local('t_size');
    local_defined('value') ? local('t_value' = ' value="' + #value + '"') | local('t_value');

    // use "macros" to create strings for slugs
    local('ec' = (#errmsg->size && #errorclass != '' ? ' '+#errorclass));
    local('em' = (#errmsg->size ? '        <span class="help-inline">'+#errmsg->join(' ') + '</span>
'));
    local('go' = (#group ? '
<div class="' + #groupclass + #ec + '">'));
    local('gc' = (#group ? '</div>
'));

    if(#default != '' && integer(#size) <= 1);
        local('t_default') = '
<option value="">' + encode_html(#default) + '</option>
<option value=""></option>';
    else;
        local('t_default');
    /if;

    local('optgroup_open' = false);
    local('t_options' = string);
    iterate(#options, local('option'));
        if(#option->name == '-optgroup');
            if(#optgroup_open);
                #t_options += '</optgroup>';
            /if;
            if(#option->value != '-optgroup');
                #t_options += '<optgroup label="' + #option->value + '">';
                #optgroup_open = true;
            /if;
        else;
            #t_options += '<option value="' + encode_html(#option->name) + '"';
            if(#option->name != '' && #fieldvalue_array >> #option->name);
                #t_options += ' selected="selected"';
            /if;
            #t_options += '>' + encode_html(#option->value) + '</option>';
        /if;
    /iterate;
    if(#optgroup_open);
        #t_options += '</optgroup>';
    /if;
    
    // Generate the HTML output
    #output = #go + '
    <label class="control-label" ' + #for + '>' + #label + #required + '</label>
    <div class="controls">
        <select' + #t_name + #t_class + #t_disabled + #t_id + #t_multiple + #t_size + #t_value + '>'
        + #t_default
        + #t_options
'
        </select>
' + #em + '</div>
' + #gc;

    return(#output);
/define_tag;
]
