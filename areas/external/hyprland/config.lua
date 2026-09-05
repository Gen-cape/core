hl.config({
	env = {
		"XDG_CURRENT_DESKTOP,Hyprland",
		"XDG_SESSION_DESKTOP,Hyprland",
		"XDG_SESSION_TYPE,wayland",
		"GDK_BACKEND,wayland,x11",
		"QT_QPA_PLATFORM,wayland;xcb",
		"MOZ_ENABLE_WAYLAND,1",
		"ELECTRON_OZONE_PLATFORM_HINT,auto",
	},

	monitor = {
		", preferred, auto, 1.6, vrr, 1",
	},

	general = {
		border_size = 2,
		gaps_in = 5,
		-- Adapted from Mango's gappov=12 and gappoh=22
		gaps_out = { top = 12, right = 22, bottom = 12, left = 22 },
		layout = "scroller",
	},

	input = {
		kb_layout = "us,ru",
		kb_options = "grp:win_space_toggle",
		repeat_rate = 50,
		repeat_delay = 300,
		numlock_by_default = true,
		left_handed = false,
		sensitivity = 0.6,

		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.422,
		},
	},

	decoration = {
		rounding = 13,
		blur = {
			enabled = true,
			size = 4,
			passes = 2,
		},
		shadow = {
			enabled = true,
		},
	},

	animations = {
		enabled = true,
		-- 400ms slide animation translated for Hyprland (4 deciseconds)
		bezier = {
			"mangoSlide, 0.4, 0.0, 0.2, 1.0",
		},
		animation = {
			"windows, 1, 4, mangoSlide, slide",
			"windowsOut, 1, 4, mangoSlide, slide",
			"workspaces, 1, 4, mangoSlide, slide",
		},
	},

	xwayland = {
		force_zero_scaling = true,
	},

	misc = {
		vrr = 1,
		disable_hyprland_logo = true,
	},
})

-- =============================================================================
-- Autostart
-- =============================================================================

hl.on("hyprland.start", function()
	local autostart_cmds = {
		"echo 'Xft.dpi: 154' | xrdb -merge",
		"noctalia",
	}
	for _, cmd in ipairs(autostart_cmds) do
		hl.exec_cmd(cmd)
	end
end)

-- =============================================================================
-- Layer & Window Rules
-- =============================================================================

hl.layer_rule({
	name = "noctalia",
	match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$" },
	no_anim = true,
	blur = true,
	ignore_alpha = 0.5,
})

hl.window_rule({
	match = { class = "^(float_term)$" },
	float = true,
	center = true,
})

hl.window_rule({
	match = { title = "^(Firefox — Sharing Indicator)$" },
	float = true,
	opacity = 0,
	no_focus = true,
})

-- =============================================================================
-- Keybindings Helper
-- =============================================================================
local function set_binds(binds)
	for _, b in ipairs(binds) do
		hl.bind(b[1], b[2], b[3])
	end
end

set_binds({
	-- Core Apps & Actions
	{ "SUPER + CTRL + S", hl.dsp.exec_cmd("sh -c 'satty-screenshot'") },
	{ "SUPER + SHIFT + G", hl.dsp.exec_cmd("hyprctl switchxkblayout all next") },
	{ "SUPER + W", hl.dsp.exec_cmd("hyprctl dispatch cyclenext") },
	{ "SUPER + S", hl.dsp.exec_cmd("hyprctl dispatch cycleprev") },
	{ "SUPER + P", hl.dsp.window.float({ action = "toggle" }) },
	{ "SUPER + SHIFT + P", hl.dsp.window.pin() },
	{ "SUPER + SHIFT + S", hl.dsp.exec_cmd("noctalia msg screenshot-region") },
	{ "SUPER + SHIFT + E", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard") },
	{ "SUPER + B", hl.dsp.exec_cmd("alacritty -e btop") },
	{ "SUPER + Return", hl.dsp.exec_cmd("alacritty") },
	{ "SUPER + SHIFT + Q", hl.dsp.window.close() },
	{ "SUPER + V", hl.dsp.window.float({ action = "toggle" }) },
	{ "SUPER + F", hl.dsp.window.fullscreen() },
	{ "SUPER + R", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher") },
	{ "SUPER + T", hl.dsp.exec_cmd("hyprctl reload") },
	{ "SUPER + E", hl.dsp.exec_cmd("alacritty -e yazi") },
	{ "SUPER + O", hl.dsp.exec_cmd("alacritty -e nvim ~/.config/hypr/hyprland.lua") },
	{ "SUPER + Z", hl.dsp.exec_cmd("alacritty") },

	-- Focus Movement
	{ "SUPER + Left", hl.dsp.focus({ direction = "l" }) },
	{ "SUPER + Right", hl.dsp.focus({ direction = "r" }) },
	{ "SUPER + Up", hl.dsp.focus({ direction = "u" }) },
	{ "SUPER + Down", hl.dsp.focus({ direction = "d" }) },

	-- Screen Capture
	{ "Print", hl.dsp.exec_cmd("sh -c 'grim - | wl-copy'") },

	-- Media & Hardware Controls
	{
		"XF86AudioRaiseVolume",
		hl.dsp.exec_cmd("pamixer -i 5 --allow-boost --set-limit 200"),
		{ repeating = true, locked = true },
	},
	{
		"XF86AudioLowerVolume",
		hl.dsp.exec_cmd("pamixer -d 5 --allow-boost --set-limit 200"),
		{ repeating = true, locked = true },
	},
	{ "XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"), { locked = true } },
	{
		"XF86MonBrightnessUp",
		hl.dsp.exec_cmd("brightnessctl -c backlight s 5%+"),
		{ repeating = true, locked = true },
	},
	{
		"XF86MonBrightnessDown",
		hl.dsp.exec_cmd("brightnessctl -c backlight s 5%-"),
		{ repeating = true, locked = true },
	},

	-- Mouse Drag & Resize
	{ "SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true } },
	{ "SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true } },
})

-- =============================================================================
-- Dynamic/Looped Keybindings
-- =============================================================================

-- Workspaces 1-10 Switching & Moving
for i = 1, 9 do
	hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))
