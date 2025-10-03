local global = vim.g
local o = vim.opt

-- Editor options

o.syntax = 'on' -- When this option is set, the syntax with this name is loaded.
o.autoindent = true -- Copy indent from current line when starting a new line.
o.expandtab = true -- In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
o.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent.
o.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for.
o.encoding = 'UTF-8' -- Sets the character encoding used inside Vim.
o.ruler = true -- Show the line and column number of the cursor position, separated by a comma.
o.title = true -- When on, the title of the window will be set to the value of 'titlestring'
o.hidden = true -- When on a buffer becomes hidden when it is |abandon|ed
-- o.ttimeoutlen = 0 -- The time in milliseconds that is waited for a key code or mapped key sequence to complete.
o.wildmenu = true -- When 'wildmenu' is on, command-line completion operates in an enhanced mode.
o.showcmd = true -- Show (partial) command in the last line of the screen. Set this option off if your terminal is slow.
o.showmatch = true -- When a bracket is inserted, briefly jump to the matching one.
-- o.inccommand = "split" -- When nonempty, shows the effects of :substitute, :smagic, :snomagic and user commands with the :command-preview flag as you type.
o.termguicolors = true

-- Use Treesitter-based folding
o.foldmethod = 'expr'
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- Start with everything open, but folding enabled
o.foldenable = true
o.foldlevel = 99
o.foldlevelstart = 99

-- Show a fold column (auto grows up to 3 cells)
o.foldcolumn = 'auto:3'

-- Nice fold icons (Nerd Font v3 friendly)
o.fillchars = {
  foldopen = '', -- open arrow
  foldclose = '', -- closed arrow
  fold = ' ', -- filler inside folds
  foldsep = ' ', -- separators between folds
  eob = ' ', -- cleaner empty lines
}
