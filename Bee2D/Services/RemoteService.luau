--- @class RemoteService
--- Static Service Class
local RemoteService = {}
local RunService = game:GetService("RunService") 

-- Remote function storage
RemoteService.RemoteFunctions = {
	Client = {};
	Server = {};
}

--- @class Remote
local Remote = {}
Remote.__index = Remote

export type Remote = {
	Name: string,
	Callback: () -> ();
}

--[=[
	Creates a new Remote object

	@param name string
	@param callback () -> ()

	@return Remote -- new Remote object
]=]
function Remote.new(name: string, callback: () -> ()) : Remote
	local self = setmetatable({
		Name =	name;
		Callback = callback;
	}, Remote)
	RemoteService.RemoteFunctions[RunService:IsClient() and "Client" or "Server"][name] = callback
	return self
end
--[=[
	Binds a new callback to a remote.

	@param name string
	@param callback () -> ()
]=]
function RemoteService:Bind(name: string, callback: () -> ()) : Remote
	assert(name, "Remote name is required")
	assert(callback, "Remote callback is required")

	return Remote.new(name, callback)
end

--[=[
	Unbinds a remote.

	@param name string -- The name of the remote
]=]
function RemoteService:Unbind(name: string)
	if RemoteService.RemoteFunctions[RunService:IsClient() and "Client" or "Server"][name] then
		RemoteService.RemoteFunctions[RunService:IsClient() and "Client" or "Server"][name] = nil
	end
end


return RemoteService
