require("lazy").setup({

	-- ── Colorscheme ────────────────────────────────────────────────────────────
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				integrations = {
					nvimtree = true,
					treesitter = true,
					telescope = true,
					gitsigns = true,
				},
			})

			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
	-- ── Icons ──────────────────────────────────────────────────────────────────
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- ── Auto pairs ───────────────────────────────────────────────────────────
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	-- ── Treesitter ─────────────────────────────────────────────────────────────
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if ok then
				configs.setup({
					ensure_installed = {
						"lua",
						"python",
						"javascript",
						"typescript",
						"tsx",

						-- Web Systems II
						"html",
						"css",
						"php",
						"sql",
						"json",

						"markdown",
						"bash",
						"vim",
						"vimdoc",
					},
					auto_install = true,
					highlight = { enable = true },
					indent = { enable = true },
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
			{ "<leader>fa", "<cmd>Telescope find_files cwd=~<cr>", desc = "Find All Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
		},
		opts = {
			defaults = {
				layout_strategy = "horizontal",
				sorting_strategy = "ascending",
				layout_config = {
					prompt_position = "top",
				},
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
			window = {
				width = 30,
			},
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = true,
				},
				follow_current_file = {
					enabled = true,
				},
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

				local map = function(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, {
						buffer = bufnr,
						desc = desc,
					})
				end

				map("]c", gs.next_hunk, "Next hunk")
				map("[c", gs.prev_hunk, "Previous hunk")
				map("<leader>gp", gs.preview_hunk, "Preview hunk")
				map("<leader>gb", gs.blame_line, "Blame line")
			end,
		},
	},

	-- ── Conform (Formatting) ───────────────────────────────────────────────────
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({
						async = true,
						lsp_fallback = true,
					})
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
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },

				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },

				php = { "php_cs_fixer" },

				json = { "prettier" },
				jsonc = { "prettier" },

				sh = { "shfmt" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},

	-- ── Mason ─────────────────────────────────────────────────────────────────
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},

	-- ── vim-tmux-navigator ────────────────────────────────────────────────────
	{
		"christoomey/vim-tmux-navigator",
	},

	-- ── nvim-cmp (Autocomplete) ───────────────────────────────────────────────
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
				dependencies = {
					"saadparwaiz1/cmp_luasnip",
				},
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

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							local clients = vim.lsp.get_clients({
								bufnr = 0,
								name = "emmet_language_server",
							})

							if #clients > 0 then
								local line = vim.api.nvim_get_current_line()
								local col = vim.api.nvim_win_get_cursor(0)[2]
								local before_cursor = line:sub(1, col)

								if before_cursor:match("[%w%.#>%-]+$") then
									vim.lsp.buf.completion()
									return
								end
							end

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

	-- ── Java ──────────────────────────────────────────────────────────────────

	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
	},

	-- ── LSP Definitions ───────────────────────────────────────────────────────
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
	},
	-- ── Copilot (inline autocomplete) ────────────────────────────────────────
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<C-y>", -- clear of cmp's <Tab> and your <C-l> window nav
					next = "<C-]>",
					prev = "<C-[>",
					dismiss = "<C-x>",
				},
			},
			panel = { enabled = false },
		},
	},

	-- ── Avante (AI chat sidebar, Claude-backed) ──────────────────────────────
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		build = "make",
		opts = {
			provider = "claude",
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-sonnet-4-6",
				temperature = 0,
				max_tokens = 4096,
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>ac", "<cmd>AvanteToggle<cr>", desc = "AI Chat Sidebar" },
		},
	},

	-- ── Toggleterm (for Claude Code agent) ───────────────────────────────────
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = "ToggleTerm",
		keys = {
			{ "<C-\\>", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle Terminal (Claude Code)" },
		},
		opts = {
			open_mapping = [[<c-\>]],
			direction = "float",
		},
	},
}, {
	ui = {
		border = "rounded",
	},
	checker = {
		enabled = false,
	},
	change_detection = {
		enabled = false,
	},
})
