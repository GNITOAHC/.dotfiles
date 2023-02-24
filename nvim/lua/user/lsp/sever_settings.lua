local M = {}

local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
}

M.get_clangd_opts = function ()
    local local_opts = {
        cmd = { "clangd", "--offset-encoding=utf-16", "--fallback-style=file:~/.clang_format" }
    }
    local opt = vim.tbl_deep_extend("force", local_opts, opts)
    return opt
end

M.get_luals_opts = function ()
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

return M
