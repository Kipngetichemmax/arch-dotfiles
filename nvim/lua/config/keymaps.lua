-- ─── KEYMAPS ───────────────────────────────────────────────────────────────

vim.g.mapleader = " "

local map = vim.keymap.set

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

-- Buffers
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Search
map("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Indentation
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Save
map("n", "<C-s>", ":w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc>:w<CR>", { desc = "Save file" })
