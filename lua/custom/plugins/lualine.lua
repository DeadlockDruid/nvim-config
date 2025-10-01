return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    lualine.setup({
      options = {
        theme = "auto",                                -- respects current colorscheme
        section_separators = { left = "", right = "" }, -- fancy separators
        component_separators = "|",                     -- simple component separator
        globalstatus = true,                             -- single statusline at the bottom
      },
      sections = {
        lualine_a = { "mode" },                          -- shows mode (NORMAL, INSERT...)
        lualine_b = { "branch", "diff", "diagnostics" }, -- git branch + changes + LSP diagnostics
        lualine_c = { "filename" },                      -- current filename
        lualine_x = {
          { lazy_status.updates, cond = lazy_status.has_updates },
          "encoding",                                    -- file encoding (e.g., UTF-8)
          "fileformat",                                  -- unix/dos
          "filetype",                                    -- lua/js/markdown
        },
        lualine_y = { "progress" },                      -- progress through file (e.g., 45%)
        lualine_z = { "location" },                      -- line:column indicator
      },
    })
  end,
}
