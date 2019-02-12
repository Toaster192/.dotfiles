
--[[

     Awesome WM configuration
     by alfunx (Alphonse Mariya)

--]]

-- {{{ Libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local cairo         = require("lgi").cairo
local gears         = require("gears")
local awful         = require("awful")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local menubar       = require("menubar")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local xresources    = require("beautiful.xresources")
local dpi           = xresources.apply_dpi
local config        = require("config")

require("awful.autofocus")
require("awful.remote")
-- }}}

-- Localization
os.setlocale(os.getenv("LANG"))

-- Define context
config.context = { }
local context = config.context

-- {{{ Variable definitions
context.theme                 = "blackout"

context.keys = { }
context.keys.modkey           = "Mod4"
context.keys.altkey           = "Mod1"
context.keys.ctrlkey          = "Control"
context.keys.shiftkey         = "Shift"
context.keys.leftkey          = "h"
context.keys.rightkey         = "l"
context.keys.upkey            = "k"
context.keys.downkey          = "j"

context.vars = { }
context.vars.sloppy_focus     = false
context.vars.update_apps      = false
context.vars.terminal         = "kitty"
-- context.vars.terminal         = "kitty -1 --listen-on unix:/tmp/_kitty_" .. os.getenv("USER")
context.vars.browser          = "chromium"
-- context.vars.net_iface        = "wlp2s0"
context.vars.cores            = 4
context.vars.batteries        = { "BAT0" }
context.vars.ac               = "AC"
context.vars.scripts_dir      = os.getenv("HOME") .. "/.bin"
context.vars.checkupdate      = "checkupdates | sed 's/->/→/' | sort | column -t -c 70 -T 2,4"

-- For compatibility with copycat-themes
awful.util.terminal           = context.vars.terminal
-- }}}

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors,
    }
end
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true
        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        }
        in_error = false
    end)
end
-- }}}

-- {{{ Theme
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), context.theme)
config.util_theme.init(context)
beautiful.init(theme_path)
-- }}}

-- {{{ Config
config.widgets.init(context)
config.util.init(context)
config.menu.init(context)
config.keys.init(context)
config.keys_command.init(context)
config.keys_client.init(context)
config.rules.init(context)
config.signals.init(context)
config.screen.init(context)
-- }}}

-- {{{ Spawn
context.util.run_once {
    "redshift -c .config/redshift.conf &",
}

context.util.run_once {
    "syndaemon -i 0.4 -K -R -d",
}

context.util.run_once {
    "compton --config ~/.config/compton.conf &",
}

-- context.util.run_once {
--     "amixer -c PCH set \"Master\" mute &",
-- }

-- context.util.spawn_once {
--     command = "chromium",
--     class = "Chromium",
--     tag = awful.screen.focused().tags[1][2],
-- }

-- context.util.spawn_once {
--     command = "kitty",
--     class = "Kitty",
--     tag = awful.screen.focused().tags[1],
-- }

context.util.spawn_once {
    command = "kitty --class='kitty-main'",
    class = "kitty-main",
    tag = awful.screen.focused().tags[1][1],
    callback = function(c)
        c.maximized = true
    end,
}

-- context.util.spawn_once {
--     command = "discord",
--     class = "Discord",
--     tag = awful.screen.focused().tags[1][3],
-- }

-- context.util.spawn_once("subl", "Sublime_text", tags[1][2])
-- context.util.spawn_once("chromium", "Chromium", tags[1][3])
-- context.util.spawn_once("thunar", "Thunar", tags[1][4])
-- context.util.spawn_once("discord", "Discord", tags[1][5])
-- context.util.spawn_once("kitty", "kitty", awful.tag.find_by_name(awful.screen.focused(), "2"))
-- }}}

-- naughty.dbus.config.mapping = {
--     {{urgency = "\1"}, naughty.config.presets.low},
--     {{urgency = "\2"}, naughty.config.presets.normal},
--     {{urgency = "\3"}, naughty.config.presets.critical}
-- }
