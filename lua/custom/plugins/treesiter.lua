return {
  -- Syntax highlighting, indentation, and more
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
    "HiPhish/nvim-ts-rainbow2",  -- 🌈 rainbow brackets
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

      autotag = {
        enable = true,
      },

      rainbow = {
        enable = true,
        query = 'rainbow-parens',
        strategy = require('ts-rainbow').strategy.global,
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
  end,
}
