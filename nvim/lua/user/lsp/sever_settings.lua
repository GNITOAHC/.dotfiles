local M = {}

local opts = {
	on_attach = require("user.lsp.handlers").on_attach,
	capabilities = require("user.lsp.handlers").capabilities,
}

M.get_clangd_opts = function()
	local local_opts = {
		cmd = { "clangd", "--offset-encoding=utf-16", "--fallback-style=file:~/.clang_format" },
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	}
	local opt = vim.tbl_deep_extend("force", local_opts, opts)
	return opt
end

M.get_luals_opts = function()
	local local_opts = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
				},
			},
		},
	}
	local opt = vim.tbl_deep_extend("force", local_opts, opts)
	return opt
end

M.get_ts_ls_opts = function()
	local local_opts = {
		root_dir = require("lspconfig").util.root_pattern("package.json"),
		single_file_support = false,
	}
	local opt = vim.tbl_deep_extend("force", local_opts, opts)
	return opt
end

M.get_denols_opts = function()
	local local_opts = {
		root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
	}
    local opt = vim.tbl_deep_extend("force", local_opts, opts)
    return opt
end

return M
