local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = false, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local mappings = {
	h = {
		name = "Help",
		J = { "", "Make curLine after prevLine" },
		n = {
			name = "Nvim Tree",
			m = { "", "Bookmakrs, 'bmv' to move" },
			r = { "", "Rename file" },
			a = { "", "Add file, leave / behind for dir" },
			d = { "", "Delete file" },
			C = {
				name = "Ctrl",
				v = { "", "Open in vertical" },
				x = { "", "Open in horivontal" },
				t = { "", "Open in tab" },
			},
		},
		m = {
			name = "Move/Hop",
			p = { "", "Pattern" },
			v = { "", "Up" },
			V = { "", "Down" },
		},
		g = {
			name = "Goto",
			d = { "", "Definition" },
			D = { "", "Declaration" },
			l = { "", "Show error message" },
			i = { "", "Inplementation" },
		},
		d = {
			name = "Diagnostic",
			p = { "", "Previos" },
			n = { "", "Next" },
		},
		K = { "", "Hover information" },
		C = {
			name = "Ctrl",
			e = { "", "Scroll down" },
			y = { "", "Scroll up" },
			u = { "", "Up without moving cursor" },
			d = { "", "Down without moving cursor" },
			f = { "", "Page down" },
			b = { "", "Page up" },
			-- For ufo.lua
			--[[ n = { "", "Next closed fold" }, ]]
			--[[ p = { "", "Previous closed fold" }, ]]
			k = { "", "Signature help" },
		},
		q = {
			name = "Quick",
			f = { "", "Fix" },
			h = { "", "Hover information" },
		},
	},
}

local send_line =
	'<cmd>lua require("toggleterm").send_lines_to_terminal("single_line", false, { args = vim.v.count })<cr>'
local send_visual =
	'<cmd>lua require("toggleterm").send_lines_to_terminal("visual_selection", false, { args = vim.v.count })<cr>'

which_key.add({
	{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer", hidden = true },
	{ "<leader>w", "<cmd>w<cr>", desc = "Write", hidden = true },
	{ "<leader>q", "<cmd>q<cr>", desc = "Quit", hidden = true },
	{ "<leader>m", "<cmd>Format<cr>", desc = "Format" },
	{ "<leader>x", "<cmd>bd<cr>", desc = "Buffer delete", hidden = true },
	{ "<leader>v", "<cmd>vsp<cr>", desc = "Vertical split", hidden = true },
	{ "<leader>V", "<cmd>sp<cr>", desc = "Horizontal split", hidden = true },
	{ "<leader>f", "<cmd>Telescope file_browser<cr>", desc = "Find file", hidden = true },
	{ "<leader>F", "<cmd>Telescope live_grep<cr>", desc = "Live grep", hidden = true },
	{ "<leader>o", "<cmd>SymbolsOutline<cr>", desc = "Outline toggle", hidden = true },
	{ "<leader>s", send_line, desc = "Send line", hidden = true },
	{ "<leader>d", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Diagnose window", hidden = true },

	-- Git
	{ "<leader>g", group = "git" },
	{ "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
	{ "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
	{ "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview changes" },
	{ "<leader>gn", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
	{ "<leader>gN", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk" },
	{ "<leader>ga", "<cmd>Gitsigns stage_hunk<cr>", desc = "Git stage hunk" },
	{ "<leader>gA", "<cmd>Gitsigns stage_buffer<cr>", desc = "Git stage buffer" },
	{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
	{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
	{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit" },
	{ "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff" },

	-- Noice
	{ "<leader>n", group = "Noice" },
	{ "<leader>nd", "<cmd>NoiceDismiss<cr>", desc = "Noice Dismiss" },
	{ "<leader>nh", "<cmd>NoiceHistory<cr>", desc = "Noice History" },

	-- Buffer
	{ "<leader>b", group = "buffer" },
	{ "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close left" },
	{ "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close right" },
	{ "<leader>ba", "<cmd>BufferLineCloseRight<cr><cmd>BufferLineCloseLeft<cr>", desc = "Close except current" },
	{ "<leader>bn", "<cmd>BufferLineMoveNext<cr>", desc = "Move next" },
	{ "<leader>bp", "<cmd>BufferLineMovePrev<cr>", desc = "Move prev" },

	-- Terminal
	{ "<leader>t", group = "Tabs/Term/Transparent" },
	{ "<leader>tt", "<cmd>TransparentToggle<cr>", desc = "Toggle transparent" },
	{ "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float terminal" },
	{ "<leader>tb", "<cmd>ToggleTerm direction=tab<cr>", desc = "Tab terminal" },
	{ "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal terminal" },
	{ "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical terminal" },
	{ "<leader>te", "<cmd>tabedit<cr>", desc = "New tab" },
	{ "<leader>tn", "<cmd>tabnext<cr>", desc = "Next tab" },
	{ "<leader>tp", "<cmd>tabprevious<cr>", desc = "Previous tab" },

	{
		mode = "v",
		{ "<leader>s", send_visual, desc = "Send visual" },
	},
})

-- which_key.setup(setup)
-- which_key.register(mappings, opts)
-- which_key.register(vmappings, vopts)
