RunService = game:GetService("RunService");
ReplicatedStorage = game:GetService("ReplicatedStorage");
local Remote = ReplicatedStorage.Bee2D.Storage.Remote

local RemoteService = require(ReplicatedStorage.Bee2D.Services.RemoteService)

game.Players.CharacterAutoLoads = false;

Remote.OnServerInvoke = function(...)
	local info = table.pack(...)
	return RemoteService.RemoteFunctions.Server[info[2]](info[1], table.unpack(info, 3))
end