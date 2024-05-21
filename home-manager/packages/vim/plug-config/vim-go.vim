" ============= GO =============== "
let g:go_fmt_command = "goimports"

" ===== styling ===== "
" highlight types
let g:go_highlight_types = 1
" highlight fields
let g:go_highlight_fields = 1
" highlight functions
let g:go_highlight_functions = 1
" highlight function calls
let g:go_highlight_function_calls = 0
" highlight operators
let g:go_highlight_operators = 0
" highlight extra types
let g:go_highlight_extra_types = 1
" highlight build constraints
let g:go_highlight_build_constraints = 1
" highlight generate tags
let g:go_highlight_generate_tags = 1
" automatically highlight variable your cursor is on
let g:go_auto_sameids = 0
" show type infor on hover
let g:go_auto_type_info = 1
" set updatetime=100

" ===== keybindings ===== "
" run all tests in the current file
autocmd FileType go nmap <leader>vgt  <Plug>(go-test)
" run the current test
autocmd FileType go nmap <leader>vgtt <Plug>(go-test-func)

" build & run
autocmd FileType go nmap <leader>vgb  <Plug>(go-build)
autocmd FileType go nmap <leader>vgr  <Plug>(go-run)

" alternate /b/ test files with :A[VST]?
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
