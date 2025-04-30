local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local send_line =
	'<cmd>lua require("toggleterm").send_lines_to_terminal("single_line", false, { args = vim.v.count })<cr>'
local send_visual =
	'<cmd>lua require("toggleterm").send_lines_to_terminal("visual_selection", false, { args = vim.v.count })<cr>'

which_key.add({
	{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer", hidden = true },
	{ "<leader>w", "<cmd>w<cr>", desc = "Write", hidden = true },
	{ "<leader>q", "<cmd>q<cr>", desc = "Quit", hidden = true },
	{ "<leader>x", "<cmd>bd<cr>", desc = "Buffer delete", hidden = true },
	{ "<leader>v", "<cmd>vsp<cr>", desc = "Vertical split", hidden = true },
	{ "<leader>V", "<cmd>sp<cr>", desc = "Horizontal split", hidden = true },
	{ "<leader>f", "<cmd>Telescope file_browser<cr>", desc = "Find file", hidden = true },
	{ "<leader>F", "<cmd>Telescope live_grep<cr>", desc = "Live grep", hidden = true },
	{ "<leader>o", "<cmd>Outline<cr>", desc = "Outline toggle", hidden = true },
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
