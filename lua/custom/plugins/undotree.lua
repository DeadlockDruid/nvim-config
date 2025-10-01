return {
  'mbbill/undotree',
  keys = {
    { '<leader>u', '<cmd>UndotreeToggle<CR>', desc = 'Toggle UndoTree' },
  },
  config = function()
    vim.g.undotree_WindowLayout = 2         -- Right side
    vim.g.undotree_SplitWidth = 35
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_DiffAutoOpen = 1
    vim.g.undotree_DiffpanelHeight = 10
  end,
}
