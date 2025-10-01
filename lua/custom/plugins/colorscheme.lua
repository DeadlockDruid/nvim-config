-- colorscheme.lua
-- Load exactly ONE theme early. Switch with:
--   NVIM_THEME=catppuccin  nvim
--   NVIM_THEME=everforest  nvim
-- Or inside config: vim.g.nv_theme = 'catppuccin' | 'everforest'

local theme = (vim.env.NVIM_THEME or vim.g.nv_theme or 'catppuccin'):lower()

return {
  -- CATPPUCCIN ---------------------------------------------------------------
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    enabled = theme == 'catppuccin',
    lazy = false,            -- load early so other plugins pick its highlights
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        transparent_background = true,
        flavour = 'mocha',
        integrations = {
          treesitter = true,
          cmp = true,
          telescope = true,
          native_lsp = {
            enabled = true,
            virtual_text = { errors = { 'italic' }, hints = { 'italic' }, warnings = { 'italic' }, information = { 'italic' } },
            underlines = { errors = { 'underline' }, hints = { 'underline' }, warnings = { 'underline' }, information = { 'underline' } },
          },
          indent_blankline = { enabled = true, colored_indent_levels = false },
          fidget = true,
          notify = true,
          markdown = true,
        },
        custom_highlights = function(C)
          return {
            CmpItemKindSnippet = { fg = C.base, bg = C.mauve },
            CmpItemKindKeyword = { fg = C.base, bg = C.red },
            CmpItemKindText = { fg = C.base, bg = C.teal },
            CmpItemKindMethod = { fg = C.base, bg = C.blue },
            CmpItemKindConstructor = { fg = C.base, bg = C.blue },
            CmpItemKindFunction = { fg = C.base, bg = C.blue },
            CmpItemKindFolder = { fg = C.base, bg = C.blue },
            CmpItemKindModule = { fg = C.base, bg = C.blue },
            CmpItemKindConstant = { fg = C.base, bg = C.peach },
            CmpItemKindField = { fg = C.base, bg = C.green },
            CmpItemKindProperty = { fg = C.base, bg = C.green },
            CmpItemKindEnum = { fg = C.base, bg = C.green },
            CmpItemKindUnit = { fg = C.base, bg = C.green },
            CmpItemKindClass = { fg = C.base, bg = C.yellow },
            CmpItemKindVariable = { fg = C.base, bg = C.flamingo },
            CmpItemKindFile = { fg = C.base, bg = C.blue },
            CmpItemKindInterface = { fg = C.base, bg = C.yellow },
            CmpItemKindColor = { fg = C.base, bg = C.red },
            CmpItemKindReference = { fg = C.base, bg = C.red },
            CmpItemKindEnumMember = { fg = C.base, bg = C.red },
            CmpItemKindStruct = { fg = C.base, bg = C.blue },
            CmpItemKindValue = { fg = C.base, bg = C.peach },
            CmpItemKindEvent = { fg = C.base, bg = C.blue },
            CmpItemKindOperator = { fg = C.base, bg = C.blue },
            CmpItemKindTypeParameter = { fg = C.base, bg = C.blue },
            CmpItemKindCopilot = { fg = C.base, bg = C.teal },
          }
        end,
      }

      -- Optional: auto-sync bufferline highlights if installed
      pcall(function()
        local ok, cat = pcall(require, 'catppuccin.groups.integrations.bufferline')
        if ok then
          local bl_ok, bufferline = pcall(require, 'bufferline')
          if bl_ok then bufferline.setup { highlights = cat.get() } end
        end
      end)

      vim.cmd.colorscheme 'catppuccin'
    end,
  },

  -- EVERFOREST ---------------------------------------------------------------
  {
    'neanias/everforest-nvim',
    version = false,
    enabled = theme == 'everforest',
    lazy = false,
    priority = 1000,
    config = function()
      require('everforest').setup {
        background = 'soft',
        transparent_background_level = 1,
        italics = true,
        disable_italic_comments = false,
        ui_contrast = 'low',
      }
      vim.cmd.colorscheme 'everforest'
    end,
  },
}
