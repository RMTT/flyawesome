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
local rule = require("theme.fly.module.rule")

-- import configurations
local icons = require("theme.assets.icons")

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/fly/theme.lua")


local fly = {}

function fly:init(config)
    -- [[ config tags
    for _,t in pairs(config.tags) do
        local selected = false

        if t.default then 
            selected = true
        end

        awful.tag.add(
            t.name,
            {
                name = t.name,
                icon = gears.surface.load_uncached(t.icon),
                icon_selected = gears.surface.load_uncached(t.icon_selected),
                selected = selected
            }
        )
    end
-- ]]

    -- add client ruls
    rule:init({client_buttons = config.client_buttons,client_keys = config.client_keys})

    self.geometry = {
        width = config.screen.geometry.width,
        height = config.screen.geometry.height
    }
    
    topbar:init{
        width = self.geometry.width,
        height = self.geometry.height,
        screen = config.screen,
        tag_buttons = config.tag_buttons
    }

    config.screen.topbar = topbar.widget
end


return fly