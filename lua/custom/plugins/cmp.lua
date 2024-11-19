return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
    },
    'rafamadriz/friendly-snippets', -- Include snippets
    'saadparwaiz1/cmp_luasnip',     -- Luasnip completion source

    -- Adds other completion capabilities
    'hrsh7th/cmp-nvim-lsp',          -- LSP completions
    'hrsh7th/cmp-path',              -- File system path completions
    'hrsh7th/cmp-buffer',            -- Text in buffer completions
    'onsails/lspkind.nvim',          -- VSCode-like pictograms
  },
  config = function()
    -- Load LuaSnip and friendly-snippets
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'
    
    luasnip.config.setup {}
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Setup nvim-cmp
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },

      -- Key mappings from the first configuration, with missing ones from the second
      mapping = cmp.mapping.preset.insert({
        -- Select next/previous item
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- Scroll docs (combined)
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- Confirm completion (combined)
        ['<C-y>'] = cmp.mapping.confirm { select = true },  -- From first config
        ['<CR>'] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace }, -- From second config

        -- Manually trigger completion
        ['<C-Space>'] = cmp.mapping.complete {},

        -- Close completion (from second config)
        ['<C-e>'] = cmp.mapping.close(),

        -- Luasnip navigation (from first config)
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        -- Scroll docs (from second config)
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      }),
      
      -- Sources for completions
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },   -- LSP completions
        { name = 'luasnip' },    -- Snippet completions
        { name = 'buffer' },     -- Buffer completions
        { name = 'path' },       -- File path completions
      }),

      -- Display icons
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
        }),
      },
    }

    -- Set completeopt options and highlight links
    vim.cmd([[
      set completeopt=menuone,noinsert,noselect
      highlight! default link CmpItemKind CmpItemMenuDefault
    ]])
  end,
}
