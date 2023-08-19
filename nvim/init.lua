-- Detect OS
if not vim.g.os then
    if (vim.fn.has('mac') == 1) then
        vim.g.os = 'mac'
    elseif (vim.fn.has('win32') == 1) then
        vim.g.os = 'win'
    end
end

require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.cmp"
require "user.lsp"
require "user.telescope"
require "user.treesitter"
require "user.autopairs"
require "user.comment"
require "user.gitsigns"
require "user.nvim-tree"
require "user.bufferline"
require "user.toggleterm"
require "user.lualine"
require "user.whichkey"
require "user.alpha"
require "user.indentline"
require "user.transparent"
-- require "user.ufo"  
require "user.pretty-fold"
require "user.neoscroll"
require "user.hop"
require "user.outline"
require "user.autocmd"
require "user.friendly-snip"
--[[ require "user.vimtex" ]]
--[[ require "user.silicon" ]]
require "user.barbecue"
require "user.formatter"

-- Set notermguicolors cause mac default terminal.app only support 256 colors
vim.cmd([[ 
    if $TERM_PROGRAM == "Apple_Terminal"
    set notermguicolors
    endif
]])
