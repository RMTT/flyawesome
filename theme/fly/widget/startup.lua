local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")

-- import configurations
local icons = require("theme.assets.icons")

local sig = require("theme.fly.signal")

local startup = {}

startup.input_grabber = awful.keygrabber{
    keybindings = {
        awful.key {
            modifiers = {'Mod1'},
            key       = 'Tab',
            on_press  = function()
                print("1")
            end
        },
        awful.key {
            modifiers = {'Mod1', 'Shift'},
            key       = 'Tab',
            on_press  = awful.client.focus.history.select_next
        },
    },
    -- Note that it is using the key name and not the modifier name.
    stop_key           = 'Mod1',
    stop_event         = 'release',
    start_callback     = function()
        print(2)
    end,
    stop_callback      = function()
        print(3)
    end,
    export_keybindings = true,
}

local backdrop = {}

local panel = {}

function startup:init(config)
    self.widget =  wibox.widget{
                wibox.widget{
                    wibox.widget{
                        image = icons.fly.startup,
                        forced_height = config.height * 0.5,
                        forced_width = config.height * 0.5,
                        widget = wibox.widget.imagebox
                    },
                    forced_width = config.height,
                    widget = wibox.container.place
                },
                bg = beautiful.startup_bg,
                widget = wibox.container.background
            }
    
    -- set startup page
    local inputbox = wibox.widget{
        markup = "",
        align  = "center",
        valign = "center",
        ellipsize = "start",
        forced_width = 50,
        widget = wibox.widget.textbox
    }

    local labelbox = wibox.widget{
        markup = "<span foreground='#ffffff'>Applications:</span>",
        align  = "center",
        valign = "center",
        font = "SF Pro Text 16",
        widget = wibox.widget.textbox
    }


    panel = awful.popup{
        widget = {
            {
                {
                    labelbox,
                    inputbox,
                    spacing = 15,
                    layout = wibox.layout.flex.horizontal
                },
                margins = 15,
                widget = wibox.container.margin
            },
            bg = beautiful.startup_bg,
            widget = wibox.container.background
        },
        visible = false,
        minimum_width = 300,
        ontop = true,
        type = "desktop",
        preferred_anchors = "front",
        preferred_positions = "bottom",
        shape        = gears.shape.rect
    }

    backdrop = wibox{
        screen = config.screen,
        ontop = true,
        bg = beautiful.transparency,
        x = config.screen.geometry.x,
        y = config.screen.geometry.y,
        width = config.screen.geometry.width,
        height = config.screen.geometry.height,
        visible = false
    }

    backdrop.buttons = {
            awful.button({}, 1, function()
                print(backdrop.x,backdrop.y,backdrop.width, backdrop.height)
                self.toggle()
            end),
        }

    awesome.connect_signal(sig.topbar.geometry_calculated,function(geometry)
        panel:move_next_to(geometry)
        panel.visible = false
    end)

    self.widget.buttons = {
        awful.button({}, 1 , function(geometry)
            self.toggle()
            -- input_grabber:start()
        end)
    }
end

function startup:toggle()
    backdrop.visible = not backdrop.visible
    panel.visible = not panel.visible
end

return startup