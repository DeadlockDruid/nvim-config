return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },  -- load lazily on file open
  main = "ibl",                            -- use the new module name
  opts = {
    indent = { char = "┊" },               -- thin dotted vertical guides
  },
}
