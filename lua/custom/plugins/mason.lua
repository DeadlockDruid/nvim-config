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
    -- Capabilities (cmp)
    local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())

    -- Global defaults
    local function on_attach(client, bufnr)
      local ih = vim.lsp.inlay_hint
      if client.server_capabilities and client.server_capabilities.inlayHintProvider then
        if type(ih) == 'table' and type(ih.enable) == 'function' then
          pcall(ih.enable, bufnr, true)
        elseif type(ih) == 'function' then
          pcall(ih, bufnr, true)
        end
      end
      if client.server_capabilities and client.server_capabilities.documentFormattingProvider then
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

    vim.lsp.config('*', {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Servers (NEW API names)
    vim.lsp.config('lua_ls', {
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
    })

    vim.lsp.config('ts_ls', {}) -- ✅ latest name
    vim.lsp.config('cssls', {})
    vim.lsp.config('html', {})
    vim.lsp.config('jsonls', {})
    vim.lsp.config('tailwindcss', {
      filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' },
    })
    vim.lsp.config('pyright', {})
    vim.lsp.config('bashls', {})
    vim.lsp.config('yamlls', {
      settings = {
        yaml = {
          schemaStore = { enable = true, url = 'https://www.schemastore.org/api/json/catalog.json' },
          validate = true,
          keyOrdering = false,
        },
      },
    })
    vim.lsp.config('prismals', {})
    vim.lsp.config('sqls', {})
    vim.lsp.config('vue_ls', {
      filetypes = { 'vue', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
      settings = {
        vue = {
          -- Enable take-over mode if you want vue_ls to handle TS/JS files too
          takeoverMode = true,
          -- Add any extra vue-specific settings here
        },
      },
    })
    vim.lsp.config('solargraph', {})
    vim.lsp.config('clangd', {})
    vim.lsp.config('gopls', {
      settings = { gopls = { analyses = { unusedparams = true, nilness = true, unusedwrite = true, shadow = true }, staticcheck = true, gofumpt = true } },
    })

    -- Mason
    require('mason').setup()

    -- We don't need mason-lspconfig.ensure_installed at all.
    require('mason-lspconfig').setup {} -- keep defaults; no ensure_installed list

    -- Use mason-tool-installer for packages (by Mason package names)
    require('mason-tool-installer').setup {
      ensure_installed = {
        -- LSP packages
        'lua-language-server',
        'typescript-language-server', -- ✅ installs TS; we still run ts_ls
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
        'clangd',
        'gopls',
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
        'clang-format',
        'gofumpt',
        'golines',
        'golangci-lint',
        'delve',
      },
      auto_update = true,
      run_on_start = true,
    }

    -- Enable everything we configured (no name mapping headaches)
    vim.lsp.enable {
      'lua_ls',
      'ts_ls',
      'cssls',
      'html',
      'jsonls',
      'tailwindcss',
      'pyright',
      'bashls',
      'yamlls',
      'prismals',
      'sqls',
      'vue_ls',
      'solargraph',
      'clangd',
      'gopls',
    }

    -- Fidget (optional)
    pcall(function()
      require('fidget').setup {}
    end)

    -- Diagnostics UI
    vim.diagnostic.config {
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = { border = 'rounded' },
    }

    -- Inlay hints toggle
    vim.keymap.set('n', '<leader>uh', function()
      local ih = vim.lsp.inlay_hint
      if type(ih) == 'table' and type(ih.is_enabled) == 'function' and type(ih.enable) == 'function' then
        ih.enable(0, not ih.is_enabled(0))
      elseif type(ih) == 'function' then
        ih(0, true)
      end
    end, { desc = 'Toggle inlay hints' })
  end,
}
