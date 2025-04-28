local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", lazyrepo, "--branch=stable", lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	--[[ GitHub copilot ]]
	{
		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup()
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
		dependencies = { "hrsh7th/nvim-cmp", "zbirenbaum/copilot.lua" },
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		opts = {
			-- add any opts here
		},
		-- if you want to download pre-built binary, then pass source=false. Make sure to follow instruction above.
		-- Also note that downloading prebuilt binary is a lot faster comparing to compiling from source.
		build = ":AvanteBuild source=false",
		config = function()
			require("avante").setup({
				provider = "copilot",
			})
		end,
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to setup it properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "Avante" },
				},
				ft = { "Avante" },
			},
		},
	},

	--[[ CMP Plugins ]]
	"hrsh7th/nvim-cmp", -- The completion plugin
	"hrsh7th/cmp-buffer", -- buffer completions
	"hrsh7th/cmp-path", -- path completions
	"hrsh7th/cmp-cmdline", -- cmdline completions
	"saadparwaiz1/cmp_luasnip", -- snippet completions
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",
	-- {
	-- 	"tzachar/cmp-tabnine",
	-- 	build = tabnine_build,
	-- 	dependencies = "hrsh7th/nvim-cmp",
	-- },

	--[[ Snippets ]]
	"L3MON4D3/LuaSnip", --snippet engine
	"rafamadriz/friendly-snippets", -- a bunch of snippets to use

	--[[ Git-conflict ]]
	{ "akinsho/git-conflict.nvim", version = "*", config = true },

	-- [[ LSP ]]
	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
	},
	"mhartington/formatter.nvim",

	--[[ Telescope ]]
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},

	--[[ Treesitter ]]
	{
		"nvim-treesitter/nvim-treesitter",
		build = { ":TSUpdate" },
	},

	--[[ Pairs & Comment ]]
	"windwp/nvim-autopairs",
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	},

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
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		config = function()
			require("ibl").setup()
		end,
	},
	-- "anuvyklack/pretty-fold.nvim",

	--[[ Transparent ]]
	"xiyaowong/nvim-transparent",

	--[[ Moving ]]
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup()
		end,
	},
	{
		"phaazon/hop.nvim",
		branch = "v2",
	},
	{
		"hedyhli/outline.nvim",
		config = function()
			require("outline").setup({})
		end,
	},

	--[[ Color or Highlighting ]]
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	config = function()
	-- 		require("tokyonight").setup({
	-- 			--[[ style = "moon", ]]
	-- 			styles = {
	-- 				comments = { italic = true },
	-- 				keywords = { italic = true },
	-- 			},
	-- 			sidebars = { "qf", "vista_kind", "terminal", "packer" },
	-- 		})
	-- 		vim.cmd([[colorscheme tokyonight]])
	-- 	end,
	-- },
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				user_default_options = {
					css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
					css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
					-- Available methods are false / true / "normal" / "lsp" / "both"
					-- True is same as normal
					tailwind = true, -- Enable tailwind colors
					always_update = true,
				},
			})
		end,
	},
	"RRethy/vim-illuminate",
	{
		"projekt0n/github-nvim-theme",
		config = function()
			require("github-theme").setup({
				palettes = {
					all = {
						red = "#ff0000",
					},
					github_dark_dimmed = {
						bg1 = "#444c56",
						sel0 = "#adbac7", -- Popup bg, visual selection bg
						sel1 = "#22272e", -- Popup sel bg, search bg
						comment = "#636e7b",
					},
				},
				vim.cmd([[colorscheme github_dark_dimmed]]),
			})
		end,
	},

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
