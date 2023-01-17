local fn = vim.fn
local os = vim.g.os

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- Install your plugins here
return packer.startup(function(use)

    --[[ Packer ]]
    use "wbthomason/packer.nvim" -- Have packer manage itself

    --[[ CMP Plugins ]]
    use "hrsh7th/nvim-cmp" -- The completion plugin
    use "hrsh7th/cmp-buffer" -- buffer completions
    use "hrsh7th/cmp-path" -- path completions
    use "hrsh7th/cmp-cmdline" -- cmdline completions
    use "saadparwaiz1/cmp_luasnip" -- snippet completions
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"
    if (os == 'mac') then
        use { 'tzachar/cmp-tabnine', run = './install.sh' } -- nvim-cmp plugin
    elseif (os == 'win') then
        use {'tzachar/cmp-tabnine', after = "nvim-cmp", run='powershell ./install.ps1', requires = 'hrsh7th/nvim-cmp'}
    end

    --[[ Snippets ]]
    use "L3MON4D3/LuaSnip" --snippet engine
    use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

    --[[ LSP ]]
    use "neovim/nvim-lspconfig" -- enable LSP
    use "williamboman/mason.nvim"
    use {
        "williamboman/mason-lspconfig.nvim",
        requires = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" }
    }
    use "jose-elias-alvarez/null-ls.nvim"

    --[[ Telescope ]]
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use "nvim-telescope/telescope-media-files.nvim"
    use "nvim-telescope/telescope-file-browser.nvim"

    --[[ Treesitter ]]
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }
    use "p00f/nvim-ts-rainbow"
    use 'JoosepAlviste/nvim-ts-context-commentstring'

    --[[ Pairs & Comment ]]
    use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter 
    use "windwp/nvim-ts-autotag" --Auto tags, integrate with treesitter 
    use "numToStr/Comment.nvim" -- Easily comment stuff

    --[[ Git ]]
    use "lewis6991/gitsigns.nvim"

    --[[ Nvim-tree ]]
    use { "nvim-tree/nvim-tree.lua",
        requires = { "nvim-tree/nvim-web-devicons" },
    }

    --[[ BufferLine & Lualine & Winbar ]]
    use "akinsho/bufferline.nvim"
    use "nvim-lualine/lualine.nvim"
    use { "utilyre/barbecue.nvim",
        requires = { "neovim/nvim-lspconfig", "smiteshp/nvim-navic", "kyazdani42/nvim-web-devicons" },
    }

    --[[ Toggleterm ]]
    use { "akinsho/toggleterm.nvim", tag = 'v2.*' }

    --[[ Whichkey ]]
    use "folke/which-key.nvim"

    --[[ Alpha ]]
    use "goolord/alpha-nvim"

    --[[ Typesetting ]]
    use "lukas-reineke/indent-blankline.nvim"
    use "anuvyklack/pretty-fold.nvim"

    --[[ Transparent ]]
    use "xiyaowong/nvim-transparent"

    --[[ VimTex ]]
    use "lervag/vimtex"

    --[[ Code runner ]]
    use "CRAG666/code_runner.nvim"

    --[[ Moving ]]
    use "karb94/neoscroll.nvim"
    use { "phaazon/hop.nvim", branch = 'v2' }
    use "simrat39/symbols-outline.nvim"

    --[[ Color or Highlighting ]]
    use 'folke/tokyonight.nvim' -- Colorscheme
    use "norcalli/nvim-colorizer.lua" -- Colorizer
    use "RRethy/vim-illuminate" -- Illuminate
    use "kyazdani42/nvim-web-devicons"

    --[[ Functions or API ]]
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

    --[[ Silicon ]]
    --[[ use {'krivahtoo/silicon.nvim', run = './install.sh'} ]]

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
