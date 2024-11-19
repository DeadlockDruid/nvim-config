return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  -- Optional dependency for nvim-cmp
  dependencies = { 'hrsh7th/nvim-cmp' },
  config = function()
    -- Setup for nvim-autopairs
    require('nvim-autopairs').setup({
      disable_filetype = { "TelescopePrompt", "vim" }, -- Disable autopairs in certain filetypes
    })

    -- Autopair integration with nvim-cmp
    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local cmp = require 'cmp'
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}