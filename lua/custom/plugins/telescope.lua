return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x', -- latest stable tag series for telescope
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
  keys = function()
    local b = require('telescope.builtin')
    return {
      { '<leader>ff', b.find_files,                 desc = 'Find files' },
      { '<leader>fr', b.oldfiles,                   desc = 'Recent files' },
      { '<leader>fs', b.live_grep,                  desc = 'Grep in cwd' },
      { '<leader>fc', b.grep_string,                desc = 'Grep word under cursor' },
      { '<leader>fh', b.help_tags,                  desc = 'Help tags' },
      { '<leader>fb', b.buffers,                    desc = 'Buffers' },
      { '<leader>ft', '<cmd>TodoTelescope<cr>',     desc = 'Find TODOs' },
      { '<leader>s',  b.current_buffer_fuzzy_find,  desc = 'Search current buffer' },
    }
  end,

  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local layout_actions = require('telescope.actions.layout')
    local transform_mod = require('telescope.actions.mt').transform_mod
    local trouble_ok, trouble_telescope = pcall(require, 'trouble.sources.telescope')

    local custom_actions = transform_mod({
      open_trouble_qflist = function(prompt_bufnr)
        if trouble_ok then
          require('trouble').toggle('quickfix')
        else
          actions.send_to_qflist(prompt_bufnr)
          vim.cmd('copen')
        end
      end,
    })

    telescope.setup({
      defaults = {
        prompt_prefix = '   ',
        selection_caret = '❯ ',
        entry_prefix = '  ',
        sorting_strategy = 'ascending',
        layout_strategy = 'flex',
        layout_config = {
          horizontal = { preview_width = 0.55 },
          vertical   = { preview_height = 0.6 },
          flex       = { flip_columns = 120 },
          prompt_position = 'top',
          width = 0.90,
          height = 0.85,
        },
        results_title = false,
        borderchars = { "─","│","─","│","╭","╮","╯","╰" },
        preview = { timeout = 100 },
        path_display = { 'smart' },
        dynamic_preview_title = true,
        vimgrep_arguments = {
          'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column',
          '--smart-case', '--hidden', '--glob', '!.git/',
        },
        file_ignore_patterns = {
          '^node_modules/', 'node_modules/',
          '^dist/', 'dist/', '^build/', 'build/',
          '^.git/', '.git/',
          '^.next/', '^.cache/', '^target/',
          '%.lock$', '%.sqlite3$', '%.ipynb$',
          '%.(jpg|jpeg|png|svg|webp|otf|ttf|ico|pdf|mp4|mkv)$',
          '%.(pdb|dll|class|exe|dylib|jar|7z|zip|tar|tar.gz|bz2)$',
          '^smalljre_.*/', '^__pycache__/', '^env/', '^.venv/', '^gradle/', '^.gradle/', '^.idea/', '^.vscode/', '^.settings/', '^.vale/',
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
            n = { ['dd']    = actions.delete_buffer },
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
          require('telescope.themes').get_dropdown({
            previewer = false,
            layout_config = { width = 0.5, height = 0.4 },
          }),
        },
      },
    })

    telescope.load_extension('fzf')
    pcall(telescope.load_extension, 'ui-select')
  end,
}