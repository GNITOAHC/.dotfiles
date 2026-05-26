vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 0
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"

-- Leader
vim.api.nvim_set_keymap("", "<space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>v", ":vsp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>V", ":sp<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "(", "()<Left>", { noremap = true })
vim.api.nvim_set_keymap("i", "[", "[]<Left>", { noremap = true })
vim.api.nvim_set_keymap("i", "{", "{}<Left>", { noremap = true })
vim.api.nvim_set_keymap("i", '"', '""<Left>', { noremap = true })
vim.api.nvim_set_keymap("i", "'", "''<Left>", { noremap = true })

-- use <leader>y to copy the unnamed register to the system clipboard using OSC52
vim.keymap.set("n", "<leader>y", function()
	local reg = '"'
	local lines = vim.fn.getreg(reg, 1)
	if type(lines) == "string" then
		lines = { lines }
	end
	local regtype = vim.fn.getregtype(reg)

	if vim.tbl_isempty(lines) then
		vim.notify('Register " is empty', vim.log.levels.WARN)
		return
	end

	require("vim.ui.clipboard.osc52").copy("+")(lines, regtype)
	vim.notify('Copied register " to OSC52 clipboard')
end, {
	desc = "Copy unnamed register to OSC52",
})
