return {
  -- Rose Pine color scheme
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function()
      require('rose-pine').setup {
        disable_background = true,
        variant = 'moon', -- Use 'main', 'moon', or 'dawn'
      }

      vim.cmd 'colorscheme rose-pine-moon'
    end,
  },
  --
  -- Catppuccin color scheme
  -- {
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('catppuccin').setup {
  --       transparent_background = true,
  --       flavour = 'mocha', -- Options: latte, frappe, macchiato, mocha
  --       dim_inactive = {
  --         enabled = false, -- dims the background color of inactive window
  --         shade = 'dark',
  --         percentage = 0.15, -- percentage of the shade to apply to the inactive window
  --       },
  --       integrations = {
  --         treesitter = true,
  --         native_lsp = {
  --           enabled = true,
  --           virtual_text = {
  --             errors = { 'italic' },
  --             hints = { 'italic' },
  --             warnings = { 'italic' },
  --             information = { 'italic' },
  --           },
  --           underlines = {
  --             errors = { 'underline' },
  --             hints = { 'underline' },
  --             warnings = { 'underline' },
  --             information = { 'underline' },
  --           },
  --         },
  --         cmp = true,
  --         lsp_saga = true,
  --         telescope = true,
  --         indent_blankline = {
  --           enabled = true,
  --           colored_indent_levels = false,
  --         },
  --         dashboard = false,
  --         fidget = true,
  --         notify = true,
  --         markdown = true,
  --       },

  -- custom_highlights = function(C)
  --   return {
  --     CmpItemKindSnippet = { fg = C.base, bg = C.mauve },
  --     CmpItemKindKeyword = { fg = C.base, bg = C.red },
  --     CmpItemKindText = { fg = C.base, bg = C.teal },
  --     CmpItemKindMethod = { fg = C.base, bg = C.blue },
  --     CmpItemKindConstructor = { fg = C.base, bg = C.blue },
  --     CmpItemKindFunction = { fg = C.base, bg = C.blue },
  --     CmpItemKindFolder = { fg = C.base, bg = C.blue },
  --     CmpItemKindModule = { fg = C.base, bg = C.blue },
  --     CmpItemKindConstant = { fg = C.base, bg = C.peach },
  --     CmpItemKindField = { fg = C.base, bg = C.green },
  --     CmpItemKindProperty = { fg = C.base, bg = C.green },
  --     CmpItemKindEnum = { fg = C.base, bg = C.green },
  --     CmpItemKindUnit = { fg = C.base, bg = C.green },
  --     CmpItemKindClass = { fg = C.base, bg = C.yellow },
  --     CmpItemKindVariable = { fg = C.base, bg = C.flamingo },
  --     CmpItemKindFile = { fg = C.base, bg = C.blue },
  --     CmpItemKindInterface = { fg = C.base, bg = C.yellow },
  --     CmpItemKindColor = { fg = C.base, bg = C.red },
  --     CmpItemKindReference = { fg = C.base, bg = C.red },
  --     CmpItemKindEnumMember = { fg = C.base, bg = C.red },
  --     CmpItemKindStruct = { fg = C.base, bg = C.blue },
  --     CmpItemKindValue = { fg = C.base, bg = C.peach },
  --     CmpItemKindEvent = { fg = C.base, bg = C.blue },
  --     CmpItemKindOperator = { fg = C.base, bg = C.blue },
  --     CmpItemKindTypeParameter = { fg = C.base, bg = C.blue },
  --     CmpItemKindCopilot = { fg = C.base, bg = C.teal },
  --   }
  -- end,
  --     }
  --
  --     -- Activate Catppuccin theme
  --     vim.cmd.colorscheme 'catppuccin'
  --   end,
  -- },
}
