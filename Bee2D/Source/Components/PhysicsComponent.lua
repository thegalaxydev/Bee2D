local PhysicsComponent = {}
PhysicsComponent.__index = PhysicsComponent
PhysicsComponent.__class = "PhysicsComponent"

local TypeDef = require(script.Parent.Parent.TypeDef)

local Component = require(script.Parent.Component)

type Actor = TypeDef.Actor

function PhysicsComponent.new(owner: Actor, name: string)
	local self = setmetatable(Component.new(owner, name), PhysicsComponent)


	return self
end
