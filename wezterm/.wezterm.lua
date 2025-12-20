-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- config.disable_default_key_bindings = true

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
end

-- Color scheme
config.color_scheme = "Github Dark (Gogh)"

-- font
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.font_size = 12.0
end
if wezterm.target_triple == "aarch64-apple-darwin" then -- Apple specific font
	config.font = wezterm.font("TerminessTTF Nerd Font Mono")
	config.font_size = 16.0
end

-- Appearance
config.window_background_opacity = 0.7
config.macos_window_background_blur = 30

-- window & tab
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
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
	{ key = "t", mods = "SHIFT|ALT", action = wezterm.action.SpawnTab("DefaultDomain") },
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
