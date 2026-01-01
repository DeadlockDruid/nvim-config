return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',

  dependencies = {
    'windwp/nvim-ts-autotag',
    'HiPhish/rainbow-delimiters.nvim',
    {
      -- Keep for queries only (no config in rewrite)
      'nvim-treesitter/nvim-treesitter-textobjects',
      branch = 'main',
      config = false,
    },
  },

  config = function()
    local ts = require 'nvim-treesitter'

    -- Rewrite setup
    ts.setup {
      install_dir = vim.fn.stdpath 'data' .. '/site',
    }

    -- Parsers you want available
    local ensured = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
      'json',
      'javascript',
      'typescript',
      'tsx',
      'yaml',
      'css',
      'dockerfile',
      'gitignore',
      'rust',
      'go',
      'python',
      'ruby',
      'vue',
      'regex',
      'latex',
    }

    -- ✅ Non-blocking ensure (don’t hang startup)
    -- This will install missing parsers in the background.
    ts.install(ensured)

    -- Big-file guard + start Treesitter highlighting
    local group = vim.api.nvim_create_augroup('TreesitterStart', { clear = true })

    local function is_big_file(buf)
      local max_size = 500 * 1024 -- 500KB (tweak if you want)
      local name = vim.api.nvim_buf_get_name(buf)
      if name == '' then
        return false
      end

      local uv = vim.uv or vim.loop
      local ok, stat = pcall(uv.fs_stat, name)
      return ok and stat and stat.size and stat.size > max_size
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      callback = function(args)
        if is_big_file(args.buf) then
          pcall(vim.treesitter.stop, args.buf)
          vim.schedule(function()
            vim.notify('Treesitter disabled (large file)', vim.log.levels.WARN)
          end)
          return
        end

        pcall(vim.treesitter.start, args.buf)
      end,
    })

    -- Autotag
    require('nvim-ts-autotag').setup {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    }

    -- Rainbow delimiters
    local rd = require 'rainbow-delimiters'
    vim.g.rainbow_delimiters = {
      strategy = {
        [''] = rd.strategy.global,
        vim = rd.strategy['local'], -- "local" is a Lua keyword -> bracket access
      },
      query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
      },
      highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
      },
    }
  end,
}
