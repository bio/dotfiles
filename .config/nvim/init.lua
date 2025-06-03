-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct
-- set space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- show line numbers
vim.opt.number = true
vim.cmd('highlight SignColumn ctermbg=255 guibg=#ffffff')

-- all tabs chars are 2 space chars
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- wraps at word boundaries
vim.opt.linebreak = true

-- enable the true color support
vim.opt.termguicolors = true

-- always show sign column
vim.opt.signcolumn = 'number'

-- show ruler
vim.opt.colorcolumn = '80'

-- highlight the current line number only
vim.opt.cursorline = true
vim.cmd('highlight CursorLine ctermbg=none guibg=none')
vim.cmd('highlight CursorLineNr ctermfg=243 ctermbg=none gui=none guifg=#767676')

vim.cmd('colorscheme brutta')

-- set indent
local indent_group = vim.api.nvim_create_augroup(
  'IndentSettings',
  { clear = true }
)
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'css',
    'javascript',
    'lua',
    'scss',
    'typescript',
    'vim',
    'vue',
  },
  group = indent_group,
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- edit init.lua
vim.keymap.set(
  'n',
  '<leader>v',
  function()
    vim.cmd.edit(vim.env.MYVIMRC)
  end,
  { desc = 'Edit init.lua' }
)

vim.keymap.set('v', 'Y', '"+y', { desc = 'Copy to system clipboard' })

-- autogroup for auto-sourcing config
local source_config = vim.api.nvim_create_augroup(
  'SourceConfig',
  { clear = true }
)

vim.api.nvim_create_autocmd('BufWritePost', {
 group = source_config,
 pattern = vim.env.MYVIMRC,
 callback = function()
   vim.cmd('source ' .. vim.env.MYVIMRC)
 end,
 nested = true
})

-- autogroup for trailing whitespace removal
local trim_whitespace = vim.api.nvim_create_augroup(
  'TrimWhitespace',
  { clear = true }
)
vim.api.nvim_create_autocmd('BufWritePre', {
 group = trim_whitespace,
 callback = function()
   -- save the cursor position
   local view = vim.fn.winsaveview()
   vim.cmd([[keeppatterns %s/\s\+$//e]])
   -- restore the cursor position
   vim.fn.winrestview(view)
 end,
})

-- autogroup to use native treesitter
local treesitter_group = vim.api.nvim_create_augroup(
  'NativeTreesitter',
  { clear = true }
)

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'lua', 'markdown', 'query', 'vim', 'vimdoc' },
  group = treesitter_group,
  desc = 'Enable native Treesitter highlighting',
  callback = function()
    vim.treesitter.start()
  end,
})

-- setup lazy.nvim
local plugins = {
  {
    'dhruvasagar/vim-prosession',
    dependencies = {
      'tpope/vim-obsession',
    },
    init = function()
      vim.g.prosession_dir = '~/.local/share/nvim/sessions/'
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    event = { 'CmdlineEnter', 'InsertEnter' },
    config = function()
      local cmp = require('cmp')

      -- https://github.com/zbirenbaum/copilot-cmp#tab-completion-configuration-highly-recommended
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
      end

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = vim.schedule_wrap(
            function(fallback)
              if cmp.visible() and has_words_before() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                fallback()
              end
            end
          ),
          ['<S-Tab>'] = vim.schedule_wrap(
            function(fallback)
              if cmp.visible() and has_words_before() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                fallback()
              end
            end
          ),
        }),

        sources = cmp.config.sources(
          {
            { name = 'path' },
            { name = 'nvim_lsp' },
            { name = 'copilot' },
          },
          {
            { name = 'buffer' },
          }
        ),
      })

      -- config for the command line
      -- use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(
        ':',
        {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources(
            {
              { name = 'path' },
            },
            {
              { name = 'cmdline' },
            }
          ),
        }
      )

      -- config for the search
      -- use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(
        { '/', '?' },
        {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' },
          },
        }
      )
    end,
  },
  {
    'ibhagwan/fzf-lua',
    keys = {
      {
        '<leader>bb',
        "<cmd>lua require('fzf-lua').buffers()<CR>",
        mode = 'n',
        remap = false,
        silent = true,
        desc = 'Find buffers',
      },
      {
        '<leader>ff',
        "<cmd>lua require('fzf-lua').files()<CR>",
        mode = 'n',
        remap = false,
        silent = true,
        desc = 'Find files',
      },
    },
    opts = {
      winopts = {
        border = 'single',
        width = 0.99,
        height = 0.90,
        preview = {
          hidden = 'nohidden',
          horizontal = 'right:42%',
        },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
    },
    event = { 'BufNewFile', 'BufReadPre' },
    keys = {
      {
        '<c-]>',
        vim.lsp.buf.definition,
        mode = 'n',
        remap = false,
        silent = true,
        desc = 'Go to definition',
      },
      {
        'K',
        vim.lsp.buf.hover,
        mode = 'n',
        remap = false,
        silent = true,
        desc = 'Show hover information',
      },
      {
        'gD',
        vim.lsp.buf.implementation,
        mode = 'n',
        remap = false,
        silent = true,
        desc = 'Go to implementation',
      },
      {
        '<c-k>',
        vim.lsp.buf.signature_help,
        mode = 'n',
        remap = false,
        silent = true,
        desc = 'Show signature help',
      },
      {
        '1gD',
        vim.lsp.buf.type_definition,
        mode = 'n',
        remap = false,
        silent = true,
        desc = 'Go to type definition',
      },
      {
        'gr',
        vim.lsp.buf.references,
        mode = 'n',
        remap = false,
        silent = true,
        desc = 'Show references',
      },
      {
        'g0',
        vim.lsp.buf.document_symbol,
        mode = 'n',
        remap = false,
        silent = true,
        desc = 'Show document symbols',
      },
      {
        'gW',
        vim.lsp.buf.workspace_symbol,
        mode = 'n',
        remap = false,
        silent = true,
        desc = 'Show workspace symbols',
      },
      {
        'gd',
        vim.lsp.buf.declaration,
        mode = 'n',
        remap = false,
        silent = true,
        desc = 'Go to declaration',
      },
    },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      lspconfig.intelephense.setup({
        capabilities = capabilities,
        cmd = { "intelephense", "--stdio" },
        filetypes = { "php" },
        root_dir = lspconfig.util.root_pattern("composer.json", ".git"),
        settings = {
          intelephense = {
            files = {
              maxSize = 1000000,
            },
          },
        },
        on_attach = function(client, bufnr)
          if client.server_capabilities.declarationProvider then
            vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, { silent = true, buffer = bufnr })
          end
        end,
      })

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })
    end,
  },
  {
    'notjedi/nvim-rooter.lua',
    opts = {
      rooter_patterns = { '.git' },
    },
  },
  {
    'rhysd/git-messenger.vim',
    keys = {
      {
        '<leader>gm',
        ':GitMessenger<CR>',
        mode = 'n',
        remap = false,
        silent = true,
        desc = 'Toggle git blame window',
      },
    },
  },
  {
    'zbirenbaum/copilot-cmp',
    dependencies = {
      'zbirenbaum/copilot.lua',
    },
    event = { 'InsertEnter', 'LspAttach' },
    config = function()
      require('copilot').setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })

      require('copilot_cmp').setup({
        formatters = {
          label = require('copilot_cmp.format').format_label_text,
          insert_text = require('copilot_cmp.format').format_insert_text,
          preview = require('copilot_cmp.format').deindent,
        },
        fix_pairs = true,
      })
    end,
  },
}

require('lazy').setup({
  spec = {
    plugins,
  },
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { 'habamax' } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
