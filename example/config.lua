local gears = require("gears")
local awful = require("awful")

local config_dir = gears.filesystem.get_xdg_config_home() .. "flyawesome/"

-- [[ config modkey and some default apps ]]
    local modkey = "Mod4"
    local terminal = "kitty"
-- ]]

-- [[ config tag 

-- [[ the icon must be a surface object or absolute path of icon file
local tag = {
    {
        name = "Terminal",
        icon = config_dir .. "/assets/icons/taglist_terminal.svg",
        icon_selected = config_dir .. "assets/icons/taglist_terminal_selected.svg",
        default = true
    },
    {
        name = "Browser",
        icon = config_dir .. "assets/icons/taglist_browser.svg",
        icon_selected =  config_dir .. "assets/icons/taglist_browser_selected.svg"
    },
    {
        name = "Document",
        icon = config_dir .. "assets/icons/taglist_document.svg",
        icon_selected =  config_dir .. "assets/icons/taglist_document_selected.svg"
    },
    {
        name = "Code",
        icon = config_dir .. "assets/icons/taglist_code.svg",
        icon_selected =  config_dir .. "assets/icons/taglist_code_selected.svg"
    }
}
-- ]]

-- [[ config mouse and keyboard events
local tag_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
)
-- ]]

-- [[ config tag related keys
awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                    tag:emit_signal("taglist::update_icon",tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    },
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
})

-- ]]

-- ]]

-- [[ config keys for launch some apps
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"})
})
--]]


-- [[ config for client related buttons and keys
    awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})
-- ]]

-- [[ config keys for awesome
    awful.keyboard.append_global_keybindings({
        awful.key({modkey, 'Control'}, 
		'r', 
		awesome.restart, 
		{description = 'reload awesome', group = 'awesome'}
	),
	awful.key({modkey, 'Control'}, 
		'q', 
		awesome.quit, 
		{description = 'quit awesome', group = 'awesome'}
	),
    })
-- ]]

-- return to flyawesome
return {
    theme = "fly",   -- choose theme
    modkey = modkey,
    tags = tag,
    tag_buttons = tag_buttons
}