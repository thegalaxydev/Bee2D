-- Bee2D by Galaxy#1337

local TileMap = {}

local IsometricTile = require(script.Parent.IsometricTile)
local Bee2D = require(script.Parent.Parent.Main)

TileMap.__index = TileMap



function TileMap.new(gridScale, tilemapData, pos)
	local self = setmetatable({}, TileMap)
	self.Tiles = {}

	for y = 1, #tilemapData do
		for x = 1, #tilemapData[y] do
			local tileTexture = tilemapData[y][x]
			local position = Vector2.new((x * gridScale), (y * gridScale))
			local tile = IsometricTile.new(tileTexture, position, false, gridScale)
			tile.Transform:SetLocalPosition(tile.Transform:GetLocalPosition() + pos)
			self.Tiles[#self.Tiles + 1] = tile
		end
	end


	return self
end

function TileMap:Update(deltaTime: number)
	for _, tile in pairs(self.Tiles) do
		tile:Update(deltaTime)
		tile.GridScale = 100 / Bee2D.Camera.Zoom
	end
end

function TileMap:Draw()
	for _, tile in pairs(self.Tiles) do
		tile:Draw()
	end
end


return TileMap