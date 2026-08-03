local source = debug.getinfo(1, "S").source:sub(2)
local root = vim.fn.fnamemodify(source, ":p:h:h")
local fixture = root .. "/tests/fixtures/project"

vim.cmd.edit(vim.fn.fnameescape(fixture .. "/nested/example.lua"))

local runner = require("runner")
runner.setup({
  output = {
    layout = "horizontal",
    size = 8,
    focus = false,
  },
})

assert(runner.find_runner() == fixture .. "/coderunner.sh", "runner was not found in a parent directory")
runner.run()

local output_buffer
local finished = vim.wait(3000, function()
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buffer) and vim.api.nvim_buf_get_name(buffer):match("runner%.nvim output$") then
      output_buffer = buffer
      local text = table.concat(vim.api.nvim_buf_get_lines(buffer, 0, -1, false), "\n")
      return text:find("%[process exited 0%]") ~= nil
    end
  end
  return false
end, 10)

assert(finished, "runner did not finish successfully")
local output = table.concat(vim.api.nvim_buf_get_lines(output_buffer, 0, -1, false), "\n")
assert(output:find("runner output", 1, true), "stdout was not captured")
assert(output:find("cwd=" .. fixture, 1, true), "runner used the wrong working directory")
assert(not vim.bo[output_buffer].modified, "completed output buffer was marked as modified")
assert(#vim.api.nvim_tabpage_list_wins(0) == 2, "horizontal output split was not created")

vim.cmd("RunCodeCmd printf command-output")
assert(vim.wait(3000, function()
  local text = table.concat(vim.api.nvim_buf_get_lines(output_buffer, 0, -1, false), "\n")
  return text:find("command-output", 1, true) ~= nil and text:find("[process exited 0]", 1, true) ~= nil
end, 10), "RunCodeCmd did not capture shell output")
assert(vim.fn.exists(":RunCodeCmd") == 2, "RunCodeCmd command was not registered")

-- Replacing long output clamps its window view before synchronous buffer
-- listeners can observe line numbers that no longer exist.
local output_module = require("runner.output")
local long_output = {}
for line = 1, 300 do
  long_output[line] = "line " .. line
end
output_module.replace(long_output)
local output_window = vim.fn.bufwinid(output_buffer)
vim.api.nvim_win_set_cursor(output_window, { 270, 0 })
output_module.replace({ "short output" })
assert(vim.api.nvim_win_get_cursor(output_window)[1] == 1, "output cursor was not clamped before replacement")
assert(vim.api.nvim_buf_line_count(output_buffer) == 1, "long output was not replaced")

-- q closes the output window but preserves its buffer for recall.
vim.api.nvim_set_current_win(output_window)
local q_map = vim.fn.maparg("q", "n", false, true)
assert(type(q_map) == "table" and q_map.buffer == 1, "q is not mapped in the output buffer")
vim.api.nvim_feedkeys("q", "mx", false)
assert(not vim.api.nvim_win_is_valid(output_window), "q did not close the output window")
assert(vim.api.nvim_buf_is_valid(output_buffer), "q discarded the output buffer")

-- The output-local CTRL-C mapping stops a long-running process.
runner.setup({ output = { layout = "horizontal", focus = true } })
runner.run(fixture .. "/slow.sh")
assert(vim.wait(1000, function()
  local text = table.concat(vim.api.nvim_buf_get_lines(output_buffer, 0, -1, false), "\n")
  return text:find("started", 1, true) ~= nil
end, 10), "slow runner did not start")
vim.api.nvim_win_close(vim.api.nvim_get_current_win(), false)
assert(runner.show_output(), "existing output buffer was not recalled")
assert(vim.api.nvim_get_current_buf() == output_buffer, "recalled window does not show the output buffer")
assert(vim.fn.exists(":RunCodeOutput") == 2, "RunCodeOutput command was not registered")
for _, mode in ipairs({ "n", "i", "v" }) do
  local ctrl_c = vim.fn.maparg("<C-C>", mode, false, true)
  assert(type(ctrl_c) == "table" and ctrl_c.buffer == 1, "CTRL-C is not mapped in mode " .. mode)
end
vim.api.nvim_feedkeys(vim.keycode("<C-c>"), "mx", false)
assert(vim.wait(1000, function()
  local text = table.concat(vim.api.nvim_buf_get_lines(output_buffer, 0, -1, false), "\n")
  return text:find("[process stopped]", 1, true) ~= nil
end, 10), "CTRL-C did not stop the process")
assert(not vim.bo[output_buffer].modified, "stopped output buffer was marked as modified")

-- Every run restores the mapping after buffer/window lifecycle hooks.
for _, mode in ipairs({ "n", "i", "v" }) do
  pcall(vim.keymap.del, mode, "<C-c>", { buffer = output_buffer })
end
runner.run(fixture .. "/slow.sh")
assert(vim.wait(1000, function()
  local text = table.concat(vim.api.nvim_buf_get_lines(output_buffer, 0, -1, false), "\n")
  return text:find("started", 1, true) ~= nil
end, 10), "second slow runner did not start")
for _, mode in ipairs({ "n", "i", "v" }) do
  local ctrl_c = vim.fn.maparg("<C-C>", mode, false, true)
  assert(type(ctrl_c) == "table" and ctrl_c.buffer == 1, "CTRL-C was not restored in mode " .. mode)
end
vim.api.nvim_feedkeys(vim.keycode("<C-c>"), "mx", false)
assert(vim.wait(1000, function()
  local text = table.concat(vim.api.nvim_buf_get_lines(output_buffer, 0, -1, false), "\n")
  return text:find("[process stopped]", 1, true) ~= nil
end, 10), "CTRL-C did not stop the second process")

-- Closing the split allows the configured float layout to create a float.
vim.api.nvim_win_close(vim.api.nvim_get_current_win(), false)
local source_window = vim.api.nvim_get_current_win()
runner.setup({ output = { layout = "float", focus = true } })
runner.run(fixture .. "/coderunner.sh")
local float_window = vim.api.nvim_get_current_win()
assert(vim.api.nvim_win_get_config(0).relative == "editor", "float output window was not created")
assert(vim.wait(3000, function()
  local text = table.concat(vim.api.nvim_buf_get_lines(output_buffer, 0, -1, false), "\n")
  return text:find("[process exited 0]", 1, true) ~= nil
end, 10), "runner did not finish in the float")
vim.api.nvim_set_current_win(source_window)
assert(vim.wait(1000, function()
  return not vim.api.nvim_win_is_valid(float_window)
end, 10), "float output window did not close after losing focus")
assert(vim.api.nvim_buf_is_valid(output_buffer), "closing the float discarded the output buffer")

-- Buffer layout shows output in the current window without making a split.
runner.setup({ output = { layout = "buffer" } })
local source_buffer = vim.api.nvim_get_current_buf()
runner.run(fixture .. "/coderunner.sh")
assert(vim.api.nvim_get_current_buf() == output_buffer, "buffer layout did not show the output buffer")
assert(#vim.api.nvim_tabpage_list_wins(0) == 1, "buffer layout unexpectedly created a window")
vim.api.nvim_feedkeys("q", "mx", false)
assert(vim.api.nvim_get_current_buf() == source_buffer, "q did not restore the source buffer")
assert(vim.api.nvim_buf_is_valid(output_buffer), "q discarded output from the buffer layout")

print("runner.nvim smoke test: ok")
