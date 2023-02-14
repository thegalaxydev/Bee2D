-- Bee2D by Galaxy#1337

local Collider = require(script.Parent.Collider)

local AABBCollider = {}
AABBCollider.__index = Collider
AABBCollider.__class = "AABBCollider"

setmetatable(AABBCollider, {__index = Collider})
local mt = {__index = AABBCollider}
function AABBCollider.new(owner)
	local self = Collider.new(owner, "AABB")
	setmetatable(self, mt)
	self.width = owner.Transform.Scale.X
	self.height = owner.Transform.Scalele.Y
	return self
end

function AABBCollider:GetLeft()
	return self.owner.Transform:GetGlobalPosition().X - self.width / 2
end

function AABBCollider:GetRight()
	return self.owner.Transform:GetGlobalPosition().X + self.width / 2
end

function AABBCollider:GetTop()
	return self.owner.Transform:GetGlobalPosition().Y - self.height / 2
end

function AABBCollider:GetBottom()
	return self.owner.Transform:GetGlobalPosition().Y + self.height / 2
end

function AABBCollider:CheckCollisionCircle(collider)
	if collider.owner == self.owner then
		return false
	end
	return collider:CheckCollisionAABB(self)
end

function AABBCollider:CheckCollisionAABB(collider)
	if collider.owner == self.owner then
		return false
	end
	if collider:GetLeft() <= self:GetRight() and
		collider:GetTop() <= self:getBottom() and
		self:GetLeft() <= collider:GetRight() and
		self:GetTop() <= collider:GetBottom() then
		return true
	end
	return false
end

return AABBCollider