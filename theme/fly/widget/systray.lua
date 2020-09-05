local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")


local systray = {}

function systray:init(config)
    systray.widget = wibox.widget.systray{
         screen = config.screen,
         visible = true,
         base_size = 20,
         horizontal = true
    }
end

return systray
