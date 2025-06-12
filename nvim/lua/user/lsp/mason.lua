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

-- Manual setup
vim.lsp.enable("clangd")
vim.lsp.config("clangd", server.get_clangd_opts())

vim.lsp.config("lua_ls", server.get_luals_opts())
vim.lsp.config("ts_ls", server.get_ts_ls_opts())
vim.lsp.config("denols", server.get_denols_opts())
