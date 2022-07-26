" specify a directory for vim-plug plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'airblade/vim-rooter'
Plug 'antoinemadec/FixCursorHold.nvim' " see https://github.com/neovim/neovim/issues/12587
Plug 'cespare/vim-toml'
Plug 'ggandor/lightspeed.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'janko/vim-test'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'rhysd/git-messenger.vim'
Plug 'tpope/vim-commentary'

" vim-prosession depends on vim-obsession
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'
call plug#end()

" show line numbers
set number

" all tabs chars are 4 space chars
set tabstop=4
set shiftwidth=4
set expandtab

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

" disable some builtin vim plugins
lua <<EOF
local disable_builtin_vim_plugins = {
  '2html_plugin',
  'getscript',
  'getscriptPlugin',
  'gzip',
  'loaded_remote_plugins',
  'loaded_tutor_mode_plugin',
  'logipat',
  'matchit',
  -- 'matchparen',
  'netrw',
  'netrwFileHandlers',
  'netrwPlugin',
  'netrwSettings',
  'rrhelper',
  'spellfile_plugin',
  'tar',
  'tarPlugin',
  'vimball',
  'vimballPlugin',
  'zip',
  'zipPlugin',
}

for i = 1, #disable_builtin_vim_plugins do
  vim.g['loaded_' .. disable_builtin_vim_plugins[i]] = 1
end
EOF

"let g:loaded_netrw = 0

" don't show the intro message
set shortmess+=I

" set space as leader key
let mapleader=" "

" statusline
function! StatusLineLspDiagnosticSummary()
  let l:summary = get(b:, 'lsp_diagnostic_summary', '')
  return strlen(l:summary) > 0 ? l:summary . '  ' : ''
endfunction

function! StatusLineGitBranch()
  let l:branchname = gitbranch#name()
  return strlen(l:branchname) > 0 ? ' (' . l:branchname . ')' : ''
endfunction

set statusline=%{StatusLineLspDiagnosticSummary()}%f%{StatusLineGitBranch()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P\ %y
highlight StatusLine cterm=none ctermfg=15 ctermbg=0 gui=none guifg=#ffffff guibg=#000000
highlight StatusLineNC cterm=none ctermfg=15 ctermbg=243 gui=none guifg=#ffffff guibg=#767676

" airblade/vim-rooter
let g:rooter_patterns = ['.git']

" hrsh7th/nvim-compe
lua <<EOF
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
  };
}
EOF

" set completeopt to have a better completion experience
set completeopt=menuone,noselect
" avoid showing 'Pattern not found' message when using completion
set shortmess+=c

autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType scss setlocal ts=2 sts=2 sw=2 expandtab

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR> compe#confirm('<CR>')
inoremap <silent><expr> <C-e> compe#close('<C-e>')

" use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'

" use C-j and C-k to navigate through popup menu
inoremap <expr> <C-j> pumvisible() ? '<C-n>' : '<C-j>'
inoremap <expr> <C-k> pumvisible() ? '<C-p>' : '<C-k>'

highlight Pmenu ctermfg=0 ctermbg=255 guibg=#e9e9e9
highlight PmenuSel ctermfg=0 ctermbg=7 guibg=#d6d6d6
highlight PmenuSbar ctermbg=248 guibg=#cccccc
highlight PmenuThumb ctermbg=0 guibg=#666666

" ggandor/lightspeed.nvim
lua <<EOF
require'lightspeed'.setup {
  limit_ft_matches = 5,
}
EOF

" janko/vim-test
nnoremap <silent> tt :TestNearest<CR>
nnoremap <silent> tf :TestFile<CR>
nnoremap <silent> ts :TestSuite<CR>
let test#strategy = "neovim"
let test#neovim#term_position = "vertical"

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
vim.api.nvim_set_keymap('n', '<Leader>/', ':RG! ', { noremap = true, silent = false })
EOF

autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType vim setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" lsp
lua <<EOF
gen_lsp_diagnostic_summary = function()
  local bufnr = vim.fn.bufnr('%')
  local lsp_diagnostic = 'E:' .. vim.tbl_count(vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR }))
    .. '  W:' .. vim.tbl_count(vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN }))
  vim.api.nvim_buf_set_var(bufnr, 'lsp_diagnostic_summary', lsp_diagnostic)
end

vim.api.nvim_exec([[
  augroup lsp_diagnostic
    autocmd! * <buffer>
    autocmd User LspDiagnosticsChanged lua gen_lsp_diagnostic_summary()
  augroup END
]], false)

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_exec([[
      highlight LspReferenceText ctermbg=255 guibg=#f5f5f5
      highlight LspReferenceRead ctermbg=255 guibg=#f5f5f5
      highlight LspReferenceWrite ctermbg=255 guibg=#f5f5f5
    ]], false)

    vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
    vim.api.nvim_clear_autocmds {
      buffer = bufnr,
      group = 'lsp_document_highlight'
    }
    vim.api.nvim_create_autocmd('CursorHold', {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      group = 'lsp_document_highlight',
      desc = 'Document highlight',
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
      group = 'lsp_document_highlight',
      desc = 'Clear all references',
    })
  end
end

local servers = { 'intelephense', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

" https://github.com/antoinemadec/FixCursorHold.nvim
" in millisecond, used for both CursorHold and CursorHoldI,
" use updatetime instead if not defined
let g:cursorhold_updatetime = 100

" show lsp diagnostic list for current buffer
lua << EOF
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('lsp_diagnostic_list', { clear = true }),
  callback = function()
    if vim.tbl_count(vim.diagnostic.get(0)) > 0 then
      vim.diagnostic.setqflist()
    end
  end,
})
EOF

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

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
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

nnoremap <silent> <leader>bd :bd<CR> " delete the current buffer

" Y copies the selected text to system clipboard
vnoremap Y "+y

" tpope/vim-commentary
augroup comments
  autocmd!
  autocmd FileType php setlocal commentstring=//\ %s
augroup END

" dhruvasagar/vim-prosession
let g:prosession_dir = '~/.local/share/nvim/sessions/'

" source config changes automatically
augroup source_config
  autocmd!
  autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
augroup END

" delete trailing whitespaces on save
augroup trailing_whitespaces
  autocmd!
  autocmd BufWritePre * let winview=winsaveview()
    \ | keepjumps keeppatterns %s/\s\+$//e
    \ | call winrestview(winview) |unlet! winview
augroup END

let g:local_vimrc = fnamemodify($MYVIMRC, ':p:h') . '/init.local.vim'
if filereadable(g:local_vimrc)
  execute 'source ' . g:local_vimrc
endif
