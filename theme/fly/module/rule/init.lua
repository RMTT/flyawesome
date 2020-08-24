local awful = require('awful')
local gears = require('gears')
local ruled = require('ruled')
local beautiful = require('beautiful')

local rule = {}

local filter = function()

end

function rule:init(config)
    ruled.client.connect_signal("request::rules",function()
        ruled.client.append_rule{
            id = "all",
            rule = {},
            properties = {
				focus     = awful.client.focus.filter,
				raise     = true,
				floating = false,
				maximized = false,
				above = false,
				below = false,
				ontop = false,
				sticky = false,
				maximized_horizontal = false,
				maximized_vertical = false,
				round_corners = true,
				keys = config.client_keys,
				buttons = config.client_buttons,
				screen    = awful.screen.preferred,
				placement = awful.placement.no_overlap + awful.placement.no_offscreen
			}
        }
    end)
end

return rule