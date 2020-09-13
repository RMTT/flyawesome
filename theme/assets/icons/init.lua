local gears = require("gears")

local base_dir = gears.filesystem.get_configuration_dir() .. "theme/" .. "assets/icons/"

return {
    fly = {
        startup = base_dir .. "startup.svg",
        control_center = base_dir .. "control_center.svg",
        tray_toggle = base_dir .. "traytoggle.svg",
        tray_toggle_clicked = base_dir .. "traytoggle_clicked.svg",
        networking_disconnected = base_dir .. "networking_disconnected.svg",
        networking_wireless_connecting = base_dir .. "networking_wireless_connecting.svg",
        networking_wireless_connected_no_internet = base_dir .. "networking_wireless_connected_no_internet.svg",
        networking_wireless_connected = base_dir .. "networking_wireless_connected.svg",
        networking_wired_connecting = base_dir .. "networking_wired_connecting.svg",
        networking_wired_connected_no_internet = base_dir .. "networking_wired_connected_no_internet.svg",
        networking_wired_connected = base_dir .. "networking_wired_connected.svg",
    }
}