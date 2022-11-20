local colorscheme = "tokyonight"

local tokyo_status, tokyonight = pcall(require, "tokyonight")
if not tokyo_status then
    vim.notify("colorscheme " .. colorscheme .. " not found!")
end

tokyonight.setup({
    --[[ style = "moon", ]]
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
    },
    sidebars = { "qf", "vista_kind", "terminal", "packer" },
})

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
