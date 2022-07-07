" stored at ~/.config/nvim

" Setting map leader. 
let mapleader = '\'

" Make mouse available under any circumstances.
set mouse=a
" set relative numbers at the left in your vim editor but actual number on current line.
set relativenumber number

" Highlight target in visual mode and surround it by <leader> and front bracket. 
vnoremap <leader>( <esc>`<i(<esc>`>la)
vnoremap <leader>[ <esc>`<i[<esc>`>la]
vnoremap <leader>{ <esc>`<i{<esc>`>la}
vnoremap <leader>" <esc>`<i"<esc>`>la"
vnoremap <leader>' <esc>`<i'<esc>`>la'

" call plug#begin('~/.config/nvim/plugged')
"
" Plug 'tpope/vim-commentary'
"
" call plug#end()

