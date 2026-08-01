--[[
Command registration for runner.nvim.

Maintenance: keep user-command definitions here and put their behavior behind
the public runner module so commands and Lua callers always share one path.
]]

if vim.g.loaded_runner_nvim then
  return
end
vim.g.loaded_runner_nvim = true

vim.api.nvim_create_user_command("RunCode", function(command)
  require("runner").run(command.args)
end, {
  nargs = "?",
  complete = "file",
	desc = "Find and run a project runner file",
})

vim.api.nvim_create_user_command("RunCodeCmd", function(command)
	require("runner").run_command(command.args)
end, {
	nargs = "+",
	complete = "shellcmd",
	desc = "Run a shell command in the runner output buffer",
})

vim.api.nvim_create_user_command("RunCodeStop", function()
	require("runner").stop()
end, {
	desc = "Stop the running process",
})

vim.api.nvim_create_user_command("RunCodeOutput", function()
	require("runner").show_output()
end, {
	desc = "Show the runner output buffer",
})
