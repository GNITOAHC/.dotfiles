local mason_ok, mason = pcall(require, "mason")
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")
local null_ls_ok, null_ls = pcall(require, "null-ls")

if not mason_ok or not mason_null_ls_ok or not mason_lspconfig_ok or not lspconfig_ok or not null_ls_ok then
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
		"clangd",
		--[[ "cssls", -- Conflicts with tailwindcss ]]
		"marksman",
		"pyright",
		"tsserver", -- LSP
		--[[ "omnisharp_mono", -- For UnityEngine ]]
	},
})

mason_lspconfig.setup_handlers({
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup(opts)
		--[[ server_name:setup(opts) ]]
	end,
	["clangd"] = function()
		lspconfig.clangd.setup(server.get_clangd_opts())
	end,
	["lua_ls"] = function()
		lspconfig.lua_ls.setup(server.get_luals_opts())
	end,
})

--[[ Mason Null LS ]]

mason_null_ls.setup({
	ensure_installed = {
		"prettier",
		"black",
		"stylua",
		"rustfmt",
		"clang_format",
	},
})

local util_status_ok, util = pcall(require, "vim.lsp.util")
if not util_status_ok then
	return
end

local formatting = null_ls.builtins.formatting
local formatting_callback = function(client, bufnr)
	vim.keymap.set("n", "<leader>m", function()
		local params = util.make_formatting_params({})
		client.request("textDocument/formatting", params, nil, bufnr) -- lsp-method
	end, { buffer = bufnr })
end

null_ls.setup({
	sources = {
		formatting.prettier.with({
			-- Always use the mason prettier (Instead of the project one)
			command = vim.fn.stdpath("data") .. "/mason/bin/prettier",
			extra_args = { vim.fn.expand("--config $HOME/.prettierrc") },
		}),
		formatting.black.with({ extra_args = { "--fast" } }),
		formatting.stylua,
		formatting.rustfmt.with({ extra_args = { "--edition=2021" } }),
		formatting.clang_format.with({
			extra_args = {
				vim.fn.expand("--style=file:$HOME/.dotfiles/format/.clang_format"),
			},
		}),
	},
	on_attach = function(client, bufnr)
		--[[ Set to utf-16 to prevent multiple client offset_encodings ]]
		--[[ local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype") ]]
		--[[ if filetype == 'css' then ]]
		--[[     client.offset_encoding = 'utf-16' ]]
		--[[ end ]]
		--[[ if filetype == 'javascriptreact' then ]]
		--[[     client.offset_encoding = 'utf-16' ]]
		--[[ end ]]
		--[[ if filetype == 'python' then ]]
		--[[     client.offset_encoding = 'utf-16' ]]
		--[[ end ]]
		formatting_callback(client, bufnr)
	end,
})

--[[ Keymaps ]]
--[[ toggle_package_expand = "<CR>", ]]
--[[ install_package = "i", ]]
--[[ update_package = "u", ]]
--[[ check_package_version = "c", ]]
--[[ update_all_packages = "U", ]]
--[[ check_outdated_packages = "C", ]]
--[[ uninstall_package = "X", ]]
--[[ cancel_installation = "<C-c>", ]]
