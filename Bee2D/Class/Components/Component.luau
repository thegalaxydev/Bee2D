-- Bee2D by Galaxy#1337

--- @class Component
--- Main component class
local Component = {}
Component.__index = Component
Component.__class = "Component"

local TypeDef = require(script.Parent.Parent.TypeDef)

type Actor = TypeDef.Actor

export type Component = {
	Owner: Actor,
	Name: string,
	Update: (deltaTime: number) -> nil,
	OnCollision: () -> nil,
}

function Component.new(owner: Actor, name: string) : Component
	local self = setmetatable({}, Component)

	self.Owner = owner
	self.Name = name

	return self
end

function Component:Update(deltaTime: number)
	return
end

function Component:OnCollision(other: Actor)
	return
end

return Component