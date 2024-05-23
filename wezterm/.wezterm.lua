-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- config.disable_default_key_bindings = true

-- Color scheme
config.color_scheme = 'Github Dark (Gogh)'

-- font
config.font = wezterm.font("TerminessTTF Nerd Font Mono")
config.font_size = 16.0

-- Appearance
config.window_background_opacity = 0.7
config.macos_window_background_blur = 30

-- window & tab
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 20,
	right = 20,
	top = 20,
	bottom = 20,
}

-- keybindings
config.keys = {
	{ key = "p", mods = "CMD", action = wezterm.action.ActivateCommandPalette },
	-- Enter CopyMode
	{ key = "v", mods = "ALT", action = wezterm.action.ActivateCopyMode },
}

-- CopyMode
local copy_mode_key_bindings = {
	{ key = "/", mods = "NONE", action = wezterm.action.CopyMode("EditPattern") },
	{ key = "Enter", mods = "NONE", action = wezterm.action.CopyMode("AcceptPattern") },
	{ key = "n", mods = "NONE", action = wezterm.action.CopyMode("NextMatch") },
	{ key = "n", mods = "SHIFT", action = wezterm.action.CopyMode("PriorMatch") },
	{ key = "Escape", mods = "NONE", action = wezterm.action.CopyMode("Close") },
	{ key = "q", mods = "SHIFT", action = wezterm.action.CopyMode("Close") },
}
local copy_mode = nil
if wezterm.gui then
	copy_mode = wezterm.gui.default_key_tables().copy_mode
	for _, k in pairs(copy_mode_key_bindings) do
		table.insert(copy_mode, k)
	end
end

config.key_tables = {
	copy_mode = copy_mode,
	search_mode = {
		{ key = "Enter", mods = "NONE", action = wezterm.action.CopyMode("AcceptPattern") },
		{ key = "u", mods = "CTRL", action = wezterm.action.CopyMode("ClearPattern") },
		{ key = "Escape", mods = "NONE", action = wezterm.action.CopyMode("Close") },
	},
}

return config
