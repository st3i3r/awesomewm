-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local lain = require("lain")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
local vicious = require("vicious")

local os = os
local theme        = {}
local gfs = require("gears.filesystem")
local config_path = gfs.get_configuration_dir()
local markup = lain.util.markup

-- Custom stuffs
local custom_buttons  = require("custom-widgets.buttons.buttons")

theme.font				= "Terminus Medium 12"

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(config_path .. "themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "mate-terminal"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   --{ "manual", terminal .. " -e man awesome" },
   --{ "edit config", editor_cmd .. " " .. awesome.conffile },
   { "reset", awesome.restart },
   { "quit", function() awesome.quit() end},
   { "restart", '/sbin/reboot'},
   { "shutdown", '/sbin/shutdown now' }

}

internet = {
  { "Firefox", "firefox" },
  { "Chromium", "chromium"},
  { "Email", terminal .. " -e mutt" },

}
multimedia = {
  { "Media Player", terminal .. " -e mocp" },
  { "VLC", "vlc" },
  { "Screenshot", "xfce4-screenshooter" },
}
develope = {
  { "Office", "libreoffice" },
  { "KdenLive", "kdenlive" },
  { "Coms" , "mumble" },
  { "Weechat" , terminal .. " -e weechat" },
}
game = {
  { "Steam", "steam" },
}
utilities = {
  { "Ranger",terminal .. " -e ranger"},
  { "Sublime Text", subl},
  { "Vim", "urxvt -e vim" },
  { "Term", terminal },
}





mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()



-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 2, function(c) c:kill() end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end


theme.widget_temp                               = config_path .. "themes/default/icons/temp.png"
theme.widget_uptime                             = config_path .. "themes/default/icons/ac.png"
theme.widget_cpu                                = config_path .. "themes/default/icons/cpu.png"
theme.widget_mem                                = config_path .. "themes/default/icons/mem.png"
theme.widget_net                                = config_path .. "themes/default/icons/net.png"
theme.widget_vol                                = config_path .. "themes/default/icons/vol.png"
theme.widget_music                              = config_path .. "themes/default/icons/note.png"



-- Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local mytextclock = wibox.widget.textclock(markup("#7788af", " %A %d %B ") .. markup("#ab7367", ">") .. markup("#de5e1e", " %H:%M "))
mytextclock.font = theme.font

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { mytextclock },
    followtag = true,
    notification_preset = {
        fg   = "#bbbbbb",
        bg   = "#000000"
    }
})

local batteryarc_widget = require("custom-widgets.battery.batteryarc")

local LIGHT_BG = "#222222"
local DARK_BG = "#000000"

-- Coretemp
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp = lain.widget.temp({
    settings = function()
widget:set_markup(markup.fontfg(theme.font, "#bbbbbb", coretemp_now .. "°C"))
end
})

-- MPC
local mpdicon = wibox.widget.imagebox(theme.widget_music)
local mpc = require("custom-widgets.mpc.mpc")
local textbox = require("wibox.widget.textbox")
local timer = require("gears.timer")
local mpd_widget = textbox('')
local state, title, artist, file = "stop", "", "", ""
local notification
local function update_widget()
	local text = " "
	text = text .. tostring(title or "") .. " - " .. tostring(artist or "") .. " "
	if state == "play" then
        naughty.destroy(notification)
		notification = naughty.notify({
            title="Now playing"
            , text=text
            , fg="#ffff00"
            , bg="#000000"
            , border_color="#ffff00"
            , font=theme.font
            , margin=5
            , timeout=5
		})
	end 
	if state == "pause" then
		text = " (paused) "
	end
	if state == "stop" then
	text =  ""
	end
	mpd_widget.text = text 
    mpd_widget.font = theme.font
end

