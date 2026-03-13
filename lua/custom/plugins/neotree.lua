return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  event = 'BufEnter',        -- fix #2: load early enough to register autocmds
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  keys = {
    {
      '\\',
      function()
        require('neo-tree.command').execute {
          source = 'filesystem',
          reveal = true,
        }
      end,
      desc = 'Reveal current file in NeoTree',
      silent = true,
    },
    {
      '<leader>ee',
      function()
        require('neo-tree.command').execute {
          source = 'filesystem',
          toggle = true,
        }
      end,
      desc = 'Toggle NeoTree',
      silent = true,
    },
    {
      '<leader>ef',
      function()
        require('neo-tree.command').execute {
          source = 'filesystem',
          focus = true,
          reveal = true,
        }
      end,
      desc = 'Focus NeoTree on current file',
      silent = true,
    },
    {
      '<leader>ec',
      '<cmd>Neotree close<cr>',
      desc = 'Close NeoTree file explorer',
      silent = true,
    },
  },
  opts = {
    close_if_last_window = true,
    window = {
      width = 36,
      auto_expand_width = false,
    },
    default_component_configs = {
      name = {
        use_git_status_colors = true,
        trailing_slash = true,
        highlight_opened_files = true,
        display_path = 'tail',
      },
      icon = { folder_closed = '', folder_open = '' },
    },
    filesystem = {
      hijack_netrw_behavior = 'disabled',
      follow_current_file = {    -- fix #1: lifted out of the erroneous inner block
        enabled = true,
        leave_dirs_open = true,
      },
      bind_to_cwd = false,       -- fix #1: same
      use_libuv_file_watcher = true,
      group_empty_dirs = true,
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['r'] = 'rename',
          ['R'] = 'refresh',
        },
      },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { 'node_modules', 'dist', '.venv' },
      },
    },
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
  },
  config = function(_, opts)
    require('nvim-web-devicons').setup { default = true }
    require('neo-tree').setup(opts)
  end,
}