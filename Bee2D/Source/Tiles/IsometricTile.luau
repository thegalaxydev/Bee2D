-- Bee2D by Galaxy#1337

local Actor = require(script.Parent.Parent.Actor)
local Sprite = require(script.Parent.Parent.Interface.Sprite)
local Tile = require(script.Parent.Tile)
local TypeDef = require(script.Parent.Parent.TypeDef)


local IsometricTile = setmetatable({}, Tile)
IsometricTile.__index = Tile
IsometricTile.__class = "IsometricTile"

type Transform = TypeDef.Transform
type Sprite = Sprite.Sprite

export type IsometricTile = {
	Name: string,
	Transform: Transform,
	Translate: (direction: Vector2) -> nil,
	Active: boolean,
	Graphic: Sprite,
	_lastPosition: Vector2,
	TileTexture: string,
	DefaultScale: number,
	GridScale: number,
	GridPosition: Vector2,
	AbsolutePosition: Vector2,
}

function IsometricTile.new(tileName: string, tileTexture: string, position: Vector2, gridScale: number): IsometricTile
	local self = setmetatable(Tile.new(tileName, tileTexture, position, gridScale), IsometricTile)

	local posX = position.X - position.Y
	local posY = (position.X + position.Y) / 2
	position = Vector2.new(posX, posY) / 2

	self.Transform:SetLocalPosition(position)
	return self
end

return IsometricTile