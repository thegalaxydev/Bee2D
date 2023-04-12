-- Bee2D by Galaxy#1337

local OBBCollider = {}
local Collider = require(script.Parent.Collider)
OBBCollider.__index = Collider
OBBCollider.__class = "OBBCollider"

export type OBBCollider = {
	owner: Instance,
	halfWidth: number,
	halfHeight: number,
	rotation: number,
}

setmetatable(OBBCollider, {__index = Collider})
local mt = {__index = OBBCollider}

function OBBCollider.new(owner)
	local self = Collider.new(owner, "OBB")
	setmetatable(self, mt)
	self.halfWidth = owner.Transform.Scale.X / 2
	self.halfHeight = owner.Transform.Scale.Y / 2
	self.rotation = owner.Transform:GetGlobalRotationAngle()
	return self
end

function OBBCollider:GetCorners()
	local corners = {
		Vector2.new(-self.halfWidth, -self.halfHeight),
		Vector2.new(self.halfWidth, -self.halfHeight),
		Vector2.new(self.halfWidth, self.halfHeight),
		Vector2.new(-self.halfWidth, self.halfHeight)
	}
	local cosR = math.cos(self.rotation)
	local sinR = math.sin(self.rotation)

	for i, v in ipairs(corners) do
		local x = v.X * cosR - v.Y * sinR
		local y = v.X * sinR + v.Y * cosR
		v.X = x
		v.Y = y
		v = v + self.owner.Transform:GetGlobalPosition()
	end
end

function OBBCollider:CheckCollisionCircle(collider)
	if collider.owner == self.owner then
		return false
	end
	return collider:CheckCollisionOBB(self)
end
	
function OBBCollider:CheckCollisionOBB(collider)
	if collider.owner == self.owner then
		return false
	end

	local axes = {
		self.owner.Transform:GetForward(),
		self.owner.Transform:GetUp(),
		collider.owner.Transform:GetForward(),
		collider.owner.Transform:GetUp()
	}

	local selfCorners = self:GetCorners()
	local colliderCorners = collider:GetCorners()

	for i, axis in ipairs(axes) do
		local selfMin, selfMax = math.huge, -math.huge
		for j, corner in ipairs(selfCorners) do
			local projection = corner:Dot(axis)
			selfMin = math.min(selfMin, projection)
			selfMax = math.max(selfMax, projection)
			local colliderMin, colliderMax = math.huge, -math.huge

			for _, corner in ipairs(colliderCorners) do
				projection = corner:Dot(axis)
				colliderMin = math.min(colliderMin, projection)
				colliderMax = math.max(colliderMax, projection)
			end

			if selfMax < colliderMin or selfMin > colliderMax then
				return false
			end
		end
	end

	return true
end

return OBBCollider