local connection
local function error_handler(err)
	mpd_widget:set_text("Error: " .. tostring(err))
	-- Try a reconnect soon-ish
	timer.start_new(10, function()
	connection:send("ping")
	end)
	end
	connection = mpc.new(nil, nil, nil, error_handler, "status", function(_, result)
	state = result.state end, "currentsong", function(_, result) title, artist, file = result.title, result.artist, result.file pcall(update_widget)
	end)
	mpd_widget:buttons(awful.button({}, 1, function() connection:toggle_play() end))


-- Volume
local volicon = wibox.widget.imagebox(theme.widget_vol)
volicon:connect_signal("button::press", function(_,_,_,button)
	if (button == 4)     then awful.spawn("amixer sset Master 5%+", false)
	elseif (button == 5) then awful.spawn("amixer sset Master 5%-", false)
	elseif (button == 1) then awful.spawn("amixer sset Master toggle", false)
end 
end)

volume = wibox.widget.textbox()
volume.font = theme.font
volume.valign = "center"
vicious.register(volume, vicious.widgets.volume, '<span color="#bbbbbb">$1%</span>', 0.1, "Master")
volume:connect_signal("button::press", function(_,_,_,button)
	if (button == 4)     then awful.spawn("amixer sset Master 5%+", false)
	elseif (button == 5) then awful.spawn("amixer sset Master 5%-", false)
	elseif (button == 1) then awful.spawn("amixer sset Master toggle", false)
	end 
end)


-- MEM
memicon = wibox.widget.imagebox(theme.widget_mem)
memwidget = wibox.widget.textbox()
memwidget.font = theme.font
vicious.register(memwidget, vicious.widgets.mem, '<span color="#bbbbbb">$2M</span>', 2)

-- CPU

local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
cpuwidget = wibox.widget.textbox()
cpuwidget.font = theme.font
vicious.register(cpuwidget, vicious.widgets.cpu, '<span color="#bbbbbb">$1%</span>', 2)


-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local netdowninfo = wibox.widget.textbox()
local netinfo = lain.widget.net({
    settings = function()
        netdowninfo:set_markup(markup.fontfg(theme.font, "#bbbbbb", " " .. net_now.received))
    end
})

local separators = lain.util.separators
local my_table = awful.util.table or gears.table

-- Separators
local arrow = separators.arrow_left
local space = wibox.widget.textbox(" ")

function theme.powerline_rl(cr, width, height)
    local arrow_depth, offset = height/2, 0

    -- Avoid going out of the (potential) clip area
    if arrow_depth < 0 then
        width  =  width + 2*arrow_depth
        offset = -arrow_depth
    end

    cr:move_to(offset + arrow_depth         , 0        )
    cr:line_to(offset + width               , 0        )
    cr:line_to(offset + width - arrow_depth , height/2 )
    cr:line_to(offset + width               , height   )
    cr:line_to(offset + arrow_depth         , height   )
    cr:line_to(offset                       , height/2 )

    cr:close_path()
end

local function pl(widget, bgcolor, padding)
    return wibox.container.background(wibox.container.margin(widget, 16, 16), bgcolor, theme.powerline_rl)
end



