return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "BufReadPost", "BufNewFile" }, -- load when a real buffer opens
  config = function()
    local ok_cfg, ts_cfg = pcall(require, "nvim-treesitter.configs")
    if not ok_cfg then return end

    -- Big-file guard (disable expensive modules for huge files)
    -- local function bigfile_disable(_, buf)
    --   local uv = vim.uv or vim.loop
    --   local name = vim.api.nvim_buf_get_name(buf)
    --   if name == "" then return false end
    --   local ok, stat = pcall(uv.fs_stat, name)
    --   return ok and stat and stat.size and stat.size > 200 * 1024  -- >200KB
    -- end

    ts_cfg.setup({
      textobjects = {
        select = {
          enable = true,
          disable = nil,
          lookahead = true, -- jump forward to next textobj
          include_surrounding_whitespace = false, -- QoL: don’t grab trailing WS by default
          -- Optional: different selection modes per textobject
          -- selection_modes = {
          --   ['@parameter.outer'] = 'v',  -- charwise
          --   ['@function.outer']  = 'V',  -- linewise
          --   ['@class.outer']     = '<c-v>', -- blockwise
          -- },
          keymaps = {
            -- Assignments
            ["a="] = { query = "@assignment.outer", desc = "Select outer assignment" },
            ["i="] = { query = "@assignment.inner", desc = "Select inner assignment" },
            ["l="] = { query = "@assignment.lhs",   desc = "Select LHS assignment" },
            ["r="] = { query = "@assignment.rhs",   desc = "Select RHS assignment" },

            -- Object properties (requires queries with @property.*)
            ["a:"] = { query = "@property.outer", desc = "Select outer property" },
            ["i:"] = { query = "@property.inner", desc = "Select inner property" },
            ["l:"] = { query = "@property.lhs",   desc = "Select left property" },
            ["r:"] = { query = "@property.rhs",   desc = "Select right property" },

            -- Params
            ["aa"] = { query = "@parameter.outer", desc = "Select outer argument" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner argument" },

            -- Conditionals
            ["ai"] = { query = "@conditional.outer", desc = "Select outer conditional" },
            ["ii"] = { query = "@conditional.inner", desc = "Select inner conditional" },

            -- Loops
            ["al"] = { query = "@loop.outer", desc = "Select outer loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inner loop" },

            -- Calls
            ["af"] = { query = "@call.outer", desc = "Select outer call" },
            ["if"] = { query = "@call.inner", desc = "Select inner call" },

            -- Functions/Methods
            ["am"] = { query = "@function.outer", desc = "Select outer function" },
            ["im"] = { query = "@function.inner", desc = "Select inner function" },

            -- Classes
            ["ac"] = { query = "@class.outer", desc = "Select outer class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner class" },
          },
        },

        swap = {
          enable = true,
          disable = bigfile_disable, -- optional: also guard swap on big files
          swap_next = {
            ["<leader>na"] = "@parameter.inner",
            ["<leader>n:"] = "@property.outer",
            ["<leader>nm"] = "@function.outer",
          },
          swap_previous = {
            ["<leader>pa"] = "@parameter.inner",
            ["<leader>p:"] = "@property.outer",
            ["<leader>pm"] = "@function.outer",
          },
        },

        move = {
          enable = true,
          disable = bigfile_disable,
          set_jumps = true, -- record in jumplist
          goto_next_start = {
            ["]f"] = { query = "@call.outer",         desc = "Next call start" },
            ["]m"] = { query = "@function.outer",     desc = "Next function start" },
            ["]c"] = { query = "@class.outer",        desc = "Next class start" },
            ["]i"] = { query = "@conditional.outer",  desc = "Next conditional start" },
            ["]l"] = { query = "@loop.outer",         desc = "Next loop start" },
            ["]s"] = { query = "@scope",  query_group = "locals", desc = "Next scope" },
            ["]z"] = { query = "@fold",   query_group = "folds",  desc = "Next fold" },
          },
          goto_next_end = {
            ["]F"] = { query = "@call.outer",         desc = "Next call end" },
            ["]M"] = { query = "@function.outer",     desc = "Next function end" },
            ["]C"] = { query = "@class.outer",        desc = "Next class end" },
            ["]I"] = { query = "@conditional.outer",  desc = "Next conditional end" },
            ["]L"] = { query = "@loop.outer",         desc = "Next loop end" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@call.outer",         desc = "Prev call start" },
            ["[m"] = { query = "@function.outer",     desc = "Prev function start" },
            ["[c"] = { query = "@class.outer",        desc = "Prev class start" },
            ["[i"] = { query = "@conditional.outer",  desc = "Prev conditional start" },
            ["[l"] = { query = "@loop.outer",         desc = "Prev loop start" },
          },
          goto_previous_end = {
            ["[F"] = { query = "@call.outer",         desc = "Prev call end" },
            ["[M"] = { query = "@function.outer",     desc = "Prev function end" },
            ["[C"] = { query = "@class.outer",        desc = "Prev class end" },
            ["[I"] = { query = "@conditional.outer",  desc = "Prev conditional end" },
            ["[L"] = { query = "@loop.outer",         desc = "Prev loop end" },
          },
        },

        -- Optional: peek definitions with TS nodes (requires nvim 0.10+ floating win OK)
        -- lsp_interop = {
        --   enable = true,
        --   border = "rounded",
        --   peek_definition_code = {
        --     ["<leader>df"] = "@function.outer",
        --     ["<leader>dc"] = "@class.outer",
        --   },
        -- },
      },
    })

    -- Repeatable motions (; and ,) with safety guards
    local ok_rep, ts_repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
    if ok_rep then
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move, { desc = "Repeat last TS move" })
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite, { desc = "Repeat TS move opposite" })
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
    end
  end,
}
