return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      -- Require the necessary modules
      local harpoon = require 'harpoon'
      local telescope = require 'telescope'

      -- Set up Harpoon
      harpoon:setup {}

      -- Key mapping to add the current file to Harpoon
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'Add file to Harpoon' })

      -- Key mappings using Alt key with numbers
      vim.keymap.set('n', '<M-1>', function()
        harpoon:list():select(1)
      end, { desc = 'Go to Harpoon file 1' })
      vim.keymap.set('n', '<M-2>', function()
        harpoon:list():select(2)
      end, { desc = 'Go to Harpoon file 2' })
      vim.keymap.set('n', '<M-3>', function()
        harpoon:list():select(3)
      end, { desc = 'Go to Harpoon file 3' })
      vim.keymap.set('n', '<M-4>', function()
        harpoon:list():select(4)
      end, { desc = 'Go to Harpoon file 4' })

      -- Key mappings to navigate to previous and next Harpoon files (optional)
      vim.keymap.set('n', '<C-S-P>', function()
        harpoon:list():prev()
      end, { desc = 'Go to previous Harpoon file' })
      vim.keymap.set('n', '<C-S-N>', function()
        harpoon:list():next()
      end, { desc = 'Go to next Harpoon file' })

      -- Basic Telescope configuration for Harpoon
      local function toggle_telescope()
        local harpoon_list = harpoon:list()
        local files = {}
        for _, item in ipairs(harpoon_list.items) do
          table.insert(files, item.value)
        end

        require('telescope.pickers')
            .new({}, {
              prompt_title = 'Harpoon Files',
              finder = require('telescope.finders').new_table {
                results = files,
              },
              sorter = require('telescope.config').values.generic_sorter {},
              attach_mappings = function(prompt_bufnr, map)
                local actions = require 'telescope.actions'
                local action_state = require 'telescope.actions.state'
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  if selection ~= nil then
                    vim.cmd('edit ' .. vim.fn.fnameescape(selection.value))
                  end
                end)
                return true
              end,
            })
            :find()
      end

      -- Key mapping to open Harpoon menu using Telescope
      vim.keymap.set('n', '<M-e>', toggle_telescope, { desc = 'Open Harpoon with Telescope' })
    end,
  },
}
