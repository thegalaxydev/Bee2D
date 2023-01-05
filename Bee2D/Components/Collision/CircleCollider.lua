-- Bee2D by Galaxy#1337

local CircleCollider = {}
local Collider = require(script.Parent.Collider)
CircleCollider.__index = Collider

setmetatable(CircleCollider, {__index = Collider})
local mt = {__index = CircleCollider}
function CircleCollider.new(owner, collisionRadius)
	local self = Collider.new(owner, "CIRCLE")
	setmetatable(self, mt)
	self.owner = owner
	self.collisionRadius = collisionRadius
	return self
end

function CircleCollider:checkCollisionCircle(otherCollider)
	if otherCollider.owner == self.owner then
		return false
	end
	local combinedRadii = otherCollider.collisionRadius + self.collisionRadius
	local distance = (otherCollider.owner.Transform:GetGlobalPosition() - self.owner.Transform:GetGlobalPosition()).magnitude
	return distance <= combinedRadii
end

function CircleCollider:checkCollisionAABB(otherCollider)
	if otherCollider.owner == self.owner then
		return false
	end
	local direction = self.owner.Transform:GetGlobalPosition() - otherCollider.owner.Transform:GetGlobalPosition()
	direction.X = direction.X < -otherCollider.width / 2 and -otherCollider.width or direction.X
	direction.X = direction.X > otherCollider.width / 2 and otherCollider.width or direction.X
	direction.Y = direction.Y < -otherCollider.height / 2 and -otherCollider.height or direction.Y
	direction.Y = direction.Y > otherCollider.height / 2 and otherCollider.height or direction.Y
	local closestPoint = otherCollider.owner.Transform:GetGlobalPosition() + direction
	local distanceFromClosestPoint = (self.owner.Transform:GetGlobalPosition() - closestPoint).Magnitude
	if distanceFromClosestPoint <= self.collisionRadius then
		return true
	end
	return false
end

return CircleCollider