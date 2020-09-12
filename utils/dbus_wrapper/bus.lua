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

        local result = self.bus:send_message_with_reply_sync(message, Gio.DBusSendMessageFlags.NONE,
            timeout, nil)

        if result and result:get_message_type() == "ERROR" then
            return false, result:get_body()
        elseif result then
            return true, result:get_body()
        else
            return true
        end
    end,
    signal_subscribe = function(self, ...)
        self.bus:signal_subscribe(...)
    end
}

local system_bus
local session_bus

function bus.new(type)
    local a, b
    local obj = {}
    setmetatable(obj, mt)
    if type == Gio.BusType.SYSTEM then
        if not system_bus then
            Gio.bus_get(type, nil, coroutine.running())
            a, b = coroutine.yield()
            system_bus = Gio.bus_get_finish(b)
        end
        obj.bus = system_bus
    end

    if type == Gio.BusType.SESSION then
        if not session_bus then
            Gio.bus_get(type, nil, coroutine.running())
            a, b = coroutine.yield()
            session_bus = Gio.bus_get_finish(b)
        end
        obj.bus = session_bus
    end

    return obj
end

return bus