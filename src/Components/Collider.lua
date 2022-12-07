local Collider = {}
local Bee2D = require(script.Parent.Parent.Main)
Collider.__index = Collider
Collider.__class = "Collider"

export type Collider = {
	Owner: {},
	CollisionInformation: {}
}

local CollisionInformation = {
	['Circle'] = {

		["Radius"] = 0;
	},
	['Box'] = {
		["Width"] = 0;
		["Height"] = 0;
	}
}

function Collider.new(owner: {}, collisionType: string)
	assert(CollisionInformation[collisionType], "[Bee2D] Invalid collision type")
	local self = setmetatable({}, {__index = Collider})
	self.Owner = owner
	self.CollisionType = collisionType
	self.CollisionInformation = CollisionInformation[collisionType]

	return self
end

function Collider:CircleCircleCollision(other: Collider): boolean
	return (self.Owner.Transform:GetPosition() - other.Owner.Transform:GetPosition()).Magnitude <= self.CollisionInformation.Radius + other.CollisionInformation.Radius
end

function Collider:BoxBoxCollision(other: Collider): boolean
	return false;
end

function Collider:CheckCollision(other: {}): boolean
	assert(other.__class, "[Bee2D] Collision can only be checked with Actor")
	assert(other.__class == "Actor", "[Bee2D] Collision can only be checked with Actor")
	if other.CollisionVolume == nil then return false end

	if other.CollisionVolume.CollisionType == "Circle" and self.CollisionType == "Cirlce" then
		return self:CircleCircleCollision(other.CollisionVolume)
	end
end

function Collider:Draw()
	local pos = self.Owner.Transform:GetPosition()
	Bee2D.DrawCircleLine(pos.X, pos.Y, self.Radius, Color3.fromRGB(255, 0, 0))
end




return Collider