" specify a directory for vim-plug plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'antoinemadec/FixCursorHold.nvim' " see https://github.com/neovim/neovim/issues/12587
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'rhysd/git-messenger.vim'
Plug 'tpope/vim-commentary'
call plug#end()

" show line numbers
set number

" all tabs chars are 4 space chars
set tabstop=4
set shiftwidth=4
set expandtab

" use system clipboard
set clipboard=unnamedplus

" enable the true color support
set termguicolors

" always show sign column
set signcolumn=number " or "yes:1"
highlight SignColumn ctermbg=255 guibg=#ffffff

" show ruler
set colorcolumn=80
highlight ColorColumn ctermbg=255 guibg=#f9f9f9

highlight LineNr ctermfg=251 ctermbg=none guifg=#c6c6c6
highlight VertSplit cterm=none ctermfg=0 ctermbg=15 gui=none guifg=#000000 guibg=#ffffff
highlight Comment ctermfg=21 ctermbg=none guifg=#0000ff

" highlight the current line number only
set cursorline
highlight CursorLine ctermbg=none guibg=none
highlight CursorLineNr ctermfg=243 ctermbg=none gui=none guifg=#767676

" enable mouse
set mouse=a

" disable netrw
let loaded_netrw=0

" set space as leader key
let mapleader=" "

" statusline
function! StatusLineGitBranch()
  let l:branchname = gitbranch#name()
  return strlen(l:branchname) > 0 ? ' (' . l:branchname . ')' : ''
endfunction
set statusline=%f%{StatusLineGitBranch()}\ %h%m%r%=%-14.(%l,%c%V%)\ %y
highlight StatusLine cterm=none ctermfg=15 ctermbg=0 gui=none guifg=#ffffff guibg=#000000
highlight StatusLineNC cterm=none ctermfg=15 ctermbg=243 gui=none guifg=#ffffff guibg=#767676

" junegunn/fzf.vim
let $FZF_DEFAULT_OPTS = '--preview-window sharp:noborder'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }

function! RipgrepFzf(query, fullscreen)
  " rg uses .config/ripgrep/ripgreprc config
  let command_fmt = 'rg --column --line-number --no-heading --color=always --context=0 -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--preview-window', 'bottom:6:noborder', '--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

nnoremap <silent> <Leader><Space> :Files<CR>
nnoremap <silent> <Leader>ff :Files<CR>
nnoremap <silent> <Leader>bb :Buffers<CR>

lua <<EOF
vim.api.nvim_set_keymap('n', '<Leader>s/', ':RG! ', { noremap = true, silent = false })
EOF

" lsp, nvim-lua/completion-nvim
lua <<EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- require('completion')
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      highlight LspReferenceText ctermbg=255 guibg=#f5f5f5
      highlight LspReferenceRead ctermbg=255 guibg=#f5f5f5
      highlight LspReferenceWrite ctermbg=255 guibg=#f5f5f5
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

local servers = { 'intelephense', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF

" https://github.com/antoinemadec/FixCursorHold.nvim
" in millisecond, used for both CursorHold and CursorHoldI,
" use updatetime instead if not defined
let g:cursorhold_updatetime = 100

" show lsp diagnostic list for current buffer
augroup lsp_diagnostic_list
  autocmd!
  autocmd BufWritePost * lua if vim.lsp.diagnostic.get_count(0) > 0 then vim.lsp.diagnostic.set_loclist() end
augroup END

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c

" use <Tab> as trigger keys for auto completion popup
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)

" nvim-treesitter/nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "css", "json", "html", "nix", "toml",
  },
  highlight = {
    enable = false, -- true,
  },
}
EOF

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition)<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0 <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.declaration()<CR>

" edit vimrc
nnoremap <leader>v :e $MYVIMRC<CR>

" moving cursor to other windows
nnoremap <silent> <leader>wk :wincmd k<CR> " up
nnoremap <silent> <leader>wj :wincmd j<CR> " down
nnoremap <silent> <leader>wh :wincmd h<CR> " left
nnoremap <silent> <leader>wl :wincmd l<CR> " right
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" splits
nnoremap <silent> <leader>wv :vsplit<CR> " vertical split
nnoremap <silent> <leader>ws :split<CR> " horizontal split
nnoremap <silent> <leader>wd :close<CR> " delete the current window
nnoremap <silent> sv :vsplit<CR> " vertical split

" tpope/vim-commentary
augroup comments
  autocmd!
  autocmd FileType php setlocal commentstring=//\ %s
augroup END

" delete trailing whitespaces on save
augroup trailing_whitespaces
  autocmd!
  autocmd BufWritePre * let winview=winsaveview()
    \ | keepjumps keeppatterns %s/\s\+$//e
    \ | call winrestview(winview) |unlet! winview
augroup END
