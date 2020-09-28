local gears = require("gears")
local awful = require("awful")
local client_ruled = require("ruled.client")

local config_dir = gears.filesystem.get_xdg_config_home() .. "flyawesome/"

-- [[ config modkey and some default apps ]]
local modkey = "Mod4"
local terminal = "alacritty"
local terminal_dropdown = "alacritty --class Dropdown"
-- ]]

-- [[ config tag 

-- [[ the icon must be a surface object or absolute path of icon file
local tag = {
    {
        name = "Terminal",
        icon = config_dir .. "/assets/icons/taglist_terminal.svg",
        icon_selected = config_dir .. "assets/icons/taglist_terminal_selected.svg",
        default = true,
        layout = awful.layout.suit.spiral.dwindle,
        default_app = "alacritty"
    },
    {
        name = "Browser",
        icon = config_dir .. "assets/icons/taglist_browser.svg",
        icon_selected = config_dir .. "assets/icons/taglist_browser_selected.svg",
        layout = awful.layout.suit.max,
        default_app = "firefox"
    },
    {
        name = "Document",
        icon = config_dir .. "assets/icons/taglist_document.svg",
        icon_selected = config_dir .. "assets/icons/taglist_document_selected.svg",
        layout = awful.layout.suit.max,
        default_app = "masterpdfeditor5"
    },
    {
        name = "Code",
        icon = config_dir .. "assets/icons/taglist_code.svg",
        icon_selected = config_dir .. "assets/icons/taglist_code_selected.svg",
        layout = awful.layout.suit.max,
        default_app = "code-oss"
    },
    {
        name = "Files",
        icon = config_dir .. "assets/icons/taglist_files.svg",
        icon_selected = config_dir .. "assets/icons/taglist_files_selected.svg",
        layout = awful.layout.suit.floating,
        default_app = "dolphin"
    },
    {
        name = "Entertainment",
        icon = config_dir .. "assets/icons/taglist_entertainment.svg",
        icon_selected = config_dir .. "assets/icons/taglist_entertainment_selected.svg",
        layout = awful.layout.suit.floating,
        default_app = "telegram-desktop"
    }
}
-- ]]

-- [[ config mouse and keyboard events
local tag_buttons = gears.table.join(awful.button({}, 1, function(t) t:view_only() end),
    awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end))
-- ]]

-- [[ config tag related keys
awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers = { modkey },
        keygroup = "numrow",
        description = "only view tag",
        group = "tag",
        on_press = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Control" },
        keygroup = "numrow",
        description = "toggle tag",
        group = "tag",
        on_press = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup = "numrow",
        description = "move focused client to tag",
        group = "tag",
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                    tag:emit_signal("taglist::update_icon", tag)
                end
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Control", "Shift" },
        keygroup = "numrow",
        description = "toggle focused client on tag",
        group = "tag",
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers = { modkey },
        keygroup = "numpad",
        description = "select layout directly",
        group = "layout",
        on_press = function(index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    },
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ modkey }, 'Escape', awful.tag.history.restore,
        { description = 'alternate between current and previous tag', group = 'tag' }),
    awful.key({ modkey },
        'space',
        function()
            awful.layout.inc(1)
        end,
        { description = 'select next layout', group = 'layout' }),
    awful.key({ modkey, 'Shift' },
        'space',
        function()
            awful.layout.inc(-1)
        end,
        { description = 'select previous layout', group = 'layout' }),
    awful.key({ modkey },
        'w',
        awful.tag.viewprev,
        { description = 'view previous tag', group = 'tag' }),

    awful.key({ modkey },
        's',
        awful.tag.viewnext,
        { description = 'view next tag', group = 'tag' }),
    awful.key({ modkey, 'Control' },
        'w',
        function()
            -- tag_view_nonempty(-1)
            local focused = awful.screen.focused()
            for i = 1, #focused.tags do
                awful.tag.viewidx(-1, focused)
                if #focused.clients > 0 then
                    return
                end
            end
        end,
        { description = 'view previous non-empty tag', group = 'tag' }),
    awful.key({ modkey, 'Control' },
        's',
        function()
            -- tag_view_nonempty(1)
            local focused = awful.screen.focused()
            for i = 1, #focused.tags do
                awful.tag.viewidx(1, focused)
                if #focused.clients > 0 then
                    return
                end
            end
        end,
        { description = 'view next non-empty tag', group = 'tag' }),
})

-- ]]

-- ]]

