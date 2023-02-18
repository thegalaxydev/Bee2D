local Event = require(script.Parent.Parent.Util.Event)

type Connection = RBXScriptConnection | Event.Connection

--- @class Connections
--- Static Connections Class
local Connections = {}
Connections.Connections = {}

--[=[
    Inserts a new connections into the Connections holder

    @param name string -- The name of the connection handler
    @param events {[string] : Connection} -- A table of event connections to insert
]=]
function Connections:Insert(name: string, events: {[string] : Connection})
    if not self.Connections[name] then
        self.Connections[name] = {}
    end
    for i,v in pairs(events) do
        self.Connections[name][i] = v
    end
end

--[=[
    Disconnects all connections from a given handler

    @param name string -- The name of the handler
]=]
function Connections:DisconnectAll(name : string)
    if not self.Connections[name] then return end

    for _,event in pairs(self.Connections[name]) do
        event:Disconnect()
        event = nil
    end
end

--[=[
    Disconnects a list of events from a given handler

    @param name string -- The name of the handler
    @param ... string -- A list of events to disconnect
]=]
function Connections:Disconnect(name : string, ... : string)
    if not self.Connections[name] then return end
    local events = {...}
    for _,event in pairs(events) do
        if self.Connections[name][event] then
            self.Connections[name][event]:Disconnect()
            self.Connections[name][event] = nil
        end
    end
end

return Connections