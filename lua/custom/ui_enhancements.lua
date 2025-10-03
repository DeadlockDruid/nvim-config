-- lua/custom/plugins/ui_enhancements.lua
return function()
  -- Rounded LSP floating windows
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded" }
  )

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = "rounded" }
  )

  vim.diagnostic.config({
    float = { border = "rounded" },
  })

  -- Diagnostics: quieter virtual text + rounded borders
  vim.diagnostic.config({
    float = { border = "rounded" },
    virtual_text = {
      spacing = 2,
      prefix = "●",
    },
    underline = true,
    signs = true,
    update_in_insert = false,
    severity_sort = true,
  })

  -- Global UI tweaks
  vim.opt.laststatus   = 3
  vim.opt.cmdheight    = 0
  vim.opt.sidescrolloff = 8
  vim.opt.conceallevel = 2
  vim.opt.splitkeep    = "screen"
  vim.opt.inccommand   = "split"

  vim.opt.fillchars:append({
    fold    = " ",
    eob     = " ",
    diff    = "╱",
    msgsep  = " ",
    vert    = "│",
  })

  vim.opt.pumblend = 10
  vim.opt.winblend = 0
end
