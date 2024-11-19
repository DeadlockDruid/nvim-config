return {
  -- -- Tokyodark color scheme
  -- {
  --   "tiagovla/tokyodark.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- Uncomment this line to use Tokyodark colorscheme
  --     -- vim.cmd("colorscheme tokyodark")
  --   end,
  -- },

  -- -- Tokyonight color scheme
  -- {
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Ensure high priority for this plugin
  --   init = function()
  --     -- Uncomment this line to use Tokyonight colorscheme
  --     -- vim.cmd.colorscheme 'tokyonight-night'

  --     -- Optional: Customize highlights
  --     -- vim.cmd.hi 'Comment gui=none'
  --   end,
  -- },

  -- Rose Pine color scheme
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function()
      require('rose-pine').setup {
        -- Optional: Customize the theme style (default, moon, dawn)
        disable_background = true,
        variant = 'moon', -- Use 'main', 'moon', or 'dawn'
      }

      -- Uncomment this line to use Rose Pine colorscheme
      vim.cmd 'colorscheme rose-pine-moon'
    end,
  },
}

