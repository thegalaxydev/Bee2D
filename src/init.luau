-- Renderer by Galaxy#1337
local RunService = game:GetService("RunService")
local Renderer = require(script.Renderer)
local Scene = require(script.Class.Scene)

type Scene = Scene.Scene
type Container = Folder | Model | Configuration


--- @class Engine
--- Static Engine Class
local Engine = {}

Engine.SCREEN_WIDTH = 800
Engine.SCREEN_HEIGHT = 450

local _drawCallbacks = {}
local _updateCallbacks = {}
local _scenes = {}

local _currentScene = nil

--[=[
	Main Start function, called automatically by Engine.Run()
]=]
function Engine.Start()
	Renderer.InitWindow(Engine.SCREEN_WIDTH, Engine.SCREEN_HEIGHT)

	if _currentScene then
		_currentScene:Start()
	end
end

--[=[
	Engine update function, called every frame.
]=]
function Engine.Update(deltaTime: number)
	Renderer.FPS = 1 / deltaTime

	if _currentScene ~= nil then
		_currentScene:Update(deltaTime)
	end

	for _,callback in ipairs(_updateCallbacks) do
		callback[2](deltaTime)
	end
end

--[=[
	Engine draw function, called every frame after update.
]=]
function Engine.Draw()
	Renderer.ClearBackground()

	if _currentScene ~= nil then
		_currentScene:Draw()
	end

	for _,callback in ipairs(_drawCallbacks) do
		callback[2]()
	end
end

--[=[
	Sets the background color of the Window.
]=]
function Engine.SetBackgroundColor(color: Color3)
	Renderer.BackgroundColor = color
end


--[=[
	Binds a callback to the draw step of the engine, given a name.
]=]
function Engine.BindToDraw(name: string, callback: ()->())
	assert(type(name) == "string", "[Renderer] Name must be a string")
	assert(type(callback) == "function", "[Renderer] Callback must be a function")
	table.insert(_drawCallbacks, {name, callback})
end

--[=[
	Unbinds a callback from the draw step of the engine, given a name.
]=]
function Engine.UnbindFromDraw(name: string)
	assert(type(name) == "string", "[Renderer] Name must be a string")
	for _,callback in pairs(_drawCallbacks) do
		if callback[1] == name then
			callback = nil
		end
	end
end

--[=[
	Binds a callback to the update step of the engine, given a name.
]=]
function Engine.BindToUpdate(name: string, callback: (number) -> nil)
	print(name)
	assert(type(name) == "string", "[Renderer] Name must be a string")
	assert(type(callback) == "function", "[Renderer] Callback must be a function")
	table.insert(_updateCallbacks, {name, callback})
end

--[=[
	Unbinds a callback from the update step of the engine, given a name.
]=]
function Engine.UnbindFromUpdate(name: string)
	assert(type(name) == "string", "[Renderer] Name must be a string")
	for callback in pairs(_updateCallbacks) do
		if callback[1] == name then
			callback = nil
		end
	end
end

--[=[
	Adds a scene to the engine.
]=]
function Engine.AddScene(scene: Scene)
	scene = if scene ~= nil then scene else Scene.new("DefaultScene")
	if scene.Prioritize then
		Engine.SetCurrentScene(scene)
	end

	table.insert(_scenes, scene)
	return scene
end

--[=[
	Removes a scene from the engine given the scene.
]=]
function Engine.RemoveScene(scene: Scene) : boolean
	for i, v in pairs(_scenes) do
		if v == scene then
			table.remove(_scenes, i)
			return true
		end
	end

	return false
end

--[=[
	Removes a scene from the engine given a name.
]=]
function Engine.RemoveSceneByName(name: string) : boolean
	for i, v in pairs(_scenes) do
		if v.Name == name then
			table.remove(_scenes, i)
			return true
		end
	end

	return false
end

--[=[
	Gets a scene from the engine given a name.
]=]
function Engine.GetScene(name: string) : Scene?
	for _, v in pairs(_scenes) do
		if v.Name == name then
			return v
		end
	end

	return
end

--[=[
	Returns the requested module from the path provided or nil if not found as well as a log message.
]=]
function Engine.Retrieve(path: string) : ({[any]: any}?, string)
	local split = string.split(path, "/")
	local current = script
	for i = 1, #split do
		if current then
			current = current:FindFirstChild(split[i])
		else
			return nil, "Path not found."
		end
	end

	if not current then return nil, "Path not found." end

	if current:IsA("ModuleScript") then
		return require(current), "Module retrieved."
	end

	return current, "Directory retrieved."
end


--[=[
	Loads all scenes from a container. Any scene with priority will be set as the current scene.
]=]
function Engine.LoadScenes(SceneFolder: Container)
	for _, Scene in pairs(SceneFolder:GetChildren()) do
		if Scene:IsA("ModuleScript") then
			local scene = require(Scene)
			Engine.AddScene(scene)
		end
	end
end

--[=[
	Sets the current scene of the engine.
]=]
function Engine.SetCurrentScene(scene: Scene)
	_currentScene = scene
	Renderer.ActiveCache = scene.Objects
end

--[=[
	Sets the current scene of the engine given a name.
]=]
function Engine.SetCurrentSceneByName(sceneName: string)
	local scene = Engine.GetScene(sceneName)
	if scene then
		_currentScene = scene
		Renderer.ActiveCache = scene.Objects
	end
end

-- Main engine params. Can be passed with Engine.Run()
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

--[=[
	Runs the engine. Goes through all params and sets them if they exist.
	This initializes the engine and starts the render loop, yielding anything below it 
	indefinitely.

	@yields
]=]
function Engine.Run(params: {[string]: any} | nil)
	if params then
		for parameter, value in pairs(params) do
			if EngineParams[parameter] then
				EngineParams[parameter](value)
			end
		end
	end

	local function buildTable(instance: Instance, t: {[any]: any}?)
		t = t or {}
		for _, child in ipairs(instance:GetChildren()) do
			if child:IsA("Folder") then
				if t then
					t[child.Name] = buildTable(child)
				end
			elseif child:IsA("ModuleScript") then
				if t then
					t[child.Name] = require(child)
				end
			end
		end
		return t
	end
	
	buildTable(script, Engine)
	

	Engine.Start()

	RunService.RenderStepped:Connect(function(deltaTime)
		Engine.Update(deltaTime);
		Engine.Draw();	
	end)

	-- alternate method
	--while(not Renderer.WindowShouldClose()) do


	--	task.wait()
	--end
end





return Engine;