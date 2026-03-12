# Neovim Keymap Reference

> Leader = `<Space>`
> All custom bindings only — built-ins included where commonly forgotten.

---

## Modes Legend
`n` = Normal · `i` = Insert · `v` = Visual · `x` = Visual (no select) · `t` = Terminal

---

## Essentials (Commonly Forgotten)

| Key | Action |
|-----|--------|
| `u` | Undo |
| `<C-r>` | **Redo** |
| `*` | Search word under cursor (forward) |
| `#` | Search word under cursor (backward) |
| `n` / `N` | Next / prev match — auto-centers + unfolds |
| `<Esc>` | Clear search highlights |
| `f{char}` | Jump to next `char` on line |
| `F{char}` | Jump to prev `char` on line |
| `t{char}` | Jump before next `char` on line |
| `T{char}` | Jump before prev `char` on line |
| `;` / `,` | Repeat / reverse last `f/t` jump |
| `%` | Jump to matching bracket |
| `gg` / `G` | First / last line |
| `0` / `$` | Line start / end |
| `^` | First non-blank character |
| `w` / `b` / `e` | Word forward / back / end |
| `<C-d>` | Half page down — auto-centers |
| `<C-u>` | Half page up — auto-centers |
| `gi` | Re-enter insert at last insert position |
| `gv` | Re-select last visual selection |
| `.` | Repeat last change |
| `q{r}` / `@{r}` | Record / replay macro in register `r` |

---

## Saving & Quitting

| Key | Action |
|-----|--------|
| `<leader>w` | Save (`:update` — only if changed) |
| `<leader>q` | Quit window |
| `<leader>Q` | Quit all |
| `<leader>vs` | Source current file (useful in config) |
| `ZZ` | Save and quit (built-in) |
| `ZQ` | Quit without saving (built-in) |

---

## Insert Mode

| Key | Action |
|-----|--------|
| `jk` | Exit to Normal mode |
| `<C-r>{reg}` | Paste from register while in insert |
| `<C-w>` | Delete word before cursor |
| `<C-u>` | Delete to start of line |

---

## Windows & Splits

| Key | Action |
|-----|--------|
| `<leader>o` | Vertical split |
| `<leader>p` | Horizontal split |
| `<C-h/j/k/l>` | Navigate windows (works across tmux panes too) |
| `<C-Left/Right>` | Resize width |
| `<C-Up/Down>` | Resize height |
| `<leader>q` | Close current window |
| `<leader>Q` | Close all |

---

## File Navigation

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>fs` | Live grep (search file contents) |
| `<leader>fc` | Grep word under cursor |
| `<leader>fb` | Open buffers |
| `<leader>fh` | Help tags |
| `<leader>ft` | Find TODOs |
| `<leader>s` | Fuzzy search current buffer |
| `<leader><leader>` | Command palette (Snacks) |

---

## Harpoon (Quick File Marks)

| Key | Action |
|-----|--------|
| `<leader>a` | Add current file to harpoon list |
| `<leader>hm` | Toggle harpoon quick menu (edit/reorder marks) |
| `<leader>H` | Open harpoon list in Telescope |
| `<leader>1` | Jump to mark 1 |
| `<leader>2` | Jump to mark 2 |
| `<leader>3` | Jump to mark 3 |
| `<leader>4` | Jump to mark 4 |
| `[h` | Previous harpoon mark |
| `]h` | Next harpoon mark |

> In the quick menu (`<leader>hm`): edit lines to reorder, delete a line to remove a mark.

---

## Neo-tree (File Explorer)

| Key | Action |
|-----|--------|
| `\` | Reveal current file in tree |
| `<leader>ee` | Toggle tree |
| `<leader>ef` | Focus tree on current file |
| `<leader>ec` | Close tree |
| `\` (in tree) | Close tree window |
| `r` (in tree) | Rename |
| `R` (in tree) | Refresh |

---

## Editing

| Key | Mode | Action |
|-----|------|--------|
| `J` | Visual | Move selected lines down |
| `K` | Visual | Move selected lines up |
| `J` | Normal | Join lines — cursor stays in place |
| `<leader>P` | Visual | Paste without clobbering register (safe replace) |
| `<leader>D` | Normal/Visual | Delete to black hole (preserves clipboard) |
| `<leader>S` | Normal | Search & replace word under cursor (file-wide) |
| `<leader>X` | Normal | `chmod +x` current file |

### Substitute (gbprod/substitute.nvim)

| Key | Mode | Action |
|-----|------|--------|
| `s{motion}` | Normal | Substitute with motion (e.g. `siw` replaces word) |
| `ss` | Normal | Substitute entire line |
| `S` | Normal | Substitute to end of line |
| `s` | Visual | Substitute selection |

> Tip: yank something, then `siw` on another word to swap it.

### Surround (nvim-surround)

| Key | Action |
|-----|--------|
| `gzs{motion}{char}` | Add surround |
| `gzd{char}` | Delete surround |
| `gzr{old}{new}` | Replace surround |
| `gzS` (visual) | Surround selection |
| `l` | Custom: wrap as Markdown link `[text](url)` |
| `t` | Custom: wrap in HTML tag |

> Example: `gzsiwb` surrounds inner word with `()`. `gzrb"` replaces `()` with `""`.

