syntax on

set expandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4

set foldmethod=indent
set foldlevelstart=99
set autoindent
set number
set backspace=2
set clipboard=unnamed

"smart mapping for tab completion
function InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

inoremap <TAB> <C-R>=InsertTabWrapper()<CR>
inoremap jj <Esc>

" Parentheses
inoremap ( ()<Left>
inoremap () ()<Left>
inoremap (<BS> <NOP>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"

" Brackets
inoremap [ []<Left>
inoremap [] []<Left>
inoremap [<BS> <NOP>
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"

" Braces
inoremap { {}<Left>
inoremap {} {}<Left>
inoremap {<BS> <NOP>
inoremap <expr> }  strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
inoremap {<CR> {<CR>}<C-o>O
