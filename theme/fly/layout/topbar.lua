local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- load widgets
local taglist = require("theme.fly.widget.taglist")
local startup = require("theme.fly.widget.startup")
local control_center = require("theme.fly.widget.control_center")

-- import configurations
local icons = require("theme.assets.icons")

local topbar = {}

function topbar:init(config)
    self.height = config.height / 40
    self.width = config.width

    self.widget = awful.wibar{
        position = "top",
        width = self.width,
        height = self.height,
        screen = config.screen,
        bg = beautiful.topbar_bg,
        ontop = true
    }

    taglist:init({screen = config.screen,height = self.height,width = self.height,tag_buttons = config.tag_buttons})
    startup:init({height = self.height * 0.9})
    control_center:init({height = self.height * 0.9})
    
    topbar.widget.widget = {
        startup.widget,
        wibox.widget{
            {
                wibox.widget{
                    taglist.widget,
                    left = 10,
                    widget = wibox.container.margin
                },
                layout = wibox.layout.align.horizontal
            },
            bottom = self.height / 10,
            color = beautiful.startup_bg,
            widget = wibox.container.margin
        },
        control_center.widget,
        layout = wibox.layout.align.horizontal
    }
end

return topbar