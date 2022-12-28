-- AABBCollider.lua

local AABBCollider = {}
AABBCollider.__index = AABBCollider

function AABBCollider.new(owner)
	local self = setmetatable({}, AABBCollider)
	self.owner = owner
	self.colliderType = "BOX"
	self.width = owner.Transform.Scale.X
	self.height = owner.Transform.Scale.Y
	return self
end

function AABBCollider:getLeft()
	return self.owner.Transform.WorldPosition.X - self.width / 2
end

function AABBCollider:getRight()
	return self.owner.Transform.WorldPosition.X + self.width / 2
end

function AABBCollider:getTop()
	return self.owner.Transform.WorldPosition.Y - self.height / 2
end

function AABBCollider:getBottom()
	return self.owner.Transform.WorldPosition.Y + self.height / 2
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