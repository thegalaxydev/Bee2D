local PhysicsComponent = {}
PhysicsComponent.__index = PhysicsComponent
PhysicsComponent.__class = "PhysicsComponent"

local TypeDef = require(script.Parent.Parent.TypeDef)

local Component = require(script.Parent.Component)

type Actor = TypeDef.Actor
type Component = Component.Component

export type PhysicsComponent = {
	Owner: Actor,
	Name: string,
	Update: (deltaTime: number) -> nil,
	OnCollision: () -> nil,
} & typeof(PhysicsComponent) & typeof(Component)

function PhysicsComponent.new(owner: Actor, name: string) : PhysicsComponent | Component
	local self = setmetatable(Component.new(owner, name), PhysicsComponent)


	return self
end

return PhysicsComponent