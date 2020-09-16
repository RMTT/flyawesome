local awful = require("awful")
local wibox = require("wibox")
local Gtk = require("lgi").Gtk
local icon_theme = Gtk.IconTheme.get_default()
local gears = require("gears")

local tasklist = {}

local tasklist_buttons = awful.util.table.join(awful.button({},
    1,
    function(c)
        if c == _G.client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            _G.client.focus = c
            c:raise()
        end
    end),
    awful.button({},
        2,
        function(c)
            c:kill()
        end),
    awful.button({},
        4,
        function()
            awful.client.focus.byidx(1)
        end),
    awful.button({},
        5,
        function()
            awful.client.focus.byidx(-1)
        end))

function tasklist:init(config)
    tasklist.widget = wibox.widget {
        awful.widget.tasklist {
            screen = config.screen,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons,
            style = {
                align = "center"
            },
            layout = {
                spacing_widget = {
                    {
                        forced_width = 10,
                        forced_height = config.height * 0.7,
                        thickness = 1,
                        color = '#000000',
                        widget = wibox.widget.separator
                    },
                    valign = 'center',
                    halign = 'center',
                    widget = wibox.container.place,
                },
                spacing = 2,
                layout = wibox.layout.fixed.horizontal
            },
            widget_template = {
                {
                    wibox.widget.base.make_widget(),
                    forced_height = config.height / 10,
                    id = 'background_role',
                    widget = wibox.container.background,
                },
                {
                    {
                        {
                            id = 'icon_role',
                            widget = wibox.widget.imagebox
                        },
                        widget = wibox.container.margin
                    },
                    widget = wibox.container.place
                },
                layout = wibox.layout.align.vertical,
                create_callback = function(self, c, index, objects) --luacheck: no unused
                    if not c.icon then
                        local tmp
                        if c.icon_name then
                            tmp = icon_theme:lookup_icon(c.icon_name, 32, 0):get_filename()
                        else
                            tmp = icon_theme:lookup_icon(c.class, 32, 0):get_filename()
                        end

                        if tmp then
                            self:get_children_by_id('icon_role')[1]:set_image(tmp)
                        end
                    end
                end,
            }
        },
        widget = wibox.container.background
    }
end

return tasklist