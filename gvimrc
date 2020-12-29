" Remove toolbar
set guioptions-=T

set lines=59
set columns=122

set guifont=Monaco:h16
set noantialias

"colorscheme mac_classic
colorscheme topfunky-light

" Do not use modal alert dialogs (prefer Vim style prompt)
set guioptions+=c

macmenu &File.New\ Tab key=<Nop>
"map <D-t> :CommandT<CR>
"imap <D-t> <Esc>:CommandT<CR>

macmenu &File.Close key=<nop>
macmenu &File.Close\ Window key=<nop>

" Next/prev buffer
macmenu Window.Show\ Next\ Tab key=<Nop>
map <silent> <D-}> :bnext<CR>
imap <silent> <D-}> <Esc>:bnext<CR>
macmenu Window.Show\ Previous\ Tab key=<Nop>
map <silent> <D-{> :bprev<CR>
imap <silent> <D-{> <Esc>:bprev<CR>

" Highlight long lines
if exists('+colorcolumn')
    set colorcolumn=80
    highlight ColorColumn ctermbg=lightgrey guibg=#f9f9f9
else
    highlight OverLength ctermbg=darkred ctermfg=white guibg=#ffd9d9
    match OverLength /\%>79v.\+/
endif
