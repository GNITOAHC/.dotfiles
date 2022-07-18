local status_ok, pretty_fold = pcall(require, "pretty-fold")
if not status_ok then
    return
end

pretty_fold.setup {
    fill_char = '━',
    remove_fold_markers = false,
    keep_indentation = true,
    add_close_patters = true,
    sections = {
        left = {
            '━ ', function() return string.rep('*', vim.v.foldlevel) end, ' ━┫', 'content', '┣'
        },
        right = {
            '┫ ', 'number_of_folded_lines', ': ', 'percentage', ' ┣━━'
        }
    },
}
