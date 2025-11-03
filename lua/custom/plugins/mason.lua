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

    local util = require 'lspconfig.util'

    -- on_attach: inlay hints + (optional) format-on-save
    local function on_attach(client, bufnr)
      -- Inlay hints (0.10/0.11 API compat)
      local ih = vim.lsp.inlay_hint
      if client.server_capabilities and client.server_capabilities.inlayHintProvider then
        if type(ih) == 'table' and type(ih.enable) == 'function' then
          pcall(ih.enable, bufnr, true)
        elseif type(ih) == 'function' then
          pcall(ih, bufnr, true)
        end
      end

      -- If you prefer conform.nvim for on-save formatting, comment the block below
      -- if client.server_capabilities and client.server_capabilities.documentFormattingProvider then
      --   local grp = vim.api.nvim_create_augroup('LspFormatting_' .. bufnr, { clear = true })
      --   vim.api.nvim_create_autocmd('BufWritePre', {
      --     group = grp,
      --     buffer = bufnr,
      --     callback = function()
      --       vim.lsp.buf.format { bufnr = bufnr, timeout_ms = 3000 }
      --     end,
      --   })
      -- end
    end

    -- Mason core
    require('mason').setup {
      -- don't spam checking on open; use :Mason or installer to update on demand
      ui = {
        border = 'rounded',
        check_outdated_packages_on_open = false,
        width = 0.8,
        height = 0.8,
      },
      log_level = vim.log.levels.WARN,
      max_concurrent_installers = 4,
      pip = { upgrade_pip = false }, -- faster startup; we manage pip ourselves
    }

    -- Filter ensure_installed to only servers mason-lspconfig knows about
    local wanted_servers = {
      'lua_ls',
      'vtsls',
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
      'ruby_lsp',
      'clangd',
      'gopls',
    }
    local ok_map, map = pcall(function()
      return require('mason-lspconfig.mappings.server').lspconfig_to_package
    end)
    local known_servers = ok_map and vim.tbl_filter(function(s)
      return map[s] ~= nil
    end, wanted_servers) or {}

    if ok_map and #known_servers == 0 then
      vim.schedule(function()
        vim.notify('[mason-lspconfig] no known servers from your list; registry may be stale', vim.log.levels.DEBUG)
      end)
    end

    -- Ensure LSP servers via mason-lspconfig (names must match lspconfig)
    require('mason-lspconfig').setup {
      ensure_installed = known_servers,
      automatic_installation = false,
    }

    -- Per-server settings
    local server_settings = {
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

      -- Modern TS/JS server
      vtsls = {
        root_dir = util.root_pattern 'package.json', -- Node projects only
        single_file_support = false, -- don't attach to lone .ts files
        settings = {
          typescript = {
            tsserver = { maxTsServerMemory = 3072 },
            preferences = {
              includeInlayParameterNameHints = 'all',
              includeInlayVariableTypeHints = true,
              includeCompletionsForModuleExports = true,
            },
          },
          vtsls = { autoUseWorkspaceTsdk = true },
        },
      },

      tailwindcss = {
        filetypes = {
          'html',
          'css',
          'scss',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
          'vue',
          'svelte',
        },
      },

      yamlls = {
        settings = {
          yaml = {
            schemaStore = { enable = true, url = 'https://www.schemastore.org/api/json/catalog.json' },
            validate = true,
            keyOrdering = false,
          },
        },
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

      -- Vue (volar). Let vtsls handle TS/JS; keep vue_ls only for .vue files
      vue_ls = {
        filetypes = { 'vue' },
        settings = { vue = { hybridMode = true } },
      },

      denols = {
        settings = {
          deno = { enable = true },
        },
        -- Attach ONLY when deno.json/deno.jsonc is present
        root_markers = { 'deno.json', 'deno.jsonc' },
        single_file_support = false,
        init_options = {
          lint = true,
          unstable = true,
          suggest = {
            imports = {
              hosts = {
                ['https://deno.land'] = true,
                ['https://jsr.io'] = true,
                ['https://esm.sh'] = true,
              },
            },
          },
        },
      },

      ruby_lsp = {},
      cssls = {},
      html = {},
      jsonls = {},
      pyright = {},
      bashls = {},
      prismals = {},
      sqls = {},
      clangd = {},
    }

    -- Setup handlers (default + overrides) using Neovim 0.11 API
    local mlsp = require 'mason-lspconfig'

    local function has_lspconfig(server)
      local ok, configs = pcall(require, 'lspconfig.configs')
      return ok and configs[server] ~= nil
    end

    local function setup_one(server)
      local opts = server_settings[server] or {}
      opts.capabilities = capabilities
      opts.on_attach = on_attach

      if has_lspconfig(server) then
        -- Use new API (no lspconfig.setup calls → no deprecation warning)
        vim.lsp.config(server, opts)
        vim.lsp.enable(server)
      else
        vim.schedule(function()
          vim.notify(("[mason-lspconfig] skipping unknown LSP server '%s'"):format(server), vim.log.levels.DEBUG)
        end)
      end
    end

    if type(mlsp.setup_handlers) == 'function' then
      mlsp.setup_handlers {
        function(server)
          setup_one(server)
        end,
      }
    else
      for _, server in ipairs(mlsp.get_installed_servers()) do
        setup_one(server)
      end
    end

    -- Hard-disable default ts servers; we'll let Node projects re-enable explicitly if needed
    pcall(vim.lsp.disable, 'ts_ls')
    pcall(vim.lsp.disable, 'vtsls')

    -- If any ts server still attaches in a Deno project, stop it so denols owns the buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('deno_exclusive_lsp', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
          return
        end
        if client.name ~= 'ts_ls' and client.name ~= 'vtsls' and client.name ~= 'eslint' then
          return
        end
        local fname = vim.api.nvim_buf_get_name(args.buf)
        local deno_root = require('lspconfig.util').root_pattern('deno.json', 'deno.jsonc')(fname)
        if deno_root then
          client:stop()
        end
      end,
    })

    -- Non-LSP tools via mason-tool-installer (formatters/linters/DAP/etc.)
    require('mason-tool-installer').setup {
      ensure_installed = {
        -- formatters / linters / extras only (avoid duplicating LSP servers)
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
      run_on_start = true, -- still auto-run, but give UI some time
      start_delay = 3000, -- ms; avoids blocking startup
      debounce_hours = 6, -- don’t re-run more than ~daily
    }

    -- nvim-lint: disable eslint_d for TS/JS so Deno projects don't error
    do
      local ok_lint, lint = pcall(require, 'lint')
      if ok_lint and lint then
        lint.linters_by_ft = lint.linters_by_ft or {}
        for _, ft in ipairs { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' } do
          lint.linters_by_ft[ft] = {} -- rely on denols diagnostics instead
        end
      end
    end

    -- Fidget (LSP progress) → render with a small rounded window; messages still go through vim.notify (Snacks)
    pcall(function()
      require('fidget').setup {
        progress = {
          display = {
            done_icon = '✔',
            progress_icon = { pattern = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }, period = 80 },
            render_limit = 16,
          },
          ignore = { 'null-ls' },
        },
        notification = {
          window = { border = 'rounded', winblend = 0, zindex = 60 },
        },
      }
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

    -- Ensure all LSP messages use vim.notify (Snacks notifier)
    vim.lsp.handlers['window/showMessage'] = function(_, result)
      local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type] or 'INFO'
      vim.notify(result.message, vim.log.levels[lvl])
    end
    vim.lsp.handlers['window/showMessageRequest'] = function(_, result)
      local actions = {}
      for i, action in ipairs(result.actions or {}) do
        actions[i] = action.title
      end
      vim.notify(result.message, vim.log.levels.INFO, { title = 'LSP', actions = actions })
    end

    -- Toggle inlay hints
    vim.keymap.set('n', '<leader>uh', function()
      local ih = vim.lsp.inlay_hint
      if type(ih) == 'table' and type(ih.is_enabled) == 'function' and type(ih.enable) == 'function' then
        ih.enable(0, not ih.is_enabled(0))
      elseif type(ih) == 'function' then
        ih(0, true)
      end
    end, { desc = 'Toggle inlay hints' })

    vim.lsp.config('denols', server_settings.denols)
    vim.lsp.enable 'denols'
  end,
}
