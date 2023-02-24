local status_ok, mason_lspconf = pcall(require, "mason-lspconfig")
if not status_ok then
    return
end

local lsp_ok, lspconfig = pcall(require, "lspconfig")
if not lsp_ok then
    return
end

mason_lspconf.setup({
    ensure_installed = {
        "lua_ls", "clangd", "cssls", "marksman", "pyright", "tsserver", -- LSP
        --[[ "omnisharp_mono", -- For UnityEngine ]]
    }
})

local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
}

local server = require("user.lsp.sever_settings")

mason_lspconf.setup_handlers {
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
}
