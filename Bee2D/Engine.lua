-- Bee2D by Galaxy#1337

local Engine = {}
local RunService = game:GetService("RunService")

local Bee2D = require(script.Parent.Main)
local Scene = require(script.Parent.Source.Scene)

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
	Bee2D.FPS = 1 / deltaTime

	if _currentScene ~= nil then
		_currentScene:Update(deltaTime)
	end

	for _,callback in ipairs(_updateCallbacks) do
		callback[2](deltaTime)
	end
end


function Engine.Draw()
	Bee2D.ClearBackground()

	if _currentScene ~= nil then
		_currentScene:Draw()
	end

	for _,callback in ipairs(_drawCallbacks) do
		callback[2]()
	end
end

function Engine.SetBackgroundColor(color: Color3)
	Bee2D.BackgroundColor = color
end


-- Bind a function to the draw step, will be called after the engine has drawn every frame
function Engine.BindToDraw(name: string, callback: () -> nil)
	assert(type(name) == "string", "[Bee2D] Name must be a string")
	assert(type(callback) == "function", "[Bee2D] Callback must be a function")
	table.insert(_drawCallbacks, {name, callback})
end

-- Unbind a function from the draw step
function Engine.UnbindFromDraw(name: string)
	assert(type(name) == "string", "[Bee2D] Name must be a string")
	for _,callback in pairs(_drawCallbacks) do
		if callback[1] == name then
			callback = nil
		end
	end
end

-- Bind a function to the draw step, will be called after the engine has updated every frame with delta time.
function Engine.BindToUpdate(name: string, callback: (number) -> nil)
	print(name)
	assert(type(name) == "string", "[Bee2D] Name must be a string")
	assert(type(callback) == "function", "[Bee2D] Callback must be a function")
	table.insert(_updateCallbacks, {name, callback})
end

-- Unbind a function from the update step
function Engine.UnbindFromUpdate(name: string)
	assert(type(name) == "string", "[Bee2D] Name must be a string")
	for callback in pairs(_updateCallbacks) do
		if callback[1] == name then
			callback = nil
		end
	end
end

function Engine.AddScene(scene)
	scene = if scene ~= nil then scene else Scene.new("DefaultScene")
	if scene.Prioritize then
		_currentScene = scene
	end

	table.insert(_scenes, scene)
	return scene
end

function Engine.RemoveScene(scene: Scene.Scene) : boolean
	assert(scene.__class, "[Bee2D] Scene can only be removed from the engine")
	assert(scene.__class == "Scene", "[Bee2D] Scene can only be removed from the engine")
	for i, v in pairs(_scenes) do
		if v == scene then
			table.remove(_scenes, i)
			return true
		end
	end

	return false
end

function Engine.RemoveSceneByName(name: string) : boolean
	for i, v in pairs(_scenes) do
		if v.Name == name then
			table.remove(_scenes, i)
			return true
		end
	end

	return false
end

function Engine.GetScene(name: string) : Scene.Scene | nil
	for _, v in pairs(_scenes) do
		if v.Name == name then
			return v
		end
	end

	return
end

function Engine.LoadScenes(SceneFolder)
	print(SceneFolder)
	for _, Scene in pairs(SceneFolder:GetChildren()) do
		if Scene:IsA("ModuleScript") then
			local scene = require(Scene)
			Engine.AddScene(scene)
		end
	end
end

function Engine.SetCurrentScene(scene: Scene.Scene)
	_currentScene = scene
end

function Engine.SetCurrentSceneByName(sceneName: string)
	local scene = Engine.GetScene(sceneName)
	if scene then
		_currentScene = scene
	end
end

EngineParams = {
	-- Allows you to set the scene folder within the Engine.Run without having to run LoadScenes
	["SceneFolder"] = function(sceneFolder)
		_scenes = {}
		Engine.LoadScenes(sceneFolder)
	end;
	["ScreenSize"] = function(screenSize: Vector2)
		Engine.SCREEN_HEIGHT = screenSize.Y
		Engine.SCREEN_WIDTH = screenSize.X
	end;
}

function Engine.Run(params: {[string]: any} | nil)
	if params then
		for parameter, value in pairs(params) do
			if EngineParams[parameter] then
				EngineParams[parameter](value)
			end
		end
	end

	Engine.Start()

	RunService.RenderStepped:Connect(function(deltaTime)
		Engine.Update(deltaTime);
		Engine.Draw();	
	end)

	-- alternate method
	--while(not Bee2D.WindowShouldClose()) do


	--	task.wait()
	--end
end





return Engine;