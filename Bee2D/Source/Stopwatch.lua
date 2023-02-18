-- Bee2D by Galaxy#1337
export type Stopwatch = {
	Start: () -> (),
	Peek: () -> number,
	Poll: () -> number,
}

local Stopwatch = {}
Stopwatch.__index = Stopwatch
Stopwatch.__class = "Stopwatch"

function Stopwatch.new()
	local self = setmetatable({}, Stopwatch)
	self.LastPollTime = os.clock()
end

function Stopwatch:Start()
	self.LastPollTime = os.clock()
end

function Stopwatch:Peek()
	return os.clock() - self.LastPollTime
end

function Stopwatch:Poll()
	local elapsedTime = self:Peek()
	self:Start()
	return elapsedTime
end

return Stopwatch