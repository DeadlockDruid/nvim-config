return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      -- renamed keys
      auto_restore = false,  -- was: auto_restore_enabled
      suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" }, -- was: auto_session_suppress_dirs
      -- keep any other settings you use here
      auto_delete_empty_sessions = true,
    })

    local keymap = vim.keymap
    keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
    keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>",    { desc = "Save session for cwd" })
  end,
}
