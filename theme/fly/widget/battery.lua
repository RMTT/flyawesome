local icons = require("theme.assets.icons")
local wibox = require("wibox")
local awful = require("awful")
local sig = require("theme.fly.signal")
local constants = require("utils.constants")

local battery = {}

function battery:init(config)
    self.widget = wibox.widget {
        image = icons.fly.battery_unknown,
        resize = true,
        forced_height = config.height,
        forced_width = config.width,
        widget = wibox.widget.imagebox
    }

    self.panel = awful.popup {
        widget = {
            {

            },
            widget = wibox.container.margin
        }
    }
    awesome.connect_signal(sig.battery_manager.update_device, function(data)
        if data.type == constants.BATTERY_DEVICE_DISPLAY then
            if data.state == constants.BATTERY_DEVICE_STATE_UNKNOWN then
                battery.widget:set_image(icons.fly.battery_unknown)
            elseif data.state == constants.BATTERY_DEVICE_STATE_CHARGING then
                battery.widet:set_image(icons.fly.battery_charging)
            elseif data.state == constants.BATTERY_DEVICE_STATE_EMPTY then
                battery.widget:set_image(icons.fly.battery_empty)
            elseif data.state == constants.BATTERY_DEVICE_STATE_FULL_CHARGED then
                battery.widget:set_image(icons.fly.battery_full)
            else
                local percentage = data.percentage
                if percentage > 0 and percentage < 25 then
                    battery.widget:set_image(icons.fly.battery_step_one)
                elseif percentage >= 25 and percentage < 50 then
                    battery.widget:set_image(icons.fly.battery_step_two)
                elseif percentage >= 50 and percentage < 75 then
                    battery.widget:set_image(icons.fly.battery_step_three)
                elseif percentage >= 75 and percentage < 100 then
                    battery.widget:set_image(icons.fly.battery_step_four)
                end
            end
        else
        end
    end)
end

return battery