-- disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

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
          completion = cmp.config.window.bordered({
            border = 'none',
            winhighlight = 'Normal:Pmenu,CursorLine:PmenuSel,Search:None',
          }),
          documentation = cmp.config.window.bordered({
            border = 'none',
            winhighlight = 'Normal:NormalFloat,Search:None',
          }),
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
        '<leader>fb',
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
      {
        '<leader>fg',
        "<cmd>lua require('fzf-lua').live_grep()<CR>",
        mode = 'n',
        remap = false,
        silent = true,
        desc = 'Live grep',
      },
    },
    opts = {
      winopts = {
        border = 'none',
        width = 1,
        height = 1,
        preview = {
          border = 'none',
          default = 'builtin',
          hidden = false,
          horizontal = 'right:50%',
          scrollbar = false,
        },
      },
      fzf_opts = {
        ['--color'] = 'light,separator:#d7d7d7',
        ['--info'] = 'inline-right',
        ['--no-scrollbar'] = true,
        ['--separator'] = '─',
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
    },
    event = { 'BufNewFile', 'BufReadPre' },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local on_attach = function(_, bufnr)
        local map = function(lhs, rhs, desc)
          vim.keymap.set(
            'n',
            lhs,
            rhs,
            { buffer = bufnr, silent = true, desc = desc }
          )
        end

        map('gd', vim.lsp.buf.definition, 'Go to definition')
        map('gD', vim.lsp.buf.declaration, 'Go to declaration')
        map('gi', vim.lsp.buf.implementation, 'Go to implementation')
        map('gr', vim.lsp.buf.references, 'Show references')
        map('gy', vim.lsp.buf.type_definition, 'Go to type definition')
        map('K', vim.lsp.buf.hover, 'Show hover information')
        map('gs', vim.lsp.buf.signature_help, 'Show signature help')

        map('<leader>ds', vim.lsp.buf.document_symbol, 'Show document symbols')
        map('<leader>ws', vim.lsp.buf.workspace_symbol, 'Show workspace symbols')
      end

      -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/intelephense.lua
      vim.lsp.config('intelephense', {
        capabilities = capabilities,
        settings = {
          intelephense = {
            files = {
              maxSize = 1000000,
            },
            telemetry = {
              enabled = false,
            },
          },
        },
        on_attach = on_attach,
      })

      -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ts_ls.lua
      vim.lsp.config('ts_ls', {
        capabilities = capabilities,
        on_attach = on_attach,
      })

      vim.lsp.enable({ 'intelephense', 'ts_ls' })
    end,
  },
  {
    'nvim-mini/mini.sessions',
    lazy = false,
    config = function()
      vim.o.sessionoptions = 'buffers,curdir,tabpages,winsize,help,terminal'

      local sessions = require('mini.sessions')

      local dir = vim.fn.expand('~/.local/share/nvim/sessions')
      if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, 'p')
      end

      sessions.setup({
        autoread = false, -- will create own to use root-based name
        autowrite = true,
        directory = dir,
        file = '', -- will use global session
        verbose = { read = false, write = false, delete = true },
      })

      -- exit if nvim has arguments
      if vim.fn.argc() > 0 then return end

      local root = vim.fs.root(0, { '.git' }) or vim.fn.getcwd()
      vim.cmd('cd ' .. vim.fn.fnameescape(root))

      local name = root:gsub('[/\\: ]', '%%')

      local session_path = dir .. '/' .. name

      if vim.fn.filereadable(session_path) == 1 then
        sessions.read(name)
      else
        sessions.write(name)
      end
    end,
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
  -- automatically check for plugin updates
  checker = {
    enabled = true,
  },
  performance = {
    -- disable built-in runtime plugins
    rtp = {
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'rplugin',
        'tarPlugin',
        'tohtml',
        'zipPlugin',
      },
    },
  },
  spec = plugins,
})

-- neovide
if vim.g.neovide then
  vim.g.neovide_padding_top = 8
  vim.g.neovide_padding_bottom = 8
  vim.g.neovide_padding_left = 16
  vim.g.neovide_padding_right = 16

  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0
  vim.o.guifont = 'Monaco:h16:#e-alias'

  -- hide line numbers
  vim.opt.number = false

  -- copy (Cmd+C)
  vim.keymap.set('v', '<D-c>', '"+y')

  -- paste (Cmd+V)
  vim.keymap.set('n', '<D-v>', '"+P')
  vim.keymap.set('v', '<D-v>', '"-d"+P')
  vim.keymap.set('c', '<D-v>', '<C-r>+')
  vim.keymap.set('i', '<D-v>', '<C-r>+')
end
