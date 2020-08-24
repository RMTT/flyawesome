local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

-- import configurations
local icons = require("theme.assets.icons")

local control_center = {}

function control_center:init(config)
    control_center.widget = wibox.widget{
                wibox.widget{
                    wibox.widget{
                        image = icons.fly.control_center,
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

return control_center