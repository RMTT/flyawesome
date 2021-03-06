local DBus = require("utils.dbus_wrapper.bus")
local Call = require("utils.dbus_wrapper.call")
local sig = require("theme.fly.signal")
local lgi = require("lgi")
local Gio = lgi.Gio
local GLib = lgi.GLib
local constants = require("utils.constants")

local battery_manager = {}
local devices_type = {}
local bus

local function get_display_device()
    local call = Call.new()
    call.name = "org.freedesktop.UPower"
    call.path = "/org/freedesktop/UPower"
    call.interface = "org.freedesktop.UPower"
    call.member = "GetDisplayDevice"
    call.timeout = -1
    call.args = nil
    local f, body = call(bus)

    if f then
        return body[1]
    else
        return nil
    end
end

local function parse_device(path, display)
    local call = Call.new()
    call.name = "org.freedesktop.UPower"
    call.path = path
    call.interface = "org.freedesktop.DBus.Properties"
    call.member = "GetAll"
    call.timeout = -1
    call.args = GLib.Variant("(s)", { "org.freedesktop.UPower.Device" })
    local f, body = call(bus)

    local data = body.value[1]
    local type = constants.BATTERY_DEVICE_OTHER
    if display then
        type = constants.BATTERY_DEVICE_DISPLAY
    end
    devices_type[path] = data["Type"]

    if devices_type[path] ~= constants.BATTERY_DEVICE_TYPE_LINE_POWER then
        awesome.emit_signal(sig.battery_manager.update_device, {
            type = type,
            path = path,
            device_type = devices_type[path],
            state = data["State"],
            percentage = data["Percentage"],
            model = data["Model"]
        })
    end
end

local function get_devices()
    local call = Call.new()
    call.name = "org.freedesktop.UPower"
    call.path = "/org/freedesktop/UPower"
    call.interface = "org.freedesktop.UPower"
    call.member = "EnumerateDevices"
    call.timeout = -1
    call.args = nil
    local f, body = call(bus)

    local res = {}
    if f then
        for i = 1, #body[1] do
            table.insert(res, body[1][i])
        end
    end
    return res
end

local function device_added(conn, sender, path, interface_name, signal_name, user_data)
    parse_device(user_data.value[1], false)
end

local function device_removed(conn, sender, path, interface_name, signal_name, user_data)
    awesome.emit_signal(sig.battery_manager.remove_device, user_data.value[1])
end

function battery_manager:init(config)
    Gio.Async.call(function()
        bus = DBus.new(Gio.BusType.SYSTEM)

        -- get display device
        local display_device = get_display_device()

        parse_device(display_device, true)

        -- enumerate device
        local devices = get_devices()
        for i = 1, #devices do
            parse_device(devices[i])
        end

        bus:signal_subscribe("org.freedesktop.UPower", "org.freedesktop.DBus.Properties", "PropertiesChanged",
            nil, nil, Gio.DBusSignalFlags.NONE, function(conn, sender, path, interface_name, signal_name, user_data)
                local data = user_data.value[2]
                if user_data.value[1] == "org.freedesktop.UPower.Device" then
                    local type = constants.BATTERY_DEVICE_OTHER
                    if path == display_device then
                        type = constants.BATTERY_DEVICE_DISPLAY
                    end

                    if devices_type[path] ~= constants.BATTERY_DEVICE_TYPE_LINE_POWER then
                        awesome.emit_signal(sig.battery_manager.update_device, {
                            type = type,
                            path = path,
                            device_type = devices_type[path],
                            state = data["State"],
                            percentage = data["Percentage"],
                            model = data["Model"]
                        })
                    end
                end
            end)

        bus:signal_subscribe("org.freedesktop.UPower", "org.freedesktop.UPower", "DeviceAdded",
            nil, nil, Gio.DBusSignalFlags.NONE, device_added)

        bus:signal_subscribe("org.freedesktop.UPower", "org.freedesktop.UPower", "DeviceRemoved",
            nil, nil, Gio.DBusSignalFlags.NONE, device_removed)
    end)()
end

return battery_manager