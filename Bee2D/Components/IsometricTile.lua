local Actor = require(script.Parent.Actor)
local Sprite = require(script.Parent.Interface.Sprite)

local IsometricTile = {}
IsometricTile.__index = Actor
IsometricTile.__class = "IsometricTile"


function IsometricTile.new(tileTexture: string, position: Vector2, gridSnap: boolean, gridScale: number)
	local self = Actor.new("IsometricTile", Sprite.new(Color3.new(1,1,1), tileTexture))
	setmetatable(self, {__index = IsometricTile})

	self.TileTexture = tileTexture

	if gridSnap or gridSnap ~= 0 then
		position = Vector2.new(math.floor(position.X / gridScale) * gridScale, math.floor(position.Y / gridScale) * gridScale)
	end

	self.AbsolutePosition = position
	position = Vector2.new(position.X  - position.Y,  (position.X + position.Y) / 2)

	self.Transform:SetLocalPosition(position)
	self.Transform:setLocalScale(gridScale)

	return self
end


return IsometricTile