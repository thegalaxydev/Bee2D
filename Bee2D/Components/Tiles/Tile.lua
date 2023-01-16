-- Bee2D by Galaxy#1337

local Actor = require(script.Parent.Parent.Actor)
local Sprite = require(script.Parent.Parent.Interface.Sprite)

local Tile = {}

Tile.__index = Actor
Tile.__class = "IsometricTile"

setmetatable(Tile, {__index = Actor})
local mt = {__index = Tile}
function Tile.new(tileTexture: string, position: Vector2, gridScale: number)
	local self = Actor.new("Tile", Sprite.new(Color3.new(1,1,1), tileTexture))
	setmetatable(self, mt)

	self.TileTexture = tileTexture
	self.DefaultScale = gridScale
	self.GridScale = gridScale
	self.GridPosition = Vector2.new(1, 1)

	self.AbsolutePosition = position

	self.Transform:SetLocalPosition(position)
	self.Transform:SetLocalScale(Vector2.new(self.GridScale, self.GridScale))

	return self
end

function Tile:Update()
	self.Transform:SetLocalScale(Vector2.new(self.GridScale, self.GridScale))
	self.Transform:UpdateTransform();
end


return Tile