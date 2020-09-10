local notification_ruled = require("ruled.notification")
local naughty = require("naughty")
local wibox = require("wibox")
local beautiful = require("beautiful")

local notification = {}

function notification:init(config)
    local icon_size = config.height * 0.5
    local spacing = 4


    local action_list_template = {
        base_layout = wibox.widget {
            spacing = 3,
            spacing_widget = wibox.widget {
                orientation = 'horizontal',
                widget = wibox.widget.separator,
            },
            layout = wibox.layout.fixed.vertical
        },
        widget_template = {
            {
                {
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox
                    },
                    widget = wibox.container.place
                },
                widget = wibox.container.background,
            },
            margins = 4,
            widget = wibox.container.margin,
        },
        forced_height = config.heiht,
        widget = naughty.list.actions
    }

    local template_full = {
        {
            {
                {
                    {
                        {
                            forced_width = icon_size,
                            forced_height = icon_size,
                            resize_strategy = "scale",
                            widget = naughty.widget.icon
                        },
                        widget = wibox.container.place
                    },
                    {
                        {
                            naughty.widget.title,
                            naughty.widget.message,
                            spacing = 4,
                            layout = wibox.layout.fixed.vertical,
                        },
                        halign = "left",
                        valign = "center",
                        widget = wibox.container.place
                    },
                    action_list_template,
                    spacing = spacing,
                    expand = "none",
                    layout = wibox.layout.align.horizontal,
                },
                margins = beautiful.notification_margin,
                widget = wibox.container.margin,
            },
            id = "background_role",
            widget = naughty.container.background,
        },
        strategy = "max",
        forced_width = config.width,
        forced_height = config.height,
        widget = wibox.container.constraint,
    }

    naughty.connect_signal("request::display", function(notif)
        naughty.layout.box {
            notification = notif,
            widget_template = template_full
        }
    end)
end

return notification