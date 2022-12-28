local Collider = {}
local Bee2D = require(script.Parent.Parent.Main)
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


return Collider