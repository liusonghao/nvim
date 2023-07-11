vim.cmd([[
"----------vimtex----------------------------
"-----------开启latex支持---------------------
let g:tex_flavor = 'latex'
"----------报错筛选---------------------------
let g:vimtex_quickfix_open_on_warning=0
let g:vimtex_quickfix_ignore_filters = [
      \ 'Underfull \\hbox',
      \ 'Overfull \\hbox',
      \ 'LaTeX Warning: .\+ float specifier changed to',
      \ 'LaTeX hooks Warning',
      \ 'Package siunitx Warning: Detected the "physics" package:',
      \ 'Package hyperref Warning: Token not allowed in a PDF string',
     \]

let g:vimtex_delim_toggle_mod_list = [
      \ ['\left', '\right'],
      \ ['\bigl', '\bigr'],
      \ ['\Bigl', '\Bigr'],
      \ ['\biggl', '\biggr'],
      \ ['\Biggl', '\Biggr'],
      \]

"使vimtex默认xelatex为编译器

" let g:vimtex_compiler_latexmk_engines = {'_':'-xelatex'}
let g:vimtex_compiler_latexmk_engines = {'_':'-pdflatex'}

"
" let g:vimtex_compiler_latexrun_engines ={'_':'xelatex'}



"----------------跳转设置----------------------------
   if has('win32') || (has('unix') && exists('$WSLENV'))
     if executable('sioyek.exe')
       let g:vimtex_view_method = 'sioyek'
       let g:vimtex_view_sioyek_exe = 'sioyek.exe'
       let g:vimtex_callback_progpath = 'wsl nvim'
     elseif executable('mupdf.exe')
       let g:vimtex_view_general_viewer = 'mupdf.exe'
     elseif executable('SumatraPDF.exe')
       let g:vimtex_view_general_viewer = 'SumatraPDF.exe'
     endif
   endif

]])
