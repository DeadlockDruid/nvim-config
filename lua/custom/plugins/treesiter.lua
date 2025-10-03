return {
  -- Syntax highlighting, indentation, and more
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
    "HiPhish/rainbow-delimiters.nvim",  -- 🌈 rainbow brackets
  },
  config = function()
    if vim.g._treesitter_loaded then
      return
    end
    vim.g._treesitter_loaded = true
    vim.g.skip_ts_context_commentstring_module = true
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline",
        "query", "vim", "vimdoc", "json", "javascript", "typescript", "tsx",
        "yaml", "css", "dockerfile", "gitignore", "rust", "go", "python", "ruby", "vue",
        "regex",
      },

      auto_install = true,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "ruby" },
      },

      indent = {
        enable = true,
        disable = { "ruby" },
      },


      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },

    })
    require('nvim-ts-autotag').setup({
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    })

    -- Configure rainbow-delimiters per official docs
    local rd = require('rainbow-delimiters')
    vim.g.rainbow_delimiters = {
      strategy = {
        [''] = rd.strategy['global'],
        vim  = rd.strategy['local'],
      },
      query = {
        ['']  = 'rainbow-delimiters',
        lua   = 'rainbow-blocks',
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
