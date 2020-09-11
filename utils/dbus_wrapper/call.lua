local call = {}

local mt = {}

function mt.__call(self, bus)
    if not self.timeout then
        self.timeout = -1
    end
    return bus:call(self.name, self.path, self.interface, self.member, self.timeout, self.args)
end

mt.__index = {
    set = function(self, name, path, interface, member, timeout, args)
        self.name = name
        self.path = path
        self.interface = interface
        self.member = member
        self.args = args
        self.timeout = timeout
    end
}

function call.new()
    local obj = {}
    setmetatable(obj, mt)

    return obj
end


return call