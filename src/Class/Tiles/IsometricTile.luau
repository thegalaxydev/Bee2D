-- Bee2D by Galaxy#1337

local Sprite = require(script.Parent.Parent.Interface.Sprite)
local Tile = require(script.Parent.Tile)
local TypeDef = require(script.Parent.Parent.TypeDef)

--- @class IsometricTile
local IsometricTile = {}
IsometricTile.__index = IsometricTile

type Transform = TypeDef.Transform
type Sprite = Sprite.Sprite

export type IsometricTile = typeof(Tile)

--[=[
	Constructor for IsometricTile

	@param tileName string -- Name of the tile
	@param tileTexture string -- Texture of the tile
	@param position Vector2 -- Position of the tile
	@param gridScale number -- Scale of the tile

	@return IsometricTile -- A new isometric tile object
]=]
function IsometricTile.new(tileName: string, tileTexture: string, position: Vector2, gridScale: number): IsometricTile
	local self = setmetatable(Tile.new(tileName, tileTexture, position, gridScale), IsometricTile)

	local posX = position.X - position.Y
	local posY = (position.X + position.Y) / 2
	position = Vector2.new(posX, posY) / 2

	self.Transform:SetLocalPosition(position)
	return self
end

return IsometricTile