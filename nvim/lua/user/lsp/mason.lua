local mason_ok, mason = pcall(require, "mason")
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")

if not mason_ok or not mason_lspconfig_ok or not lspconfig_ok then
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
local server = require("user.lsp.sever_settings")

mason_lspconfig.setup({
	ensure_installed = {
		"lua_ls",
		--[[ "clangd", ]]
		--[[ "cssls", -- Conflicts with tailwindcss ]]
		"marksman",
		-- "pyright",
		"ts_ls", -- 0d072b5 fix: rename tsserver to ts_ls
		--[[ "omnisharp_mono", -- For UnityEngine ]]
	},
})

--[[ Default handlers settings ]]
mason_lspconfig.setup_handlers({
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup(opts)
	end,
})

--[[ Custom handlers settings ]]
lspconfig.lua_ls.setup(server.get_luals_opts())
lspconfig.clangd.setup(server.get_clangd_opts())
lspconfig.ts_ls.setup(server.get_ts_ls_opts())
lspconfig.denols.setup(server.get_luals_opts())

--[[ mason_lspconfig.setup_handlers({ ]]
--[[ 	function(server_name) -- default handler (optional) ]]
--[[ 		require("lspconfig")[server_name].setup(opts) ]]
--[[ 	end, ]]
--[[ 	["clangd"] = function() ]]
--[[ 		lspconfig.clangd.setup(server.get_clangd_opts()) ]]
--[[ 	end, ]]
--[[ 	["lua_ls"] = function() ]]
--[[ 		lspconfig.lua_ls.setup(server.get_luals_opts()) ]]
--[[ 	end, ]]
--[[ }) ]]

--[[ Keymaps ]]
--[[ toggle_package_expand = "<CR>", ]]
--[[ install_package = "i", ]]
--[[ update_package = "u", ]]
--[[ check_package_version = "c", ]]
--[[ update_all_packages = "U", ]]
--[[ check_outdated_packages = "C", ]]
--[[ uninstall_package = "X", ]]
--[[ cancel_installation = "<C-c>", ]]
