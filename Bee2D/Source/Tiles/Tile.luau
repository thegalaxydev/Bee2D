-- Bee2D by Galaxy#1337

local Actor = require(script.Parent.Parent.Actor)
local Sprite = require(script.Parent.Parent.Interface.Sprite)
local TypeDef = require(script.Parent.Parent.TypeDef)

--- @class Tile
local Tile = {}
Tile.__index = Tile

type Transform = TypeDef.Transform
type Sprite = TypeDef.Sprite

export type Tile = {
	TileTexture: string,
	DefaultScale: number,
	GridScale: number,
	GridPosition: Vector2,
	AbsolutePosition: Vector2,
} & typeof(Tile) & typeof(Actor)

--[=[
	Constructor for Tile

	@param tileName string -- Name of the tile
	@param tileTexture string -- Texture of the tile
	@param position Vector2 -- Position of the tile
	@param gridScale number -- Scale of the tile

	@return Tile -- A new tile object
]=]
function Tile.new(tileName: string, tileTexture: string, position: Vector2, gridScale: number) : Tile
	local self = setmetatable(Actor.new(tileName, Sprite.new(Color3.new(1,1,1), tileTexture)), Tile)

	self.TileTexture = tileTexture
	self.DefaultScale = gridScale
	self.GridScale = gridScale
	self.GridPosition = Vector2.new(1, 1)

	self.AbsolutePosition = position

	self.Transform:SetLocalPosition(position)
	self.Transform:SetLocalScale(Vector2.new(self.GridScale, self.GridScale))

	return self
end

--[=[
	Updates the tile

	@param deltaTime number -- Time since last update
]=]
function Tile:Update(deltaTime: number)
	Actor.Update(self, deltaTime)

	self.Transform:SetLocalScale(Vector2.new(self.GridScale, self.GridScale))
	self.Transform:UpdateTransform();
end


return Tile