--[[
Output presentation for runner.nvim.

Maintenance: this module owns the output buffer, its window, and all layout
logic. It deliberately knows nothing about runner discovery or job creation;
callers pass the configured output options to show().
]]

local M = {}

local buffer
local window
local previous_buffer
local wrote_output = false

local function close_output(output_buffer)
	local output_window = vim.api.nvim_get_current_win()
	if vim.api.nvim_get_current_buf() ~= output_buffer then
		return
	end

	local is_float = vim.api.nvim_win_get_config(output_window).relative ~= ""
	if is_float or #vim.api.nvim_tabpage_list_wins(0) > 1 then
		vim.api.nvim_win_close(output_window, false)
	elseif previous_buffer and vim.api.nvim_buf_is_valid(previous_buffer) then
		vim.api.nvim_win_set_buf(output_window, previous_buffer)
	else
		vim.api.nvim_win_set_buf(output_window, vim.api.nvim_create_buf(true, false))
	end

	if window == output_window then
		window = nil
	end
end

local function set_output_keymaps(output_buffer)
	vim.keymap.set({ "n", "i", "v" }, "<C-c>", function()
		require("runner").stop()
	end, { buffer = output_buffer, silent = true, nowait = true, desc = "Stop the running process" })
	vim.keymap.set("n", "q", function()
		close_output(output_buffer)
	end, { buffer = output_buffer, silent = true, nowait = true, desc = "Close the runner output" })
end

local function configure_buffer(output_buffer)
	vim.bo[output_buffer].buftype = "nofile"
	vim.bo[output_buffer].bufhidden = "hide"
	vim.bo[output_buffer].swapfile = false
	vim.bo[output_buffer].modifiable = false
	vim.bo[output_buffer].filetype = "runner-output"
	vim.api.nvim_buf_set_name(output_buffer, "runner.nvim output")
end

local function get_buffer()
	if buffer and vim.api.nvim_buf_is_valid(buffer) then
		return buffer
	end

	buffer = vim.api.nvim_create_buf(false, true)
	configure_buffer(buffer)
	return buffer
end

local function apply_split_size(layout, size)
	if not size then
		return
	end
	if layout == "vertical" then
		vim.api.nvim_win_set_width(0, size)
	else
		vim.api.nvim_win_set_height(0, size)
	end
end

local function float_window_config(float_config)
	local editor_height = math.max(1, vim.o.lines - vim.o.cmdheight)
	local available_width = math.max(1, vim.o.columns - 2)
	local available_height = math.max(1, editor_height - 2)
	local width = float_config.width <= 1 and math.floor(available_width * float_config.width)
		or math.floor(float_config.width)
	local height = float_config.height <= 1 and math.floor(available_height * float_config.height)
		or math.floor(float_config.height)
	width = math.max(1, math.min(width, available_width))
	height = math.max(1, math.min(height, available_height))

	return {
		relative = "editor",
		style = "minimal",
		border = float_config.border,
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((editor_height - height) / 2),
	}
end

local function close_float_on_leave(float_window, output_buffer)
	vim.api.nvim_create_autocmd("WinLeave", {
		buffer = output_buffer,
		once = true,
		callback = function()
			vim.schedule(function()
				if vim.api.nvim_win_is_valid(float_window) then
					vim.api.nvim_win_close(float_window, false)
				end
				if window == float_window then
					window = nil
				end
			end)
		end,
	})
end

local function clamp_window_cursors(output_buffer, last_line)
	last_line = math.max(1, last_line)
	for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
		for _, output_window in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
			if vim.api.nvim_win_is_valid(output_window) and vim.api.nvim_win_get_buf(output_window) == output_buffer then
				local cursor = vim.api.nvim_win_get_cursor(output_window)
				if cursor[1] > last_line then
					vim.api.nvim_win_set_cursor(output_window, { last_line, 0 })
				end
			end
		end
	end
end

function M.is_current()
	return buffer ~= nil and buffer == vim.api.nvim_get_current_buf()
end

function M.exists()
	return buffer ~= nil and vim.api.nvim_buf_is_valid(buffer)
end

function M.show(options)
	local source_window = vim.api.nvim_get_current_win()
	local source_buffer = vim.api.nvim_get_current_buf()
	local output_buffer = get_buffer()

	if window and vim.api.nvim_win_is_valid(window) then
		vim.api.nvim_win_set_buf(window, output_buffer)
		if options.focus then
			vim.api.nvim_set_current_win(window)
		end
	elseif options.layout == "float" then
		window = vim.api.nvim_open_win(output_buffer, options.focus, float_window_config(options.float))
		close_float_on_leave(window, output_buffer)
	elseif options.layout == "buffer" then
		if source_buffer ~= output_buffer then
			previous_buffer = source_buffer
		end
		window = source_window
		vim.api.nvim_win_set_buf(window, output_buffer)
	else
		vim.cmd(options.layout == "vertical" and "botright vsplit" or "botright split")
		window = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(window, output_buffer)
		apply_split_size(options.layout, options.size)
	end

	if not options.focus and vim.api.nvim_win_is_valid(source_window) then
		vim.api.nvim_set_current_win(source_window)
	end

	-- Reapply after window events in case a BufEnter hook cleared local maps.
	set_output_keymaps(output_buffer)
	return output_buffer
end

function M.replace(lines)
	if not buffer or not vim.api.nvim_buf_is_valid(buffer) then
		return
	end
	-- Keep every viewport inside the replacement range before shrinking the
	-- buffer. Text-change listeners may inspect the viewport synchronously.
	clamp_window_cursors(buffer, #lines)
	vim.bo[buffer].modifiable = true
	vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
	vim.bo[buffer].modified = false
	vim.bo[buffer].modifiable = false
	wrote_output = #lines > 0
end

function M.append(lines)
	if not buffer or not vim.api.nvim_buf_is_valid(buffer) or not lines or #lines == 0 then
		return
	end
	if lines[#lines] == "" then
		table.remove(lines, #lines)
	end
	if #lines == 0 then
		return
	end

	vim.bo[buffer].modifiable = true
	local first_line = wrote_output and -1 or 0
	vim.api.nvim_buf_set_lines(buffer, first_line, -1, false, lines)
	vim.bo[buffer].modified = false
	vim.bo[buffer].modifiable = false
	wrote_output = true
end

return M
