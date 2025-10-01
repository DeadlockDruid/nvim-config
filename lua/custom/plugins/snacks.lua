return {
  "folke/snacks.nvim",
  lazy = false,               -- load immediately so ui.input/select are ready
  priority = 1000,            -- make sure it loads early
  opts = {
    -- 👇 Keep only what you need
    input = {
      enabled = true,
      border = "rounded",
      title_pos = "center",
      win_options = { winblend = 0 },
    },
    bigfile = {
      enabled = true,
      -- default triggers at 1MB, adjust if you like
      size = 1 * 1024 * 1024,
    },
    lazygit = {
      configure = true, -- auto-theme + nvim-remote integration
      config = {
        os = { editPreset = "nvim-remote" },
        gui = {
          nerdFontsVersion = "3", -- you’re on a Nerd Font v3 setup
        },
      },
      theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
      theme = {
        -- tweak a few highlight mappings; inherit the rest from your colorscheme
        activeBorderColor          = { fg = "MatchParen", bold = true },
        inactiveBorderColor        = { fg = "FloatBorder" },
        selectedLineBgColor        = { bg = "Visual" }, -- set to 'default' to remove
        optionsTextColor           = { fg = "Function" },
        unstagedChangesColor       = { fg = "DiagnosticError" },
        [241]                      = { fg = "Special" },
      },
      win = { style = "lazygit" }, -- Snacks window preset for LG
    },

    -- Disable everything else
    dashboard     = { enabled = false },
    explorer      = { enabled = false },
    picker = {
      enabled = true,
      -- optional: keep it light
      sources = { "commands" }, -- or leave empty to allow all
    },
    notifier      = {
      enabled = true,
      style = "fancy",                -- "fancy" | "compact" | "simple"
      timeout = 3000,
      border = "rounded",
      level = vim.log.levels.INFO,
      win_options = { winblend = 0 },
      -- proper icons table (no booleans)
      icons = {
        info    = " ",
        warn    = " ",
        error   = " ",
        debug   = " ",
        trace   = "✎ ",
        success = " ",
      },
    },
    search        = { enabled = false },
    terminal      = { enabled = false },
    quickfile     = { enabled = false },
    scratch       = { enabled = false },
    scroll        = { enabled = false },
    statuscolumn = {
      enabled = true,
      folds = true,
      git = true,
      diagnostics = true,
      separator = " ",
    },
    words = {
      enabled = true,
      debounce = 60,
      hl = "LspReferenceText",  -- use your theme’s reference highlight
      scope = { min_chars = 2 },-- ignore single letters
    },
    indent        = { enabled = false },
    scope         = { enabled = false },
    layout        = { enabled = false },
    image         = { enabled = false },
    toggle        = { enabled = false },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    -- Route all notifications through Snacks
    local ok, notifier = pcall(require, "snacks.notifier")
    if ok then
      vim.notify = notifier.notify
    end

    -- Command palette using Snacks picker
    vim.keymap.set("n", "<leader><leader>", function()
      require("snacks").picker.commands()
    end, { desc = "Commands (Snacks)" })
  end,
}
