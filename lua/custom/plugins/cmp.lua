-- return {
--   "hrsh7th/nvim-cmp",
--   event = "InsertEnter",
--   dependencies = {
--     "hrsh7th/cmp-buffer", -- source for text in buffer
--     "hrsh7th/cmp-path", -- source for file system paths
--     {
--       "L3MON4D3/LuaSnip",
--       -- follow latest release.
--       version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
--       -- install jsregexp (optional!).
--       build = "make install_jsregexp",
--     },
--     "saadparwaiz1/cmp_luasnip", -- for autocompletion
--     "rafamadriz/friendly-snippets", -- useful snippets
--     "onsails/lspkind.nvim", -- vs-code like pictograms
--   },
--   config = function()
--     local cmp = require("cmp")
--     local luasnip = require("luasnip")
--     local lspkind = require("lspkind")
--
--     -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
--     require("luasnip.loaders.from_vscode").lazy_load()
--
--     cmp.setup({
--       completion = {
--         completeopt = "menu,menuone,preview,noselect",
--       },
--       snippet = { -- configure how nvim-cmp interacts with snippet engine
--         expand = function(args)
--           luasnip.lsp_expand(args.body)
--         end,
--       },
--       mapping = cmp.mapping.preset.insert({
--         ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
--         ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
--         ["<C-b>"] = cmp.mapping.scroll_docs(-4),
--         ["<C-f>"] = cmp.mapping.scroll_docs(4),
--         ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
--         ["<C-e>"] = cmp.mapping.abort(), -- close completion window
--         ["<CR>"] = cmp.mapping.confirm({ select = false }),
--       }),
--       -- sources for autocompletion
--       sources = cmp.config.sources({
--         { name = "nvim_lsp" },
--         { name = "luasnip" }, -- snippets
--         { name = "buffer" }, -- text within current buffer
--         { name = "path" }, -- file system paths
--       }),
--
--       -- configure lspkind for vs-code like pictograms in completion menu
--       formatting = {
--         format = lspkind.cmp_format({
--           maxwidth = 50,
--           ellipsis_char = "...",
--         }),
--       },
--     })
--
--     -- Set completeopt options and highlight links (outside cmp.setup)
--     vim.cmd([[
--       set completeopt=menuone,noinsert,noselect
--       highlight! default link CmpItemKind CmpItemMenuDefault
--     ]])
--   end,
-- }
--

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
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
    end

    -- Load friendly snippets
    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup {
      completion = {
        completeopt = 'menu,menuone,preview,noselect',
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-k>'] = cmp.mapping.select_prev_item(), -- previous suggestion
        ['<C-j>'] = cmp.mapping.select_next_item(), -- next suggestion
        ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- scroll documentation up
        ['<C-f>'] = cmp.mapping.scroll_docs(4), -- scroll documentation down
        ['<C-Space>'] = cmp.mapping.complete(), -- trigger completion menu
        ['<C-e>'] = cmp.mapping.abort(), -- close completion window
        ['<CR>'] = cmp.mapping.confirm { select = false }, -- confirm selection
        ['<Tab>'] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = cmp.config.sources {
        { name = 'nvim_lsp' }, -- LSP completions
        { name = 'luasnip' }, -- Snippet completions
        { name = 'buffer' }, -- Buffer text completions
        { name = 'path' }, -- Filesystem path completions
        { name = 'nvim_lua' }, -- Neovim Lua API completions
      },
      formatting = {
        format = lspkind.cmp_format {
          mode = 'symbol_text', -- Show both text and symbol
          maxwidth = 50, -- Limit completion width
          ellipsis_char = '...', -- Show ellipsis for truncated items
        },
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
      sources = {
        { name = 'cmdline' },
        { name = 'path' },
      },
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

