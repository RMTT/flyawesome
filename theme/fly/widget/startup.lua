local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

-- import configurations
local icons = require("theme.assets.icons")

local startup = {}

function startup:init(config)
    startup.widget =  wibox.widget{
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
end

return startup