-- [[ Set global variable ]]

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- [[ Setting options ]] See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:help option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)

-- Print the line number in front of each line
vim.o.number = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Highlight the line where the cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 5

-- Show <tab> and trailing spaces
vim.o.list = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s) See `:help 'confirm'`
vim.o.confirm = true

-- Conform.nvim configuration
vim.opt.formatexpr = "v:lua.require('confrm').formatexpr()"

-- Disable automatically fold
vim.o.foldenable = false
vim.o.foldlevel = 99

-- [[ Set up keymaps ]] See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ "t", "i" }, "<A-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set({ "t", "i" }, "<A-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set({ "t", "i" }, "<A-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set({ "t", "i" }, "<A-l>", "<C-\\><C-n><C-w>l")
vim.keymap.set({ "n" }, "<A-h>", "<C-w>h")
vim.keymap.set({ "n" }, "<A-j>", "<C-w>j")
vim.keymap.set({ "n" }, "<A-k>", "<C-w>k")
vim.keymap.set({ "n" }, "<A-l>", "<C-w>l")

-- Map <A-up>, <A-down>, <A-left>, <A-right> to resize the window
vim.keymap.set({ "t", "i" }, "<A-Up>", "<Cmd>resize -1<CR>")
vim.keymap.set({ "t", "i" }, "<A-Down>", "<Cmd>resize +1<CR>")
vim.keymap.set({ "t", "i" }, "<A-Left>", "<Cmd>vertical resize -1<CR>")
vim.keymap.set({ "t", "i" }, "<A-Right>", "<Cmd>vertical resize +1<CR>")
vim.keymap.set({ "n" }, "<A-Up>", "<Cmd>resize -1<CR>")
vim.keymap.set({ "n" }, "<A-Down>", "<Cmd>resize +1<CR>")
vim.keymap.set({ "n" }, "<A-Left>", "<Cmd>vertical resize -1<CR>")
vim.keymap.set({ "n" }, "<A-Right>", "<Cmd>vertical resize +1<CR>")

-- Map <Esc> to nohlsearch command
vim.keymap.set({ "n" }, "<Esc>", "<Cmd>nohlsearch<CR>")

-- LSP keymaps
vim.keymap.set({ "n" }, "grd", vim.lsp.buf.definition, { desc = "Goto Definition" })

-- [[ Basic Autocommands ]].
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    vim.o.clipboard = "unnamedplus"
  end,
})

-- Set conform.nvim to automatically format before buffer is written
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnu = args.buf })
  end,
})

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Create user commands ]]
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Load lazy.nvim
require("config.lazy")
