return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },

  -- Lazy-load on first key use
  keys = {
    { '<leader>a', function() require('harpoon'):list():add() end,                   desc = 'Harpoon: Add' },
    { '<leader>H', '<cmd>HarpoonPicker<CR>', desc = 'Harpoon (Telescope)' },
    { '<leader>1', function() require('harpoon'):list():select(1) end },
    { '<leader>2', function() require('harpoon'):list():select(2) end },
    { '<leader>3', function() require('harpoon'):list():select(3) end },
    { '<leader>4', function() require('harpoon'):list():select(4) end },
    { '<leader>Fp', function() require('harpoon'):list():prev() end,  desc = 'Harpoon: Previous' },
    { '<leader>Fn', function() require('harpoon'):list():next() end,  desc = 'Harpoon: Next' },
  },

  config = function()
    require('harpoon'):setup()

    -- Back-compat shim for older mappings that call:
    --   require('custom.plugins.harpoon')._toggle_picker()
    do
      local mod = package.loaded['custom.plugins.harpoon'] or {}
      function mod._toggle_picker()
        vim.cmd('HarpoonPicker')
      end
      package.loaded['custom.plugins.harpoon'] = mod
    end

    -- Define a user command so keymaps don't need to require this file as a module
    vim.api.nvim_create_user_command("HarpoonPicker", function()
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
        previewer = previewers.vim_buffer_cat.new({}),  -- buffer-based previewer avoids termopen issues
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
              list:remove(row) -- Harpoon v2 expects an index
              -- refresh list & finder without closing the picker
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
