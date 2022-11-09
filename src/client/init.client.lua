local Engine = require(script.Bee2D.Engine);
local Bee2D = require(script.Bee2D.Main)

local Actor = require(script.Bee2D.Components.Actor)
local Sprite = require(script.Bee2D.Components.Sprite)
local Input = require(script.Bee2D.Components.Input)


Bee2D:SetFullscreen(true);
Engine.Run();




Engine:BindToUpdate("Main", function(deltaTime)

end)

Engine:BindToDraw("Main", function()

end)

