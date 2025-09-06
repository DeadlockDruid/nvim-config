return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'j-hui/fidget.nvim',
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    local lspconfig = require 'lspconfig'

    -- Capabilities (cmp)
    local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities())

    -- LSP servers (lspconfig names)
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            diagnostics = { disable = { 'missing-fields' } },
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = { vim.fn.expand '$VIMRUNTIME/lua', vim.fn.stdpath 'config' .. '/lua' },
            },
            telemetry = { enable = false },
          },
        },
      },
      ts_ls = {}, -- TypeScript/JavaScript
      cssls = {},
      html = {},
      jsonls = {},
      tailwindcss = {
        filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' },
      },
      pyright = {},
      bashls = {},
      yamlls = {
        settings = {
          yaml = {
            schemaStore = { enable = true, url = 'https://www.schemastore.org/api/json/catalog.json' },
            validate = true,
            keyOrdering = false,
          },
        },
      },
      prismals = {},
      sqls = {}, -- matches Mason package 'sqls'
      volar = {  -- Vue
        filetypes = { 'vue', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
        settings = { vue = { inlayHints = { enable = true } } },
      },
      solargraph = {}, -- Ruby
      -- NEW: C/C++ and Go
      clangd = {
        -- You can tweak cmd flags if you need (indexing/speed). Defaults are fine for most.
        -- cmd = { "clangd", "--background-index", "--clang-tidy" },
      },
      gopls = {
        settings = {
          gopls = {
            analyses = { unusedparams = true, nilness = true, unusedwrite = true, shadow = true },
            staticcheck = true,
            gofumpt = true,
          },
        },
      },
    }

    require('mason').setup()

    -- mason-lspconfig (latest option name is automatic_installation)
    require('mason-lspconfig').setup {
      ensure_installed = vim.tbl_keys(servers),
      automatic_installation = true,
    }

    -- Tools (Mason package names)
    require('mason-tool-installer').setup {
      ensure_installed = {
        -- LSPs
        'lua-language-server',
        'typescript-language-server',
        'css-lsp',
        'html-lsp',
        'json-lsp',
        'tailwindcss-language-server',
        'pyright',
        'bash-language-server',
        'yaml-language-server',
        'prisma-language-server',
        'sqls',
        'vue-language-server',
        'solargraph',
        'clangd', -- C/C++
        'gopls',  -- Go
        -- formatters / linters / extras
        'prettier',
        'stylua',
        'isort',
        'black',
        'pylint',
        'eslint_d',
        'shfmt',
        'shellcheck',
        'sqlfluff',
        'clang-format',  -- C/C++ formatter
        'gofumpt',       -- Go formatter
        'golines',       -- Go line-wrapping formatter
        'golangci-lint', -- Go mega-linter
        'delve',         -- Go debugger
      },
      auto_update = true,
      run_on_start = true,
    }

    pcall(function()
      require('fidget').setup {}
    end)

    vim.diagnostic.config {
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = { border = 'rounded' },
    }

    local function on_attach(client, bufnr)
      if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint(bufnr, true)
      end
      if client.server_capabilities.documentFormattingProvider then
        local grp = vim.api.nvim_create_augroup('LspFormatting_' .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = grp,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format { bufnr = bufnr, timeout_ms = 3000 }
          end,
        })
      end
    end

    for name, cfg in pairs(servers) do
      lspconfig[name].setup(vim.tbl_deep_extend('force', {
        capabilities = capabilities,
        on_attach = on_attach,
      }, cfg))
    end
  end,
}
