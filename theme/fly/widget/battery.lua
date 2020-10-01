local icons = require("theme.assets.icons")
local wibox = require("wibox")
local awful = require("awful")
local sig = require("theme.fly.signal")
local beautiful = require("beautiful")
local constants = require("utils.constants")
local gears = require("gears")

local battery = {}

local have_moved = 0

local items = {}
local progressbars = {}
local icon_color = "#000000"
local icon_color_clicked = "#2177b8"
local clicked = false
local state, percentage

local show_percentage = false

function battery:init(config)
    self.widget = wibox.widget {
        image = icons.fly.battery_warning,
        resize = true,
        forced_height = config.height,
        forced_width = config.width,
        widget = wibox.widget.imagebox,
    }

    self.panel_content = wibox.widget {
        spacing = 5,
        layout = wibox.layout.fixed.vertical
    }

    self.panel = awful.popup {
        widget = {
            self.panel_content,
            margins = 5,
            widget = wibox.container.margin
        },
        preferred_positions = "bottom",
        preferred_anchors = "middle",
        bg = beautiful.startup_bg,
        visible = false,
        ontop = true
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
            battery:toggle()
        end)
    })

    self.widget:connect_signal("button::press", function(geo, lx, ly, button, mods, w)
        if button == 1 then
            if have_moved == 0 then
                battery.panel:move_next_to(w)
                have_moved = 1
            end

            battery:toggle()
        end
    end)

    awesome.connect_signal(sig.battery_manager.remove_device, function(path)
        if items[path] then
            battery.panel_content:remove_widgets(items[path])
            items[path] = nil
        end
    end)

    awesome.connect_signal(sig.battery_manager.update_device, function(data)
        if data.type == constants.BATTERY_DEVICE_DISPLAY then
            state = data.state
            percentage = data.percentage
            battery:set_icon()
        else
            if items[data.path] then
                -- if percentage changed
                if data.percentage then
                    if progressbars[data.path] then
                        progressbars[data.path].value = data.percentage
                    end
                end
            else
                local markup = data.model
                if data.device_type == constants.BATTERY_DEVICE_TYPE_BATTERY then
                    markup = "Battery"
                end

                progressbars[data.path] = wibox.widget {
                    max_value = 100,
                    value = data.percentage,
                    forced_height = 15,
                    forced_width = 100,
                    paddings = 1,
                    border_width = 1,
                    border_color = beautiful.border_color,
                    widget = wibox.widget.progressbar,
                }

                items[data.path] = wibox.widget {
                    {
                        wibox.widget {
                            markup = markup,
                            align = 'center',
                            valign = 'center',
                            widget = wibox.widget.textbox
                        },
                        progressbars[data.path],
                        layout = wibox.layout.align.vertical
                    },
                    widget = wibox.container.margin
                }

                battery.panel_content:add(items[data.path])
            end
        end
    end)
end

function battery:set_icon()
    local color = icon_color

    if clicked then
        color = icon_color_clicked
    end

    if state then
        show_percentage = false
        if state == constants.BATTERY_DEVICE_STATE_UNKNOWN then
            self.widget:set_image(gears.color.recolor_image(icons.fly.battery_warning, color))
        elseif state == constants.BATTERY_DEVICE_STATE_CHARGING then
            self.widget:set_image(gears.color.recolor_image(icons.fly.battery_charging, color))
        elseif state == constants.BATTERY_DEVICE_STATE_EMPTY then
            self.widget:set_image(gears.color.recolor_image(icons.fly.battery_empty, color))
        elseif state == constants.BATTERY_DEVICE_STATE_FULL_CHARGED then
            self.widget:set_image(gears.color.recolor_image(icons.fly.battery_full, color))
        else
            show_percentage = true
        end
    end

    if show_percentage and percentage then
        if percentage > 0 and percentage < 10 then
            self.widget:set_image(gears.color.recolor_image(icons.fly.battery_step_one, color))
        elseif percentage >= 10 and percentage < 20 then
            self.widget:set_image(gears.color.recolor_image(icons.fly.battery_step_two, color))
        elseif percentage >= 20 and percentage < 30 then
            self.widget:set_image(gears.color.recolor_image(icons.fly.battery_step_three, color))
        elseif percentage >= 30 and percentage < 40 then
            self.widget:set_image(gears.color.recolor_image(icons.fly.battery_step_four, color))
        elseif percentage >= 40 and percentage < 50 then
            self.widget:set_image(gears.color.recolor_image(icons.fly.battery_step_five, color))
        elseif percentage >= 50 and percentage < 60 then
            self.widget:set_image(gears.color.recolor_image(icons.fly.battery_step_six, color))
        elseif percentage >= 60 and percentage < 70 then
            self.widget:set_image(gears.color.recolor_image(icons.fly.battery_step_seven, color))
        elseif percentage >= 70 and percentage < 80 then
            self.widget:set_image(gears.color.recolor_image(icons.fly.battery_step_eight, color))
        elseif percentage >= 80 and percentage < 90 then
            self.widget:set_image(gears.color.recolor_image(icons.fly.battery_step_nine, color))
        elseif percentage >= 90 then
            self.widget:set_image(gears.color.recolor_image(icons.fly.battery_full, color))
        end
    end
end

function battery:toggle()
    clicked = not clicked
    self.backdrop.visible = not self.backdrop.visible

    if have_moved == 1 then
        have_moved = 2
    elseif have_moved == 2 then
        self.panel.visible = not self.panel.visible
    end

    self:set_icon()
end

return battery