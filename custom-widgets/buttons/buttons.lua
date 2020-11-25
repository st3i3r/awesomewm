local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local capi = { keygrabber = keygrabber }
local gears = require("gears")
local beautiful = require("beautiful")
local awesomebuttons = require("awesome-buttons.awesome-buttons")

local CONFIG_DIR = gears.filesystem.get_configuration_dir()
local WIDGET_DIR = CONFIG_DIR .. "custom-widgets/buttons/widget"

local w = wibox {
    bg = beautiful.bg_normal,
    max_widget_size = 500,
    ontop = true,
    height = 400,
    width = 800,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 8)
    end
}

local action = wibox.widget {
    text = " ",
    widget = wibox.widget.textbox,
}

local phrase_widget = wibox.widget {
    text = "Where there is a shell, there is always a way",
    font = "Terminus 14",
    align = "center",
    widget = wibox.widget.textbox,
}

local function create_button(icon_name, action_name, color, on_click, icon_size, icon_margin)

    local button = awesomebuttons.with_icon {
        type = "basic",
        icon = icon_name,
        color = color,
        icon_size = icon_size,
        icon_margin = icon_margin,
        onclick = function() 
            on_click()
            w.visible = false,
            capi.keygrabber.stop()
        end
    }

    button:connect_signal("mouse::enter", function(c) action:set_text(action_name) end)
    button:connect_signal("mouse::leave", function(c) action:set_text(" ") end)
    
    return button
end

local function launch(args)

    local bg_color = beautiful.bg_normal
    local accent_color = beautiful.bg_focus
    local text_color = beautiful.fg_normal
    local phrases = {"Goodbye!"}
    local icon_size = icon_size or 40
    local icon_margin = icon_margin or 16
    local onlogout = function () naughty.notify {text = "log out"} end

    w:set_bg(bg_color)

    if #phrases > 100 then
        phrase_widget:set_markup_silently("<span color='" .. text_color .. "' size='20000'>")
    end

    w:setup {
        -- Array of widget
        -- First widget: contains subwidgets
        {
            phrase_widget,
            {
                {
                    create_button('log-out', 'Logout (l)', accent_color, onlogout, icon_size, icon_margin),
                    create_button('log-out', 'Logout (l)', accent_color, onlogout, icon_size, icon_margin),
                    create_button('log-out', 'Logout (l)', accent_color, onlogout, icon_size, icon_margin),
                    valign = "center",
                    id = "buttons",
                    spacing = 20,
                    layout = wibox.layout.fixed.horizontal
                },
                valign = "center",
                layout = wibox.layout.fixed.vertical
            },
            {
                action,
                halign = "center",
                layout = wibox.layout.fixed.vertical
            },
            spacing = 32,
            layout = wibox.layout.fixed.vertical
        },
        id = "a",
        shape_border_width = 1,
        valign = "center",
        layout = wibox.container.place
    }

    w.screen = mouse.screen
    w.visible = true

    awful.placement.centered(w)

end

local function widget(args) 
    return nil
end

return {
    launch = launch,
    widget = widget
}
