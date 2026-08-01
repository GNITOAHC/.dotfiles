--[[
Core behavior for runner.nvim.

Maintenance: configuration, runner discovery, and process lifecycle stay in
this module because they form one execution flow. Window and buffer rendering
belongs in runner.output; public API compatibility belongs in runner.init.
]]

local M = {}
local output = require("runner.output")

local defaults = {
	runner_files = { "coderunner.sh" },
	output = {
		layout = "horizontal",
		size = nil,
		focus = false,
		float = {
			width = 0.8,
			height = 0.8,
			border = "rounded",
		},
	},
}

local config = vim.deepcopy(defaults)
local job
local last_runner
local run_id = 0

local function is_file(path)
	local uv = vim.uv or vim.loop
	local stat = uv.fs_stat(path)
	return stat ~= nil and stat.type == "file"
end

local function start_directory()
	local buffer_name = vim.api.nvim_buf_get_name(0)
	if buffer_name ~= "" then
		return vim.fn.fnamemodify(buffer_name, ":p:h")
	end
	return vim.fn.getcwd()
end

local function find_runner(candidates)
	local directory = start_directory()

	while directory and directory ~= "" do
		for _, candidate in ipairs(candidates) do
			local path = candidate
			if candidate:sub(1, 1) ~= "/" then
				path = directory .. "/" .. candidate
			end
			path = vim.fn.fnamemodify(path, ":p")

			if is_file(path) then
				return path
			end
		end

		local parent = vim.fn.fnamemodify(directory, ":h")
		if parent == directory then
			break
		end
		directory = parent
	end
end

local function validate(next_config)
	if type(next_config.runner_files) ~= "table" or #next_config.runner_files == 0 then
		error("runner.nvim: runner_files must be a non-empty list")
	end
	for _, runner_file in ipairs(next_config.runner_files) do
		if type(runner_file) ~= "string" or runner_file == "" then
			error("runner.nvim: each runner_files item must be a non-empty string")
		end
	end

	local valid_layouts = { horizontal = true, vertical = true, float = true, buffer = true }
	if not valid_layouts[next_config.output.layout] then
		error("runner.nvim: output.layout must be 'horizontal', 'vertical', 'float', or 'buffer'")
	end
	if next_config.output.size ~= nil
		and (type(next_config.output.size) ~= "number" or next_config.output.size <= 0)
	then
		error("runner.nvim: output.size must be a positive number")
	end
	for _, option in ipairs({ "width", "height" }) do
		local value = next_config.output.float[option]
		if type(value) ~= "number" or value <= 0 then
			error("runner.nvim: output.float." .. option .. " must be a positive number")
		end
	end
end

local function candidates_for(file)
	if not file or file == "" then
		return config.runner_files
	end

	local expanded = vim.fn.expand(file)
	local absolute = vim.fn.fnamemodify(expanded, ":p")
	return is_file(absolute) and { absolute } or { expanded }
end

local function command_for(path)
	if vim.fn.executable(path) == 1 then
		return { path }
	end
	return { vim.o.shell, path }
end

local function start_job(command, cwd, label)
	-- Ignore callbacks from an earlier process before stopping it.
	run_id = run_id + 1
	if job and vim.fn.jobwait({ job }, 0)[1] == -1 then
		vim.fn.jobstop(job)
	end

	local current_run = run_id
	output.show(config.output)
	output.replace({ "$ " .. label, "" })

	local new_job = vim.fn.jobstart(command, {
		cwd = cwd,
		stdout_buffered = false,
		stderr_buffered = false,
		on_stdout = function(_, data)
			if current_run == run_id then
				output.append(data)
			end
		end,
		on_stderr = function(_, data)
			if current_run == run_id then
				output.append(data)
			end
		end,
		on_exit = function(_, exit_code)
			if current_run == run_id then
				output.append({ "", "[process exited " .. exit_code .. "]" })
				job = nil
			end
		end,
	})

	if new_job <= 0 then
		output.append({ "Failed to start command (jobstart returned " .. new_job .. ")" })
		job = nil
		return
	end

	job = new_job
	return new_job
end

function M.setup(options)
	local next_config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), options or {})
	validate(next_config)
	config = next_config
end

function M.find_runner(candidates)
	return find_runner(candidates or config.runner_files)
end

function M.show_output()
	if not output.exists() then
		vim.notify("No runner output available", vim.log.levels.INFO, { title = "runner.nvim" })
		return false
	end

	output.show(config.output)
	return true
end

function M.stop()
	if not job or vim.fn.jobwait({ job }, 0)[1] ~= -1 then
		job = nil
		return false
	end

	local active_job = job
	run_id = run_id + 1
	job = nil
	vim.fn.jobstop(active_job)
	output.append({ "", "[process stopped]" })
	return true
end

function M.run_command(command)
	if type(command) ~= "string" or command:match("^%s*$") then
		vim.notify("RunCodeCmd requires a command", vim.log.levels.ERROR, { title = "runner.nvim" })
		return
	end

	return start_job(command, vim.fn.getcwd(), command)
end

function M.run(file)
	local candidates = candidates_for(file)
	local runner
	if (not file or file == "") and output.is_current() and is_file(last_runner or "") then
		runner = last_runner
	else
		runner = find_runner(candidates)
	end

	if not runner then
		vim.notify(
			"No runner file found (looked for: " .. table.concat(candidates, ", ") .. ")",
			vim.log.levels.ERROR,
			{ title = "runner.nvim" }
		)
		return
	end
	last_runner = runner
	return start_job(command_for(runner), vim.fn.fnamemodify(runner, ":h"), runner)
end

return M