### Text Objects (mini.ai — use with `d`, `c`, `y`, `v`, etc.)

| Object | Meaning |
|--------|---------|
| `a` | Argument / parameter |
| `m` | Function (method) |
| `c` | Class |
| `f` | Function call |
| `i` | Conditional |
| `l` | Loop |
| `=` | Assignment (whole) |
| `L` | Assignment left-hand side |
| `R` | Assignment right-hand side |
| `:` | Property |
| `H` | Property key |
| `T` | Property value |
| `b` | Brackets `()` |
| `B` | Braces `{}` |
| `q` | Quotes (any) |

> Use `i` (inner) or `a` (around). Example: `vim` = select inside function, `dam` = delete around function.

---

## LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>uh` | Toggle inlay hints |
| `<leader>oi` | Organize imports (Python only) |
| `<leader>of` | Fix all — ruff (Python only) |
| `<leader>mp` | Format file / selection |
| `<leader>l` | Trigger lint manually |

---

## Diagnostics & Trouble

| Key | Action |
|-----|--------|
| `<leader>xw` | Workspace diagnostics (Trouble) |
| `<leader>xd` | Document diagnostics (Trouble) |
| `<leader>xq` | Quickfix list (Trouble) |
| `<leader>xl` | Location list (Trouble) |
| `<leader>xt` | TODOs in Trouble |
| `<leader>xf` | Floating diagnostics preview |
| `<M-k>` | Next quickfix item + center |
| `<M-j>` | Prev quickfix item + center |
| `<leader>k` | Next location list item + center |
| `<leader>j` | Prev location list item + center |

---

## Git

| Key | Action |
|-----|--------|
| `<leader>lg` | Open LazyGit |
| `]c` / `[c` | Next / prev git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage entire buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hR` | Reset entire buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame current line |
| `<leader>hd` | Diff against index |
| `<leader>hD` | Diff against last commit |
| `<leader>tb` | Toggle inline blame |
| `<leader>tD` | Toggle show deleted lines |
| `ih` / `ah` | Text object: inside / around hunk |

---

## TODOs

| Key | Action |
|-----|--------|
| `]t` / `[t` | Next / prev TODO |
| `]x` / `[x` | Next / prev problem TODO (FIX/WARN/BUG only) |
| `<leader>tq` | Send all TODOs to quickfix |
| `<leader>ft` | Find TODOs in Telescope |

> Keywords: `TODO` `FIX` `FIXME` `BUG` `HACK` `WARN` `NOTE` `PERF` `TEST`

---

## Sessions

| Key | Action |
|-----|--------|
| `<leader>wr` | Restore session for current directory |
| `<leader>ws` | Save session for current directory |

---

## Completion (nvim-cmp)

| Key | Action |
|-----|--------|
| `<C-j>` | Next item |
| `<C-k>` | Prev item |
| `<C-Space>` | Trigger completion |
| `<C-b>` / `<C-f>` | Scroll docs up / down |
| `<CR>` | Confirm (only if explicitly selected) |
| `<C-e>` | Abort / close |
| `<Tab>` | Next item or expand/jump snippet |
| `<S-Tab>` | Prev item or jump back in snippet |

---

## Debugging (DAP)

| Key | Action |
|-----|--------|
| `<F5>` | Start / continue |
| `<F1>` | Step into |
| `<F2>` | Step over |
| `<F3>` | Step out |
| `<F7>` | Toggle DAP UI |
| `<leader>b` | Toggle breakpoint |
| `<leader>B` | Conditional breakpoint |

---

## Undo Tree

| Key | Action |
|-----|--------|
| `<leader>u` | Toggle undo tree |

> Navigate the tree with `j/k`, press `<CR>` to restore that state.

---

## Terminal

| Key | Action |
|-----|--------|
| `<F7>` | Toggle floating terminal (ToggleTerm) |
| `<Esc><Esc>` | Exit terminal mode back to Normal |

---

## Misc

| Key | Action |
|-----|--------|
| `<leader>mr` | Cellular automaton rain (fun) |

---

## Telescope — Inside Picker

| Key | Action |
|-----|--------|
| `<C-j>` / `<C-k>` | Move selection |
| `<C-p>` | Toggle preview |
| `<C-q>` | Send selected to quickfix |
| `<C-t>` | Open in Trouble |
| `<C-d>` (buffers) | Delete buffer |
| `dd` (buffers, normal) | Delete buffer |

---

## Quick Tips

**Replace a word across the file:**
Place cursor on word → `<leader>S` → modify replacement → `<Enter>`

**Paste without losing clipboard:**
Yank what you want → visual select target → `<leader>P`

**Swap two words:**
Yank first word (`yiw`) → cursor on second word → `siw` (substitute.nvim)

**Select to first char forward:**
`f{char}` to jump, or `t{char}` to stop before it. Use `v` first for visual.

**Search tip:**
`<leader>fs` for content search, `<leader>ff` for filename search.
Inside Telescope: `<C-p>` toggles preview if you need context.
