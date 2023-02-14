-- Bee2D by Galaxy#1337


local Collider = require(script.Parent.Collision.Collider)
local Transform2D = require(script.Parent.Transform2D)
local Input = require(script.Parent.Interface.Input)
local Sprite = require(script.Parent.Interface.Sprite)
local Bee2D = require(script.Parent.Parent.Main)

local Component = require(script.Parent.Components.Component)

local Actor = {}
Actor.__index = Actor
Actor.__class = "Actor"

type Sprite = Sprite.Sprite
type Component = Component.Component
type Transform = Transform2D.Transform

export type Actor = {
	Name: string,
	Transform: Transform,
	Draw: () -> nil,
	Update: (deltaTime: number) -> nil,
	Translate: (direction: Vector2) -> nil,
	Active: boolean,
	Graphic: Sprite,
	_lastPosition: Vector2,
}

function Actor.new(name: string, graphic: Sprite)
	local self = setmetatable({}, Actor)
	self._lastPosition = Vector2.new(0, 0)
	self.Active = true
	self.Name = name
	self.Graphic = graphic
	self.Transform = Transform2D.new(self)
	self.Components = {}
	return self
end

function Actor:Start()
	for _, comp in pairs(self.Components) do
		comp:Start()
	end
end

function Actor:AddComponent(component: Component)
	table.insert(self.Components, component)
end

function Actor:RemoveComponent(component: Component)
	for i, comp in pairs(self.comp) do
		if comp == component then
			table.remove(self.comp, i)
		end
	end
end

function Actor:GetComponent(name: string)
	for _, comp in pairs(self.Components) do
		if comp.Name == name then
			return comp
		end
	end
end

function Actor:Update(deltaTime: number)
	self.Transform:UpdateTransform();

	for _, comp in pairs(self.Components) do
		comp:Update(deltaTime)
	end
end

function Actor:OnCollision()
	for _, comp in pairs(self.Components) do
		comp:OnCollision()
	end
end


function Actor:Translate(direction: Vector2)
	self.Transform:SetLocalPosition(self.Transform:GetLocalPosition() + direction)
end

function Actor:Draw()
	if self.Graphic then
		self.Graphic:Draw(self.Transform)
	end

	for _, comp in pairs(self.Components) do
		comp:Draw()
	end
end

return Actor