vim.cmd([[
" ================屏幕滚动条======================================
 let g:scrollview_excluded_filetypes = ['nerdtree']
 let g:scrollview_current_only = 1
 let g:scrollview_winblend = 75
 " Position the scrollbar at the 80th character of the buffer
 "let g:scrollview_base = 'buffer'
let g:scrollview_column = 1
 " ==================================================================================================
highlight ScrollView ctermbg=159 guibg=LightCyan
]])
