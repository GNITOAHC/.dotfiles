local formatter_ok, formatter = pcall(require, "formatter")

if not formatter_ok then
	vim.notify("Formatter: Failed to load dependencies", vim.log.levels.ERROR)
	return
end

local function clang_format()
	return {
		exe = "clang-format",
		args = { "--style=file:$HOME/.dotfiles/format/.clang_format" },
		stdin = true,
	}
end

local function prettier()
	local dir = vim.fn.getcwd()
	-- Check if a .prettierrc or .prettierrc.json file exists in the current directory
	local path = "$HOME/.dotfiles/format/.prettierrc"
	if vim.fn.filereadable(dir .. "/.prettierrc") == 1 then
		path = dir .. "/.prettierrc"
	end
	if vim.fn.filereadable(dir .. "/.prettierrc.json") == 1 then
		path = dir .. "/.prettierrc.json"
	end
	return {
		exe = "prettier",
		args = { "--config", path, "--parser", "typescript" },
		stdin = true,
	}
end

local function prettier_tabfour()
	return {
		exe = "prettier",
		args = { "--tab-width", "4", "--parser", "markdown" },
		stdin = true,
	}
end

formatter.setup({
	filetype = {
		lua = { require("formatter.filetypes.lua").stylua },
		cpp = { clang_format() },
		c = { clang_format() },
		go = { require("formatter.filetypes.go").gofmt },
		python = { require("formatter.filetypes.python").black },
		markdown = { prettier_tabfour() },
		mdx = { require("formatter.filetypes.markdown").prettier },
		rust = { require("formatter.filetypes.rust").rustfmt },
		javascript = { prettier() },
		javascriptreact = { prettier() },
		typescript = { prettier() },
		typescriptreact = { prettier() },
		html = { require("formatter.filetypes.html").prettier },
		css = { require("formatter.filetypes.css").prettier },
	},
})
