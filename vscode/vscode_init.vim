" stored at ~/.config/nvim

" Setting map leader. 
let mapleader = ' '
nnoremap <leader>nh <cmd>noh<cr>

" Make mouse available under any circumstances.
set mouse=a
" set relative numbers at the left in your vim editor but actual number on current line.
set relativenumber number
set clipboard=unnamedplus " Allow vscode-neovim to access the system clipboard. 

" Highlight target in visual mode and surround it by <leader> and front bracket. 
vnoremap \( <esc>`<i(<esc>`>la)
vnoremap \[ <esc>`<i[<esc>`>la]
vnoremap \{ <esc>`<i{<esc>`>la}
vnoremap \" <esc>`<i"<esc>`>la"
vnoremap \' <esc>`<i'<esc>`>la'

" Mapping <C-/> to Comment in vscode. 
xnoremap <C-/> <Plug>VSCodeCommentarygv
nnoremap <C-/> <Plug>VSCodeCommentaryLinegv

lua << EOF
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
keymap("n", "-", "<Esc>:m .-2<CR>==", opts) -- Up
keymap("n", "_", "<Esc>:m .+1<CR>==", opts) -- Down

--[[ require('packer').startup(function(use) ]]
--[[     use "numToStr/Comment.nvim" -- Easily comment stuff ]]
--[[ end) ]]

EOF

" call plug#begin('~/.config/nvim/plugged')
"
" Plug 'tpope/vim-commentary'
"
" call plug#end()

