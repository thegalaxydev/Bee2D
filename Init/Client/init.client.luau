ReplicatedStorage = game:GetService("ReplicatedStorage");
local Remote = ReplicatedStorage.Bee2D.Storage.Remote
local RemoteService = require(ReplicatedStorage.Bee2D.Services.RemoteService)
local Engine = require(ReplicatedStorage.Bee2D.Engine)

Remote.OnClientInvoke = function(...)
	local info = table.pack(...)
	return RemoteService.RemoteFunctions.Server[info[1]](table.unpack(info, 2))
end

Engine.LoadScenes(script.Scenes)
Engine.Run()

