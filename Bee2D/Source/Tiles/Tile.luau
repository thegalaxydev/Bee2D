local TextService = game:GetService("TextService")
-- Bee2D by Galaxy#1337

local Actor = require(script.Parent.Parent.Actor)
local Sprite = require(script.Parent.Parent.Interface.Sprite)

local TypeDef = require(script.Parent.Parent.TypeDef)

local Tile = setmetatable({}, Actor)
Tile.__index = Actor
Tile.__class = "Tile"

type Transform = TypeDef.Transform
type Sprite = TypeDef.Sprite

export type Tile = {
	Name: string,
	Transform: Transform,
	Draw: () -> nil,
	Update: (deltaTime: number) -> nil,
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

function Tile.new(tileName: string, tileTexture: string, position: Vector2, gridScale: number)
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

function Tile:Update(deltaTime: number)
	Actor.Update(self, deltaTime)

	self.Transform:SetLocalScale(Vector2.new(self.GridScale, self.GridScale))
	self.Transform:UpdateTransform();
end


return Tile