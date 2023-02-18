-- Bee2D by Galaxy#1337

local Collider = {}
Collider.__index = Collider
Collider.__class = "Collider"


function Collider.new(owner: {}, collisionType: string)	
	local self = setmetatable({}, {__index = Collider})
	self.Owner = owner
	self.CollisionType = collisionType

	return self
end

function Collider:CheckCollision(other)
	if self.CollisionType == "AABB" then
		return if other.CollisionType == "AABB" then self:CheckCollisionAABB(other)
			elseif other.CollisionType == "CIRCLE" then self:CheckCollisionCircle(other)
			elseif other.CollisionType == "OBB" then self:CheckCollisionOBB(other)
			else false
	elseif self.CollisionType == "CIRCLE" then
		return if other.CollisionType == "AABB" then self:CheckCollisionAABB(other)
			elseif other.CollisionType == "CIRCLE" then self:CheckCollisionCircle(other)
			elseif other.CollisionType == "OBB" then self:CheckCollisionOBB(other)
			else false
	elseif self.CollisionType == "OBB" then
		return if other.CollisionType == "AABB" then self:CheckCollisionAABB(other)
			elseif other.CollisionType == "CIRCLE" then self:CheckCollisionCircle(other)
			elseif other.CollisionType == "OBB" then self:CheckCollisionOBB(other)
			else false
	end
end


return Collider