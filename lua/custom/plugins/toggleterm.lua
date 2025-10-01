return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<F7>", "<cmd>ToggleTerm<CR>", desc = "Toggle Terminal" },
  },
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      open_mapping = [[<F7>]],
      shading_factor = 2,
      persist_mode = false,
      close_on_exit = true,
      shell = vim.o.shell,
      direction = "float",
      float_opts = {
        border = "curved",
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })
  end,
}
