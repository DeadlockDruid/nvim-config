return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local todo = require("todo-comments")

    -- Keymaps
    local map = vim.keymap.set
    map("n", "]t", todo.jump_next, { desc = "Next TODO comment" })
    map("n", "[t", todo.jump_prev, { desc = "Prev TODO comment" })

    -- Focused jumps: only FIX/FIXME/BUG/ERROR/WARN
    map("n", "]x", function()
      todo.jump_next({ keywords = { "FIX", "FIXME", "BUG", "ERROR", "WARN" } })
    end, { desc = "Next problem TODO (FIX/WARN)" })
    map("n", "[x", function()
      todo.jump_prev({ keywords = { "FIX", "FIXME", "BUG", "ERROR", "WARN" } })
    end, { desc = "Prev problem TODO (FIX/WARN)" })

    -- Optional: open lists (Telescope mapping also exists in your telescope.lua)
    map("n", "<leader>tq", ":TodoQuickFix<CR>", { desc = "TODOs → quickfix" })

    todo.setup({
      signs = true,
      sign_priority = 6,
      keywords = {
        FIX   = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO  = { icon = " ", color = "hint" },
        HACK  = { icon = " ", color = "warning" },
        WARN  = { icon = " ", color = "warning", alt = { "WARNING" } },
        PERF  = { icon = " ", color = "info",    alt = { "OPTIM", "PERF", "PERFORMANCE" } },
        NOTE  = { icon = " ", color = "hint",    alt = { "INFO" } },
        TEST  = { icon = " ", color = "test",    alt = { "TESTING", "PASSED", "FAILED" } },
      },
      highlight = {
        multiline = false,            -- faster & cleaner
        before = "",
        keyword = "bg",              -- highlight the keyword strongly
        after = "fg",                -- keep comment readable
        pattern = [[.*<(KEYWORDS)\s*:]],
      },
      colors = {
        error   = { "#f38ba8", "DiagnosticError", "ErrorMsg" },
        warning = { "#f9e2af", "DiagnosticWarn" },
        info    = { "#89b4fa", "DiagnosticInfo" },
        hint    = { "#94e2d5", "DiagnosticHint" },
        default = { "#cdd6f4", "Normal" },
        test    = { "#a6e3a1" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never", "--no-heading", "--with-filename", "--line-number", "--column",
          "--smart-case", "--hidden", "--glob", "!.git/",
        },
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      },
    })
  end,
}
