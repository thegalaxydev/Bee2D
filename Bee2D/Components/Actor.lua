local Actor = {}
local Collider = require(script.Parent.Collider)
local Transform2D = require(script.Parent.Transform2D)
local Input = require(script.Parent.Interface.Input)
local Sprite = require(script.Parent.Interface.Sprite)
local Bee2D = require(script.Parent.Parent.Main)

Actor.__index = Actor
Actor.__class = "Actor"

export type Actor = {
	Name: string,
	Transform: Transform2D.Transform,
	Draw: () -> nil,
}

function Actor.new(name: string, graphic: Sprite.Sprite)
	local self = setmetatable({}, Actor)
	self._lastPosition = Vector2.new(0, 0)
	self.Active = true
	self.Name = name
	self.Graphic = graphic
	self.Transform = Transform2D.new(self)
	return self
end

function Actor:Start()
end

function Actor:Update(deltaTime)
	self.Transform:UpdateTransform();
end


function Actor:Translate(direction: Vector2)
	self.Transform:SetLocalPosition(self.Transform:GetLocalPosition() + direction)
end

function Actor:Draw()
	if self.Graphic then
		self.Graphic:Draw(self.Transform)
	end
end

return Actor