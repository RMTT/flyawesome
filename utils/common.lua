local awful = require("awful")

local common = {}

function common.clickable(widget,bg_normal,bg_enter)
    local cursor,wibox

    if widget.bg then
        widget:connect_signal("mouse::enter",function()
            if widget.bg then
                widget.bg = bg_enter
            end
    
            local w = mouse.current_wibox
            if w then
                cursor,wibox = w.cursor,w
                wibox.cursor = "hand1"
            end
        end)

        widget:connect_signal("mouse::leave",function()
            if widget.bg then
                widget.bg = bg_normal
            end

            if wibox then
                wibox.cursor = cursor
                wibox = nil
            end
        end)
    end
end

function common.show_rofi(mode,config_dir ,location,anchor,offset_x,offset_y,height,width)
    local rofi_cmd = string.format("rofi -show %s",mode)

    if config_dir then
        rofi_cmd = rofi_cmd .. string.format(" -theme %s", config_dir)
    end

    local rofi_window_str = " -theme-str \"#window{"

    if location then
        rofi_window_str = rofi_window_str .. string.format("location:%s;", location)
    end

    if anchor then
        rofi_window_str = rofi_window_str .. string.format("anchor:%s;", anchor)
    end

    if offset_x then
        rofi_window_str = rofi_window_str .. string.format("x-offset:%s;", offset_x)
    end

    if offset_y then
        rofi_window_str = rofi_window_str .. string.format("y-offset:%s;", offset_y)
    end

    if height then
        rofi_window_str = rofi_window_str .. string.format("height:%s;", height)
    end

    if width then
        rofi_window_str = rofi_window_str .. string.format("width:%s;", width)
    end

    rofi_window_str = rofi_window_str .. "}\""
    rofi_cmd = rofi_cmd .. rofi_window_str
    awful.spawn(rofi_cmd, false)
end

return common