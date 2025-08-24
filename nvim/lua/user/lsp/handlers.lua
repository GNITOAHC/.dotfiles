local M = {}

M.setup = function()
	local config = {
		virtual_text = false, -- disable virtual text
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.HINT] = "",
				[vim.diagnostic.severity.INFO] = "",
			},
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}
	vim.diagnostic.config(config)

	-- Overwrite the default floating window border style
	-- Source: https://www.reddit.com/r/neovim/comments/1jbegzo/how_to_change_border_style_in_floating_windows/
	local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
	---@diagnostic disable-next-line: duplicate-set-field
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"

		return orig_util_open_floating_preview(contents, syntax, opts, ...)
	end
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		return
	end
	illuminate.on_attach(client)
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

	vim.api.nvim_buf_set_keymap(bufnr, "n", "qf", "<cmd>lua vim.lsp.buf.code_action(quickfix)<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "qh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

	--[[ vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts) ]]

	vim.api.nvim_buf_set_keymap(bufnr, "n", "dp", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "dn", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>d", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
end

-- Should attach to every buffer instead of buffer with language server, so setup outside of lsp_keymaps and set the function globally.
function Toggle_setloclist()
	local loclist_winid = vim.fn.getloclist(0, { winid = 0 }).winid
	if loclist_winid ~= 0 then
		-- Location list is open, close it
		vim.cmd("lclose")
	else
		-- Location list is not open, populate and open it with diagnostics
		vim.diagnostic.setloclist({ open = true })
	end
end
vim.api.nvim_set_keymap("n", "<leader>d", "<cmd>lua Toggle_setloclist()<CR>", { noremap = true, silent = true })

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M
