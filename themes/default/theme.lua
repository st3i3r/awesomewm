---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font          = "Terminus Medium 14"

theme.bg_normal     = "#000000aa"
theme.bg_focus      = "#20ab1d"
theme.bg_urgent     = "#ff0000"
--theme.bg_minimize   = "#0000A444"
theme.bg_minimize   = "#00527a55"
theme.bg_systray    = "#ffffff"

theme.fg_normal     = "#cccccc"
theme.fg_focus      = "#000000"
theme.fg_urgent     = "#cccccc"
theme.fg_minimize   = "#aaaaaa"

theme.useless_gap   = dpi(5)
theme.border_width  = dpi(5)
-- theme.border_focus = "#3d86ff" -- blue
theme.border_focus = "#20ab1d" -- green
theme.border_normal  = "#0dabd6"
--theme.border_marked = "#00ff00"
--theme.prompt_fg  	= "#cccccc"
--theme.prompt_bg			= "#222222"
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
theme.taglist_bg_focus = "#20ab1d"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_border_color 	= "#aaaaaa"
theme.notification_border_width		= dpi(1)
theme.notification_bg				= "#000000dd"
theme.notification_fg				= "#cccccc"
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_fg_focus = "#000000"
theme.menu_submenu_icon = "~/.config/awesome/themes/default/arrow.png"
theme.menu_height = dpi(25)
theme.menu_width  = dpi(150)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
theme.bg_widget = "#ff0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path .. "default/titlebar/maximized_focus_active.png"


theme.widget_temp                               = "/home/viet/.config/awesome/themes/default/icons/temp.png"
theme.widget_uptime                             = "/home/viet/.config/awesome/themes/default/icons/ac.png"
theme.widget_cpu                                = "/home/viet/.config/awesome/themes/default/icons/cpu.png"
theme.widget_weather                            = "/home/viet/.config/awesome/themes/default/icons/dish.png"
theme.widget_mem                                = "/home/viet/.config/awesome/themes/default/icons/mem.png"
theme.widget_netdown                            = "/home/viet/.config/awesome/themes/default/icons/net_down.png"
theme.widget_netup                              = "/home/viet/.config/awesome/themes/default/icons/net_up.png"
theme.widget_batt                               = "/home/viet/.config/awesome/themes/default/icons/bat.png"
theme.widget_clock                              = "/home/viet/.config/awesome/themes/default/icons/clock.png"
theme.widget_vol                                = "/home/viet/.config/awesome/themes/default/icons/spkr.png"
theme.taglist_squares_sel                       = "/home/viet/.config/awesome/themes/default/icons/square_a.png"
theme.taglist_squares_sel                       = "/home/viet/.config/awesome/themes/default/icons/square_a.png"
theme.wallpaper = "~/.config/awesome/images/wallpaper.jpg"

-- You can use your own layout icons like this:
--[[
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"
--]]

theme.layout_tile                               = "/home/viet/.config/awesome/themes/default/icons/tile.png"
theme.layout_tilegaps                           = "/home/viet/.config/awesome/themes/default/icons/tilegaps.png"
theme.layout_tileleft                           = "/home/viet/.config/awesome/themes/default/icons/tileleft.png"
theme.layout_tilebottom                         = "/home/viet/.config/awesome/themes/default/icons/tilebottom.png"
theme.layout_tiletop                            = "/home/viet/.config/awesome/themes/default/icons/tiletop.png"
theme.layout_fairv                              = "/home/viet/.config/awesome/themes/default/icons/fairv.png"
theme.layout_fairh                              = "/home/viet/.config/awesome/themes/default/icons/fairh.png"
theme.layout_spiral                             = "/home/viet/.config/awesome/themes/default/icons/spiral.png"
theme.layout_dwindle                            = "/home/viet/.config/awesome/themes/default/icons/dwindle.png"
theme.layout_max                                = "/home/viet/.config/awesome/themes/default/icons/max.png"
theme.layout_fullscreen                         = "/home/viet/.config/awesome/themes/default/icons/fullscreen.png"
theme.layout_magnifier                          = "/home/viet/.config/awesome/themes/default/icons/magnifier.png"
theme.layout_floating                           = "/home/viet/.config/awesome/themes/default/icons/floating.png"

-- Generate Awesome icon:
--theme.awesome_icon = theme_assets.awesome_icon(
--    theme.menu_height, theme.bg_focus, theme.fg_focus
--)
theme.awesome_icon = "~/.config/awesome/themes/default/arch.png"
-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil


return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
