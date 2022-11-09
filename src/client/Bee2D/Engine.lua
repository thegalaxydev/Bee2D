local Engine = {}
local RunService = game:GetService("RunService")

local Bee2D = require(script.Parent.Main)
local Scene = require(script.Parent.Components.Scene)
local Stopwatch = require(script.Parent.Components.Stopwatch)
local Scenes = script.Parent.Scenes

Engine.SCREEN_WIDTH = 800
Engine.SCREEN_HEIGHT = 450

local _drawCallbacks = {}
local _updateCallbacks = {}
local _scenes = {}

local _currentScene = nil

function Engine.Start()
	Bee2D.InitWindow(Engine.SCREEN_WIDTH, Engine.SCREEN_HEIGHT)

	if _currentScene then
		_currentScene:Start()
	end
end

function Engine.Update(deltaTime: number)
	if _currentScene ~= nil then
		_currentScene:Update(deltaTime)
	end

	for _,callback in ipairs(_updateCallbacks) do
		callback[2](deltaTime)
	end
end


function Engine.Draw()
	Bee2D.ClearBackground(Color3.fromRGB(0,0,0))

	if _currentScene ~= nil then
		_currentScene:Draw()
	end

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

function Engine.AddScene(scene)
	scene = if scene ~= nil then scene else Scene.new()
	if scene.Prioritize then
		_currentScene = scene
	end

	table.insert(_scenes, scene)
	return scene
end

function Engine.RemoveScene(scene: Scene.Scene)
	assert(scene.__class, "[Bee2D] Scene can only be removed from the engine")
	assert(scene.__class == "Scene", "[Bee2D] Scene can only be removed from the engine")
	for i, v in pairs(_scenes) do
		if v == scene then
			table.remove(_scenes, i)
		end
	end
end

function Engine.Run()
	local _stopwatch = Stopwatch.new();
	_stopwatch:Start();

	for _, Scene in pairs(Scenes:GetChildren()) do
		if Scene:IsA("ModuleScript") then
			local scene = require(Scene)
			Engine.AddScene(scene)
		end
	end

	Engine.Start()

	local currentTime = 0;
	local lastTime = 0;
	local deltaTime = 0;

	while(not Bee2D.WindowShouldClose()) do
		currentTime = _stopwatch.ElapsedTime;

		deltaTime = currentTime - lastTime;

		Engine.Update(deltaTime);
		Engine.Draw();

		lastTime = currentTime;

		task.wait()
	end
end





return Engine;