local Event = {}
Event.__index = Event
Event.__class = "Event"

export type Event = {
	Callbacks : {};
	Waiting : {};
	Connect : (Event, func : () -> nil) -> Connection,
	Fire : (Event, ...any) -> nil,
	Wait : (Event) -> any
}
export type Connection = {
	Connected : boolean,
	Disconnect: () -> nil
}

function Event.new() : Event
	local self = setmetatable({}, Event)
	self.Callbacks = {}
	self.Waiting = {}

	return self
end

function Event:Connect(func) : Connection
	print("Event connected")
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
	for func in pairs(self.Callbacks) do
		coroutine.create(func)(...)
	end

	for _, thread in pairs(self.Waiting) do
		table.remove(self.Waiting, thread)
		coroutine.resume(thread , ...)
	end
end

function Event:Wait()
	local thread = coroutine.running()
	table.insert(self.Waiting, thread)

	return coroutine.yield()
end

return Event