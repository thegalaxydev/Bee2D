local Scene = {}
Scene.__index = Scene
Scene.__class = "Scene"

local Bee2D = require(script.Parent.Parent.Main)
local Actor = require(script.Parent.Actor)

export type Scene = {
    Actors: {},
    Prioritize: boolean,
    Name: string
}

function Scene.new(name: string)
    local self = setmetatable({}, Scene)
    self.Name = name
    self.Actors = {}
    self.Prioritize = false

    return self
end

function Scene:AddActor(actor: Actor)
    assert(actor.__class, "[Bee2D] Actor can only be added to a Scene")
    assert(actor.__class == "Actor", "[Bee2D] Actor can only be added to a Scene")
    table.insert(self.Actors, actor)

    return actor
end

function Scene:RemoveActor(actor: Actor)
    assert(actor.__class, "[Bee2D] Actor can only be removed from a Scene")
    assert(actor.__class == "Actor", "[Bee2D] Actor can only be removed from a Scene")
    for i, v in pairs(self.Actors) do
        if v == actor then
            table.remove(self.Actors, i)
        end
    end
end

function Scene:Start()
    for i, v in pairs(self.Actors) do
        v:Start()
    end
end

function Scene:Update(deltaTime: number)
    for i, v in pairs(self.Actors) do
        v:Update(deltaTime)
    end
end

function Scene:Draw()
    for i, v in pairs(self.Actors) do
        v:Draw()
    end
end

return Scene


