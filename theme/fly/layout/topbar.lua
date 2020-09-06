local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- import flyawesome lib
local common = require("utils.common")

-- load widgets
local taglist = require("theme.fly.widget.taglist")
local startup = require("theme.fly.widget.startup")
local control_center = require("theme.fly.widget.control_center")
local tasklist = require("theme.fly.widget.tasklist")
local clock = require("theme.fly.widget.clock")
local systray = require("theme.fly.widget.systray")
local layoutbox = require("theme.fly.widget.layoutbox")

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

    taglist:init({screen = config.screen,height = self.height,tag_buttons = config.tag_buttons})
    startup:init({height = self.height, screen = config.screen})
    control_center:init({height = self.height})
    tasklist:init({screen = config.screen,height = self.height})
    clock:init({bg = beautiful.topbar_bg})
    systray:init({screen = config.screen})
    layoutbox:init({height = self.height})

    local topbar_bg_clickable = "#cdd1d3cc"
    common.clickable(startup.widget,beautiful.startup_bg,beautiful.startup_bg .. "cc")
    common.clickable(control_center.widget,beautiful.startup_bg,beautiful.startup_bg .. "cc")
    common.clickable(clock.widget,beautiful.topbar_bg, topbar_bg_clickable)
    
    topbar.widget.widget = {
        startup.widget,
        wibox.widget{
            {
                wibox.widget{
                    taglist.widget,
                    left = 10,
                    widget = wibox.container.margin
                },
                tasklist.widget,
                wibox.widget{
                    {
                        wibox.widget{
                            systray.widget,
                            top  = self.height / 10,
                            bottom = self.height / 10,
                            widget = wibox.container.margin
                        },
                        layoutbox.widget,
                        clock.widget,
                        spacing = 5,
                        layout = wibox.layout.fixed.horizontal
                    },
                    right = 10,
                    widget = wibox.container.margin
                },
                expand = "none",
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
