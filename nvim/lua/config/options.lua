-- ─── OPTIONS ───────────────────────────────────────────────────────────────

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Mouse
opt.mouse = "a"

-- Clipboard
opt.clipboard = "unnamedplus"

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Update time
opt.updatetime = 250

-- Undo
opt.undofile = true
