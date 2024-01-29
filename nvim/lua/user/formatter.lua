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
    return {
        exe = "prettier",
        args = { "--config $HOME/.dotfiles/format/.prettierrc", "--parser", "typescript" },
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
		markdown = { require("formatter.filetypes.markdown").prettier },
		rust = { require("formatter.filetypes.rust").rustfmt },
		javascript = { prettier() },
		javascriptreact = { prettier() },
		typescript = { prettier() },
		typescriptreact = { prettier() },
		html = { require("formatter.filetypes.html").prettier },
	},
})
