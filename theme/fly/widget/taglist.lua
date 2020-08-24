local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local taglist = {}

function taglist:init(config)
    local top_margin_height = config.height / 10

    taglist.widget = awful.widget.taglist {
        screen = config.screen,
        filter  = awful.widget.taglist.filter.all,
        widget_template = {
            {
                _id = "icon_container",
                forced_width = config.height,
                forced_height = config.height, 
                widget = wibox.container.place
            },
            top = 0,
            color = beautiful.startup_bg,
            create_callback = function(widget,t,index,tags)
                local container

                for _,w in pairs(widget:get_all_children()) do
                    if w._id == "icon_container" then
                        container = w
                    end
                end
                
                local icon = wibox.widget{
                    _id = "icon",
                    forced_height = config.height * 0.6,
                    forced_width = config.height * 0.6,
                    widget = wibox.widget.imagebox
                }

                container.widget = icon
                
                local update_icon = function(t)
                    local count = #t:clients()

                    if t.selected then
                        widget.top = top_margin_height
                        icon:set_image(t.icon_selected)
                    elseif count > 0 then
                        widget.top = 0
                        icon:set_image(t.icon_selected)
                    else
                        widget.top = 0
                        icon:set_image(t.icon)
                    end
                end

                update_icon(t)

                t:connect_signal("property::selected",update_icon)

                t:connect_signal("taglist::update_icon",update_icon)
            end,
            widget = wibox.container.margin
        },
        buttons = config.tag_buttons
    }
end

return taglist