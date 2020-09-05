local awful = require('awful')

local autostart = {}

function autostart:init(config)
    for index = 1, #config.apps do
        awful.util.spawn(config.apps[index])
    end
end

return autostart