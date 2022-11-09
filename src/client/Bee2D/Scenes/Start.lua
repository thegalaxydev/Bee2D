local Scene = require(script.Parent.Parent.Components.Scene)
local Actor = require(script.Parent.Parent.Components.Actor)
local Sprite = require(script.Parent.Parent.Components.Sprite)
local Input = require(script.Parent.Parent.Components.Input)

local Bee2D = require(script.Parent.Parent.Main)

local Start = Scene.new()
Start.Prioritize = true

local player = Start:AddActor(Actor.new("Player", Sprite.new(Color3.new(1, 1, 1), "rbxassetid://11508210561")))
player.Transform:SetScale(Vector2.new(100, 100))
player.Transform:SetPosition(Vector2.new(25, 25))

local enemy = Start:AddActor(Actor.new("Enemy", Sprite.new(Color3.new(1, 1, 1), "rbxassetid://11508205472")))
enemy.Transform:SetScale(Vector2.new(100, 100))
enemy.Transform:SetPosition(Vector2.new(400, 400))


function player:Update(deltaTime)
	player.CollisionVolume.Radius = player.Transform:GetScale().X
	player._lastPosition = player.Transform:GetPosition();

	local direction = Input.GetMoveInput()
	local velocity = direction * 50 * deltaTime;

	player:Translate(velocity);
end

function enemy:Update(deltaTime)
	enemy.CollisionVolume.Radius = enemy.Transform:GetScale().X
	local enemyPosition = enemy.Transform:GetPosition()
	local playerPosition = player.Transform:GetPosition()

	enemy._lastPosition = enemyPosition;
	local direction = (playerPosition - enemyPosition).Unit
	local velocity = direction * 25 * deltaTime;

	if (playerPosition - enemyPosition).Magnitude > 75 and Vector2.xAxis:Dot(direction) >= 0.5 then
		enemy:Translate(velocity);
	end
end

function enemy:Draw()
	enemy.Graphic:Draw(enemy.Transform)
	local enemyPosition = enemy.Transform:GetPosition()
	enemy.CollisionVolume:Draw()

	local radians = math.acos(0.5);
	local endLineDirection = Vector2.new(math.cos(radians), math.sin(radians)) * -(75 / math.cos(radians * 180 / math.pi));

	Bee2D.DrawLine(Vector2.new(enemyPosition.X, enemyPosition.Y), Vector2.new(enemyPosition.X + 75, enemyPosition.Y), 2, Color3.new(1, 0, 0))
	Bee2D.DrawLine(Vector2.new(enemyPosition.X, enemyPosition.Y), Vector2.new(enemyPosition.X + endLineDirection.X, enemyPosition.Y - endLineDirection.Y), 2, Color3.new(1, 0, 0))
	Bee2D.DrawLine(Vector2.new(enemyPosition.X, enemyPosition.Y), Vector2.new(enemyPosition.X + endLineDirection.X, enemyPosition.Y + endLineDirection.Y), 2, Color3.new(1, 0, 0))

end

return Start