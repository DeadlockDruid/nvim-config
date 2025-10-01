return {
  "kylechui/nvim-surround",
  event = "VeryLazy", -- load after UI; maps are still available
  version = "*",
  opts = {

    -- A couple of useful custom surrounds
    surrounds = {
      -- Markdown link: surrounds selection/word with [text](url)
      -- Usage: select text → `gzS` then enter `l`
      l = {
        add = function()
          local url = vim.fn.input("Link URL: ")
          if url == "" then return nil end
          return { { "[" }, { "](" .. url .. ")" } }
        end,
        -- crude find patterns so change/delete works for existing links
        find = "%b[]%b()",
        delete = "^(%[)().-(%]%b())()$",
        change = {
          target = "^%[().-(%]%()().-(%)()$",
          replacement = function()
            local new_url = vim.fn.input("New URL: ")
            return { { "" }, { new_url } }
          end,
        },
      },

      -- HTML tag with prompt (e.g. div, span)
      -- Usage: motion → `gzs` then enter `t`
      t = {
        add = function()
          local tag = vim.fn.input("Tag: ")
          if tag == "" then return nil end
          return { { "<" .. tag .. ">" }, { "</" .. tag .. ">" } }
        end,
        find = function()
          return require("nvim-surround.config").get_selection({
            node = "xml_element", -- works for html/xml/tsx if treesitter has nodes
          })
        end,
      },
    },
  },
}
