-- ─── LSP ───────────────────────────────────────────────────────────────────

local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

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
	end,
})

-- Lua
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

-- Python
vim.lsp.config("pyright", {
	capabilities = capabilities,
})

-- TypeScript / JavaScript
vim.lsp.config("ts_ls", {
	capabilities = capabilities,

	init_options = {
		hostInfo = "neovim",
		tsserver = {
			path = vim.fn.getcwd() .. "/node_modules/typescript/lib",
		},
	},
})

-- Bash
vim.lsp.config("bashls", {
	capabilities = capabilities,
})

vim.lsp.enable({
	"lua_ls",
	"pyright",
	"ts_ls",
	"bashls",
})
