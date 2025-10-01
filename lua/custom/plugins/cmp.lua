return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-buffer', -- source for text in buffer
    'hrsh7th/cmp-path', -- source for file system paths
    'hrsh7th/cmp-nvim-lsp', -- source for LSP
    'hrsh7th/cmp-nvim-lua', -- source for Neovim Lua APIs
    'hrsh7th/cmp-cmdline', -- source for command-line completion
    'saadparwaiz1/cmp_luasnip', -- for autocompletion
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*', -- Follow the latest release
      build = 'make install_jsregexp', -- Install optional regex support
    },
    'rafamadriz/friendly-snippets', -- useful snippets
    'onsails/lspkind.nvim', -- VS Code-like pictograms
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'

    -- Context-aware snippet expansion helper
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      if col == 0 then return false end
      local text = vim.api.nvim_buf_get_text(0, line - 1, col - 1, line - 1, col, {})[1]
      return not text:match("%s")
    end

    -- Load friendly snippets
    require('luasnip.loaders.from_vscode').lazy_load()

    require('luasnip').config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
    })

    cmp.setup {
      completion = {
        completeopt = 'menu,menuone,noselect',
        keyword_length = 2,
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources {
        { name = 'nvim_lsp' }, -- LSP completions
        { name = 'luasnip' }, -- Snippet completions
        { name = 'buffer' }, -- Buffer text completions
        { name = 'path' }, -- Filesystem path completions
        { name = 'nvim_lua' }, -- Neovim Lua API completions
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text',
          maxwidth = 80,
          ellipsis_char = '…',
          menu = {
            buffer   = '[Buf]',
            nvim_lsp = '[LSP]',
            path     = '[Path]',
            luasnip  = '[Snip]',
            nvim_lua = '[API]',
          },
        }),
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      experimental = {
        ghost_text = true, -- Enable ghost text
      },
    }

    -- Command-line completion setup
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
        { { name = 'path' } },
        { { name = 'cmdline' } }
      ),
    })

    -- Search completion setup
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })

    -- Highlight for better visibility
    vim.cmd [[
      set completeopt=menu,menuone,noinsert,noselect
      highlight! default link CmpItemKind CmpItemMenuDefault
    ]]
  end,
}
