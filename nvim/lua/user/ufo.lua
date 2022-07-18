local status_ok, ufo = pcall(require, "ufo")
if not status_ok then
    return
end
local nvim_lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

vim.o.foldcolumn = '1'

local language_servers = {'clangd', 'sumneko_lua', 'pyright', 'tsserver', 'cssls' } -- like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
    nvim_lsp[ls].setup({
        capabilities = capabilities,
        flags = {debounce_text_changes = 150},
        -- other_fields = ...
    })
end
require('ufo').setup()

vim.keymap.set('n', '<tab>', function()
    local winid = require('ufo').peekFoldedLinesUnderCursor()
    if not winid then
        -- choose one of them
        -- coc.nvim
        -- vim.fn.CocActionAsync('definitionHover')
        -- nvimlsp
        vim.lsp.buf.hover()
    end
end)

vim.keymap.set('n', '<C-n>', function()
    local nextclose = require('ufo').goNextClosedFold()
    if not nextclose then
        return
    end
end)

vim.keymap.set('n', '<C-p>', function()
    local previousclose = require('ufo').goPreviousClosedFold()
    if not previousclose then
        return
    end
end)
