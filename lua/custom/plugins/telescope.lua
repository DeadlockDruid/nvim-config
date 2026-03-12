return {
  'nvim-telescope/telescope.nvim',
  branch = 'master',
  -- (optional but recommended to avoid lazy pinning tags)
  version = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-tree/nvim-web-devicons',
    'folke/todo-comments.nvim',
    { 'nvim-telescope/telescope-ui-select.nvim' }, -- pretty vim.ui.select
  },

  -- Lazy-load on common commands/keys
  cmd = {
    'Telescope',
    'TodoTelescope',
  },
  -- AFTER
  keys = {
    { '<leader>ff', function() require('telescope.builtin').find_files() end,                desc = 'Find files' },
    { '<leader>fr', function() require('telescope.builtin').oldfiles() end,                  desc = 'Recent files' },
    { '<leader>fs', function() require('telescope.builtin').live_grep() end,                 desc = 'Grep in cwd' },
    { '<leader>fc', function() require('telescope.builtin').grep_string() end,               desc = 'Grep word under cursor' },
    { '<leader>fh', function() require('telescope.builtin').help_tags() end,                 desc = 'Help tags' },
    { '<leader>fb', function() require('telescope.builtin').buffers() end,                   desc = 'Buffers' },
    { '<leader>ft', '<cmd>TodoTelescope<cr>',                                                desc = 'Find TODOs' },
    { '<leader>s',  function() require('telescope.builtin').current_buffer_fuzzy_find() end, desc = 'Search current buffer' },
  },

  config = function()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'
    local layout_actions = require 'telescope.actions.layout'
    local transform_mod = require('telescope.actions.mt').transform_mod
    local trouble_ok, trouble_telescope = pcall(require, 'trouble.sources.telescope')

    local custom_actions = transform_mod {
      open_trouble_qflist = function(prompt_bufnr)
        if trouble_ok then
          require('trouble').toggle 'quickfix'
        else
          actions.send_to_qflist(prompt_bufnr)
          vim.cmd 'copen'
        end
      end,
    }

    telescope.setup {
      defaults = {
        prompt_prefix = '   ',
        selection_caret = '❯ ',
        entry_prefix = '  ',
        sorting_strategy = 'ascending',
        layout_strategy = 'flex',
        layout_config = {
          horizontal = { preview_width = 0.55 },
          vertical = { preview_height = 0.6 },
          flex = { flip_columns = 120 },
          prompt_position = 'top',
          width = 0.90,
          height = 0.85,
        },
        results_title = false,
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        preview = { timeout = 100 },
        path_display = { 'smart' },
        dynamic_preview_title = true,
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--hidden',
          '--glob',
          '!.git/',
        },
        file_ignore_patterns = {
          '^node_modules/',
          'node_modules/',
          '^dist/',
          'dist/',
          '^build/',
          'build/',
          '^.git/',
          '.git/',
          '^.next/',
          '^.cache/',
          '^target/',
          '%.lock$',
          '%.sqlite3$',
          '%.ipynb$',
          '%.(jpg|jpeg|png|svg|webp|otf|ttf|ico|pdf|mp4|mkv)$',
          '%.(pdb|dll|class|exe|dylib|jar|7z|zip|tar|tar.gz|bz2)$',
          '^smalljre_.*/',
          '^__pycache__/',
          '^env/',
          '^.venv/',
          '^gradle/',
          '^.gradle/',
          '^.idea/',
          '^.vscode/',
          '^.settings/',
          '^.vale/',
        },
        mappings = {
          i = {
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-p>'] = layout_actions.toggle_preview,
            ['<C-q>'] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
            ['<C-t>'] = trouble_ok and trouble_telescope.open or nil,
          },
          n = {
            ['<C-p>'] = layout_actions.toggle_preview,
            ['<C-q>'] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
            ['<C-t>'] = trouble_ok and trouble_telescope.open or nil,
          },
        },
      },

      pickers = {
        find_files = {
          hidden = true,
          no_ignore = false,
          previewer = true,
          find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix', '--hidden', '--exclude', '.git' },
        },
        live_grep = {
          additional_args = function()
            return { '--hidden', '--glob', '!.git/' }
          end,
        },
        buffers = {
          sort_mru = true,
          ignore_current_buffer = true,
          mappings = {
            i = { ['<C-d>'] = actions.delete_buffer },
            n = { ['dd'] = actions.delete_buffer },
          },
        },
      },

      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown {
            previewer = false,
            layout_config = { width = 0.5, height = 0.4 },
          },
        },
      },
    }

    telescope.load_extension 'fzf'
    pcall(telescope.load_extension, 'ui-select')
  end,
}
