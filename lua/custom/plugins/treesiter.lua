return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  event = { "BufReadPre", "BufNewFile" }, -- Event-based loading for performance
  build = ':TSUpdate', -- Automatically update Treesitter parsers
  dependencies = {
    "windwp/nvim-ts-autotag", -- Additional plugin dependency
  },
  config = function()
    -- Setup Treesitter
    local treesitter = require("nvim-treesitter.configs")

    -- Setup ts_context_commentstring
    require('ts_context_commentstring').setup({
      enable_autocmd = false, -- Avoid automatic updates
      languages = {
        typescript = '// %s',
        javascript = '// %s',
        vue = '<!-- %s -->',
        html = '<!-- %s -->',
      },
    })

    vim.g.skip_ts_context_commentstring_module = true

    treesitter.setup({
      -- Ensure installed parsers
      ensure_installed = {
        'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query',
        'vim', 'vimdoc', 'json', 'javascript', 'typescript', 'tsx', 'yaml', 'css',
        'dockerfile', 'gitignore', 'rust', 'go', 'python', 'ruby', 'javascript', 'vue'
      },

      -- Autoinstall parsers that are not installed
      auto_install = true,

      -- Highlight settings
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system for indent rules
        additional_vim_regex_highlighting = { 'ruby' }, -- Enabling vim regex highlighting for Ruby
      },

      -- Indentation settings
      indent = {
        enable = true,
        disable = { 'ruby' }, -- Disable indent for Ruby due to special behavior
      },

      -- Autotag for HTML and XML
      autotag = {
        enable = true,
      },

      -- Incremental selection settings
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },

      -- Rainbow parentheses
      rainbow = {
        enable = true,
        disable = { "html" }, -- Disable for HTML files
        extended_mode = false, -- Do not highlight non-parentheses delimiters like tags
        max_file_lines = nil, -- No limit on file size for enabling rainbow
      },
    })
  end,
}