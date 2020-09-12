local gears = require("gears")

local base_dir = gears.filesystem.get_configuration_dir() .. "theme/" .. "assets/icons/"

return {
    fly = {
        startup = base_dir .. "startup.svg",
        control_center = base_dir .. "control_center.svg",
        tray_toggle = base_dir .. "traytoggle.svg",
        tray_toggle_clicked = base_dir .. "traytoggle_clicked.svg"
    }
}