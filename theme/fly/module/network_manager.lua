local lgi = require("lgi")
local DBus = require("utils.dbus_wrapper.bus")
local Call = require("utils.dbus_wrapper.call")
local constants = require("utils.constants")
local sig = require("theme.fly.signal")
local Gio = lgi.Gio
local GLib = lgi.GLib

local nm = {}
local id, type
local bus

local function get_current_active_connection()
    local call = Call.new()
    call.name = "org.freedesktop.NetworkManager"
    call.path = "/org/freedesktop/NetworkManager"
    call.interface = "org.freedesktop.DBus.Properties"
    call.member = "Get"
    call.args = GLib.Variant("(ss)", { "org.freedesktop.NetworkManager", "ActivatingConnection" })
    call.timeout = -1
    local f, body = call(bus)

    local s = body[1]:get_string()
    local path = string.format("%s", s)

    call.path = path
    call.interface = "org.freedesktop.DBus.Properties"
    call.member = "GetAll"
    call.args = GLib.Variant("(s)", { "org.freedesktop.NetworkManager.Connection.Active" })
    f, body = call(bus)
    if f then
        return body[1]
    end

    return nil
end

local function emit_state_signal(state)
    awesome.emit_signal(sig.network_manager.state_changed, state, {
        id = id,
        type = type
    })
end

local function network_state_changed(conn, sender, object_path, interface_name, signal_name, user_data)
    local state = tonumber(user_data[1])
    if state == constants.NM_STATE_UNKNOWN or state == constants.NM_STATE_ASLEEP
            or state == constants.NM_STATE_DISCONNECTED or state == constants.NM_STATE_DISCONNECTING then
        id = nil
        type = nil
        emit_state_signal(constants.NETWORK_DISCONNECTED)
    end

    if state == constants.NM_STATE_CONNECTING then
        local result = get_current_active_connection()
        if result then
            id = result.Id
            type = result.Type
            emit_state_signal(constants.NETWORK_CONNECTING)
        end
    end

    if state == constants.NM_STATE_CONNECTED_LOCAL or state == constants.NM_STATE_CONNECTED_SITE then
        emit_state_signal(constants.NETWORK_CONNECTED_NO_INTERNET)
    end

    if state == constants.NM_STATE_CONNECTED_GLOBAL then
        emit_state_signal(constants.NETWORK_CONNECTED)
    end
end

function nm:init(config)
    Gio.Async.call(function()
        bus = DBus.new(Gio.BusType.SYSTEM)
        local result = get_current_active_connection()
        if result then
            if not id and not type then
                id = result.Id
                type = result.Type
            end
            local state = result.State
            if state == constants.NM_ACTIVE_CONNECTION_STATE_UNKNOWN or state == constants.NM_ACTIVE_CONNECTION_STATE_DEACTIVATING
                    or state == constants.NM_ACTIVE_CONNECTION_STATE_DEACTIVATED then
                emit_state_signal(constants.NETWORK_DISCONNECTED)
            end

            if state == constants.NM_ACTIVE_CONNECTION_STATE_ACTIVATING then
                emit_state_signal(constants.NETWORK_CONNECTING)
            end

            if state == constants.NM_ACTIVE_CONNECTION_STATE_ACTIVATED then
                emit_state_signal(constants.NETWORK_CONNECTED)
            end
        end

        bus:signal_subscribe("org.freedesktop.NetworkManager", "org.freedesktop.NetworkManager", "StateChanged",
            nil, nil, Gio.DBusSignalFlags.NONE, network_state_changed)
    end)()
end

return nm