return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },

  keys = {
    { '<leader>a',  function() require('harpoon'):list():add() end,            desc = 'Harpoon: Add' },
    { '<leader>hm', function()
        local h = require('harpoon')
        h.ui:toggle_quick_menu(h:list())
      end,                                                                      desc = 'Harpoon: Menu' },
    { '<leader>H',  '<cmd>HarpoonPicker<CR>',                                  desc = 'Harpoon: Telescope picker' },
    { '<leader>1',  function() require('harpoon'):list():select(1) end,        desc = 'Harpoon: File 1' },
    { '<leader>2',  function() require('harpoon'):list():select(2) end,        desc = 'Harpoon: File 2' },
    { '<leader>3',  function() require('harpoon'):list():select(3) end,        desc = 'Harpoon: File 3' },
    { '<leader>4',  function() require('harpoon'):list():select(4) end,        desc = 'Harpoon: File 4' },
    { '[h',         function() require('harpoon'):list():prev() end,           desc = 'Harpoon: Previous' },
    { ']h',         function() require('harpoon'):list():next() end,           desc = 'Harpoon: Next' },
  },

  config = function()
    require('harpoon'):setup()

    vim.api.nvim_create_user_command('HarpoonPicker', function()
      local ok_find, finders    = pcall(require, 'telescope.finders')
      local ok_pick, pickers    = pcall(require, 'telescope.pickers')
      local ok_conf, conf_mod   = pcall(require, 'telescope.config')
      local ok_prev, previewers = pcall(require, 'telescope.previewers')
      if not (ok_find and ok_pick and ok_conf and ok_prev) then
        vim.notify('Telescope not available', vim.log.levels.WARN)
        return
      end

      local harpoon = require('harpoon')
      local list = harpoon:list()

      local items = {}
      for _, item in ipairs(list.items) do
        table.insert(items, item.value)
      end

      local function make_finder()
        return finders.new_table({ results = items })
      end

      pickers.new({}, {
        prompt_title = 'Harpoon',
        finder = make_finder(),
        previewer = previewers.vim_buffer_cat.new({}),
        sorter = conf_mod.values.generic_sorter({}),
        layout_strategy = 'center',
        layout_config = {
          preview_cutoff = 1,
          width  = function(_, max_cols)  return math.min(max_cols, 90) end,
          height = function(_, _, max_ln) return math.min(max_ln, 20) end,
        },
        borderchars = {
          prompt  = { '─','│',' ','│','╭','╮','│','│' },
          results = { '─','│','─','│','├','┤','╯','╰' },
          preview = { '─','│','─','│','╭','╮','╯','╰' },
        },
        attach_mappings = function(prompt_bufnr, map)
          local actions_state = require('telescope.actions.state')
          map('i', '<S-F2>', function()
            local picker = actions_state.get_current_picker(prompt_bufnr)
            local row = picker:get_selection_row()
            if row and row >= 1 and row <= #list.items then
              list:remove(row)
              items = {}
              for _, it in ipairs(list.items) do table.insert(items, it.value) end
              picker:refresh(make_finder(), { reset_prompt = false })
            end
          end)
          return true
        end,
      }):find()
    end, {})
  end,
}
