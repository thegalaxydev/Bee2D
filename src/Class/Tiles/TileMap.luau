-- Renderer by Galaxy#1337
local IsometricTile = require(script.Parent.IsometricTile)
local Tile = require(script.Parent.Tile)
local Renderer = require(script.Parent.Parent.Parent.Renderer)

--- @class TileMap
local TileMap = {}
TileMap.__index = TileMap

type Tile = Tile.Tile

export type TileMap = {
	Tiles: {Tile},
	Update: (deltaTime: number) -> nil,
	Draw: () -> nil,
} & typeof(TileMap)

--[=[
	Constructor for TileMap

	@param gridScale number -- Scale of the tile
	@param pos Vector2 -- Position of the tile
	@param isometric boolean -- Is the tilemap isometric

	@return TileMap -- A new tilemap object
]=]
function TileMap.new(gridScale: number, pos: Vector2, isometric: boolean, tilemapData: { {tileTexture : string, tileName: string} } ) : TileMap
	local self = setmetatable({}, TileMap)
	self.Tiles = {}
	
	for y = 1, #tilemapData do
		for x = 1, #tilemapData[y] do
			local tileTexture = tilemapData[y][x][1]
			local tileName = tilemapData[y][x][2]
			local position = Vector2.new((x * gridScale), (y * gridScale))
			local tileType = isometric and IsometricTile or Tile
			local tile = tileType.new(tileName, tileTexture, position, gridScale)

			tile.GridPosition = Vector2.new(x, y)
			tile.Transform:SetLocalPosition(tile.Transform:GetLocalPosition() + pos)

			print(tile.Name)
			
			self.Tiles[#self.Tiles + 1] = tile
		end
	end

	return self
end

--[=[
	Updates the tilemap

	@param deltaTime number -- Delta time of the game
]=]
function TileMap:Update(deltaTime: number)
	for _, tile in pairs(self.Tiles) do
		tile:Update(deltaTime)
		tile.GridScale = tile.DefaultScale / Renderer.Camera.Zoom
	end
end

--[=[
	Draws the tilemap
]=]
function TileMap:Draw()
	for _, tile in pairs(self.Tiles) do
		tile:Draw()
	end
end


return TileMap