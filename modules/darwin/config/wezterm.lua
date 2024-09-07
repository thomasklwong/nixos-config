local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Darcula (base16)'

config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

config.unicode_version = 14
config.ui_key_cap_rendering = "AppleSymbols"

config.window_background_opacity = 0.9
config.macos_window_background_blur = 20

-- config.window_background_image = '/path/to/wallpaper.jpg'
-- config.window_background_image_hsb = {
--     -- Darken the background image by reducing it to 1/3rd
--     brightness = 0.3,
--     -- You can adjust the hue by scaling its value.
--     -- a multiplier of 1.0 leaves the value unchanged.
--     hue = 1.0,
--     saturation = 1.0,
-- };

config.window_frame = {
    font = wezterm.font { family = 'JetBrains Mono', weight = 'Bold' },
    -- font_size = 12.0,
    -- active_titlebar_bg = '#555555',
    -- inactive_titlebar_bg = '#333333',
}

config.inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
}

config.colors = {
    tab_bar = {
        -- The color of the inactive tab bar edge/divider
        inactive_tab_edge = '#575757',
    },
}

wezterm.on('update-right-status', function(window, pane)
    -- "Wed Mar 3 08:14"
    local date = wezterm.strftime '%a %b %-d %H:%M '

    local bat = ''
    for _, b in ipairs(wezterm.battery_info()) do
        bat = '🔋 ' .. string.format('%.0f%%', b.state_of_charge * 100)
    end

    window:set_right_status(wezterm.format {
        { Text = bat .. '   ' .. date },
    })
end)

return config
