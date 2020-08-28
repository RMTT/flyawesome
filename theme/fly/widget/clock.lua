local wibox = require("wibox")
local beautiful = require("beautiful")

local clock = {}

function clock:init(config)
    clock.widget = wibox.widget{
        wibox.widget{
            format = "<span font='Alarm Clock 15'>%H:%M</span>",
            widget = wibox.widget.textclock
        },
        bg = config.bg,
        fg = "#000000",
        widget = wibox.container.background
    }
end

return clock