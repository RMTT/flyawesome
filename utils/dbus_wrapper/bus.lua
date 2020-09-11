local lgi = require("lgi")

local Gio = lgi.Gio

local bus = {}

local mt = {}
mt.__index = {
    call = function(self, name, path, interface, member, timeout, args)
        local message = Gio.DBusMessage.new_method_call(name, path, interface, member)
        if args then
            message:set_body(args)
        end

        local result, err = self.bus:async_send_message_with_reply(message, Gio.DBusSendMessageFlags.NONE,
            timeout, nil)

        local body = result:get_body()

        if body then
            if err then
                return false, body
            else
                return true, body
            end
        end
    end
}

local system_bus
local session_bus

function bus.new(type)
    local a, b
    local obj = {}
    setmetatable(obj, mt)
    if type == Gio.BusType.SYSTEM and not system_bus then
        Gio.bus_get(type, nil, coroutine.running())
        a, b = coroutine.yield()
        system_bus = Gio.bus_get_finish(b)
        obj.bus = system_bus
    end

    if type == Gio.BusType.SESSION and not session_bus then
        Gio.bus_get(type, nil, coroutine.running())
        a, b = coroutine.yield()
        session_bus = Gio.bus_get_finish(b)
        obj.bus = session_bus
    end

    return obj
end

return bus