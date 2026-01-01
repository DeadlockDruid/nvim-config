return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    input = {
      enabled = true,
      border = 'rounded',
      title_pos = 'center',
      win_options = { winblend = 0 },
    },

    bigfile = {
      enabled = true,
      size = 1 * 1024 * 1024,
    },

    lazygit = {
      enabled = true,
      configure = true,
      config = {
        os = { editPreset = 'nvim-remote' },
        gui = { nerdFontsVersion = '3' },
      },
      theme_path = vim.fs.normalize(vim.fn.stdpath 'cache' .. '/lazygit-theme.yml'),
      theme = {
        activeBorderColor = { fg = 'MatchParen', bold = true },
        inactiveBorderColor = { fg = 'FloatBorder' },
        selectedLineBgColor = { bg = 'Visual' },
        optionsTextColor = { fg = 'Function' },
        unstagedChangesColor = { fg = 'DiagnosticError' },
        [241] = { fg = 'Special' },
      },
      win = { style = 'lazygit' },
    },

    picker = {
      enabled = true,
      -- IMPORTANT: don’t restrict sources unless you really mean it.
      -- If you set sources = { "commands" }, other pickers won’t show up.
      -- sources = { "commands" },
    },

    notifier = {
      enabled = true,
      style = 'fancy',
      timeout = 3000,
      border = 'rounded',
      level = vim.log.levels.INFO,
      win_options = { winblend = 0 },
      icons = {
        info = ' ',
        warn = ' ',
        error = ' ',
        debug = ' ',
        trace = '✎ ',
        success = ' ',
      },
    },

    -- disable stuff you don’t use
    dashboard = { enabled = false },
    explorer = { enabled = false },
    search = { enabled = false },
    terminal = { enabled = false },
    quickfile = { enabled = false },
    scratch = { enabled = false },
    scroll = { enabled = false },
    indent = { enabled = false },
    scope = { enabled = false },
    layout = { enabled = false },
    image = { enabled = false },
    toggle = { enabled = false },

    statuscolumn = {
      enabled = true,
      left = { 'mark', 'sign' },
      right = { 'fold', 'git' },
      folds = { open = true, git_hl = true },
      git = { patterns = { 'GitSign', 'MiniDiffSign' } },
      refresh = 50,
    },

    words = {
      enabled = true,
      debounce = 60,
      hl = 'LspReferenceText',
      scope = { min_chars = 2 },
    },
  },

  config = function(_, opts)
    require('snacks').setup(opts)

    -- Command palette
    vim.keymap.set('n', '<leader><leader>', function()
      Snacks.picker.commands()
    end, { desc = 'Commands (Snacks)' })
  end,
}
