local common = {}

function common.clickable(widget,bg)
    local cursor,wibox

    if widget.bg then
        widget:connect_signal("mouse::enter",function()
            if widget.bg then
                widget.bg = bg .. "cc"
            end
    
            local w = mouse.current_wibox
            if w then
                cursor,wibox = w.cursor,w
                wibox.cursor = "hand1"
            end
        end)

        widget:connect_signal("mouse::leave",function()
            if widget.bg then
                widget.bg = bg
            end

            if wibox then
                wibox.cursor = cursor
                wibox = nil
            end
        end)
    end
end

return common