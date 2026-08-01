local M = {}

local defaults = {
	mappings = {
		normal = "<leader>s",
		visual = "<leader>s",
	},
	prefix = "!",
	execute = false,
	join_multiline = true,
	strip_continuation = true,
}

local config = vim.deepcopy(defaults)
local active_mappings = {}

local function escape_lua_pattern(text)
	return text:gsub("([^%w])", "%%%1")
end

local function extract_command(line, commentstring)
	if commentstring == "" or not commentstring:find("%s", 1, true) then
		return nil
	end

	local prefix, suffix = commentstring:match("^(.-)%%s(.-)$")

	prefix = vim.trim(prefix or "")
	suffix = vim.trim(suffix or "")

	local pattern = "^%s*" .. escape_lua_pattern(prefix) .. "%s*(.-)%s*"

	if suffix ~= "" then
		pattern = pattern .. escape_lua_pattern(suffix) .. "%s*$"
	else
		pattern = pattern .. "$"
	end

	return line:match(pattern)
end

local function remove_shell_continuation(command)
	return command:gsub("%s*\\%s*$", "")
end

local function command_keys(command)
	local enter = config.execute and "<CR>" or ""
	return vim.api.nvim_replace_termcodes(":" .. config.prefix .. command .. enter, true, false, true)
end

local function send_command(command, leave_visual_mode)
	local keys = command_keys(command)

	if not leave_visual_mode then
		vim.api.nvim_feedkeys(keys, "n", false)
		return
	end

	-- Leave Visual mode first. Otherwise `:` inserts `'<,'>`.
	local escape = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
	vim.api.nvim_feedkeys(escape, "nx", false)

	vim.schedule(function()
		vim.api.nvim_feedkeys(keys, "n", false)
	end)
end

local function send_normal_command()
	local command = extract_command(vim.api.nvim_get_current_line(), vim.bo.commentstring)

	if not command or command == "" then
		vim.notify("Current line is not a valid command comment", vim.log.levels.WARN)
		return
	end

	send_command(command, false)
end

local function send_visual_command()
	local visual_pos = vim.fn.getpos("v")
	local cursor_pos = vim.fn.getpos(".")
	local start_line = math.min(visual_pos[2], cursor_pos[2])
	local end_line = math.max(visual_pos[2], cursor_pos[2])
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	local commands = {}

	for index, line in ipairs(lines) do
		if not line:match("^%s*$") then
			local command = extract_command(line, vim.bo.commentstring)

			if not command or command == "" then
				vim.notify(
					string.format("Line %d is not a valid command comment", start_line + index - 1),
					vim.log.levels.WARN
				)
				return
			end

			if config.strip_continuation then
				command = remove_shell_continuation(command)
			end

			if command ~= "" then
				table.insert(commands, command)
			end
		end
	end

	if #commands == 0 then
		vim.notify("Selection contains no commands", vim.log.levels.WARN)
		return
	end

	if #commands > 1 and not config.join_multiline then
		vim.notify("Selection contains multiple commands and join_multiline is disabled", vim.log.levels.WARN)
		return
	end

	send_command(table.concat(commands, " "), true)
end

local function clear_mappings()
	for _, mapping in ipairs(active_mappings) do
		pcall(vim.keymap.del, mapping.mode, mapping.lhs)
	end
	active_mappings = {}
end

local function set_mapping(mode, lhs, callback, description)
	if lhs == nil or lhs == false then
		return
	end

	vim.keymap.set(mode, lhs, callback, { desc = description })
	table.insert(active_mappings, { mode = mode, lhs = lhs })
end

function M.setup(options)
	config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), options or {})

	clear_mappings()
	set_mapping("n", config.mappings.normal, send_normal_command, "Send commented command to command line")
	set_mapping("x", config.mappings.visual, send_visual_command, "Send selected command comments to command line")
end

return M