-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen hasits own tag table.
    awful.tag({ " ✡ ", " ♬ ", " ⌗ " , " ₪ ", " 0 "}, s, awful.layout.layouts[2])
	
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 30 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            space,
            mylauncher,
            space,
            s.mytaglist,
            s.mypromptbox,
        },
            s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- mykeyboardlayout,
            wibox.widget.systray(),
            wibox.container.background(wibox.container.margin(wibox.widget { mpdicon, mpd_widget, layout = wibox.layout.align.horizontal }, 5, 5), LIGHT_BG),
            -- wibox.container.background(wibox.container.margin(wibox.widget { weathericon, theme.weather.widget, layout = wibox.layout.align.horizontal }, 1, 1), "#777E76"),
            -- arrow("#333333", "#111111"),
            wibox.container.background(wibox.container.margin(wibox.widget { neticon, netdowninfo, layout = wibox.layout.align.horizontal }, 10, 10), DARK_BG),
            -- arrow("#111111", "#333333"),
            wibox.container.background(wibox.container.margin(wibox.widget { memicon, memwidget, layout = wibox.layout.align.horizontal }, 3, 10), LIGHT_BG),
            -- arrow("#333333", "#111111"),
            wibox.container.background(wibox.container.margin(wibox.widget { cpuicon, cpuwidget, layout = wibox.layout.align.horizontal }, 5, 10), DARK_BG),
            -- arrow("#111111", "#333333"),
            wibox.container.background(wibox.container.margin(wibox.widget { tempicon, temp.widget, layout = wibox.layout.align.horizontal }, 3, 10), LIGHT_BG),
            -- arrow("#333333", "#111111"),
            wibox.container.background(wibox.container.margin(wibox.widget { volicon, volume, layout = wibox.layout.align.horizontal }, 5, 10), DARK_BG),
            -- arrow("#111111", "#333333"),
            -- wibox.container.background(wibox.container.margin(wibox.widget { baticon, batwidget, layout = wibox.layout.align.horizontal }, 1, 1), "#333333"),
            wibox.container.background(wibox.container.margin(batteryarc_widget({ bat = 0 }), 5, 0), LIGHT_BG),
            wibox.container.background(wibox.container.margin(batteryarc_widget({ bat = 1 }), -3, 5), LIGHT_BG),
            -- arrow("#333333", "#000000"),

            wibox.container.background(wibox.container.margin(mytextclock, 5, 5), DARK_BG),
            s.mylayoutbox,
        },
    }
end)

-- {{{ Mouse bindings
root.buttons(gears.table.join(

    awful.button({ }, 3, function (c) mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
--
--

local brightness_notification
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,     "Mod1"      }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,      "Mod1"      }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Take a screenshot
    -- https://github.com/lcpz/dots/blob/master/bin/screenshot
    awful.key({}, "Print", function() awful.util.spawn("scrot -q 100 -u '%d-%m-%Y-%H:%M:%S.png' -e 'mv $f ~/Pictures/Screenshot/'") end,
              {description = "take a screenshot", group = "hotkeys"}),

    -- X screen locker
    awful.key({"Mod1", "Control"}, "l", function () 
    	awful.util.spawn(config_path .. "script/lock.sh", false) end,
              {description = "lock screen", group = "hotkeys"}),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),
    awful.key({ modkey           }, "w", function () mymainmenu:show() end,
{description = "show main menu", group = "awesome"}),

   
    -- Volume Keys
   awful.key({}, "XF86AudioLowerVolume", function ()
     awful.util.spawn("amixer  sset Master 3%-", false)
   end),
   awful.key({}, "XF86AudioRaiseVolume", function ()
     awful.util.spawn("amixer sset Master 3%+", false)
   end),
   awful.key({}, "XF86AudioMute", function ()
     awful.util.spawn("amixer  set Master toggle", false)
   end),


   -- Media Keys
   awful.key({}, "XF86AudioStop", function()
     awful.spawn.with_shell("mpc stop && playerctl stop ", false)
   end),
   awful.key({}, "XF86AudioPlay", function()
     awful.spawn.with_shell("mpc toggle || playerctl play-pause", false)
   end),
   awful.key({}, "XF86AudioNext", function()
     awful.spawn.with_shell("mpc next || playerctl next ", false)
   end),
   awful.key({}, "XF86AudioPrev", function()
     awful.spawn.with_shell("playerctl previous || mpc prev", false)
   end),

	-- Meida Keys for ThinkPad
	   awful.key({"Control"}, "<", function()
     awful.spawn.with_shell("mpc toggle || playerctl play-pause", false)
   end),
	   awful.key({"Control", "Shift"}, "<", function()
     awful.spawn.with_shell("mpc prev || playerctl prev", false)
   end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,     "Shift"      }, "Right",     function () awful.tag.incmwfact( 0.025)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,     "Shift"       }, "Left",     function () awful.tag.incmwfact(-0.025)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey,    "Shift"        }, "Up",     function () awful.client.incwfact(0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,      "Shift"      }, "Down",     function () awful.client.incwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey,    }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey,    }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),


    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),


    -- Brightness
    awful.key({ }, "XF86MonBrightnessUp", 
	function () 
			awful.spawn("xbacklight -inc 1") 
			local b_capacity = assert(io.open("/sys/class/backlight/intel_backlight/brightness", "r"))
  			local brightness_level = tonumber(b_capacity:read("*all"))
            naughty.destroy(brightness_notification)
    		brightness_notification = naughty.notify({ title      = "Brightness"
      		, text       =  "Brightness level: " .. math.ceil(brightness_level/15.2) .. "%"
      		, fg="#bbbbbb"
      		, bg="#000000"
      		, timeout    = 2 
    		})
	end, {description = "increase brightness", group = "custom"}),

    awful.key({ }, "XF86MonBrightnessDown", 
	function () 
			awful.spawn("xbacklight -dec 1") 
			local b_capacity = assert(io.open("/sys/class/backlight/intel_backlight/brightness", "r"))
  			local brightness_level = tonumber(b_capacity:read("*all"))
            naughty.destroy(brightness_notification)
    		brightness_notification = naughty.notify({ title      = "Brightness", 
			text       =  "Brightness level: " .. math.ceil(brightness_level/15.2) .. "%",
      		fg="#bbbbbb",
      		bg="#000000",
      		timeout    = 2
    		})
	end, {description = "decrease brightness", group = "custom"}),

    -- Del
    awful.key({"Control"}, "Delete" , function () awful.spawn("xkill") end)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),
         
   -- working toggle titlebar
   awful.key({ modkey, "Control" }, "t", 
   		function (c) 
		   awful.titlebar.toggle(c)         
   		end, 
        {description = "Show/Hide Titlebars", group="client"}),

    -- Custom buttons
    awful.key({ modkey }, "b",
        function()
            custom_buttons.launch()
        end,
        { description = "Launch custom buttons", group = "custom" }
    )
)




