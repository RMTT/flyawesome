local gears = require("gears")

local base_dir = gears.filesystem.get_configuration_dir() .. "theme/" .. "assets/icons/"

return {
    fly = {
        -- icons for startup widget
        startup = base_dir .. "startup.svg",

        -- icons for control center widget
        control_center = base_dir .. "control_center.svg",

        -- icons for systray widget
        tray_toggle = base_dir .. "traytoggle.svg",
        tray_toggle_clicked = base_dir .. "traytoggle_clicked.svg",

        -- icons for networking widget
        networking_disconnected = base_dir .. "networking_disconnected.svg",
        networking_wireless_connecting = base_dir .. "networking_wireless_connecting.svg",
        networking_wireless_connected_no_internet = base_dir .. "networking_wireless_connected_no_internet.svg",
        networking_wireless_connected = base_dir .. "networking_wireless_connected.svg",
        networking_wired_connecting = base_dir .. "networking_wired_connecting.svg",
        networking_wired_connected_no_internet = base_dir .. "networking_wired_connected_no_internet.svg",
        networking_wired_connected = base_dir .. "networking_wired_connected.svg",

        -- icons for battery widget
        battery_charging = base_dir .. "battery_charging.svg",
        battery_empty = base_dir .. "battery_empty.svg",
        battery_full = base_dir .. "battery_full.svg",
        battery_step_one = base_dir .. "battery_step_one.svg",
        battery_step_two = base_dir .. "battery_step_two.svg",
        battery_step_three = base_dir .. "battery_step_three.svg",
        battery_step_four = base_dir .. "battery_step_four.svg",
        battery_step_five = base_dir .. "battery_step_five.svg",
        battery_step_six = base_dir .. "battery_step_six.svg",
        battery_step_seven = base_dir .. "battery_step_seven.svg",
        battery_step_eight = base_dir .. "battery_step_eight.svg",
        battery_step_nine = base_dir .. "battery_step_nine.svg",
        battery_warning = base_dir .. "battery_warning.svg"
    }
}