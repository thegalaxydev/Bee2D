-- Bee2D by Galaxy#1337

local Scene = {}
Scene.__index = Scene

local Actor = require(script.Parent.Actor)
local Bee2D = require(script.Parent.Parent.Main)
local TileMap = require(script.Parent.Tiles.TileMap)
local Cache = require(script.Parent.Cache)

type Actor = Actor.Actor
type DrawTarget = "Rectangle" | "Image" | "Line" | "Text"
type Cache = Cache.Cache

export type Scene = {
    Actors: {Actor},
    TileMaps: {},
    Prioritize: boolean,
    Name: string,
    Objects: Cache,
} & typeof(Scene)


function Scene.new(name: string)
    local self = setmetatable({}, Scene)
    self.Name = name
    self.Actors = {}
    self.Objects = Cache.new()
    self.Prioritize = false

    self.Object.OnCompress = function(object: GuiObject, index: number)
    end

    return self
end

function Scene:AddActor(actor: Actor)
    table.insert(self.Actors, actor)


    return actor
end

function Scene:RemoveActor(actor: Actor)
    for i, v in ipairs(self.Actors) do
        if v == actor then
            print(true)
            table.remove(self.Actors, i)
        end
    end

    if actor.Graphic and actor.Graphic.CacheIndex then
        self.Objects:PopObject(actor.Graphic.CacheIndex)
    end
end

function Scene:AddTileMap( gridScale: number, pos: Vector2, isometric: boolean, 
        tilemapData: { {tileTexture : string, tileName: string} } ) : TileMap.TileMap

    local tileMap = TileMap.new(gridScale, pos, isometric, tilemapData)
    
    self:AddActor(tileMap)

    return tileMap
end

function Scene:Start()
    for i, v in ipairs(self.Actors) do
        v:Start()
    end
end

function Scene:Update(deltaTime: number)
    for i, v in ipairs(self.Actors) do
        v:Update(deltaTime)
    end
end

function Scene:Draw()  
    for i, v in ipairs(self.Actors) do 
        if not v.Graphic then continue end

        local guiObject = v:Draw()

        if not v.Graphic.CacheIndex then
            v.Graphic.CacheIndex = self.Objects:PushObject(guiObject)
        end     
    end
end

function Scene:Render(type: DrawTarget, ...:any) : GuiObject
    local drawnObject = Bee2D["Draw"..type](...)
    self.Objects:PushObject(drawnObject)

    return drawnObject
end

return Scene


