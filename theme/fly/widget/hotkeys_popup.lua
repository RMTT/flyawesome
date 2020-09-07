local awful_hotkeys_popup = require("awful.hotkeys_popup")
local sig = require("theme.fly.signal")

local hotkeys_popup = {}

function hotkeys_popup:init(config)
    self.widget = awful_hotkeys_popup.widget.new{
        merge_duplicates = true
    }

    awesome.connect_signal(sig.hotkeys_popup.show_help,function()
        hotkeys_popup.widget:show_help()
        print(1)
    end)
end

return hotkeys_popup