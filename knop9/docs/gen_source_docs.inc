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


// Knop depends on logging, so we need to initialize it.
log_initialize

    
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


/*
2012-12-06  Brad Lindsay  First Version
    Basic algorithm is to keep track of the number of methods and types currently loaded,
    and then load a library file and process the new methods and types that are loaded.
    However, because Lasso can dynamically load libraries, some of the new methods and
    types are from other libriaries and not defined in the file we just sourcefiled.
    Since all methods and types in knop are properly namespaced, we can filter for those
    methods and types that begin with "knop".
    
    LassoSoft Wishlist:
        - A way for sourcefile to return just the methods / types / traits defined in it.
        
        - A way to inspect a signature / type and see what file it was defined in. I'm
        not sure how error_stack's trace is implemented, but hopefully this would be easy
        to implement.

    Known Issues:
        - Currently doesn't process traits for documentation.
        
        - Need to figure out best way to handle thread object type.
        
            Currently, lasso shows a thread object type as two types: one that has the name
            it was given and one that has the name with "_thread$" tagged on to the end.
            While the member methods are all under the given name, the doccomment is stored
            in the one that adds "_thread$" to it. It would be nice to handle this.
        
        - If a member method is added to a trait or type outside the type declaration and
        in a different file than the type declaration, then it will not be processed.
        
        - No way of determining where a method, type, or trait was defined, so we are
        relying on all of them to have a "knop" prefix.
        
        - There is no Lasso domain for Sphinx, so all types are being labeled as classes.
        
        - Need to figure out how we want to handle multiple-dispatch. Currently, each
        method is listed on it's own, but it may be nice to list them all together. We
        may also want to list them together *unless* the following one has its own doccoment.
*/

// These variables are used to keep track of what has already been processed
local(types) = map
local(listTypes_index)
local(listMethods_index)

with lib in #core_libs do {
    #listTypes_index   = sys_listTypes->size
    #listMethods_index = sys_listUnboundMethods->size
    sourcefile(file(#libs_path + #lib + '.lasso'), -autoCollect=false)->invoke

    local(doc) = file(#doc_src_path + #lib + `.rst`)
    handle => { #doc->close }
    #doc->openTruncate&writeBytes(bytes(#lib + '\n' + ('=' * #lib->size) + '\n\n'))

    with type in sys_listTypes
    skip #listTypes_index
    where #type->asString->beginsWith(`knop`)
    do {
        #types->insert(#type->asString)
        #doc->writeBytes(bytes('.. class:: ' + #type + '\n\n'))
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
    // Also using listMethods_index to track where the new methods start
    with method in sys_listUnboundMethods
    skip #listMethods_index
    let name = #method->methodName->asString
    where #name->beginsWith(`knop`)
    where not #types->contains(#name)
    let comment = process_doccomment(#method->doccomment, 1)
    order by #method->asString
    do {
        #doc->writeBytes(bytes('.. method:: ' + #method + '\n\n'))
        #comment->size > 0
            ? #doc->writeBytes(bytes(#comment))
    }
}


file(#doc_src_path + `index.rst`)->doWithClose => {
    local(f) = #1
    
    #f->openTruncate&writeBytes(bytes("\
.. Knop documentation master file, created by
   gen_source_docs on " + date->format(`%a %b %-d %H:%M:%S %Y.`) + "
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to Knop's documentation!
================================

Contents:

.. toctree::
   :maxdepth: 2
   
"
    ))
    with lib in #core_libs do #f->writeBytes(bytes('   ' + #lib + '\n'))

    #f->writeBytes(bytes("

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
"
    ))
}