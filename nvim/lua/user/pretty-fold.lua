local status_ok, pretty_fold = pcall(require, "pretty-fold")
if not status_ok then
    return
end

vim.o.foldcolumn = '1'
vim.opt.fillchars:append('fold:•')

pretty_fold.setup {
    remove_fold_markers = false
}
