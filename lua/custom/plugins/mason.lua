return {
  -- Main LSP and Mason Configuration
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Mason setup for managing LSP servers and tools
    {
      "williamboman/mason.nvim",
      config = true, -- Automatically sets up Mason before dependents
    },
    "williamboman/mason-lspconfig.nvim", -- Integrates Mason with LSP config
    "WhoIsSethDaniel/mason-tool-installer.nvim", -- Ensures tools are installed
    "j-hui/fidget.nvim", -- LSP status updates
    "hrsh7th/cmp-nvim-lsp", -- Adds LSP autocompletion for cmp
  },
  config = function()
    -- Helper functions to determine Ruby version
    local function get_ruby_version()
      local handle = io.popen("ruby -e 'puts RUBY_VERSION'")
      local result = handle:read("*a")
      handle:close()
      return result:match("%d+%.%d+%.%d+") -- Extract version (e.g., "3.1.2")
    end

    local function is_ruby_version_gte_3()
      local version = get_ruby_version()
      local major, minor = version:match("^(%d+)%.(%d+)")
      return tonumber(major) >= 3
    end

    -- LSP server capabilities
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )

    -- Setup installed LSP servers
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = { disable = { "missing-fields" } },
          },
        },
      },
      ts_ls = {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      },
      cssls = {},
      html = {},
      jsonls = {},
      tailwindcss = {},
      pyright = {},
      bashls = {
        settings = {
          bashIde = {
            globPattern = "*@(.sh|.inc|.bash|.command)",
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow"] = ".github/workflows/*",
              ["https://json.schemastore.org/kubernetes"] = "/*.k8s.yaml",
              ["https://json.schemastore.org/prettierrc"] = ".prettierrc.yaml",
            },
            validate = true,
          },
        },
      },
      prismals = {
        settings = {
          prisma = {
            prismaFmtBinPath = "prisma-fmt",
          },
        },
      },
      sqlls = {
        settings = {
          sql = {
            connections = {
              {
                driver = "sqlite",
                dataSourceName = "path/to/your/database.db",
              },
            },
          },
        },
      },
      volar = {
        filetypes = { "vue" },
      },
      solargraph = {
        settings = {
          solargraph = {
            diagnostics = true,
            formatting = false, -- Delegate formatting to RuboCop
          },
        },
      },
    }

    -- Add Ruby-specific configurations
    -- if is_ruby_version_gte_3() then
    --   require("lspconfig")["ruby-lsp"].setup({
    --     cmd = { "ruby-lsp" },
    --     filetypes = { "ruby" },
    --     root_dir = require("lspconfig").util.root_pattern("Gemfile", ".git"),
    --     capabilities = capabilities,
    --     on_attach = function(client, bufnr)
    --       -- Format on save
    --       if client.server_capabilities.documentFormattingProvider then
    --         vim.api.nvim_create_autocmd("BufWritePre", {
    --           group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
    --           buffer = bufnr,
    --           callback = function()
    --             vim.lsp.buf.format()
    --           end,
    --         })
    --       end
    --     end,
    --   })
    -- else
      
    -- end

    -- Mason setup
    require("mason").setup()

    -- Mason LSP config setup
    require("mason-lspconfig").setup({
      automatic_installation = true,
      ensure_installed = vim.tbl_keys(servers), -- Automatically install listed servers
    })

    -- Mason tool installer setup
    require("mason-tool-installer").setup({
      ensure_installed = {
        "prettier",
        "stylua",
        "isort",
        "black",
        "pylint",
        "eslint_d",
        "shfmt",
        "shellcheck",
        "sqlfluff",
        "yaml-language-server",
        "prisma-language-server",
        "ts_ls",
        "solargraph",
        "volar",
        "sqlls",
        "prismals",
        "yamlls",
        "bashls",
        "pyright",
        "tailwindcss",
        "jsonls",
        "cssls",
        "html",
        "lua_ls",
      },
    })

    -- Mason-LSPconfig handler to configure servers
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        local server = servers[server_name] or {}
        require("lspconfig")[server_name].setup(vim.tbl_extend("force", {
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            -- Format on save
            if client.server_capabilities.documentFormattingProvider then
              vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format()
                end,
              })
            end
          end,
        }, server))
      end,
    })
  end,
}
