-- AABBCollider.lua
local Collider = require(script.Parent.Collider)

local AABBCollider = {}
AABBCollider.__index = Collider
AABBCollider.__class = "AABBCollider"


function AABBCollider.new(owner)
	local self = Collider.new(owner, "AABB")
	setmetatable(self, {__index = AABBCollider})
	self.width = owner.Transform.Scale.X
	self.height = owner.Transform.Scalele.Y
	return self
end

function AABBCollider:getLeft()
	return self.owner.Transform:GetGlobalPosition().X - self.width / 2
end

function AABBCollider:getRight()
	return self.owner.Transform:GetGlobalPosition().X + self.width / 2
end

function AABBCollider:getTop()
	return self.owner.Transform:GetGlobalPosition().Y - self.height / 2
end

function AABBCollider:getBottom()
	return self.owner.Transform:GetGlobalPosition().Y + self.height / 2
end

function AABBCollider:checkCollisionCircle(collider)
	if collider.owner == self.owner then
		return false
	end
	return collider:checkCollisionAABB(self)
end

function AABBCollider:checkCollisionAABB(collider)
	if collider.owner == self.owner then
		return false
	end
	if collider:getLeft() <= self:getRight() and
		collider:getTop() <= self:getBottom() and
		self:getLeft() <= collider:getRight() and
		self:getTop() <= collider:getBottom() then
		return true
	end
	return false
end

return AABBCollider