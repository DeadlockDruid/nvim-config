return {
  "NvChad/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    filetypes = { "*" },
    buftypes = {},
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      RRGGBBAA = true,
      AARRGGBB = true,
      names = true,
      rgb_fn = true,
      hsl_fn = true,
      css = true,
      css_fn = true,
      tailwind = "lsp",
      mode = "background", -- or "virtualtext"
      virtualtext = "■",
      always_update = false,
      sass = { enable = true, parsers = { "css" } },
    },
  },
  config = function(_, opts)
    require("colorizer").setup(opts)

    -- Big-file guard: detach colorizer for files > 500KB
    local MAX = 500 * 1024
    vim.api.nvim_create_autocmd("BufReadPost", {
      callback = function(args)
        local ok, stat = pcall((vim.uv or vim.loop).fs_stat, args.file)
        if ok and stat and stat.size and stat.size > MAX then
          pcall(require("colorizer").detach_from_buffer, args.buf)
          vim.schedule(function()
            vim.notify("Colorizer disabled for large file (>500KB)", vim.log.levels.INFO)
          end)
        end
      end,
    })
  end,
}
