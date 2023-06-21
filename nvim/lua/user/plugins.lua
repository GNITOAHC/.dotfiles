local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local tabnine_build = "./install.sh"
if vim.g.os == "win" then
	tabnine_build = "./install.ps1"
end

require("lazy").setup({

	--[[ GitHub copilot ]]
	"github/copilot.vim",

	--[[ CMP Plugins ]]
	"hrsh7th/nvim-cmp", -- The completion plugin
	"hrsh7th/cmp-buffer", -- buffer completions
	"hrsh7th/cmp-path", -- path completions
	"hrsh7th/cmp-cmdline", -- cmdline completions
	"saadparwaiz1/cmp_luasnip", -- snippet completions
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",
	{
		"tzachar/cmp-tabnine",
		build = tabnine_build,
		dependencies = "hrsh7th/nvim-cmp",
	},

	--[[ Snippets ]]
	"L3MON4D3/LuaSnip", --snippet engine
	"rafamadriz/friendly-snippets", -- a bunch of snippets to use

	-- [[ LSP ]]
	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
	},
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
	},
	"jose-elias-alvarez/null-ls.nvim",

	--[[ Telescope ]]
	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.0",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	"nvim-telescope/telescope-file-browser.nvim",

	--[[ Treesitter ]]
	{
		"nvim-treesitter/nvim-treesitter",
		build = { ":TSUpdate" },
	},
	"p00f/nvim-ts-rainbow",
	"JoosepAlviste/nvim-ts-context-commentstring",

	--[[ Pairs & Comment ]]
	"windwp/nvim-autopairs",
	"windwp/nvim-ts-autotag",
	"numToStr/Comment.nvim",

	--[[ Git ]]
	"lewis6991/gitsigns.nvim",

	--[[ Nvim-tree ]]
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	--[[ BufferLine & Lualine & Winbar ]]
	"akinsho/bufferline.nvim",
	"nvim-lualine/lualine.nvim",
	{
		"utilyre/barbecue.nvim",
		dependencies = {
			"smiteshp/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
	},

	--[[ Toggleterm ]]
	{
		"akinsho/toggleterm.nvim",
		version = "*",
	},

	--[[ Whichkey ]]
	"folke/which-key.nvim",

	--[[ Alpha ]]
	"goolord/alpha-nvim",

	--[[ Typesetting ]]
	"lukas-reineke/indent-blankline.nvim",
	"anuvyklack/pretty-fold.nvim",

	--[[ Transparent ]]
	"xiyaowong/nvim-transparent",

	--[[ Moving ]]
	"karb94/neoscroll.nvim",
	{
		"phaazon/hop.nvim",
		branch = "v2",
	},
	"simrat39/symbols-outline.nvim",

	--[[ Color or Highlighting ]]
	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("tokyonight").setup({
				--[[ style = "moon", ]]
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
				},
				sidebars = { "qf", "vista_kind", "terminal", "packer" },
			})
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	"RRethy/vim-illuminate",

	--[[ Noice ]]
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				routes = { -- show macro recording
					{
						view = "mini",
						filter = {
							any = {
								{ event = require("noice.ui.msg").events.showcmd },
								{ event = require("noice.ui.msg").events.showmode },
							},
						},
					},
				},
				messages = { enabled = true },
			})
			require("notify").setup({
				background_colour = "#000000",
			})
		end,
	},
})
