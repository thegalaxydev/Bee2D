local Actor = {}
local Collider = require(script.Parent.Collider)
local Transform2D = require(script.Parent.Transform2D)
local Input = require(script.Parent.Input)
local Sprite = require(script.Parent.Sprite)
local Bee2D = require(script.Parent.Parent.Main)

Actor.__index = Actor
Actor.__class = "Actor"

export type Actor = {
	Name: string,
	Transform: Transform2D.Transform,
	CollisionVolume: Collider.Collider,
	Draw: () -> nil,
}

function Actor.new(name: string, graphic: Sprite.Sprite)
	local self = setmetatable({}, Actor)
	self._lastPosition = Vector2.new(0, 0)
	self.Active = true
	self.Name = name
	self.Graphic = graphic
	self.Transform = Transform2D.new(self)
	self.CollisionVolume = Collider.new(self, "Circle")
	self.CollisionVolume.CollisionInformation.Radius = self.Transform:GetScale().X / 2

	return self
end

function Actor:Start()
end

function Actor:Update(deltaTime)
	self.CollisionVolume.Radius = self.Transform:GetScale().X / 2
end


function Actor:Translate(direction: Vector2)
	self.Transform:SetPosition(self.Transform:GetPosition() + direction)
end

function Actor:Draw()
	if self.Graphic then
		self.Graphic:Draw(self.Transform)
	end
end



function Actor:CheckCollision(other: Actor)
	return self.CollisionVolume ~= nil and self.CollisionVolume.CheckCollision(other) or false
end



return Actor