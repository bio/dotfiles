" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" GUI configuration
if has("gui_running")
    " Remove toolbar
    set guioptions-=T

    set lines=59
    set columns=122

    set guifont=Monaco:h15
    set noantialias


    " Do not use modal alert dialogs! (Prefer Vim style prompt)
    set guioptions+=c
endif

" Store plugin to its own private directory in .vim/bundle
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()


set backupdir=$HOME/tmp/vim
set directory=$HOME/tmp/vim/swap

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set hidden

set fileencoding=utf-8

if has("autocmd")
    " For all text files set 'textwidth' to 79 characters.
    autocmd FileType text setlocal textwidth=79

    autocmd BufEnter *.php set syn=php
endif

filetype on
syntax on

" Turn ON autoindent
"set autoindent

" use :w!! to write to a file using sudo if you forgot to 'sudo vim file'
cmap w!! %!sudo tee > /dev/null %
