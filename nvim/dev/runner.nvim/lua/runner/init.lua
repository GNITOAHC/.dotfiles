--[[
Public API for runner.nvim.

Maintenance: keep this file deliberately small. Public methods belong here,
while implementation details belong in runner.core or runner.output.
]]

local M = {}

function M.setup(options)
	require("runner.core").setup(options)
end

function M.find_runner(candidates)
	return require("runner.core").find_runner(candidates)
end

function M.show_output()
	return require("runner.core").show_output()
end

function M.stop()
	return require("runner.core").stop()
end

function M.run(file)
	return require("runner.core").run(file)
end

function M.run_command(command)
	return require("runner.core").run_command(command)
end

return M
