local status_ok, indentline = pcall(require, "indent_blankline")
if not status_ok then
    return
end

indentline.setup {
    show_current_context = true,
    show_current_context_start = true,
}

-- vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")

-- defualt
-- require("indent_blankline").setup {
--     -- for example, context is off by default, use this to turn it on
--     show_current_context = true,
--     show_current_context_start = true,
-- }
