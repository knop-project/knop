#! /usr/bin/lasso9
    
// Find the absolute path here so we can source files relative to this one
local(path_here) = currentCapture->callsite_file->stripLastComponent
not #path_here->beginsWith('/')
    ? #path_here = io_file_getcwd + '/' + #path_here
not #path_here->endsWith('/')
    ? #path_here->append('/')


local(core_libs) = (:
	'knop_base',
	'knop_cache',
	'knop_database',
	'knop_form',
	'knop_grid',
	'knop_lang',
	'knop_nav',
	'knop_user',
	'knop_utils'
)    
local(libs_path)    = #path_here + `../knoplibs/`
local(doc_src_path) = #path_here + `source/`
    
// How things should be indented
define indentor => '    '

// Procecssing doc comments by stripping the beginning and ending comment parts
// and reformatting the indentation based on the passed indentation level.
define process_doccomment(comment::string, indent_lvl::integer=0) => {
    #comment = #comment->asCopy
    #comment->removeLeading('/**!')&removeTrailing('*/')&removeTrailing('*')
             &removeLeading('\r\n')&removeLeading('\r')&removeLeading('\n')
    
    #comment->size == 0
        ? return
    
    local(ret) = ''
    
    // The first line of the doccomment will tell us how much whitespace is
    // the base - for each line we'll want to remove that amount
    local(num_remove) = 1
    while(#comment->isWhitespace(#num_remove)) => { #num_remove++ }
    #num_remove--
    
    with line in #comment->eachLine do {
        #line->remove(1, #num_remove)
        #ret->append((indentor * #indent_lvl) + #line + '\n')
    }

    return #ret
}    

// Knop depends on some libraries outside the Lasso 9 core
log_initialize
   

local(types) = map
local(sigs)  = map


with lib in #core_libs do {
    // Load the Knop library
    sourcefile(file(#libs_path + #lib + '.lasso'), -autoCollect=false)->invoke

    local(doc) = file(#doc_src_path + #lib + `.rst`)
    handle => { #doc->close }
    #doc->openTruncate

    with type in sys_listTypes
    where #type->asString->beginsWith(`knop`)
    where not #types->contains(#type->asString)
    do {
        #types->insert(#type->asString)
        #doc->writeBytes(bytes('.. type:: ' + #type + '\n\n'))
        local(comment) = process_doccomment(#type->doccomment, 1)
        #comment->size > 0
            ? #doc->writeBytes(bytes(#comment))
    
        // Get member methods defined specifically for the type
        with method in #type->getType->listMethods
        where #method->typeName == #type
        where `'` != #method->methodName->asString->get(1)
        let output = (#method->asString->remove(1, #type->asString->size + 2)&)
        let comment = process_doccomment(#method->doccomment, 2)
        order by #output
        do {
            #doc->writeBytes(bytes(indentor + '.. method:: ' + #output + '\n\n'))
            #comment->size > 0
                ? #doc->writeBytes(bytes(#comment))
        }
    }

    // Process knop methods
    // Don't want to include onCreate methods
    // Also need to track signatures that have already been processed (might be able to do that by index)
    with method in sys_listUnboundMethods
    let name = #method->methodName->asString
    where #name->beginsWith(`knop`)
    where not #types->contains(#name)
    where not #sigs ->contains(#method->asString)
    let comment = process_doccomment(#method->doccomment, 1)
    order by #method->asString
    do {
        #sigs->insert(#method->asString)
        #doc->writeBytes(bytes('.. method:: ' + #method + '\n\n'))
        #comment->size > 0
            ? #doc->writeBytes(bytes(#comment))
    }
}