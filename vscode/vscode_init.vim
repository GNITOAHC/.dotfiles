" stored at ~/.dotfiles/vscode/vscode_init.vim

" insert mode should be maintained in vscode. 
function! _vscode_config()
    e.g.
    "vscode-neovim.compositeKeys": {
        "jj": {
            "command": "vscode-neovim.lua",
            "args": [
                "vim.api.nvim_input('<ESC>')"
            ]
        },
    }
endfunction 

" Setting map leader. 
let mapleader = ' '
nnoremap <leader>nh <cmd>noh<cr>
nnoremap <leader>w <cmd>w<cr>

" set relative numbers at the left in your vim editor but actual number on current line.
set relativenumber number
set clipboard=unnamedplus " Allow vscode-neovim to access the system clipboard. 

" Highlight target in visual mode and surround it by <leader> and front bracket. 
vnoremap \( <esc>`<i(<esc>`>la)
vnoremap \[ <esc>`<i[<esc>`>la]
vnoremap \{ <esc>`<i{<esc>`>la}
vnoremap \" <esc>`<i"<esc>`>la"
vnoremap \' <esc>`<i'<esc>`>la'
vnoremap \` <esc>`<i`<esc>`>la`

" Mapping <C-/> to Comment in vscode. 
xnoremap <C-/> <Plug>VSCodeCommentarygv
nnoremap <C-/> <Plug>VSCodeCommentaryLinegv

lua << EOF
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
keymap("n", "-", "<Esc>:m .-2<CR>==", opts) -- Up
keymap("n", "_", "<Esc>:m .+1<CR>==", opts) -- Down

-- source: https://github.com/vscode-neovim/vscode-neovim/issues/58#issuecomment-2569772615
if vim.g.vscode then
   -- Remap folding keys
   vim.api.nvim_set_keymap('n', 'zM', '<Cmd>call VSCodeNotify("editor.foldAll")<CR>', { noremap = true, silent = true })
   vim.api.nvim_set_keymap('n', 'zR', '<Cmd>call VSCodeNotify("editor.unfoldAll")<CR>', { noremap = true, silent = true })
   vim.api.nvim_set_keymap('n', 'zc', '<Cmd>call VSCodeNotify("editor.fold")<CR>', { noremap = true, silent = true })
   vim.api.nvim_set_keymap('n', 'zC', '<Cmd>call VSCodeNotify("editor.foldRecursively")<CR>', { noremap = true, silent = true })
   vim.api.nvim_set_keymap('n', 'zo', '<Cmd>call VSCodeNotify("editor.unfold")<CR>', { noremap = true, silent = true })
   vim.api.nvim_set_keymap('n', 'zO', '<Cmd>call VSCodeNotify("editor.unfoldRecursively")<CR>', { noremap = true, silent = true })
   vim.api.nvim_set_keymap('n', 'za', '<Cmd>call VSCodeNotify("editor.toggleFold")<CR>', { noremap = true, silent = true })
end

EOF
