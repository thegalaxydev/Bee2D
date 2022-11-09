local CircleCollider = {}
local Bee2D = require(script.Parent.Parent.Main)
CircleCollider.__index = CircleCollider
CircleCollider.__class = "CircleCollider"

export type CircleCollider = {
	Radius: number,
	Position: Vector2,
	Owner: {},
}

function CircleCollider.new(radius: number, owner: {})
	local self = setmetatable({}, {__index = CircleCollider})
	self.Radius = radius
	self.Owner = owner

	return self
end

function CircleCollider:CheckCircleCollision(other: CircleCollider): boolean
	assert(other.__class, "[Bee2D] Circle Collision can only be checked with a Circle Collider")
	assert(other.__class == "CircleCollider", "[Bee2D] Circle Collision can only be checked with a Circle Collider")
	return (self.Owner.Transform:GetPosition() - other.Owner.Transform:GetPosition()).Magnitude <= self.Radius + other.Radius
end

function CircleCollider:CheckCollision(other: {}): boolean
	assert(other.__class, "[Bee2D] Collision can only be checked with Actor")
	assert(other.__class == "Actor", "[Bee2D] Collision can only be checked with Actor")
	if other.CollisionVolume == nil then return false end

	if other.CollisionVolume.__class == "CircleCollider" then
		return self:CheckCircleCollision(other.CollisionVolume)
	end
end

function CircleCollider:Draw()
	local pos = self.Owner.Transform:GetPosition()
	Bee2D.DrawCircleLine(pos.X, pos.Y, self.Radius, Color3.fromRGB(255, 0, 0))
end




return CircleCollider