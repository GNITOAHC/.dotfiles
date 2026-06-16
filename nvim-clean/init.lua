vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 0
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"

vim.cmd("filetype plugin indent on")
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Leader
vim.api.nvim_set_keymap("", "<space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>v", ":vsp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>V", ":sp<CR>", { noremap = true, silent = true })

-- use <leader>y to copy the unnamed register to the system clipboard using OSC52
vim.keymap.set("n", "<leader>y", function()
	local reg = '"'
	local raw = vim.fn.getreg(reg, 1)
	local lines = type(raw) == "string" and { raw } or raw --[[@as string[] ]]

	if vim.tbl_isempty(lines) then
		vim.notify('Register " is empty', vim.log.levels.WARN)
		return
	end

	require("vim.ui.clipboard.osc52").copy("+")(lines)
	vim.notify('Copied register " to OSC52 clipboard')
end, {
	desc = "Copy unnamed register to OSC52",
})

-- autocmd to set 2 spaces for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
    -- stylua: ignore
	pattern = {
		"typescript", "typescriptreact",
        "javascript", "javascriptreact",
		"css", "html", "scss", "json",
		"markdown", "sh",
	},
	command = "setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab",
	group = vim.api.nvim_create_augroup("Tab2Autocmd", {}),
})

-- Don't wrap text in CSV files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "csv",
	command = "setlocal nowrap",
})

vim.cmd([[
    autocmd RecordingEnter * echo("Recording macro...")
    autocmd RecordingLeave * echo("Macro recorded!")
]])

-- Auto pairs
local function close_or_jump(char)
	return function()
		local col = vim.fn.col(".")
		local line = vim.fn.getline(".")

		if line:sub(col, col) == char then
			return "<Right>"
		end

		return char
	end
end

local function quote_or_jump(char)
	return function()
		local col = vim.fn.col(".")
		local line = vim.fn.getline(".")
		local next_char = line:sub(col, col)

		if next_char == char then
			return "<Right>"
		end

		return char .. char .. "<Left>"
	end
end

vim.keymap.set("i", "(", "()<Left>", { noremap = true })
vim.keymap.set("i", "[", "[]<Left>", { noremap = true })
vim.keymap.set("i", "{", "{}<Left>", { noremap = true })

vim.keymap.set("i", ")", close_or_jump(")"), { expr = true, noremap = true })
vim.keymap.set("i", "]", close_or_jump("]"), { expr = true, noremap = true })
vim.keymap.set("i", "}", close_or_jump("}"), { expr = true, noremap = true })

vim.keymap.set("i", '"', quote_or_jump('"'), { expr = true, noremap = true })
vim.keymap.set("i", "'", quote_or_jump("'"), { expr = true, noremap = true })

-- Autopairs indentation
local pair_map = {
	["{"] = "}",
	["["] = "]",
	["("] = ")",
}

local function smart_enter()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local line = vim.api.nvim_get_current_line()

	local prev_char = line:sub(col, col)
	local next_char = line:sub(col + 1, col + 1)

	if pair_map[prev_char] == next_char then
		return "<CR><Esc>O"
	end

	return "<CR>"
end
vim.keymap.set("i", "<CR>", smart_enter, { expr = true, noremap = true })
