local Event = {}
Event.__index = Event
Event.__class = "Event"

export type Event = {
    Callbacks : {};
    Waiting : {};
}
export type Connection = {
    Connected : boolean
}

function Event.new() : Event
    return setmetatable({
        Callbacks = {};
        Waiting = {};
    }, Event)
end


function revipairs(t)
    return function(tb : {}, i : number)
        i = i - 1
        if i > 0 then
            return i, tb[i]
        end
    end, t, #t + 1
end


function Event:Connect(func) : Connection
    local connection = {}
    connection.Connected = true

    function connection:Disconnect()
        self.Callbacks[func] = nil
        connection.Connected = false
        connection = nil
    end
    
    self.Callbacks[func] = newproxy()

    return connection
end

function Event:Fire(...)
    for func in revipairs(self.Callbacks) do
        coroutine.create(func)(...)
	end

	for _, thread in revipairs(self.Waiting) do
        table.remove(self.Waiting, thread)
        coroutine.resume(thread , ...)
	end
end

function Event:Wait()
    local thread = coroutine.running()
    table.insert(self.Waiting, 1, thread)
    
    coroutine.yield()
end

return Event