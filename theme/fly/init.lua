--  _____ _  __   __  _____ _   _ _____ __  __ _____ 
-- |  ___| | \ \ / / |_   _| | | | ____|  \/  | ____|
-- | |_  | |  \ V /    | | | |_| |  _| | |\/| |  _|  
-- |  _| | |___| |     | | |  _  | |___| |  | | |___ 
-- |_|   |_____|_|     |_| |_| |_|_____|_|  |_|_____|


-- import standard library
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")

-- import widgets and layouts and rules
local topbar = require("theme.fly.layout.topbar")
local dropdown = require("theme.fly.widget.dropdown")
local notification = require("theme.fly.widget.notification")

-- import configurations
local icons = require("theme.assets.icons")

-- import predefined signals
local sig = require("theme.fly.signal")

-- import modules
local autostart = require("theme.fly.module.autostart")
local rule = require("theme.fly.module.rule")
local geoinfo = require("theme.fly.module.geoinfo")

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/fly/theme.lua")


local fly = {}

function fly:init(config)
    -- [[ config tags
    for _, t in pairs(config.tags) do
        local selected = false

        if t.default then
            selected = true
        end

        awful.tag.add(t.name,
            {
                name = t.name,
                icon = gears.surface.load_uncached(t.icon),
                icon_selected = gears.surface.load_uncached(t.icon_selected),
                selected = selected,
                gap_single_client = false,
                gap = beautiful.useless_gap,
                layout = t.layout,
                default_app = t.default_app,
                num_fullscreen = 0
            })
    end

    tag.connect_signal('property::layout',
        function(t)
            local currentLayout = awful.tag.getproperty(t, 'layout')
            if (currentLayout == awful.layout.suit.max) then
                t.gap = 0
            else
                t.gap = beautiful.useless_gap
            end
        end)
    -- ]]

    -- add client ruls
    rule:init({ client_buttons = config.client_buttons, client_keys = config.client_keys })

    self.geometry = {
        width = config.screen.geometry.width,
        height = config.screen.geometry.height
    }

    topbar:init {
        width = self.geometry.width,
        height = self.geometry.height,
        screen = config.screen,
        tag_buttons = config.tag_buttons
    }
    config.screen.topbar = topbar.widget

    dropdown:init({
        terminal = config.terminal_dropdown,
        height = self.geometry.height * 0.4,
        position = "bottom",
        anchor = "middle",
        parent = topbar.widget
    })

    notification:init({ width = self.geometry.width / 5, height = self.geometry.height / 12 })

    autostart:init({ apps = config.autostart })

    -- config geoinfo
    geoinfo:init({})
end


return fly