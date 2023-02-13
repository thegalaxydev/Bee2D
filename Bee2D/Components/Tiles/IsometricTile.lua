-- Bee2D by Galaxy#1337

local Actor = require(script.Parent.Parent.Actor)
local Sprite = require(script.Parent.Parent.Interface.Sprite)
local Tile = require(script.Parent.Tile)

local IsometricTile = setmetatable({}, Tile)
IsometricTile.__index = Tile
IsometricTile.__class = "IsometricTile"


function IsometricTile.new(tileName: string, tileTexture: string, position: Vector2, gridScale: number)
	local self = setmetatable(Tile.new(tileName, tileTexture, position, gridScale), IsometricTile)

	local posX = position.X - position.Y
	local posY = (position.X + position.Y) / 2
	position = Vector2.new(posX, posY) / 2

	self.Transform:SetLocalPosition(position)
	return self
end


return IsometricTile