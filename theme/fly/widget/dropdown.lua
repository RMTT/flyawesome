local awful = require("awful")
local sig = require("theme.fly.signal")

local dropdown = {}

function dropdown:init(config)
    self.pid = nil
    self.terminal_object = nil
    self.terminal = config.terminal

    awesome.connect_signal(sig.dropdown.toggle, function()
        dropdown:toggle()
    end)

    client.connect_signal("request::manage", function(c)
        if dropdown.pid and c.pid == dropdown.pid then
            tags = c:tags()
            for index = 1, #tags do
                tags[index].has_dropdown = true
            end

            c.floating = true
            c.sticky = true
            c.ontop = true
            c.skip_taskbar = true
            c.maximized_horizontal = true
            c.height = config.height
            c.hidden = false
            c.requests_no_titlebar = true
            c.immobilized_horizontal = true
            c.border_width = 0

            awful.placement.next_to(c,
                {
                    preferred_positions = config.position,
                    preferred_anchors = config.anchor,
                    geometry = config.parent
                })
            dropdown.terminal_object = c
        end
    end)

    client.connect_signal("request::unmanage", function(c)

        if dropdown.pid and dropdown.pid == c.pid then
            tags = c:tags()
            for index in #tags do
                tags[index].has_dropdown = false
            end

            dropdown.pid = nil
            dropdown.terminal_object = nil
        end
    end)
end

function dropdown:toggle()
    if not self.pid then
        self.pid = awful.spawn(self.terminal)
    end

    if self.terminal_object then
        self.terminal_object.hidden = not self.terminal_object.hidden

        if not self.terminal_object.hidden then
            self.terminal_object:emit_signal('request::activate')
        end
    end
end

return dropdown