" install packer
let install_path = stdpath('data') . '/site/pack/packer/start/packer.nvim'
if !isdirectory(install_path)
  execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' . install_path)
endif

lua <<EOF
require('packer').startup(function(use)
  use 'airblade/vim-rooter'
  use 'antoinemadec/FixCursorHold.nvim' -- see https://github.com/neovim/neovim/issues/12587
  use 'cespare/vim-toml'
  use 'ggandor/lightspeed.nvim'
  use 'hrsh7th/nvim-compe'
  use 'ibhagwan/fzf-lua'
  use 'janko/vim-test'
  use 'itchyny/vim-gitbranch'
  use 'neovim/nvim-lspconfig'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
  }
  use 'rhysd/git-messenger.vim'
  use 'tpope/vim-commentary'
  use 'wbthomason/packer.nvim'

  -- vim-prosession depends on vim-obsession
  use 'tpope/vim-obsession'
  use 'dhruvasagar/vim-prosession'
end)
EOF

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

" don't show the intro message
set shortmess+=I

" set space as leader key
let mapleader=" "

autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType scss setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType vim setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

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

" show lsp diagnostic list for current buffer
lua << EOF
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('lsp_diagnostic_list', { clear = true }),
  callback = function()
    if vim.tbl_count(vim.diagnostic.get(0)) > 0 then
      vim.diagnostic.setqflist({ open = true })
    else
      vim.api.nvim_command('cclose') -- close the quickfix window
      vim.fn.setqflist({}, 'r', { title = 'Diagnostics' }) -- clear items from the current quickfix list
    end
  end,
})
EOF

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


" airblade/vim-rooter
let g:rooter_patterns = ['.git']


" https://github.com/antoinemadec/FixCursorHold.nvim
" in millisecond, used for both CursorHold and CursorHoldI,
" use updatetime instead if not defined
let g:cursorhold_updatetime = 100


" ggandor/lightspeed.nvim
lua <<EOF
require('lightspeed').setup {
  limit_ft_matches = 5,
}
EOF


" hrsh7th/nvim-compe
lua <<EOF
require('compe').setup {
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


" ibhagwan/fzf-lua
lua <<EOF
require('fzf-lua').setup {
  winopts = {
    border = 'single',
    width = 0.95,
    height = 0.85,
  },
}
EOF

lua <<EOF
vim.api.nvim_set_keymap(
  'n',
  '<Leader>bb',
  "<Cmd>lua require('fzf-lua').buffers()<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  'n',
  '<Leader>ff',
  "<Cmd>lua require('fzf-lua').files()<CR>",
  { noremap = true, silent = true }
)
EOF

" define :Rg command
lua <<EOF
vim.api.nvim_create_user_command(
  'Rg',
  function(opts)
    require('fzf-lua').live_grep({
      cmd = 'rg --column --line-number --no-heading --color=always --context=0',
      search = opts.args
    })
  end,
  { nargs = 1 }
)

vim.api.nvim_set_keymap(
  'n',
  '<Leader>/',
  ':Rg ',
  { noremap = true, silent = false }
)
EOF


" janko/vim-test
nnoremap <silent> tt :TestNearest<CR>
nnoremap <silent> tf :TestFile<CR>
nnoremap <silent> ts :TestSuite<CR>
let test#strategy = "neovim"
let test#neovim#term_position = "vertical"


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


" nvim-treesitter/nvim-treesitter
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'css', 'json', 'html', 'nix', 'toml',
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


" tpope/vim-commentary
augroup comments
  autocmd!
  autocmd FileType php setlocal commentstring=//\ %s
augroup END


" dhruvasagar/vim-prosession
let g:prosession_dir = '~/.local/share/nvim/sessions/'


let g:local_vimrc = fnamemodify($MYVIMRC, ':p:h') . '/init.local.vim'
if filereadable(g:local_vimrc)
  execute 'source ' . g:local_vimrc
endif