-- [[ config keys for launch some apps
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey },
        "e",
        function()
            awesome.emit_signal("startup::show_panel")
        end,
        { description = "show startup panel", group = "launcher" }),
    awful.key({ modkey, "Shift" },
        "d",
        function()
            awful.spawn(awful.screen.focused().selected_tag.default_app,
                {
                    tag = mouse.screen.selected_tag
                })
        end,
        { description = "launch default app for current tag", group = 'launcher' }),
    awful.key({ modkey, }, "`",
        function()
            awesome.emit_signal("dropdown::toggle")
        end,
        { description = "toggle dropdown terminal", group = 'launcher' }),
    awful.key({ modkey, "Shift" }, "f",
        function()
            awful.spawn("flameshot gui")
        end,
        { description = "screen capture", group = 'launcher' }),
})
--]]


-- [[ config for global client related buttons and keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "a",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }),
    awful.key({ modkey, }, "d",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }),
    awful.key({ modkey, }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),
    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:activate { raise = true, context = "key.unminimize" }
            end
        end,
        { description = "restore minimized", group = "client" }),
})
-- ]]

-- [[ config client related keys and buttons
local client_buttons = {
    awful.button({},
        1,
        function(c)
            c:activate()
            c:raise()
        end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
}


local client_keys = {
    -- close client
    awful.key({ modkey },
        'q',
        function(c)
            c:kill()
        end,
        { description = 'close', group = 'client' }),
    awful.key({ modkey },
        'f',
        function(c)
            -- Toggle fullscreen
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = 'toggle fullscreen', group = 'client' })
}
-- ]]

-- [[ config keys for awesome
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Control" },
        "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Control" },
        "q",
        awesome.quit,
        { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "s",
        function()
            awesome.emit_signal("hotkeys_popup::show_help")
        end,
        { description = "show help", group = "awesome" }),
})
-- ]]

-- [[ config tag rules

-- [[ config window to specific tag
-- for tag "Terminal"
client_ruled.append_rule {
    rule_any = {
        class = {
            "Alacritty",
            "Kitty"
        }
    },
    except_any = {
        instance = {
            "Dropdown"
        }
    },
    properties = {
        tag = "Terminal",
    },
}

-- for tag "Browser"
client_ruled.append_rule {
    rule_any = {
        class = {
            "firefox"
        }
    },
    properties = {
        tag = "Browser",
    },
}

-- for tag "Document"
client_ruled.append_rule {
    rule_any = {
        class = {
            "masterpdfeditor5",
        }
    },
    properties = {
        tag = "Document",
    },
}

-- for tag "Code"
client_ruled.append_rule {
    rule_any = {
        class = {
            "code-oss",
        }
    },
    properties = {
        tag = "Code",
    },
}

-- for tag "Files"
client_ruled.append_rule {
    rule_any = {
        class = {
            "Zotero",
            "dolpin"
        }
    },
    properties = {
        tag = "Files",
    },
}

-- for tag "Entertainment"
client_ruled.append_rule {
    rule_any = {
        class = {
            "telegram-desktop",
            "Thunderbird"
        }
    },
    properties = {
        tag = "Entertainment",
    },
}
-- ]]

-- ]]

-- [[ rule for different window type
-- Dialogs
client_ruled.append_rule {
    id = 'dialog',
    rule_any = {
        type = { 'dialog' },
        class = { 'Wicd-client.py', 'calendar.google.com' }
    },
    properties = {
        titlebars_enabled = true,
        floating = true,
        above = true,
        skip_decoration = true,
        placement = awful.placement.centered
    }
}

-- Modals
client_ruled.append_rule {
    id = 'dialog',
    rule_any = {
        type = { 'modal' }
    },
    properties = {
        titlebars_enabled = true,
        floating = true,
        above = true,
        skip_decoration = true,
        placement = awful.placement.centered
    }
}

-- Utilities
client_ruled.append_rule {
    id = 'utility',
    rule_any = {
        type = { 'utility' }
    },
    properties = {
        titlebars_enabled = false,
        floating = true,
        hide_titlebars = true,
        skip_decoration = true,
        placement = awful.placement.centered
    }
}

-- Splash
client_ruled.append_rule {
    id = 'splash',
    rule_any = {
        type = { 'splash' }
    },
    properties = {
        titlebars_enabled = false,
        floating = true,
        above = true,
        hide_titlebars = true,
        skip_decoration = true,
        placement = awful.placement.centered
    }
}

-- ]]

-- [[ autostart apps 
local autostart = {
    "picom --experimental-backends --dbus -b --config " .. config_dir .. "assets/picom/picom.conf",
    "redshift",
    "fcitx"
}
--]]

-- [[ configurations for some modules
local module = {
    wallpaper = {
        mode = "auto",
        timezone = 8,
        latitude = 0,
        longitude = 0,
        theme = "YourName"
    }
}
-- ]]
-- return to flyawesome
return {
    theme = "fly", -- choose theme
    modkey = modkey,
    terminal_dropdown = terminal_dropdown,
    tags = tag,
    tag_buttons = tag_buttons,
    client_buttons = client_buttons,
    client_keys = client_keys,
    autostart = autostart,
    module = module
}
