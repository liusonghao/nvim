vim.cmd([[ 
let g:im_select_get_im_cmd = ['im-select']
let g:ImSelectSetImCmd = {key -> ['im-select', key]}
function! GetImCallback(exit_code, stdout, stderr) abort
    return a:stdout
endfunction
let g:ImSelectGetImCallback = function('GetImCallback')
let g:im_select_default = '1033'
]])
