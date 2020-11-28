-------------------------------------------------
-- Battery Arc Widget for Awesome Window Manager
-- Shows the battery level of the laptop
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/batteryarc-widget

-- @author Pavel Makhov
-- @copyright 2020 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local AWESOME_DIR = gears.filesystem.get_configuration_dir()

local widget = {}

local function worker(args)

    local args = args or {}

    local arc_thickness = args.arc_thickness or 3
    local show_current_level = args.show_current_level or true
    local show_current_status = args.show_current_status or true
    local timeout = args.timeout or 90
    local font = "Terminus 8"
    local size = args.size or 20

    local main_color = args.main_color or beautiful.color
    local bg_color = args.bg_color or "#ffffff55"
    local low_level_color = args.low_level_color or "#e53935"
    local medium_level_color = args.medium_level_color or "#c0ca33"
    local charging_color = args.charging_color or "#32a047"

    local warning_msg_title = "Mr Robot, we have a problem"
    local warning_msg_text = "Battery is dying"
    local warning_msg_position = "top_right"
    local warning_msg_icon = AWESOME_DIR .. "/custom-widgets/battery/spaceman.jpg"
    local info_msg_icon = AWESOME_DIR .. "/custom-widgets/battery/spaceman.jpg"

    local bat_no = args.bat or 1 -- Battery 0 or battery 1

    local enable_warning = true

    local text = wibox.widget {
        font = font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local text_with_background = wibox.container.background(text)

    local widget = wibox.widget {
        text_with_background,
        max_value = 100,
        rounded_edge = true,
        thickness = arc_thickness,
        forced_height = size,
        forced_width = size,
        start_angle = 4.71238898, -- 2pi*3/4
        bg = bg_color,
        paddings = 2,
        widget = wibox.container.arcchart
    }

    widget_with_margin = wibox.container.margin(
        widget,
        6,
        6
    )

    local last_battery_check = os.time()

    local function update_widget(widget, stdout) 
        local charge = 0
        local another_bat_charge = 0
        local status, another_bat_status
        for s in stdout:gmatch("[^\r\n]+") do
            local cur_bat_no, cur_status, charge_str, time = string.match(s, '.+(%d): (%a+), (%d?%d?%d)%%,?(.*)')
            -- Only one battery
            if tonumber(cur_bat_no) == bat_no then
                if cur_status ~= nil and charge_str ~= nil then
                    local cur_charge = tonumber(charge_str)
                    if cur_charge > charge  then
                        charge = cur_charge
                        status = cur_status
                    end
                end
            else
                another_bat_status = cur_status
                another_bat_charge = tonumber(charge_str)
            end
        end

        widget.value = charge


        if show_current_level == true then
            text.text = charge < 10 and charge or ''
        else
            text.text = ''
        end

        -- Change icon text depends on status
        if status == "Charging" then
            widget.colors = { charging_color }
            text.text = '+'
        elseif status == "Discharging" then
            text.text = '-'
        end

        -- Change color, depends on charge level and warning
        if charge > 20 and charge < 40 then
            widget.colors = { medium_level_color }
        elseif charge < 20 then
            widget.colors = { low_level_color }
            if enable_warning and 
               status ~= "Charging" and 
               os.difftime(os.time(), last_battery_check) > timeout and 
               another_bat_charge < 20 and 
               another_bat_status ~= "Charging" then
                    -- warn every timeout = 2 mins
                    last_battery_check = os.time()
                    show_battery_warning()
            end
        else
            widget.colors = { main_color }
        end
    end

    watch("acpi", timeout, update_widget, widget)

    -- Battery status popup when hover
    local notification
    function show_battery_status()
        awful.spawn.easy_async([[bash -c 'acpi']],
            function(stdout, _, _, _)
                naughty.destroy(notification)
                notification = naughty.notify {
                    text = stdout,
                    icon = info_msg_icon,
                    icon_size = 150,
                    title = "Battery status",
                    timeout = 5,
                    margin = 10,
                    hover_timeout = 0.5,
                    width = 430,
                }
            end)
    end

    widget:connect_signal("mouse::enter", function()
        show_battery_status(bat_no)
    end)

    widget:connect_signal("mouse::leave", function()
        naughty.destroy(notification)
    end)

    -- Warning notifications
    function show_battery_warning()
        -- Custom centered notification
        local content = wibox.widget {
            text = "",
            align = "center",
            widget = wibox.widget.textbox
        }

        awful.spawn.easy_async([[bash -c 'acpi']],
            function(stdout, _, _, _)
                local filtered_stdout = ""
                for s in stdout:gmatch("[^\r\n]+") do
                    local cur_bat_no, cur_status, charge_str, time_str = string.match(s, ".+(%d): (%a+), (%d?%d?%d)%%?(.*)")
                    local tmp_stdout = "Battery " .. tostring(cur_bat_no) .. ": " .. tostring(charge_str) .. "%" .. tostring(time_str)
                    filtered_stdout = filtered_stdout .. tmp_stdout .. "\n\n"
                end
                content.text = filtered_stdout

            end)

        local w = wibox {
            bg = "#EF2929",
            fg = "#dddddd",
            max_widget_size = 500,
            opacity = 0.4,
            border_width = 6,
            border_color = "#cbcbcb",
            ontop = true,
            height = 200,
            width = 420,
            shape = function(cr, width, height)
                gears.shape.rectangle(cr, width, height)
            end
        }


        local title = wibox.widget {
            text = "SYSTEM WARNING ALERT !!!",
            align = "center",
            font = "Terminus Bold 19",
            widget = wibox.widget.textbox
        }

        local container_widget = wibox.widget {
            {
                title,
                layout = wibox.layout.flex.vertical
            },
            {
                content,
                layout = wibox.layout.fixed.vertical
            },
            layout = wibox.layout.ratio.vertical,
        }

        container_widget:set_ratio(1, 0.5, 0.5)
        local notification_timer = timer({timeout = 10})
        notification_timer:connect_signal(
            "timeout",
            function() 
                w.visible = false
            end
        )

        w:setup {
            container_widget,
            layout = wibox.layout.flex.vertical
        }

        w.screen = mouse.screen
        w.visible = true

        w:connect_signal("mouse::enter", function()
            w.visible = false
        end)

        awful.placement.centered(w, { margins = { top = -100 }} )
        notification_timer:start()
    end

    return widget_with_margin

end


return setmetatable(widget, { __call = function(_, ...) 
    return worker(...)
end })
