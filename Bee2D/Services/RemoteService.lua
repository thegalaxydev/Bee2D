local RemoteService = {}
local RunService = game:GetService("RunService") 

RemoteService.RemoteFunctions = {
	Client = {};
	Server = {};
}

local Remote = {}
Remote.__index = Remote

export type Remote = {
	Name: string,
	Callback: () -> ();
}

function Remote.new(name: string, callback: () -> ()) : Remote
	local self = setmetatable({
		Name =	name;
		Callback = callback;
	}, Remote)
	RemoteService.RemoteFunctions[RunService:IsClient() and "Client" or "Server"][name] = callback
	return self
end

function RemoteService:Bind(name: string, callback: () -> ()) : Remote
	assert(name, "Remote name is required")
	assert(callback, "Remote callback is required")

	return Remote.new(name, callback)
end

function RemoteService:Unbind(name: string)
	if RemoteService.RemoteFunctions[RunService:IsClient() and "Client" or "Server"][name] then
		RemoteService.RemoteFunctions[RunService:IsClient() and "Client" or "Server"][name] = nil
	end
end


return RemoteService
