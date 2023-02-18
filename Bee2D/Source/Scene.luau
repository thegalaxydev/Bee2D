-- Bee2D by Galaxy#1337

local Scene = {}
Scene.__index = Scene
Scene.__class = "Scene"

local Actor = require(script.Parent.Actor)
local TileMap = require(script.Parent.Tiles.TileMap)

type Actor = Actor.Actor

export type Scene = {
    Actors: {Actor},
    TileMaps: {},
    Prioritize: boolean,
    Name: string,
    __class: string
}

function Scene.new(name: string)
    local self = setmetatable({}, Scene)
    self.Name = name
    self.Actors = {}
    self.TileMaps = {}
    self.Prioritize = false

    return self
end

function Scene:AddActor(actor: Actor)
    assert(actor.__class, "[Bee2D] Actor can only be added to a Scene")
    table.insert(self.Actors, actor)

    return actor
end

function Scene:RemoveActor(actor: Actor)
    assert(actor.__class, "[Bee2D] Actor can only be removed from a Scene")
    for i, v in ipairs(self.Actors) do
        if v == actor then
            table.remove(self.Actors, i)
        end
    end
end

function Scene:AddTileMap( gridScale: number, pos: Vector2, isometric: boolean, tilemapData: { {tileTexture : string, tileName: string} } ) : TileMap.TileMap
    local tileMap = TileMap.new(gridScale, pos, isometric, tilemapData)
    table.insert(self.TileMaps, tileMap)

    return tileMap
end

function Scene:RemoveTileMap(tileMap: TileMap.TileMap)
    for i, v in ipairs(self.TileMaps) do
        if v == tileMap then
            table.remove(self.TileMaps, i)
        end
    end
end

function Scene:Start()
    for i, v in ipairs(self.Actors) do
        v:Start()
    end

    for _,v in ipairs(self.TileMaps) do
        v:Start()
    end
end

function Scene:Update(deltaTime: number)
    for i, v in ipairs(self.Actors) do
        v:Update(deltaTime)
    end
    for _,v in ipairs(self.TileMaps) do
        v:Update(deltaTime)
    end
end

function Scene:Draw()
    for i, v in ipairs(self.Actors) do
        v:Draw(i)
    end

    for i, v in ipairs(self.TileMaps) do
        v:Draw(i)
    end
end

return Scene


