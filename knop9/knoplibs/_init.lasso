<?lasso
/*
Load core methods in order.
Optionally shuffle the loading order of elements as desired.
*/
local(coremethods) = array(
//    'debug.type.lasso',
    'knop_utils.lasso',
    'knop_base.lasso',
    'knop_cache.lasso',
    'knop_lang.lasso',
    'knop_database.lasso',
    'knop_form.lasso',
    'knop_grid.lasso',
    'knop_nav.lasso',
    'knop_user.lasso'
)


(not lasso_tagExists('debug')) ? #coremethods -> insertfirst('debug.type.lasso')
// Courtesy of Ke Carlton. L-Debug for Lasso 9, https://github.com/zeroloop/l-debug

with file in #coremethods do protect => {
    local(s) = micros
    handle => {
        stdoutnl(
            error_msg + ' (' + ((micros - #s) * 0.000001) -> asstring(-precision=3) + ' seconds)'
        )
    }

    stdout('\t' + #file + ' - ')

    web_request
    ? library(include_path + #file)
    | lassoapp_include(#file)

}
?>
