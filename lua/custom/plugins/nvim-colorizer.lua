return {
  'NvChad/nvim-colorizer.lua',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    filetypes = { '*' },
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

      -- key fix: stop using colorizer's Tailwind LSP path
      tailwind = true,

      mode = 'background',
      virtualtext = '■',
      always_update = false,
      sass = { enable = true, parsers = { 'css' } },
    },
  },
  config = function(_, opts)
    require('colorizer').setup(opts)

    local MAX = 500 * 1024
    vim.api.nvim_create_autocmd('BufReadPost', {
      callback = function(args)
        local path = vim.api.nvim_buf_get_name(args.buf)
        if path == '' then
          return
        end

        local ok, stat = pcall((vim.uv or vim.loop).fs_stat, path)
        if not ok or not stat or not stat.size then
          return
        end

        if stat.size > MAX then
          pcall(function()
            require('colorizer').detach_from_buffer(args.buf)
          end)

          vim.schedule(function()
            vim.notify('Colorizer disabled for large file (>500KB)', vim.log.levels.INFO)
          end)
        end
      end,
    })
  end,
}
