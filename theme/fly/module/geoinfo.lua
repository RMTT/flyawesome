local sig = require("theme.fly.signal")
local Dbus = require("utils.dbus_wrapper.bus")
local Call = require("utils.dbus_wrapper.call")
local Gio = require("lgi").Gio
local GLib = require("lgi").GLib

local geoinfo = {}

local bus

local function get_geoclue2_client()
    call = Call.new()
    call.name = "org.freedesktop.GeoClue2"
    call.path = "/org/freedesktop/GeoClue2/Manager"
    call.interface = "org.freedesktop.GeoClue2.Manager"
    call.member = "GetClient"
    call.timeout = -1
    call.args = nil
    f, body = call(bus)
    if not f then
        return nil
    else
        return body[1]
    end
end

local function set_geoclue2_desktopid(client_path)
    call.name = "org.freedesktop.GeoClue2"
    call.path = client_path
    call.interface = "org.freedesktop.DBus.Properties"
    call.member = "Set"
    call.timeout = -1
    call.args = GLib.Variant("(sss)", { "org.freedesktop.GeoClue2.Client", "DesktopId", "flyawesome" })
    f, body = call(bus)
    print(body[1])
end

local function start_geoclue2_client(client_path)
    call = Call.new()
    call.name = "org.freedesktop.GeoClue2"
    call.path = client_path
    call.interfce = "org.freedesktop.GeoClue2.Client"
    call.member = "Start"
    call.args = nil
    call.timeout = -1
    f, body = call(bus)
    print(body[1])
end

function geoinfo:init(config)
    Gio.Async.call(function()
        bus = Dbus.new(Gio.BusType.SYSTEM)

        local client_path = get_geoclue2_client()
        print(client_path)
        if not client_path then
            --      do something
        else
            set_geoclue2_desktopid(client_path)
        end
    end)()
end

return geoinfo