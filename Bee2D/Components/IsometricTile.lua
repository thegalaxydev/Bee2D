local Actor = require(script.Parent.Actor)
local Sprite = require(script.Parent.Interface.Sprite)

local IsometricTile = {}

IsometricTile.__index = Actor
IsometricTile.__class = "IsometricTile"

export type IsometricTile = typeof(setmetatable({}, Actor)) &
{
	TileTexture: string,
	AbsolutePosition: Vector2
}
setmetatable(IsometricTile, {__index = Actor})
local IsoMT = {__index = IsometricTile}
function IsometricTile.new(tileTexture: string, position: Vector2, gridScale: number) : IsometricTile
	local self = Actor.new("IsometricTile", Sprite.new(Color3.new(1,1,1), tileTexture))
	setmetatable(self, IsoMT)

	self.TileTexture = tileTexture
	self.AbsolutePosition = position

	local posX = position.X - position.Y / 1.5
	local posY = (position.X + position.Y) / 2
	position = Vector2.new(posX, posY)

	self.Transform:SetLocalPosition(position)
	self.Transform:SetLocalScale(Vector2.new(gridScale, gridScale))

	return self
end


return IsometricTile