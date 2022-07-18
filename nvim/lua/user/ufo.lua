local status_ok, ufo = pcall(require, "ufo")
if not status_ok then
    return
end

vim.o.foldcolumn = '1'

-- ufo.setup {
--     preview = {
--         win_config = {
--             border = 'rounded',
--             winblend = 1,
--             -- winhighlight = 'Normal:Normal',
--         },
--         mappings = {
--             close = '<tab>',
--             switch = '<CR>',
--             trace = '',
--         }
--     },
--     provider_selector = function(bufnr, filetype)
--         return {'treesitter', 'indent'}
--     end,
-- }
local language_servers = {'clangd', 'sumneko_lua', 'pyright', 'tsserver', 'cssls' } -- like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
    require('lspconfig')[ls].setup({
        -- capabilities = capabilities,
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

local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = ('  %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
end

-- global handler
-- require('ufo').setup({
--     fold_virt_text_handler = handler
-- })

-- buffer scope handler
-- will override global handler if it is existed
local bufnr = vim.api.nvim_get_current_buf()
require('ufo').setFoldVirtTextHandler(bufnr, handler)
