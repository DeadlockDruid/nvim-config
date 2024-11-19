return {
  "stevearc/conform.nvim",
  event = { "BufWritePre", "BufReadPre", "BufNewFile" }, -- Autoformat on save and setup on read/new file
  cmd = { "ConformInfo" }, -- Command to get info about conform
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' } -- Async formatting on demand
      end,
      mode = { "n", "v" }, -- Works in normal and visual mode
      desc = "[F]ormat file or range",
    },
  },
  config = function()
    local conform = require("conform")

    conform.setup({
      -- Formatter setup by filetype
      formatters_by_ft = {
        javascript = { "prettier" }, -- Use prettier for JS
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" }, -- Add Vue support using prettier
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" }, -- Use stylua for Lua
        ruby = { "rubocop" }, -- Add Ruby support using rubocop
        python = { "isort", "black" }, -- Sequential formatting for Python
      },

      -- Autoformat settings (async)
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for certain filetypes (e.g., C, C++)
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt

        -- Determine if we need to disable LSP formatting for certain filetypes
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback' -- Use LSP as fallback
        end

        return {
          timeout_ms = 1000, -- Set 1-second timeout for formatting
          lsp_format = lsp_format_opt, -- Fallback to LSP if no formatter
        }
      end,
      
      -- Global options
      notify_on_error = false, -- Suppress error notifications during formatting
    })

    -- Key mapping for manual formatting
    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      conform.format({
        lsp_format = 'fallback', -- Use LSP if no formatter configured
        async = true, -- Perform async formatting for smoother experience
        timeout_ms = 1000, -- Set 1-second timeout
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}