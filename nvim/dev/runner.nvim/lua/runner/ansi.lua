-- ANSI SGR parsing for runner output buffers.

local M = {}

local default_palette = {
	"#000000", "#800000", "#008000", "#808000", "#000080", "#800080", "#008080", "#c0c0c0",
	"#808080", "#ff0000", "#00ff00", "#ffff00", "#0000ff", "#ff00ff", "#00ffff", "#ffffff",
}

local highlight_groups = {}
local highlight_group_count = 0

local function palette_color(index)
	local configured = vim.g["terminal_color_" .. index]
	if type(configured) == "string" and configured ~= "" then
		return configured
	end
	return default_palette[index + 1]
end

local function indexed_color(index)
	if type(index) ~= "number" or index < 0 or index > 255 then
		return nil
	end
	if index < 16 then
		return palette_color(index)
	end
	if index < 232 then
		local value = index - 16
		local levels = { 0, 95, 135, 175, 215, 255 }
		local red = levels[math.floor(value / 36) + 1]
		local green = levels[math.floor(value / 6) % 6 + 1]
		local blue = levels[value % 6 + 1]
		return string.format("#%02x%02x%02x", red, green, blue)
	end
	local level = 8 + (index - 232) * 10
	return string.format("#%02x%02x%02x", level, level, level)
end

local function rgb_color(red, green, blue)
	if not red or not green or not blue then
		return nil
	end
	if red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255 then
		return nil
	end
	return string.format("#%02x%02x%02x", red, green, blue)
end

local function has_style(style)
	return style.fg or style.bg or style.bold or style.italic or style.underline or style.strikethrough or style.reverse
end

local function highlight_group(style)
	local key = table.concat({
		style.fg or "",
		style.bg or "",
		style.bold and "1" or "0",
		style.italic and "1" or "0",
		style.underline and "1" or "0",
		style.strikethrough and "1" or "0",
		style.reverse and "1" or "0",
	}, ":")
	if highlight_groups[key] then
		return highlight_groups[key]
	end

	highlight_group_count = highlight_group_count + 1
	local name = "RunnerAnsi" .. highlight_group_count
	vim.api.nvim_set_hl(0, name, {
		fg = style.fg,
		bg = style.bg,
		bold = style.bold or false,
		italic = style.italic or false,
		underline = style.underline or false,
		strikethrough = style.strikethrough or false,
		reverse = style.reverse or false,
	})
	highlight_groups[key] = name
	return name
end

local function reset(style)
	for key in pairs(style) do
		style[key] = nil
	end
end

local function parameters(value)
	if value == "" then
		return { 0 }
	end
	local result = {}
	for parameter in (value:gsub(":", ";") .. ";"):gmatch("(.-);") do
		result[#result + 1] = tonumber(parameter) or 0
	end
	return result
end

local function apply_sgr(style, value)
	local params = parameters(value)
	local index = 1
	while index <= #params do
		local code = params[index]
		if code == 0 then
			reset(style)
		elseif code == 1 then
			style.bold = true
		elseif code == 3 then
			style.italic = true
		elseif code == 4 then
			style.underline = true
		elseif code == 7 then
			style.reverse = true
		elseif code == 9 then
			style.strikethrough = true
		elseif code == 22 then
			style.bold = nil
		elseif code == 23 then
			style.italic = nil
		elseif code == 24 then
			style.underline = nil
		elseif code == 27 then
			style.reverse = nil
		elseif code == 29 then
			style.strikethrough = nil
		elseif code >= 30 and code <= 37 then
			style.fg = palette_color(code - 30)
		elseif code == 39 then
			style.fg = nil
		elseif code >= 40 and code <= 47 then
			style.bg = palette_color(code - 40)
		elseif code == 49 then
			style.bg = nil
		elseif code >= 90 and code <= 97 then
			style.fg = palette_color(code - 90 + 8)
		elseif code >= 100 and code <= 107 then
			style.bg = palette_color(code - 100 + 8)
		elseif (code == 38 or code == 48) and params[index + 1] == 5 then
			style[code == 38 and "fg" or "bg"] = indexed_color(params[index + 2])
			index = index + 2
		elseif (code == 38 or code == 48) and params[index + 1] == 2 then
			style[code == 38 and "fg" or "bg"] = rgb_color(params[index + 2], params[index + 3], params[index + 4])
			index = index + 4
		end
		index = index + 1
	end
end

local function parse_line(line, style)
	local text = {}
	local spans = {}
	local column = 0
	local position = 1

	local function append(value)
		if value == "" then
			return
		end
		text[#text + 1] = value
		local next_column = column + #value
		if has_style(style) then
			spans[#spans + 1] = {
				start_col = column,
				end_col = next_column,
				hl_group = highlight_group(style),
			}
		end
		column = next_column
	end

	while true do
		local start_position, end_position, sgr = line:find("\27%[([0-9;:]*)m", position)
		if not start_position then
			append(line:sub(position))
			break
		end
		append(line:sub(position, start_position - 1))
		apply_sgr(style, sgr)
		position = end_position + 1
	end

	return table.concat(text), spans
end

function M.new_state()
	return {}
end

function M.reset(state)
	reset(state)
end

function M.parse(lines, state)
	local parsed_lines = {}
	local parsed_spans = {}
	for index, line in ipairs(lines) do
		parsed_lines[index], parsed_spans[index] = parse_line(line, state)
	end
	return parsed_lines, parsed_spans
end

return M
