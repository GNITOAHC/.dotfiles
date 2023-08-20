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

formatter.setup({
	filetype = {
		lua = { require("formatter.filetypes.lua").stylua },
		cpp = { clang_format() },
		c = { clang_format() },
		go = { require("formatter.filetypes.go").gofmt },
		python = { require("formatter.filetypes.python").black },
		rust = { require("formatter.filetypes.rust").rustfmt },
		javascript = { require("formatter.filetypes.javascript").prettier },
		javascriptreact = { require("formatter.filetypes.javascriptreact").prettier },
		typescript = { require("formatter.filetypes.typescript").prettier },
		typescriptreact = { require("formatter.filetypes.typescriptreact").prettier },
	},
})
