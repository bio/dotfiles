" Use Vim settings, rather then Vi settings.
" This must be first, because it changes other options as a side effect.
set nocompatible

" Store plugins to its own private directory in .vim/bundle
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()


" GUI configuration
if has("gui_running")
    " Remove toolbar
    set guioptions-=T

    set lines=59
    set columns=122

    set guifont=Monaco:h15
    set noantialias

    colorscheme mac_classic

    " Do not use modal alert dialogs (prefer Vim style prompt)
    set guioptions+=c
endif


set backupdir=$HOME/tmp/vim
set directory=$HOME/tmp/vim

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set hidden
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

set fileencoding=utf-8

if has("autocmd")
    " For all text files set 'textwidth' to 79 characters.
    autocmd FileType text setlocal textwidth=79

    autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType markdown setlocal wrap linebreak nolist
endif

filetype on
syntax on

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup

" Turn ON autoindent
"set autoindent

" Toggles & Switches (Leader commands)
let mapleader = ","
nmap <silent> <leader>l :set list!<CR>
nmap <silent> <leader>w :set wrap!<CR>

" use :w!! to write to a file using sudo if you forgot to 'sudo vim file'
cmap w!! %!sudo tee > /dev/null %


" Preserves the state
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" Strip trailing whitespaces
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>
vmap _$ :call Preserve("s/\\s\\+$//e")<CR>

" Automatically remove trailing whitespace
autocmd BufWritePre *.php,*.py,*.js :call Preserve("%s/\\s\\+$//e")

" Shortcuts for visual selections
nmap gV `[v`]

" Easily modify vimrc
nmap <leader>v :e $MYVIMRC<CR>
" Apply vim configurations without restarting
if has("autocmd")
    augroup myvimrchooks
        au!
        autocmd BufWritePost .vimrc source ~/.vimrc
    augroup END
endif

" Mappings for a recovering TextMate user indentation
nmap <D-[> <<
nmap <D-]> >>
vmap <D-[> <gv
vmap <D-]> >gv

menu Encoding.utf-8 :e ++enc=utf-8<CR>
menu Encoding.windows-1251 :e ++enc=cp1251<CR>
menu Encoding.koi8-r :e ++enc=koi8-r<CR>

