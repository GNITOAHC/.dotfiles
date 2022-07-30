local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
    return
end

luasnip.filetype_extend("javascript", { "javascriptreact" })
luasnip.filetype_extend("javascript", { "html" })
luasnip.filetype_extend("html", { "html" })
