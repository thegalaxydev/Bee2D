-- Bee2D by Galaxy#1337

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
function IsometricTile.new(tileTexture: string, position: Vector2, gridSnap: boolean, gridScale: number) : IsometricTile
	local self = Actor.new("IsometricTile", Sprite.new(Color3.new(1,1,1), tileTexture))
	setmetatable(self, IsoMT)

	self.TileTexture = tileTexture
	self.DefaultScale = gridScale
	self.GridScale = gridScale
	self.GridSnap = gridSnap

	if gridSnap or gridSnap ~= 0 then
		position = Vector2.new(math.floor(position.X / self.GridScale) * self.GridScale, math.floor(position.Y / self.GridScale) * self.GridScale)
	end

	self.AbsolutePosition = position

	local posX = position.X - position.Y
	local posY = (position.X + position.Y) / 2
	position = Vector2.new(posX, posY) / 2

	self.Transform:SetLocalPosition(position)
	self.Transform:SetLocalScale(Vector2.new(self.GridScale, self.GridScale))

	return self
end

function IsometricTile:Update()
	self.Transform:SetLocalScale(Vector2.new(self.GridScale, self.GridScale))
	self.Transform:UpdateTransform();
end


return IsometricTile