-- =============================================================================
-- init.lua — Neovim 0.12+ config for Arch Linux
-- LSP servers needed:
--   sudo pacman -S lua-language-server bash-language-server
--   npm install -g pyright typescript typescript-language-server
-- =============================================================================

-- ─── OPTIONS ─────────────────────────────────────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.splitright = true
opt.splitbelow = true
opt.clipboard = "unnamedplus"
opt.scrolloff = 8
opt.cursorline = true
opt.undofile = true

-- ─── BOOTSTRAP LAZY.NVIM ─────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ─── PLUGINS ─────────────────────────────────────────────────────────────────
require("lazy").setup({

	-- ── Colorscheme ────────────────────────────────────────────────────────────
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = { style = "night" },
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},

	-- ── Icons ──────────────────────────────────────────────────────────────────
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- ── Treesitter ─────────────────────────────────────────────────────────────
	-- Neovim 0.12 has treesitter highlighting built-in.
	-- This plugin is only needed to download/compile parsers.
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false, -- load eagerly so parsers are available on first open
		config = function()
			-- nvim-treesitter.configs still exists in the plugin for parser management
			-- but the highlight module is no longer needed — Neovim handles it natively.
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if ok then
				configs.setup({
					ensure_installed = {
						"lua",
						"python",
						"javascript",
						"typescript",
						"tsx",
						"json",
						"markdown",
						"bash",
						"vim",
						"vimdoc",
					},
					auto_install = true,
					highlight = { enable = false }, -- let Neovim 0.12 handle this
					indent = { enable = false },
				})
			end
		end,
	},

	-- ── Telescope ──────────────────────────────────────────────────────────────
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
		},
		opts = {
			defaults = {
				layout_strategy = "horizontal",
				sorting_strategy = "ascending",
				layout_config = { prompt_position = "top" },
			},
		},
	},

	-- ── Which-key ──────────────────────────────────────────────────────────────
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- ── Neo-tree ───────────────────────────────────────────────────────────────
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
			{ "<leader>o", "<cmd>Neotree focus<cr>", desc = "Focus Explorer" },
		},
		opts = {
			close_if_last_window = true,
			window = { width = 30 },
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = true,
				},
				follow_current_file = { enabled = true },
			},
		},
	},

	-- ── Gitsigns ───────────────────────────────────────────────────────────────
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local map = function(l, r, desc)
					vim.keymap.set("n", l, r, { buffer = bufnr, desc = desc })
				end
				map("]c", gs.next_hunk, "Next hunk")
				map("[c", gs.prev_hunk, "Prev hunk")
				map("<leader>gp", gs.preview_hunk, "Preview hunk")
				map("<leader>gb", gs.blame_line, "Blame line")
			end,
		},
	},

	-- ── Conform (formatting) ───────────────────────────────────────────────────
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				sh = { "shfmt" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},

	-- ── nvim-tmux-navigator ────────────────────────────────────────────────
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},

	-- ── nvim-cmp (autocomplete) ────────────────────────────────────────────────
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			{
				"L3MON4D3/LuaSnip",
				build = "make install_jsregexp",
				dependencies = { "saadparwaiz1/cmp_luasnip" },
			},
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},

	-- ── nvim-lspconfig (provides server definitions only) ─────────────────────
	-- In 0.12, this plugin just supplies the lsp/*.lua config files.
	-- We call vim.lsp.config() + vim.lsp.enable() ourselves — no lspconfig.setup()
	{ "neovim/nvim-lspconfig", dependencies = { "hrsh7th/cmp-nvim-lsp" } },
}, {
	ui = { border = "rounded" },
	checker = { enabled = false },
	change_detection = { enabled = false },
})

-- ─── LSP SETUP (Neovim 0.12 native API) ──────────────────────────────────────
-- Must run AFTER lazy so nvim-lspconfig's lsp/*.lua files are on runtimepath,
-- and AFTER cmp-nvim-lsp is loaded so capabilities are available.

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Merge nvim-cmp LSP capabilities if the plugin loaded
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- Keymaps attached when any LSP connects to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
	callback = function(args)
		local bufnr = args.buf
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end
		map("gd", vim.lsp.buf.definition, "Go to Definition")
		map("gD", vim.lsp.buf.declaration, "Go to Declaration")
		map("gr", vim.lsp.buf.references, "References")
		map("gi", vim.lsp.buf.implementation, "Go to Implementation")
		map("K", vim.lsp.buf.hover, "Hover Docs")
		map("<leader>rn", vim.lsp.buf.rename, "Rename")
		map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
		map("<leader>ds", vim.diagnostic.open_float, "Diagnostic Float")
		map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
		map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
	end,
})

-- Server configs — vim.lsp.config() extends the definitions provided by
-- nvim-lspconfig's lsp/*.lua files (cmd, filetypes, root_markers are already
-- set there; we only need to add our capabilities + per-server settings).

vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file("", true),
			},
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
		},
	},
})

vim.lsp.config("pyright", {
	capabilities = capabilities,
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "basic",
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
			},
		},
	},
})

vim.lsp.config("ts_ls", {
	capabilities = capabilities,
	-- Ensure it finds projects without a lockfile present
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
})

vim.lsp.config("bashls", {
	capabilities = capabilities,
})

-- Enable all four servers
vim.lsp.enable({ "lua_ls", "pyright", "ts_ls", "bashls" })

-- ─── DIAGNOSTICS UI ──────────────────────────────────────────────────────────
vim.diagnostic.config({
	virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
	},
})

-- ─── KEYMAPS ─────────────────────────────────────────────────────────────────
local map = vim.keymap.set

map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Left" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Up" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Right" })
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Clear highlights" })
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
map("n", "<C-s>", ":w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc>:w<CR>", { desc = "Save file" })
