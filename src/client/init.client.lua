local Engine = require(script.Bee2D.Engine);
local Bee2D = require(script.Bee2D.Main)

local Actor = require(script.Bee2D.Components.Actor)
local Sprite = require(script.Bee2D.Components.Sprite)

Engine.Run();

newActor = Actor.new("Test", Sprite.new(Color3.new(1, 1, 1), "rbxassetid://7285797360"));
newActor.Transform:SetScale(Vector2.new(50, 50))
newActor.Transform:SetPosition(Vector2.new(25, 25))

Engine:BindToUpdate("Main", function(deltaTime)
    newActor:Update(deltaTime)
end)

Engine:BindToDraw("Main", function()
    newActor:Draw()
end)

