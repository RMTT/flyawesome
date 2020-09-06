local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local common = require("utils.common")

-- import configurations
local icons = require("theme.assets.icons")

local sig = require("theme.fly.signal")

local startup = {}

function show_panel(offset_y)
    common.show_rofi("drun", gears.filesystem.get_configuration_dir() .. "theme/fly/assets/rofi/startup_panel.rasi",
             "north west", "north west", 0, math.floor(offset_y),"50%","25%")
end

function startup:init(config)
    self.widget =  wibox.widget{
                wibox.widget{
                    wibox.widget{
                        image = icons.fly.startup,
                        forced_height = config.height * 0.5,
                        forced_width = config.height * 0.5,
                        widget = wibox.widget.imagebox
                    },
                    forced_width = config.height,
                    widget = wibox.container.place
                },
                bg = beautiful.startup_bg,
                widget = wibox.container.background
            }


    self.widget.buttons = {
        awful.button({}, 1, function()
            show_panel(config.height)
        end)
    }

    
    awesome.connect_signal(sig.startup.show_panel,function()
        show_panel(config.height)
    end)
end

return startup