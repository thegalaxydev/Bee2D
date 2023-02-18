local Component = {}
Component.__index = Component
Component.__class = "Component"

local TypeDef = require(script.Parent.Parent.TypeDef)

type Actor = TypeDef.Actor

export type Component = {
	Owner: Actor,
	Name: string,
	Start: () -> nil,
	Update: (deltaTime: number) -> nil,
	OnCollision: () -> nil,
	Draw: () -> nil,
}

function Component.new(owner: Actor, name: string)
	local self = setmetatable({}, Component)

	self.Owner = owner
	self.Name = name

	return self
end

function Component:Start(): nil
	return
end

function Component:Update(deltaTime: number): nil
	return
end

function Component:OnCollision(): nil
	return
end

function Component:Draw(identifier: number): nil
	return
end

return Component