-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}





-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "Firefox",
          "Dialog",  -- Firefox addon DownThemAll.
          "copyq", -- Includes session name in class.
		  "qt-app",
		  "test",
	},
        class = {
          "Arandr",
	  	   "Firefox",
          "Gpick",
		  "qt-app",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
	  "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
    	  "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    --{ rule = { class = "VirtualBox Machine" },
    --   properties = { screen = 1, tag = " ◧ " } },
    --{ rule = { class = "Firefox" },
    --   properties = { maximized = true } },
    { rule = { class = "Spotify" },
       properties = { maximized = true, tag = " ♬ " } },
    { rule = { class = "Vmware" },
       properties = { maximized = true } },
	{ rule = { class = "qt-app"},
		properties = {titlebars_enabled = true}	},
	{ rule = { class = "test"},
		properties = {titlebars_enabled = true}	},
    { rule = { class = "remmina" },
       properties = { maximized = true } },
    { rule = { class = "burp-StartBurp" },
       properties = { maximized = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            --awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            --awful.titlebar.widget.stickybutton   (c),
            --awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end

client.connect_signal("focus", border_adjust)
client.connect_signal("property::maximized", border_adjust)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
awful.spawn.with_shell(config_path .. "script/autorun.sh")
--
-- naughty.notify {
--     icon = "/home/viet/.config/awesome/mr-robot-quote.jpg",
--     icon_size = 400,
--     fg = "#20ab1d",
--     title = "Mr Robot",
--     text = "We’re all living in each other’s paranoia."
-- }
--
naughty.notify {
    icon = config_path .. "images/mr-robot-quote.jpg",
    icon_size = 350,
    fg = "#20ab1d",
    title = "UNIX",
    margin = 10,
    text = "Where there is a shell, there is a way",
    font = theme.font
}
