local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local capi = { keygrabber = keygrabber }
local gears = require("gears")
local beautiful = require("beautiful")
local awesomebuttons = require("awesome-buttons.awesome-buttons")

local CONFIG_DIR = gears.filesystem.get_configuration_dir()
local WIDGET_DIR = CONFIG_DIR .. "custom-widgets/buttons/widget"

local font = "Terminus 14"
local font_bigger = "Terminus 16"

-- CALLBACK DEFINE

local onlogout = function () naughty.notify {text = "log out"} end

local ewh = function ()
    naughty.notify {
        title = "Ewh",
        text = "System of a down"
    }
end

local pycharm = function ()
    awful.spawn.with_shell("pycharm")
end

local spotify = function ()
    awful.spawn.with_shell("spotify")
end

---

local function category_widget(title) 
    local _w = wibox.widget {
        text = title,
        font = font,
        widget = wibox.widget.textbox,
    }
    return _w
end


local w = wibox {
    max_widget_size = 500,
    ontop = true,
    bg = "#111111",
    height = 400,
    border_width = 5,
    border_color = "#00ff00",
    width = 800,
    shape = function(cr, width, height)
        gears.shape.rectangle(cr, width, height)
    end
}

local action = wibox.widget {
    text = " ",
    font = font,
    widget = wibox.widget.textbox,
}

local title_widget = wibox.widget {
    text = "Where there is a shell, there is always a way",
    font = "Terminus 19",
    align = "center",
    widget = wibox.widget.textbox,
}

local function create_button(args)

    local button = awesomebuttons.with_icon {
        type = "basic",
        icon = args.icon_name,
        color = args.color or accent_color,
        icon_size = args.icon_size or icon_size,
        icon_margin = args.icon_margin or icon_margin,
        shape = args.shape or "rounded_rect",
        onclick = function() 
            args.on_click()
            w.visible = false,
            capi.keygrabber.stop()
        end
    }

    button:connect_signal("mouse::enter", function(c) action:set_text(args.action_name) end)
    button:connect_signal("mouse::leave", function(c) action:set_text(" ") end)
    
    return button
end

local function launch(args)

    local bg_color = "#333333"
    local accent_color = beautiful.bg_focus
    local text_color = "#00ff00"
    local phrases = "Where there is a shell, there is always a way"
    local icon_size = icon_size or 25
    local icon_margin = icon_margin or 10
    local spacing = 20

    title_widget:set_markup_silently("<span weight='bold' color='" .. text_color .. "' size='20000'>" .. phrases .. "</span>")

    local system_widgets = wibox.widget {
        {
            category_widget("SYSTEM:"),
            create_button {
                icon_name = 'gitlab', 
                action_name = 'Ewhhhh !', 
                color = "#f48",
                on_click = ewh
            },
            create_button {
                icon_name = 'log-out', 
                action_name = 'Logout (l)',
                color = "#218", 
                on_click = onlogout
            },
            create_button {
                icon_name = 'wifi', 
                action_name = 'Wifi',
                color = accent_color,
                on_click = onlogout
            },
            create_button {
                icon_name = 'box',
                action_name = 'Pycharm', 
                color = accent_color, 
                on_click = pycharm
            },
            valign = "center",
            id = "system",
            spacing = spacing,
            layout = wibox.layout.fixed.horizontal
        },
        valign = "center",
        layout = wibox.layout.fixed.horizontal
    }

    local music_widgets = wibox.widget {
            category_widget("MUSIC:"),
            create_button {
                icon_name = 'box', 
                action_name = 'Spotify', 
                color = accent_color, 
                on_click = spotify, 
                shape = "circle"
            },
            create_button {
                icon_name = 'log-out', 
                action_name = 'Logout (l)',
                color = "#218", 
                on_click = onlogout
            },
            create_button {
                icon_name = 'wifi', 
                action_name = 'Wifi', 
                color = accent_color,
                on_click = onlogout, 
            },
            create_button {
                icon_name = 'box', 
                action_name = 'Pycharm', 
                color = accent_color,
                on_click = pycharm
            },
            valign = "center",
            id = "system",
            spacing = spacing,
            layout = wibox.layout.fixed.horizontal
    }

    local info_widgets = wibox.widget {
        category_widget("SYS:"),
        create_button {
            icon_name = "battery-charging",
            action_name = "Charging",
            on_click = function() end
        },
        create_button {
            icon_name = "bluetooth",
            action_name = "Turn on/off bluetooth",
            on_click = function()
                local cmd_to_run = "bluetoothctl power on"
                naughty.notify {
                    title = "Running command",
                    text = cmd_to_run,
                    margin = 10
                }
                awful.spawn.with_shell(cmd_to_run)

            end
        },
        create_button {
            icon_name = "wifi",
            action_name = "Turn on/off wifi",
            on_click = function()
                local cmd_to_run = "run me",
                naughty.notify {
                    title = "Running command",
                    text = cmd_to_run,
                    margin = 10
                }
            end
        },
        align = "center",
        spacing = spacing,
        layout = wibox.layout.fixed.horizontal
    }

    local main_widget = wibox.widget {
            homogeneous = True,
            spacing = 15,
            min_cols_size = 10,
            min_rows_size = 10,
            layout = wibox.layout.grid
    }

    local separator_widget = wibox.widget {
        text = "",
        widget = wibox.widget.textbox
    }

    main_widget:add_widget_at(title_widget, 1, 1, 1, 12)
    main_widget:add_widget_at(separator_widget, 2, 1, 1, 12)
    main_widget:add_widget_at(system_widgets, 3, 3, 1, 12)
    main_widget:add_widget_at(music_widgets, 4, 3, 1, 12)
    main_widget:add_widget_at(separator_widget, 5, 1, 1, 12)
    main_widget:add_widget_at(info_widgets, 6, 3, 1, 12)


    w:setup {
        -- Array of widget
        -- First widget: contains subwidgets
        main_widget,
        id = "a",
        shape_border_width = 1,
        valign = "center",
        layout = wibox.container.place
    }

    w.visible = true

    awful.placement.centered(w, { margins = { top = -100 }, parent = awful.screen.focused() })

end

local function widget(args) 
    return nil
end

return {
    launch = launch,
    widget = widget
}
