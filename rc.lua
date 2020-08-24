--  _____ _  __   __ ___        _______ ____   ___  __  __ _____ 
-- |  ___| | \ \ / // \ \      / / ____/ ___| / _ \|  \/  | ____|
-- | |_  | |  \ V // _ \ \ /\ / /|  _| \___ \| | | | |\/| |  _|  
-- |  _| | |___| |/ ___ \ V  V / | |___ ___) | |_| | |  | | |___ 
-- |_|   |_____|_/_/   \_\_/\_/  |_____|____/ \___/|_|  |_|_____|

-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- import some standard library
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
require("awful.autofocus")

-- predefined variables
local configuration_dir = gears.filesystem.get_xdg_config_home() .. "flyawesome"
local configuration_filename = "config.lua"
local theme_dir_name = "theme"

-- load configurations
local config = {}
local status, res = pcall(dofile, configuration_dir .. "/" .. configuration_filename)

print(res)
-- handle screen decoration
local handle_theme = function(s)
    local theme = require(theme_dir_name .. "." .. config.theme)

    theme:init {
        screen = s,
        tags = res.tags,
        tag_buttons = res.tag_buttons,
        client_buttons = res.client_buttons,
        client_keys = res.client_keys
    }
end

-- load configuration succeed
if status then
    setmetatable( config, {__mode = "v", __index = res} )
    screen.connect_signal("request::desktop_decoration", handle_theme)

    screen.connect_signal("request::wallpaper", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)
end