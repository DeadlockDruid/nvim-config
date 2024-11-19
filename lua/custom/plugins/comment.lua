return {
  "numToStr/Comment.nvim",
  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" }, -- Tree-sitter support for commenting

  config = function()
    -- Configure Comment.nvim with Tree-sitter context-aware commenting
    require("Comment").setup({
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })

    vim.g.skip_ts_context_commentstring_module = true

    -- Key mappings for '^$'
    vim.keymap.set("n", "^_", "gcc", { noremap = true, silent = true, desc = "Toggle line comment with ^_" }) -- Line comment
    vim.keymap.set("x", "^_", "gc", { noremap = true, silent = true, desc = "Toggle block comment with ^_" }) -- Block comment
  end,
}