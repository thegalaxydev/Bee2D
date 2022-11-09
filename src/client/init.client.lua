local Engine = require(script.Bee2D.Engine)
local Bee2D = require(script.Bee2D.Main)

Engine:BindToUpdate("Main", function(deltaTime)

end)

Engine:BindToDraw("Main", function()

end)

Bee2D:SetFullscreen(true)
Engine.Run()

