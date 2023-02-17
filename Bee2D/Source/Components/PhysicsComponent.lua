local PhysicsComponent = {}
PhysicsComponent.__index = PhysicsComponent
PhysicsComponent.__class = "PhysicsComponent"

local Component = require(script.Parent.Component)



function PhysicsComponent.new()
	local self = setmetatable(Component.new(), PhysicsComponent)


	return self
end
