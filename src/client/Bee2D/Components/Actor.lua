local Actor = {}
local CircleCollider = require(script.Parent.CircleCollider)
local Transform2D = require(script.Parent.Transform2D)
local Input = require(script.Parent.Input)
local Sprite = require(script.Parent.Sprite)
local Bee2D = require(script.Parent.Parent.Main)

Actor.__index = Actor
Actor.__class = "Actor"

export type Actor = {
	Name: string,
	Transform: Transform2D.Transform,
	CollisionVolume: CircleCollider.CircleCollider,
	Draw: () -> nil,
}

function Actor.new(name: string, graphic: Sprite.Sprite)
	local self = setmetatable({}, Actor)
	self._lastPosition = Vector2.new(0, 0)
	self.Active = true
	self.Name = name
	self.Graphic = graphic
	self.Transform = Transform2D.new(self)
	self.CollisionVolume = CircleCollider.new(self.Transform.LocalScale, self)

	return self
end

function Actor:Update(deltaTime)
	self._lastPosition = self.Transform:GetPosition();
	local direction = Input.GetMoveInput()
	local velocity = direction * 15 * deltaTime;
	
	
	self:Translate(velocity);
end

function Actor:Translate(direction: Vector2)
	self.Transform:SetPosition(self.Transform:GetPosition() + direction)
end

function Actor:Draw()
	self.Graphic:Draw(self.Transform)
end



function Actor:CheckCollision(other: Actor)
	return self.CollisionVolume ~= nil and self.CollisionVolume.CheckCollision(other) or false
end



return Actor