local awful = require("awful")
local wibox = require("wibox")


local tasklist = {}

function tasklist:init(config)
    tasklist.widget = wibox.widget{
        awful.widget.tasklist {
            screen   = config.screen,
            filter   = awful.widget.tasklist.filter.currenttags,
            buttons  = tasklist_buttons,
            style = {
                align = "center"
            },
            layout   = {
                spacing = 2,
                layout  = wibox.layout.fixed.horizontal
            },
            widget_template = {
                {
                    wibox.widget.base.make_widget(),
                    forced_height = config.height / 10,
                    id            = 'background_role',
                    widget        = wibox.container.background,
                },
                {
                    awful.widget.clienticon,
                    widget  = wibox.container.margin
                },
                layout = wibox.layout.align.vertical
            }
        },
        widget = wibox.container.place
    }
end

return tasklist