local wibox = require("wibox")
local sig = require("theme.fly.signal")
local icons = require("theme.assets.icons")
local constants = require("utils.constants")
local awful = require("awful")
local gears = require("gears")

local networking = {}
local tooltip

function networking:init(config)
    self.widget = wibox.widget {
        image = icons.fly.networking_disconnected,
        forced_width = config.width,
        forced_height = config.height,
        resize = true,
        widget = wibox.widget.imagebox
    }

    local tooltip = awful.tooltip {
        preferred_positions = { 'left', 'right', 'top', 'bottom' },
        mode = "outside",
        objects = { self.widget },
    }

    tooltip.text = "No connection"

    awesome.connect_signal(sig.network_manager.state_changed, function(state, data)
        local id, type
        if data then
            id = data.id
            type = data.type
        end
        if state == constants.NETWORK_DISCONNECTED then
            networking.widget.image = icons.fly.networking_disconnected
            tooltip.text = "No connection"
        end

        if state == constants.NETWORK_CONNECTING then
            if string.find(type, "wireless") then
                networking.widget.image = icons.fly.networking_wireless_connecting
            else
                networking.widget.image = icons.fly.networing_wired_connecting
            end

            tooltip.text = string.format("connecting to %s", id)
        end

        if state == constants.NETWORK_CONNECTED_NO_INTERNET then
            if string.find(type, "wireless") then
                networking.widget.image = icons.fly.networking_wireless_connected_no_internet
            else
                networking.widget.image = icons.fly.networking_wired_connected_no_internet
            end

            tooltip.text = string.format("connected to %s\nBut no internet", id)
        end

        if state == constants.NETWORK_CONNECTED then
            if string.find(type, "wireless") then
                networking.widget.image = icons.fly.networking_wireless_connected
            else
                networking.widget.image = icons.fly.networking_wired_connected
            end
            tooltip.text = string.format("connected to %s succeed", id)
        end
    end)
end

return networking