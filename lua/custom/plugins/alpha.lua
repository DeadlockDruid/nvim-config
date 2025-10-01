return {
  -- "goolord/alpha-nvim",
  -- event = "VimEnter",
  -- config = function()
  --   local alpha = require("alpha")
  --   local dashboard = require("alpha.themes.dashboard")

  --   -- Set header
  --   dashboard.section.header.val = {
  --     "                                                     ",
  --     "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  --     "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  --     "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  --     "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  --     "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  --     "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  --     "                                                     ",
  --   }

  --   -- Set menu
  --   dashboard.section.buttons.val = {
  --     dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
  --     dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
  --     dashboard.button("SPC ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
  --     dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
  --     dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
  --     dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
  --   }

  --   -- Send config to alpha
  --   alpha.setup(dashboard.opts)

  --   -- Disable folding on alpha buffer and clean up UI using modern API
  --   vim.api.nvim_create_autocmd("FileType", {
  --     pattern = "alpha",
  --     callback = function(event)
  --       vim.opt_local.foldenable = false
  --       -- keep the left gutter clean on the start screen
  --       pcall(function() vim.opt_local.statuscolumn = "" end)
  --     end,
  --   })
  -- end,
}
