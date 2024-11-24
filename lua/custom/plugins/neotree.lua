return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*', -- Use the latest version branch for stability and new features
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- Recommended for icons
    'MunifTanjim/nui.nvim',
    '3rd/image.nvim',              -- Uncomment this line if you need image preview support
  },
  cmd = 'Neotree',                 -- Lazy load NeoTree on this command
  init = function()
    -- Disable netrw at the very start
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  keys = {
    { '\\',         ':Neotree reveal<CR>',     desc = 'NeoTree reveal',                silent = true }, -- Key mapping to reveal file in tree
    { '<leader>ee', '<cmd>Neotree toggle<CR>', desc = 'Toggle NeoTree file explorer',  silent = true },
    { '<leader>ef', '<cmd>Neotree focus<CR>',  desc = 'Focus NeoTree on current file', silent = true },
    { '<leader>ec', '<cmd>Neotree close<CR>',  desc = 'Close NeoTree file explorer',   silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window', -- Close NeoTree window with '\'
        },
      },
    },
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
  },
  config = function()
    -- Ensure nvim-web-devicons is properly loaded and configured
    require('nvim-web-devicons').setup {
      default = true, -- globally enable default icons
    }

    -- Optionally, set up NeoTree-specific configurations here
    require('neo-tree').setup {
      -- Your NeoTree configuration goes here
      filesystem = {
        filtered_items = {
          visible = true,          -- Shows hidden files
          hide_dotfiles = false,   -- Set this to false to show dotfiles (files starting with .)
          hide_gitignored = false, -- Set this to false if you want to see files ignored by .gitignore
        },
      },
    }
  end,
}
