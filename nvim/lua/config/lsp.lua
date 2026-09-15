-- ─── LSP ───────────────────────────────────────────────────────────────────

local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- ─── LSP Keymaps ────────────────────────────────────────────────────────────

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local map = function(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, {
				buffer = args.buf,
				desc = desc,
			})
		end

		map("gd", vim.lsp.buf.definition, "Go to Definition")
		map("gD", vim.lsp.buf.declaration, "Go to Declaration")
		map("gr", vim.lsp.buf.references, "References")
		map("gi", vim.lsp.buf.implementation, "Go to Implementation")
		map("K", vim.lsp.buf.hover, "Hover Documentation")

		map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
		map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

		map("<leader>lf", function()
			vim.lsp.buf.format({ async = true })
		end, "Format with LSP")
	end,
})

-- ─── Lua ────────────────────────────────────────────────────────────────────

vim.lsp.config("lua_ls", {
	capabilities = capabilities,

	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},

			workspace = {
				checkThirdParty = false,
			},

			telemetry = {
				enable = false,
			},
		},
	},
})

-- ─── Python ─────────────────────────────────────────────────────────────────

vim.lsp.config("pyright", {
	capabilities = capabilities,
})

-- ─── JavaScript / TypeScript ────────────────────────────────────────────────

vim.lsp.config("ts_ls", {
	capabilities = capabilities,

	init_options = {
		hostInfo = "neovim",
	},
})

-- ─── PHP ────────────────────────────────────────────────────────────────────

vim.lsp.config("intelephense", {
	capabilities = capabilities,

	settings = {
		intelephense = {
			files = {
				maxSize = 5000000,
			},

			diagnostics = {
				enable = true,
			},

			format = {
				enable = true,
			},
		},
	},
})

-- ─── HTML ───────────────────────────────────────────────────────────────────

vim.lsp.config("html", {
	capabilities = capabilities,

	filetypes = {
		"html",
	},
})

vim.lsp.config("emmet_language_server", {
	capabilities = capabilities,

	filetypes = {
		"html",
		"css",
		"scss",
		"less",
		"javascriptreact",
		"typescriptreact",
	},
})

-- ─── CSS ────────────────────────────────────────────────────────────────────

vim.lsp.config("cssls", {
	capabilities = capabilities,

	filetypes = {
		"css",
		"scss",
		"less",
	},
})

-- ─── JSON ───────────────────────────────────────────────────────────────────

vim.lsp.config("jsonls", {
	capabilities = capabilities,

	filetypes = {
		"json",
		"jsonc",
	},
})

-- ─── Bash ───────────────────────────────────────────────────────────────────

vim.lsp.config("bashls", {
	capabilities = capabilities,
})

-- ─── Enable LSP Servers ─────────────────────────────────────────────────────

vim.lsp.enable({
	"lua_ls",
	"pyright",
	"ts_ls",
	"intelephense",
	"html",
	"emmet_language_server",
	"cssls",
	"jsonls",
	"bashls",
})
