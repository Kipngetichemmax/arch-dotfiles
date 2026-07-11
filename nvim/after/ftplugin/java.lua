local jdtls = require("jdtls")

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

local home = vim.fn.expand("$HOME")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/.local/share/jdtls-workspaces/" .. project_name

local config = {
	cmd = {
		home .. "/.local/share/nvim/mason/bin/jdtls",
		"-data",
		workspace_dir,
	},
	root_dir = vim.fs.root(0, {
		".git",
		"mvnw",
		"gradlew",
		"pom.xml",
		"build.gradle",
		"build.gradle.kts",
	}),
	capabilities = capabilities,
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
		},
	},
	init_options = {
		bundles = {},
	},
}

jdtls.start_or_attach(config)
