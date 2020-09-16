local wibox = require("wibox")
local beautiful = require("beautiful")

local clock = {}

function clock:init(config)
    clock.widget = wibox.widget {
        wibox.widget {
            format = "<span font='Alarm Clock 14'>%H:%M</span>",
            widget = wibox.widget.textclock,
            forced_height = config.height
        },
        bg = config.bg,
        fg = "#000000",
        widget = wibox.container.background
    }
end

return clock