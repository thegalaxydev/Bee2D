local Stopwatch = {}
Stopwatch.__index = Stopwatch
Stopwatch.__class = "Stopwatch"

function Stopwatch.new()
	local self = setmetatable({}, Stopwatch)
	self.StartTime = tick()
	self.ElapsedTime = 0
	self.ElapsedMilliseconds = 0
	self.IsRunning = false

	self._runTask = nil

	return self
end

function Stopwatch:Start()
	self.IsRunning = true
	self.StartTime = tick()
	self._runTask = task.spawn(function()
		while true do
			if self.IsRunning then
				self.ElapsedTime = tick() - self.StartTime
				self.ElapsedMilliseconds = self.ElapsedTime * 1000
			end
			task.wait()
		end
	end)
end

function Stopwatch:Stop()
	self.IsRunning = false
	task.cancel(self._runTask)
end


return Stopwatch