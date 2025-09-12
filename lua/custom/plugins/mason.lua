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
    local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())

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
      ts_ls = {}, -- TypeScript/JavaScript (new name in lspconfig)
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
      volar = { -- Vue
        filetypes = { 'vue', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
        settings = { vue = { inlayHints = { enable = true } } },
      },
      solargraph = {}, -- Ruby
      -- C/C++ and Go
      clangd = {
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

    -- Mason core
    require('mason').setup()

    -- mason-lspconfig (use automatic_installation for latest)
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
        'gopls', -- Go
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
        'clang-format', -- C/C++ formatter
        'gofumpt', -- Go formatter
        'golines', -- Go line-wrapping formatter
        'golangci-lint', -- Go mega-linter
        'delve', -- Go debugger
      },
      auto_update = true,
      run_on_start = true,
    }

    -- Fidget (non-fatal if missing)
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

    ------------------------------------------------------------------------
    -- Cross-version inlay hints helper (fixes 0.10+ change)
    ------------------------------------------------------------------------
    local function enable_inlay_hints(bufnr, enable)
      local ih = vim.lsp.inlay_hint
      if type(ih) == 'function' then
        -- Neovim <= 0.9: vim.lsp.inlay_hint(bufnr, true/false)
        pcall(ih, bufnr, enable)
        return
      end
      if type(ih) == 'table' then
        -- Neovim 0.10+: vim.lsp.inlay_hint.enable(bufnr, true/false)
        if type(ih.enable) == 'function' then
          local ok = pcall(ih.enable, bufnr, enable)
          if not ok then
            pcall(ih.enable, enable, { bufnr = bufnr })
          end
        elseif type(ih.set) == 'function' then
          pcall(ih.set, enable, { bufnr = bufnr })
        end
      end
    end

    -- Optional: toggle mapping for inlay hints
    vim.keymap.set('n', '<leader>uh', function()
      local ih = vim.lsp.inlay_hint
      if type(ih) == 'table' and type(ih.is_enabled) == 'function' and type(ih.enable) == 'function' then
        ih.enable(0, not ih.is_enabled(0))
      elseif type(ih) == 'function' then
        ih(0, true) -- 0.9 has no read API; just turn on
      end
    end, { desc = 'Toggle inlay hints' })

    -- on_attach
    local function on_attach(client, bufnr)
      -- Inlay hints (guarded + cross-version)
      if client and client.server_capabilities and client.server_capabilities.inlayHintProvider then
        enable_inlay_hints(bufnr, true)
      end

      -- Format-on-save
      if client and client.server_capabilities and client.server_capabilities.documentFormattingProvider then
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

    -- Setup all servers
    for name, cfg in pairs(servers) do
      lspconfig[name].setup(vim.tbl_deep_extend('force', {
        capabilities = capabilities,
        on_attach = on_attach,
      }, cfg))
    end
  end,
}
