-- Bee2D by Galaxy#1337
local Actor = require(script.Parent.Actor)
local Bee2D = require(script.Parent.Parent.Renderer)
local TileMap = require(script.Parent.Tiles.TileMap)
local Cache = require(script.Parent.Cache)

--- @class Scene
local Scene = {}
Scene.__index = Scene



type Actor = Actor.Actor
type Cache = Cache.Cache

export type Scene = {
    Actors: {Actor},
    TileMaps: {},
    Prioritize: boolean,
    Name: string,
    Objects: Cache,
} & typeof(Scene)

type DrawTarget = "Rectangle" | "Image" | "Line" | "Text"

--[=[
Constructor for Scene

    @param name string -- Name of the scene

    @return Scene -- A new scene object
]=]
function Scene.new(name: string)
    local self = setmetatable({}, Scene)
    self.Name = name
    self.Actors = {}
    self.Objects = Cache.new()
    self.Prioritize = false

    self.Objects.OnCompress = function(object: GuiObject, index: number)
    end

    return self
end

--[=[
Adds an actor to the scene

    @param actor Actor -- Actor to add

    @return Actor -- The actor that was added
]=]
function Scene:AddActor(actor: Actor)
    table.insert(self.Actors, actor)


    return actor
end

--[=[
Removes an actor from the scene and pops the graphic from the cache.

    @param actor Actor -- Actor to remove
]=]
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

--[=[
Adds a tilemap to the scene

@param gridScale number -- The scale of the grid
@param pos number -- The position of the tilemap
@param isometric boolean -- Whether or not the tilemap is isometric
@return TileMap -- The tilemap that was added
]=]
function Scene:AddTileMap( gridScale: number, pos: Vector2, isometric: boolean, 
        tilemapData: { {tileTexture : string, tileName: string} } ) : TileMap.TileMap

    local tileMap = TileMap.new(gridScale, pos, isometric, tilemapData)
    
    self:AddActor(tileMap)

    return tileMap
end

--[=[
Starts the scene and all of its actors. This is called before the first update call.
]=]
function Scene:Start()
    for i, v in ipairs(self.Actors) do
        v:Start()
    end
end

--[=[
    Updates the scene and all of its actors. This is called every frame.

    @param deltaTime number -- The time since the last update call
]=]
function Scene:Update(deltaTime: number)
    for i, v in ipairs(self.Actors) do
        v:Update(deltaTime)
    end
end

--[=[
    Draws the scene and all of its actors. This is called every frame.
]=]
function Scene:Draw()  
    for i, v in ipairs(self.Actors) do 
        if not v.Graphic then continue end

        local guiObject = v:Draw()

        if not v.Graphic.CacheIndex then
            v.Graphic.CacheIndex = self.Objects:PushObject(guiObject)
        end     
    end
end

--[=[
    Renders a graphic to the scene

    @param type -- The type of graphic to render
    @param ... -- The arguments for the graphic

    @return GuiObject -- The graphic that was rendered
]=]
function Scene:Render(type: DrawTarget, ...:any) : GuiObject
    local drawnObject = Bee2D["Draw"..type](...)
    self.Objects:PushObject(drawnObject)

    return drawnObject
end

return Scene


