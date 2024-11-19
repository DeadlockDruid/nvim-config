return {
  'lewis6991/gitsigns.nvim',
  config = function()
    local gitsigns = require 'gitsigns'

    gitsigns.setup {
      -- Git signs configuration (taking text values from both configs)
      signs = {
        add = { text = '│' }, -- Add sign
        change = { text = '│' }, -- Change sign
        delete = { text = '_' }, -- Delete sign
        topdelete = { text = '‾' }, -- Top delete sign
        changedelete = { text = '~' }, -- Change delete sign
        untracked = { text = '┆' }, -- Untracked file sign
      },

      -- Options for gitsigns features
      signcolumn = true, -- Show git signs in the sign column
      numhl = false, -- Disable number highlight
      linehl = false, -- Disable line highlight
      word_diff = false, -- Disable word diff

      -- Watch git directory for changes
      watch_gitdir = {
        interval = 1000, -- Check for changes every second
        follow_files = true,
      },

      -- Enable attaching to untracked files
      attach_to_untracked = true,

      -- Blame settings
      current_line_blame = false, -- Disable line blame (can be toggled with `:Gitsigns toggle_current_line_blame`)
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- Display blame text at the end of the line
        delay = 1000, -- Delay before blame is shown
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',

      -- Performance and display tweaks
      sign_priority = 6, -- Set sign priority
      update_debounce = 100, -- Debounce updates to avoid too frequent refreshes
      max_file_length = 40000, -- Disable gitsigns for files longer than 40,000 lines

      -- Preview configuration for diffs
      preview_config = {
        border = 'single', -- Single border for preview window
        style = 'minimal', -- Minimal window style
        relative = 'cursor', -- Position relative to cursor
        row = 0,
        col = 1,
      }
    }
  end,
}

