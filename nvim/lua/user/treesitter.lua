local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

if vim.g.os == "win" then
	require("nvim-treesitter.install").compilers = { "zig" }
end

-- Add mdx support
vim.filetype.add({
	extension = {
		mdx = "mdx",
	},
})
vim.treesitter.language.register("markdown", "mdx")

configs.setup({
    -- stylua: ignore start
    ensure_installed = { "c", "cpp", "lua", "python", "c_sharp", "typescript", "javascript", "markdown", "scss", "fish", "vim" },
	-- stylua: ignore end
	sync_install = false,
	ignore_install = { "" }, -- List of parsers to ignore installing
	autopairs = {
		enable = true,
	},
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true, disable = { "yaml" } },
	rainbow = {
		enable = true,
		-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
		extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = nil, -- Do not enable for files with more than n lines, int
		-- colors = {}, -- table of hex strings
		-- termcolors = {} -- table of colour name strings
	},
})
