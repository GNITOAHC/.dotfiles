local mason_ok, mason = pcall(require, "mason")
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")

if not mason_ok or not mason_lspconfig_ok then
	vim.notify("Mason: Failed to load dependencies", vim.log.levels.ERROR)
	return
end

-- [[ Mason ]]

mason.setup()

-- [[ Mason LSP ]]

local opts = {
	on_attach = require("user.lsp.handlers").on_attach,
	capabilities = require("user.lsp.handlers").capabilities,
}
local server = require("user.lsp.server_settings")

mason_lspconfig.setup({
	ensure_installed = {
		"lua_ls",
		"marksman",
		-- "ts_ls", -- 0d072b5 fix: rename tsserver to ts_ls
	},
})

for _, s in pairs(mason_lspconfig.get_installed_servers()) do
	vim.lsp.config(s, opts)
end

-- For vim diagnostics, see `get_luals_opts`
vim.lsp.config("lua_ls", server.get_luals_opts())

-- Manual setup
vim.lsp.enable("clangd")
vim.lsp.config("clangd", server.get_clangd_opts())

-- For sourcekit (Xcode)
-- https://github.com/SolaWing/xcode-build-server
-- https://wojciechkulik.pl/ios/the-complete-guide-to-ios-macos-development-in-neovim
vim.lsp.config.sourcekit = {
	cmd = { "xcrun", "sourcekit-lsp" },
	workspace = {
		didChangeWatchedFiles = {
			dynamicRegistration = true,
		},
	},

	on_attach = require("user.lsp.handlers").on_attach,
	capabilities = require("user.lsp.handlers").capabilities,
}
vim.lsp.enable("sourcekit")

-- denols and ts_ls setup
-- https://github.com/neovim/neovim/issues/32037
-- https://github.com/neovim/neovim/issues/32037#issuecomment-2774451000

vim.lsp.config.denols = {
	cmd = { "deno", "lsp" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_dir = function(_, callback)
		local root_dir = vim.fs.root(0, { "deno.json", "deno.jsonc" })

		if root_dir then
			callback(root_dir)
		end
	end,
	-- Extend opts to this table
	on_attach = require("user.lsp.handlers").on_attach,
	capabilities = require("user.lsp.handlers").capabilities,
}

vim.lsp.enable("denols")

vim.lsp.config.ts_ls = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_dir = function(_, callback)
		local deno_dir = vim.fs.root(0, { "deno.json", "deno.jsonc" })
		local root_dir = vim.fs.root(0, { "tsconfig.json", "jsconfig.json", "package.json" })

		if root_dir and deno_dir == nil then
			callback(root_dir)
		end
	end,
	on_attach = require("user.lsp.handlers").on_attach,
	capabilities = require("user.lsp.handlers").capabilities,
}

vim.lsp.enable("ts_ls")
