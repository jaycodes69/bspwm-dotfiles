-- Set leader keys early (global + local)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Helper function for mapping
local map = vim.keymap.set

-- =========================
-- File operations
-- =========================

-- Save file (force if read-only)
map("n", "<leader>w", "<cmd>write!<CR>", {
	desc = "Save current file (force if readonly)",
	noremap = true,
	silent = true,
})

-- update Lazy
map("n", "<leader>u", "<cmd>Lazy update<CR>", {
	desc = "Update lazy",
	noremap = true,
	silent = true,
})

-- Quit file without saving
map("n", "<leader>q", "<cmd>quit!<CR>", {
	desc = "Quit current window without saving",
	noremap = true,
	silent = true,
})

-- Save & source current file (great for config tweaking)
map("n", "<leader>o", "<cmd>update! | source %<CR>", {
	desc = "Save & source current file",
	noremap = true,
	silent = true,
})

-- =========================
-- Clipboard operations
-- =========================

-- Yank to system clipboard (works like normal y but sends to + register)
map({ "n", "v" }, "<leader>y", '"+y', {
	desc = "Yank to system clipboard",
	noremap = true,
	silent = true,
})

-- Paste from system clipboard
map({ "n", "v" }, "<leader>p", '"+p', {
	desc = "Paste from system clipboard",
	noremap = true,
	silent = true,
})

-- Paste over selection without overwriting unnamed register
map("x", "<leader>P", '"_dP', {
	desc = "Paste over selection without replacing last yank",
	noremap = true,
	silent = true,
})

-- =========================
-- Quality of life tweaks
-- =========================

-- Save file with Ctrl+S (works in normal, insert, and visual modes)
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<CR>", {
	desc = "Save file",
	noremap = true,
	silent = true,
})

-- Clear search highlights with <Esc>
map("n", "<Esc>", "<cmd>nohlsearch<CR>", {
	desc = "Clear search highlights",
	noremap = true,
	silent = true,
})

map("n", "<leader>cp", ":read ~/personal/code/cp/templates/cp.cpp", {
	desc = "Add template",
	noremap = true,
	silent = true,
})

map("n", "<leader>fm", ":lua vim.lsp.buf.format()<CR>", {
	desc = "format using lsp",
	noremap = true,
	silent = true,
})

-- Move lines up/down with Alt+j/k in visual mode
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", noremap = true, silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", noremap = true, silent = true })

-- Window navigation (like tmux)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize splits
map("n", "<A-Up>", ":resize -2<CR>", opts)
map("n", "<A-Down>", ":resize +2<CR>", opts)
map("n", "<A-Left>", ":vertical resize -2<CR>", opts)
map("n", "<A-Right>", ":vertical resize +2<CR>", opts)
