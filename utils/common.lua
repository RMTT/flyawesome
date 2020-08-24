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

return common