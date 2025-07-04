local api = vim.api
local jsGrp = api.nvim_create_augroup("JavascriptAutocmd", {})

-- Javascript autocmd
api.nvim_create_autocmd("FileType", {
	pattern = {
		"typescript",
		"typescriptreact",
		"javascript",
		"javascriptreact",
		"css",
		"html",
		"scss",
		"json",
		"markdown",
	},
	command = "setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab",
	group = jsGrp,
})

vim.cmd([[
    autocmd RecordingEnter * echo("Recording macro...")
    autocmd RecordingLeave * echo("Macro recorded!")
]])
