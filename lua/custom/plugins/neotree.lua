return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*', -- Use the latest version branch for stability and new features
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- Recommended for icons
    'MunifTanjim/nui.nvim',
    -- '3rd/image.nvim',              -- Uncomment this line if you need image preview support
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
    close_if_last_window = true,
    window = {
      width = 33,
      auto_expand_width = true, -- adapts when you have long filenames
    },
    default_component_configs = {
      name = { use_git_status_colors = true, trailing_slash = true },
      icon = { folder_closed = "", folder_open = "" },
    },
    filesystem = {
      hijack_netrw_behavior = "disabled",
      follow_current_file = { enabled = true, leave_dirs_open = false },
      bind_to_cwd = true,
      use_libuv_file_watcher = true,  -- auto refresh on file changes
      group_empty_dirs = true,
      window = {
        mappings = {
          ['\\'] = 'close_window', -- Close NeoTree window with '\'
          ["r"] = "refresh",
          ["R"] = "refresh",
        },
      },
      filtered_items = {
        visible = true,          -- Shows hidden files
        hide_dotfiles = false,   -- Set this to false to show dotfiles (files starting with .)
        hide_gitignored = false, -- Set this to false if you want to see files ignored by .gitignore
        hide_by_name = { "node_modules", "dist", ".venv" },
      },
    },
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
  },
  config = function(_, opts)
    require('nvim-web-devicons').setup {
      default = true, -- globally enable default icons
    }
    require('neo-tree').setup(opts)
  end,
}
