local Collider = {}
Collider.__index = Collider
Collider.__class = "Collider"

export type Collider = {
	Owner: {},
	CollisionInformation: {}
}

function Collider.new(owner: {}, collisionType: string)
	local self = setmetatable({}, {__index = Collider})
	self.Owner = owner
	self.CollisionType = collisionType

	return self
end

function Collider:checkCollision(other)
	if self.CollisionType == "AABB" then
		return if other.CollisionType == "AABB" then self:checkCollisionAABB(other)
			elseif other.CollisionType == "CIRCLE" then self:checkCollisionCircle(other)
			elseif other.CollisionType == "OBB" then self:checkCollisionOBB(other)
			else false
	elseif self.CollisionType == "CIRCLE" then
		return if other.CollisionType == "AABB" then self:checkCollisionAABB(other)
			elseif other.CollisionType == "CIRCLE" then self:checkCollisionCircle(other)
			elseif other.CollisionType == "OBB" then self:checkCollisionOBB(other)
			else false
	elseif self.CollisionType == "OBB" then
		return if other.CollisionType == "AABB" then self:checkCollisionAABB(other)
			elseif other.CollisionType == "CIRCLE" then self:checkCollisionCircle(other)
			elseif other.CollisionType == "OBB" then self:checkCollisionOBB(other)
			else false
	end
end


return Collider