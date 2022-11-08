local Engine = {}
local RunService = game:GetService("RunService")

local Bee2D = require(script.Parent.Main)

Engine.SCREEN_WIDTH = 800
Engine.SCREEN_HEIGHT = 450

local _drawCallbacks = {}
local _updateCallbacks = {}


function Engine.Start()
    Bee2D.InitWindow(Engine.SCREEN_WIDTH, Engine.SCREEN_HEIGHT)
end

function Engine.Update(deltaTime: number)
    for _,callback in ipairs(_updateCallbacks) do
        callback[2](deltaTime)
    end
end


function Engine.Draw()
    Bee2D.ClearBackground(Color3.fromRGB(0,0,0))
    for _,callback in ipairs(_drawCallbacks) do
        callback[2]()
    end
end

-- Bind a function to the draw step, will be called after the engine has drawn every frame
function Engine:BindToDraw(name: string, callback: () -> nil)
    assert(type(name) == "string", "[Bee2D] Name must be a string")
    assert(type(callback) == "function", "[Bee2D] Callback must be a function")
    table.insert(_drawCallbacks, {name, callback})
end

-- Unbind a function from the draw step
function Engine:UnbindFromDraw(name: string)
    assert(type(name) == "string", "[Bee2D] Name must be a string")
    for _,callback in pairs(_drawCallbacks) do
        if callback[1] == name then
            callback = nil
        end
    end
end

-- Bind a function to the draw step, will be called after the engine has updated every frame with delta time.
function Engine:BindToUpdate(name: string, callback: (number) -> nil)
    assert(type(name) == "string", "[Bee2D] Name must be a string")
    assert(type(callback) == "function", "[Bee2D] Callback must be a function")
    table.insert(_updateCallbacks, {name, callback})
end

-- Unbind a function from the update step
function Engine:UnbindFromUpdate(name: string)
    assert(type(name) == "string", "[Bee2D] Name must be a string")
    for callback in pairs(_updateCallbacks) do
        if callback[1] == name then
            callback = nil
        end
    end
end

function Engine.Run()
    Engine.Start()

    RunService:BindToRenderStep("Bee2DEngine", Enum.RenderPriority.First.Value, function(deltaTime)
        Engine.Update(deltaTime)
        Engine.Draw()
    end)
end





return Engine;