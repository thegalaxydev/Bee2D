local PhysicsActor = {}
local Actor = require(script.Parent.Parent.Actor)
local Sprite = require(script.Parent.Parent.Interface.Sprite)
local Collider = require(script.Parent.Parent.Collision.Collider)

setmetatable(PhysicsActor, {__index = Actor})

function PhysicsActor.new(name: string, graphic: Sprite.Sprite)
	local self = Actor.new(name, graphic)
	setmetatable(self, {__index = PhysicsActor})
	
	self.Velocity = Vector2.new(0, 0)
	self.Acceleration = Vector2.new(0, 0)
	self.Gravity = Vector2.new(0, 0)
	self.Collider = Collider.new(self)
	
	return self
end

function PhysicsActor:Update(deltaTime)
	Actor.Update(self, deltaTime)
	
	self.Velocity = self.Velocity + self.Acceleration * deltaTime
	self.Velocity = self.Velocity + self.Gravity * deltaTime
	self:Translate(self.Velocity * deltaTime)
	
	self.Collider:Update()
end

return PhysicsActor