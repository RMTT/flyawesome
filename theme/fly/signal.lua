-- predefined signals for theme

return {
    startup = {
        show_panel = "startup::show_panel"
    },
    hotkeys_popup = {
        show_help = "hotkeys_popup::show_help"
    },
    dropdown = {
        toggle = "dropdown::toggle"
    },
    geoinfo = {
        geoinfo_update = "geoinfo::update"
    },
    network_manager = {
        state_changed = "network::changed"
    },
    wallpaper = {
        update_wallpaper = "wallpaper::update"
    },
    taglist = {
        update_icon = "taglist::update_icon"
    },
    battery_manager = {
        update_device = "battery::update_device",
        remove_device = "battery::remove_device"
    }
}