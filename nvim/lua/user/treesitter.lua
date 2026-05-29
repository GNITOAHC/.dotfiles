require("nvim-treesitter").install({ "c", "cpp", "lua", "python", "typescript", "javascript", "markdown", "scss" })

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("AutoStartTreesitter", { clear = true }),
	callback = function(args)
		local bufnr = args.buf
		local ft = vim.bo[bufnr].filetype
		local lang = vim.treesitter.language.get_lang(ft)

		if not lang then
			return
		end

		local ok = pcall(vim.treesitter.language.add, lang)
		if ok then
			pcall(vim.treesitter.start, bufnr, lang)
		end
	end,
})
