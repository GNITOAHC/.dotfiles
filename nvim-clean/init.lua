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
