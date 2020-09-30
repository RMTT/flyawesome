local icons = require("theme.assets.icons")
local wibox = require("wibox")
local awful = require("awful")
local sig = require("theme.fly.signal")
local beautiful = require("beautiful")
local constants = require("utils.constants")

local battery = {}

local have_moved = false

local items = {}
local progressbars = {}

local show_percentage = false

function battery:init(config)
    self.widget = wibox.widget {
        image = icons.fly.battery_unknown,
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
            battery.backdrop.visible = not battery.backdrop.visible
            battery.panel.visible = not battery.panel.visible
        end)
    })

    self.widget:connect_signal("button::press", function(geo, lx, ly, button, mods, w)
        if button == 1 then
            battery.backdrop.visible = not battery.backdrop.visible

            if not have_moved then
                battery.panel:move_next_to(w)
                have_moved = true
            else
                battery.panel.visible = not battery.panel.visible
            end
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
            if data.state then
                show_percentage = false
                if data.state == constants.BATTERY_DEVICE_STATE_UNKNOWN then
                    battery.widget:set_image(icons.fly.battery_warning)
                elseif data.state == constants.BATTERY_DEVICE_STATE_CHARGING then
                    battery.widget:set_image(icons.fly.battery_charging)
                elseif data.state == constants.BATTERY_DEVICE_STATE_EMPTY then
                    battery.widget:set_image(icons.fly.battery_empty)
                elseif data.state == constants.BATTERY_DEVICE_STATE_FULL_CHARGED then
                    battery.widget:set_image(icons.fly.battery_full)
                else
                    show_percentage = true
                end
            end

            if show_percentage and data.percentage then
                local percentage = data.percentage
                if percentage > 0 and percentage < 10 then
                    battery.widget:set_image(icons.fly.battery_step_one)
                elseif percentage >= 10 and percentage < 20 then
                    battery.widget:set_image(icons.fly.battery_step_two)
                elseif percentage >= 20 and percentage < 30 then
                    battery.widget:set_image(icons.fly.battery_step_three)
                elseif percentage >= 30 and percentage < 40 then
                    battery.widget:set_image(icons.fly.battery_step_four)
                elseif percentage >= 40 and percentage < 50 then
                    battery.widget:set_image(icons.fly.battery_step_five)
                elseif percentage >= 50 and percentage < 60 then
                    battery.widget:set_image(icons.fly.battery_step_six)
                elseif percentage >= 60 and percentage < 70 then
                    battery.widget:set_image(icons.fly.battery_step_seven)
                elseif percentage >= 70 and percentage < 80 then
                    battery.widget:set_image(icons.fly.battery_step_eight)
                elseif percentage >= 80 and percentage < 90 then
                    battery.widget:set_image(icons.fly.battery_step_nine)
                elseif percentage >= 90 then
                    battery.widget:set_image(icons.fly.battery_full)
                end
            end
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

return battery