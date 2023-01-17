-- Bee2D by Galaxy#1337

local TileMap = {}

local IsometricTile = require(script.Parent.IsometricTile)
local Tile = require(script.Parent.Tile)
local Bee2D = require(script.Parent.Parent.Parent.Main)

TileMap.__index = TileMap


export type TileMap = {
	Tiles: {}
}

function TileMap.new(gridScale: number, pos: Vector2, isometric: boolean, tilemapData: { {tileTexture : string, tileName: string} } ) : TileMap
	local self = setmetatable({}, TileMap)
	self.Tiles = {}
	
	for y = 1, #tilemapData do
		for x = 1, #tilemapData[y] do
			local tileTexture = tilemapData[y][x][1]
			local tileName = tilemapData[y][x][2]
			local position = Vector2.new((x * gridScale), (y * gridScale))
			local tile = (isometric and IsometricTile or Tile).new(tileName, tileTexture, position, gridScale)

			tile.GridPosition = Vector2.new(x, y)
			tile.Transform:SetLocalPosition(tile.Transform:GetLocalPosition() + pos)

			print(tile.Name)
			
			self.Tiles[#self.Tiles + 1] = tile
		end
	end

	return self
end

function TileMap:Update(deltaTime: number)
	for _, tile in pairs(self.Tiles) do
		tile:Update(deltaTime)
		tile.GridScale = tile.DefaultScale / Bee2D.Camera.Zoom
	end
end

function TileMap:Draw()
	for _, tile in pairs(self.Tiles) do
		tile:Draw()
	end
end


return TileMap