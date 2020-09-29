local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local sig = require("theme.fly.signal")

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
local hotkeys_popup = require("theme.fly.widget.hotkeys_popup")
local networking = require("theme.fly.widget.networking")
local battery = require("theme.fly.widget.battery")

-- import configurations
local icons = require("theme.assets.icons")

local topbar = {}

function topbar:init(config)
    self.height = config.height / 40
    self.width = config.width

    self.widget = awful.wibar {
        position = "top",
        width = self.width,
        height = self.height,
        screen = config.screen,
        bg = beautiful.topbar_bg,
        ontop = true
    }

    taglist:init({ screen = config.screen, height = self.height, tag_buttons = config.tag_buttons })
    startup:init({ height = self.height, screen = config.screen })
    control_center:init({ height = self.height })
    tasklist:init({ screen = config.screen, width = self.height * 0.7, height = self.height * 0.7, top_seperator_height = self.height / 10 })
    clock:init({ bg = beautiful.topbar_bg, height = self.height * 0.7 })
    systray:init({ screen = config.screen, width = self.width, height = self.height })
    layoutbox:init({ height = self.height })
    hotkeys_popup:init({})
    networking:init({ width = self.height * 0.7, height = self.height * 0.7 })
    battery:init({ width = self.height * 0.5 * (57 / 32), height = self.height * 0.5, screen = config.screen })

    local topbar_bg_clickable = "#cdd1d3cc"
    common.clickable(startup.widget, beautiful.startup_bg, beautiful.startup_bg .. "cc")
    common.clickable(control_center.widget, beautiful.startup_bg, beautiful.startup_bg .. "cc")
    common.clickable(clock.widget, beautiful.topbar_bg, topbar_bg_clickable)

    topbar.widget.widget = {
        startup.widget,
        wibox.widget {
            {
                wibox.widget {
                    taglist.widget,
                    left = 10,
                    widget = wibox.container.margin
                },
                tasklist.widget,
                wibox.widget {
                    {
                        wibox.widget {
                            systray.widget,
                            widget = wibox.container.place
                        },
                        wibox.widget {
                            battery.widget,
                            widget = wibox.container.place
                        },
                        wibox.widget {
                            networking.widget,
                            widget = wibox.container.place
                        },
                        wibox.widget {
                            layoutbox.widget,
                            widget = wibox.container.place
                        },
                        wibox.widget {
                            clock.widget,
                            widget = wibox.container.place
                        },
                        spacing = 10,
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

    -- handle topbar visibility when client want to fullscreen
    client.connect_signal("property::fullscreen", function(c)
        local tag = awful.screen.focused().selected_tag
        if c.fullscreen then
            tag.num_fullscreen = tag.num_fullscreen + 1
        else
            tag.num_fullscreen = tag.num_fullscreen - 1
        end

        if tag.num_fullscreen < 0 then
            tag.num_fullscreen = 0
        end

        topbar:update_visible()
    end)

    client.connect_signal("request::activate", function()
        topbar:update_visible()
    end)

    tag.connect_signal("property::selected", function()
        topbar:update_visible()
    end)
end

function topbar:show()
    self.widget.visible = true
end

function topbar:hide()
    self.widget.visible = false
end

function topbar:update_visible()
    local s = awful.screen.focused()
    local tag = s.selected_tag

    if not tag or not client.focus then
        topbar:show()
        return
    end

    if tag.num_fullscreen > 0 and client.focus.fullscreen then
        self:hide()
    else
        self:show()
    end
end

return topbar
