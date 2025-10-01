local function map(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- Save
map('n', '<leader>w', '<CMD>update<CR>')

-- Quit
map('n', '<leader>q', '<CMD>q<CR>')
map('n', '<leader>Q', '<CMD>qa<CR>') -- quit all buffers/windows

-- Exit insert mode
map('i', 'jk', '<ESC>')

-- New Windows
map('n', '<leader>o', '<CMD>vsplit<CR>')
map('n', '<leader>p', '<CMD>split<CR>')

-- Window Navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-l>', '<C-w>l')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-j>', '<C-w>j')

-- Resize Windows
map('n', '<C-Left>', '<C-w><')
map('n', '<C-Right>', '<C-w>>')
map('n', '<C-Up>', '<C-w>+')
map('n', '<C-Down>', '<C-w>-')

-- Move selected lines down without jumping to the last line
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")

-- Move selected lines up
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Enhances the default `J` behavior in normal mode to:
-- 1. Temporarily mark the cursor position before joining lines (`mz`).
-- 2. Join the current line with the next (`J`).
-- 3. Return the cursor to its original position (`\`z`).
-- 4. Keep the view centered on the joined lines (`z`).
vim.keymap.set('n', 'J', 'mzJ`z')

-- Enhances <C-d> (scroll half-page down) by:
-- 1. Scrolling half a page down (<C-d>).
-- 2. Centering the cursor vertically in the viewport (zz).
vim.keymap.set('n', '<C-d>', '<C-d>zz')

-- Enhances <C-u> (scroll half-page up) by:
-- 1. Scrolling half a page up (<C-u>).
-- 2. Centering the cursor vertically in the viewport (zz).
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Enhances `n` (search next occurrence) by:
-- 1. Moving to the next search match (n).
-- 2. Centering the match vertically in the viewport (zzz).
-- 3. Ensuring the match is unfolded and visible (v).
vim.keymap.set('n', 'n', 'nzzzv')

-- Enhances `N` (search previous occurrence) by:
-- 1. Moving to the previous search match (N).
-- 2. Centering the match vertically in the viewport (zzz).
-- 3. Ensuring the match is unfolded and visible (v).
vim.keymap.set('n', 'N', 'Nzzzv')

-- `<leader>p` in visual mode:
-- Replaces the selected text with the contents of the unnamed register (default register),
-- 1. Deletes the selected text (`_d`) but sends it to the black hole register (`_`), so it is not saved in the default register.
-- 2. Pastes (`P`) the content from the unnamed register, preserving the clipboard contents.
-- Useful for replacing text without overwriting the clipboard content.
vim.keymap.set('x', '<leader>P', [["_dP]])

-- `<leader>D` in normal or visual mode:
-- Deletes the current line without copying it to the default register.
-- 1. Uses the black hole register (`"_"`) to discard the deleted content.
-- 2. Ensures the previously copied content in the default register remains intact,
--    allowing seamless pasting after deletion.
-- Useful when you want to delete lines without overwriting the clipboard or register.
vim.keymap.set({ 'n', 'v' }, '<leader>D', [["_d]])

-- Navigate the quickfix list:
-- <M-k>: Jump to the next item in the quickfix list (`:cnext`) and center the cursor (`zz`).
-- <M-j>: Jump to the previous item in the quickfix list (`:cprev`) and center the cursor (`zz`).
vim.keymap.set('n', '<M-k>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<M-j>', '<cmd>cprev<CR>zz')

-- Navigate the location list:
-- <leader>k: Jump to the next item in the location list (`:lnext`) and center the cursor (`zz`).
-- <leader>j: Jump to the previous item in the location list (`:lprev`) and center the cursor (`zz`).
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz')
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz')

-- <leader>S:
-- Performs a search-and-replace operation for the word under the cursor across the entire file.
-- 1. `:%s/`: Substitutes in the entire file.
-- 2. `\<` and `\>`: Ensure only whole-word matches are replaced.
-- 3. `<C-r><C-w>`: Inserts the word under the cursor as the search and replacement term.
-- 4. `gI`: Replaces all matches (`g` - global) and makes the search case-insensitive (`I`).
-- 5. `<Left><Left><Left>`: Moves the cursor to the replacement field, allowing the user to modify the replacement text before execution.
-- Usage:
-- - Place the cursor on the word to be replaced.
-- - Press <leader>s, modify the replacement if needed, and press Enter to execute.
vim.keymap.set('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- <leader>X:
-- Makes the current file executable by running `chmod +x` on it.
-- 1. `%`: Refers to the current file in Vim.
-- 2. `!chmod +x %`: Executes the shell command to make the file executable.
-- 3. `{ silent = true }`: Suppresses shell output (e.g., success messages).
-- Usage:
-- - Open a script or file in Neovim.
-- - Press <leader>x to make it executable.
vim.keymap.set('n', '<leader>X', '<cmd>!chmod +x %<CR>', { silent = true })

-- <leader>mr:
-- Triggers the CellularAutomaton plugin with the "make_it_rain" animation preset.
-- 1. `CellularAutomaton`: Likely a plugin or script for rendering animations.
-- 2. `make_it_rain`: A specific animation or visualization mode.
-- Usage:
-- - Press <leader>mr in normal mode to start the "make it rain" animation.
-- - This is likely for fun or demonstration purposes.
vim.keymap.set('n', '<leader>mr', '<cmd>CellularAutomaton make_it_rain<CR>')

-- <leader><leader>:
-- Reloads the current Neovim configuration file.
-- 1. `vim.cmd("so")`: Executes the `:so` (source) command to reload the file.
--    This allows you to apply changes made in your configuration without restarting Neovim.
-- Usage:
-- - Open a configuration file (e.g., init.lua or any plugin-specific Lua file).
-- - Make changes to the file.
-- - Press <leader><leader> to reload the configuration and apply changes immediately.
vim.keymap.set('n', '<leader><leader>', function()
  vim.cmd 'so'
end)
