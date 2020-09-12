local sig = require("theme.fly.signal")
local Dbus = require("utils.dbus_wrapper.bus")
local Call = require("utils.dbus_wrapper.call")
local Gio = require("lgi").Gio
local GLib = require("lgi").GLib
local naughty = require("naughty")

local geoinfo = {}

local bus

local function get_geoclue2_client()
    local call = Call.new()
    call.name = "org.freedesktop.GeoClue2"
    call.path = "/org/freedesktop/GeoClue2/Manager"
    call.interface = "org.freedesktop.GeoClue2.Manager"
    call.member = "GetClient"
    call.timeout = -1
    call.args = nil
    local f, body = call(bus)

    if not f then
        return nil
    else
        return body[1]
    end
end

local function set_geoclue2_desktopid(client_path)
    local call = Call.new()
    call.name = "org.freedesktop.GeoClue2"
    call.path = client_path
    call.interface = "org.freedesktop.DBus.Properties"
    call.member = "Set"
    call.timeout = -1
    call.args = GLib.Variant("(ssv)", { "org.freedesktop.GeoClue2.Client", "DesktopId", GLib.Variant("s", "flyawesome") })
    local f, body = call(bus)
    return f
end

local function start_geoclue2_client(client_path)
    local call = Call.new()
    call.name = "org.freedesktop.GeoClue2"
    call.path = client_path
    call.interface = "org.freedesktop.GeoClue2.Client"
    call.member = "Start"
    call.args = nil
    call.timeout = -1
    local f, body = call(bus)
    return f
end

local function get_location(location_path)
    local call = Call.new()
    call.name = "org.freedesktop.GeoClue2"
    call.path = location_path
    call.interface = "org.freedesktop.DBus.Properties"
    call.member = "GetAll"
    call.args = GLib.Variant("(s)", { "org.freedesktop.GeoClue2.Location" })
    call.timeout = -1
    local f, body = call(bus)
    if f then
        return body[1].Latitude, body[1].Longitude
    else
        return nil, nil
    end
end

local function location_update(conn, sender, object_path, interface_name, signal_name, user_data)
    local old_path = user_data[1]
    local new_path = user_data[2]
    local la, lo = get_location(new_path)

    if la and lo then
        print(la, lo)
        awesome.emit_signal(sig.geoinfo.geoinfo_update, la, lo)
    end
end

function geoinfo:init(config)
    Gio.Async.call(function()
        bus = Dbus.new(Gio.BusType.SYSTEM)
        local client_path = get_geoclue2_client()
        print(client_path)

        bus:signal_subscribe("org.freedesktop.GeoClue2", "org.freedesktop.GeoClue2.Client", "LocationUpdated",
            nil, nil, Gio.DBusSignalFlags.NONE, location_update)

        if client_path then
            local f = set_geoclue2_desktopid(client_path)
            if f then
                start_geoclue2_client(client_path)
            end
        end
    end)()
end

return geoinfo