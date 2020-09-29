local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local icons = require("theme.assets.icons")


local systray = {}
function systray:toggle_icon()
    if self.panel.visible then
        self.widget.image = icons.fly.tray_toggle_clicked
    else
        self.widget.image = icons.fly.tray_toggle
    end
end

function systray:init(config)
    self.widget = wibox.widget {
        image = icons.fly.tray_toggle,
        forced_width = config.height * 0.7,
        forced_height = config.height * 0.7,
        resize = true,
        widget = wibox.widget.imagebox
    }

    self.backdrop = wibox {
        x = 0,
        y = 0,
        bg = "#00000000",
        ontop = true,
        type = "dock",
        screen = config.screen,
        width = config.screen.geometry.width,
        height = config.screen.geometry.height,
        visible = false,
    }

    self.backdrop:buttons({
        awful.button({}, 1, nil, function()
            systray.backdrop.visible = not systray.backdrop.visible
            systray.panel.visible = not systray.panel.visible

            systray:toggle_icon()
        end)
    })

    self.panel = awful.popup {
        widget = {
            {
                base_size = config.height * 0.7,
                horizontal = false,
                widget = wibox.widget.systray
            },
            margins = 5,
            widget = wibox.container.margin
        },
        ontop = true,
        bg = beautiful.startup_bg,
        minimum_height = 25,
        maximum_height = config.screen.geometry.height,
        visible = false,
        shape = gears.shape.rect
    }

    self.widget:add_button(awful.button({}, 1, function(geometry)
        systray.backdrop.visible = not systray.backdrop.visible

        systray.panel.width = config.height * 0.7 + 10
        systray.panel.x = geometry.x + (config.height * 0.7 * 0.5 - systray.panel.width * 0.5)
        systray.panel.y = geometry.y + config.height - 5
        systray.panel.visible = not systray.panel.visible

        systray:toggle_icon()
    end))
end

return systray
