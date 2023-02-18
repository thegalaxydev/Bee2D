local Event = require(script.Parent.Event)

local Connections = {}
Connections.Connections = {}


function Connections:Insert(name: string, events: {[string] : RBXScriptConnection | Event.Connection})
    if not self.Connections[name] then
        self.Connections[name] = {}
    end
    for i,v in pairs(events) do
        self.Connections[name][i] = v
    end
end

function Connections:DisconnectAll(name : string)
    if not self.Connections[name] then return end

    for _,event in pairs(self.Connections[name]) do
        event:Disconnect()
        event = nil
    end
end

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