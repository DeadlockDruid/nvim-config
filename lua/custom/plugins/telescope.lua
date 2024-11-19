return {
  "nvim-telescope/telescope.nvim",
  version = "*",  -- Always use the latest branch
  dependencies = {
    "nvim-lua/plenary.nvim",  -- Required dependency
    { -- FZF native extension for faster fuzzy finding
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable "make" == 1  -- Only load if `make` is available
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },  -- For better UI select dropdowns
    { -- Icons, recommended for better visuals
      "nvim-tree/nvim-web-devicons", 
      enabled = vim.g.have_nerd_font  -- Only load if Nerd Fonts are available
    },
  },
  cmd = "Telescope",  -- Lazy load telescope with this command
  event = "VimEnter", -- Load telescope on VimEnter event
  config = function()
    -- Configure telescope and its extensions
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        -- Add custom default key mappings or behavior here if needed
        file_ignore_patterns = {
          "vendor/*",
          "public/packs",
          "dist/*",
          "%.lock",
          "__pycache__/*",
          "%.sqlite3",
          "%.ipynb",
          "node_modules/*",
          "%.jpg",
          "%.jpeg",
          "%.png",
          "%.svg",
          "%.otf",
          "%.ttf",
          ".git/",
          "%.webp",
          ".dart_tool/",
          ".github/",
          ".gradle/",
          ".idea/",
          ".settings/",
          ".vscode/",
          "__pycache__/",
          "build/",
          "env/",
          "gradle/",
          "node_modules/",
          "target/",
          "%.pdb",
          "%.dll",
          "%.class",
          "%.exe",
          "%.cache",
          "%.ico",
          "%.pdf",
          "%.dylib",
          "%.jar",
          "%.docx",
          "%.met",
          "smalljre_*/*",
          ".vale/",
          "%.burp",
          "%.mp4",
          "%.mkv",
          "%.rar",
          "%.zip",
          "%.7z",
          "%.tar",
          "%.bz2",
          "%.epub",
          "%.flac",
          "%.tar.gz",
          "%.o",
          "%.d",
          "%.sql",
        }
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),  -- Use dropdown for UI selections
        },
      },
    })

    -- Load Telescope extensions if available
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")

    -- Set key mappings for Telescope features
    local builtin = require "telescope.builtin"
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep for strings in cwd" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "List open buffers" })
    vim.keymap.set("n", "<leader>fs", builtin.git_status, { desc = "Search in Git status" })
    vim.keymap.set("n", "<leader>fc", builtin.git_commits, { desc = "Search Git commits" })

    -- More advanced keymaps and configurations
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files" })

    -- Fuzzy search in the current buffer
    vim.keymap.set("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    -- Search only in open files
    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      }
    end, { desc = "[S]earch [/] in Open Files" })

    -- Shortcut to search Neovim configuration files
    vim.keymap.set("n", "<leader>sn", function()
      builtin.find_files { cwd = vim.fn.stdpath("config") }
    end, { desc = "[S]earch [N]eovim files" })
  end,
}