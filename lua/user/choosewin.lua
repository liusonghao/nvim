vim.cmd([["window选择器
" if you want to use overlay feature
let g:choosewin_overlay_enable = 1
nmap - <Plug>(choosewin)
let g:choosewin_keymap   = {}         " initialize as Dictionary
let g:choosewin_keymap.m = 'win_land' " Navigate with 'm'
let g:choosewin_keymap.0 = '<NOP>'    " Disable default 0 keybind
]])
