" Use Vim settings, rather then Vi settings.
" This must be first, because it changes other options as a side effect.
set nocompatible

" Store plugins to its own private directory in .vim/bundle
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

set backupdir=$HOME/tmp/vim
set directory=$HOME/tmp/vim

" Disable visual error flash and the error beep
set visualbell t_vb=
set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set nojoinspaces
set hidden
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

set fileencoding=utf-8

" Keep 50 lines of command line history
set history=50
" Show the cursor position all the time
set ruler
" Display incomplete commands
set showcmd
" Do incremental searching
set incsearch

" Always show the status line (even if no split windows)
set laststatus=2

" Show options as list when switching buffers etc
set wildmenu
set wildmode=longest,full
" Patterns to ignore during file-navigation
set wildignore+=*.o,*/.git/*,*/.hg/*,*/.svn/*

" Moise in all modes
set mouse=a

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("autocmd")
    " For all text files set 'textwidth' to 79 characters.
    autocmd FileType text setlocal textwidth=79

    autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType css setlocal ts=4 sts=4 sw=4 noexpandtab
    autocmd FileType markdown setlocal wrap linebreak nolist

    " Automatically remove trailing whitespace
    autocmd BufWritePre *.php,*.py,*.css,*.js,*.md,*.txt :call Preserve("%s/\\s\\+$//e")

    " Don't write backup file if vim is being called by "crontab -e"
    autocmd BufWrite /private/tmp/crontab.* set nowritebackup
    " Don't write backup file if vim is being called by "chpass"
    autocmd BufWrite /private/etc/pw.* set nowritebackup

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " ??? Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

    augroup END
else
	" always set autoindenting on
    set autoindent
endif

filetype on

" Highlight matching parenthesis (brackets)
set showmatch

" Toggles & Switches (Leader commands)
let mapleader = ","
nmap <silent> <leader>l :set list!<CR>
nmap <silent> <leader>w :set wrap!<CR>
nmap <silent> <leader>n :silent :nohlsearch<CR>
"nmap <silent> <ESC><ESC> :silent :nohlsearch<CR>

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

" Fuzzy Finder
map <silent> <leader>fb :FufBuffer!<CR>
map <silent> <leader>ff :FufFile!<CR>
map <silent> <leader>fc :FufRenewCache<CR>
map <silent> <leader>fm :FufMruFile<CR>
map <silent> <leader>b :FufBuffer!<CR>

" Mappings for a recovering TextMate user indentation
nmap <D-[> <<
imap <D-[> <C-O><<
nmap <D-]> >>
imap <D-]> <C-O>>>
vmap <D-[> <gv
vmap <D-]> >gv

" Commenting
vmap <D-/> \\gv
map <D-/> \\\

" ctrl-a and ctrl-e move the cursor to the start and end of the line 
" without leaving insert mode
" http://stackoverflow.com/questions/6926034
imap <C-a> <C-o>I
imap <C-e> <C-r>=InsCtrlE()<cr>
function! InsCtrlE()
    try
        norm! i
        return "\<C-o>A"
    catch
        return "\<C-e>"
    endtry
endfunction

" Command-T
let g:CommandTMaxFiles=20000
nmap <silent> <leader>t :CommandT<CR>
imap <silent> <leader>t <Esc>:CommandT<CR>
" flush path cache and rescan dir
nmap <silent> <leader>f :CommandTFlush<CR>
imap <silent> <leader>f <Esc>:CommandTFlush<CR>

menu Encoding.utf-8 :e ++enc=utf-8<CR>
menu Encoding.windows-1251 :e ++enc=cp1251<CR>

" allow cyrillic into Normal mode 
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,
        \фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz,
        \ХЪЖЭБЮ;{}:\\"<>,
        \хъжэбю;[];'\\,.,
        \№;#
