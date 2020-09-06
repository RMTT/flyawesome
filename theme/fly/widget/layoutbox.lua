local awful = require("awful")
local wibox = require("wibox")

local layoutbox = {}

function layoutbox:init(config)
    layoutbox.widget = wibox.widget{
        awful.widget.layoutbox{
            forced_height = config.height * 0.7,
            forced_width = config.height * 0.7
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place
    }

    layoutbox.widget.buttons = {
        awful.button(
            {},
            1,
            function()
                awful.layout.inc(1)
            end
            ),
        awful.button(
            {},
            3,
            function()
                awful.layout.inc(-1)
            end
            ),
        awful.button(
            {},
            4,
            function()
                awful.layout.inc(1)
            end
            ),
        awful.button(
            {},
            5,
            function()
                awful.layout.inc(-1)
            end
            )
    }
end

return layoutbox