local api = vim.api
local jsGrp = api.nvim_create_augroup("JavascriptAutocmd", {})

-- Javascript autocmd
api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "css", "html" },
    command = "setlocal shiftwidth=2 softtabstop=2 expandtab",
    group = jsGrp,
})
