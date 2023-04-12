# Bee2D

Bee2D is a semi-barebones 2D game engine integrated into Roblox. Simply download the repo and run the `default.project.json` with Rojo to clone it into your game. Additionally, you can add it straight into your game with the model below:
https://www.roblox.com/library/12159480029/Bee2D

Discord Server: https://discord.gg/ptNSRYcvr9


# Getting Started

Bee2D has a bit of a learning curve, but once you get into it, it's extremely simple. To start out, simply require the `Main` and `Engine` modules from Bee2D like so:

```lua
local Engine = require(Services.ReplicatedStorage.Bee2D.Engine)
local Bee2D = require(Services.ReplicatedStorage.Bee2D)
```

From there, there's a couple of built-in functions you can set up.

```lua
Engine.BindToUpdate("Name", function(deltaTime)
	-- This will allow you to bind functions to the update calls of the engine. 
	--Engine.Update(deltaTime) runs every frame.
	-- The first argument, "Name", is what you will use to unbind the function.
end)

Engine.BindToDraw("Name", function()
	-- This will allow you to bind functions to the draw calls of the engine. 	
	-- Engine.Draw() runs every frame after Engine.Update() is called.
	-- The first argument, "Name", is what you will use to unbind the function.
end)
```

In order to unbind these functions, it's as simple as running the following:

```lua
Engine.UnbindFromUpdate("Name")
Engine.UnbindFromDraw("Name")
```

This engine runs with modules called `Scenes`. Scenes have their own `Start`, `Update`, and `Draw` functions which are called with the Engine. To set up your scenes, simply make a folder for them and load them with the following:

```lua
Engine.LoadScenes(ScenesFolder)
```

A scene is set up like such:

```lua
-- First you want to include the Scene module, as it sets up the class for you to use.
local Scene = require(ReplicatedStorage.Bee2D.Components.Scene)

-- Then you can set up your Scene like such:

local YourSceneName = Scene.new()
YourSceneName.Prioritize = true -- This will make this scene the current active scene when it is loaded. This means that it will be displayed immediately.

function YourSceneName:Start()
-- This will run once when the scene is loaded.
end

function YourSceneName:Update(deltaTime)
-- This will run every frame.
end

function YourSceneName:Draw()
-- This will run every frame after Update, and is used to render images and geometry.
end
```

Bee2D's Main module also has some neat functions for you to use.

```lua
function Bee2D.DrawFPS()
-- Displays the FPS on screen in the top right corner.

function Bee2D:SetFullScreen(boolean)
-- Will make the window take up the entire screen.

function Bee2D.DrawImage(texture: string, position: Vector2, rotation: number, scale: Vector2, tint: Color3)
-- Will draw an image on screen given the texture (roblox image link).

function Bee2D.DrawRectangle(posX: number, posY: number, width: number, height: number, color: Color3)
-- Will draw a rectangle on screen given a position, width, and height.

function Bee2D.DrawRectangleEx(posX: number, posY: number, width: number, height: number, rotation: number, color: Color3)
-- Will draw a rectangle on screen same as above, but includes rotation.

function Bee2D.DrawText(text: string, posX: number, posY: number, color: Color3, font: Enum.Font, size: number)
-- Displays text on screen

function Bee2D.DrawLine(lineStart: Vector2, lineEnd: Vector2, width: number, color: Color3)
-- Draws a line on screen given a start and end. May be buggy.

function Bee2D.DrawCircleLine(posX: number, posY: number, radius: number, color: Color3)
-- Draws a circle out of lines.
```

## Actors

Actors are more advanced objects that are displayed in a scene.
Actors also have a Start, Update, and Draw function that can be overriden. These functions are run when you add the actor to a scene like such:
```lua
local Actor = require(ReplicatedStorage.Bee2D.Source.Actor)
local Sprite = require(ReplicatedStorage.Bee2D.Source.Interface.Sprite)
-- Sprite class is used to display the actor

local Player = YourSceneName:AddActor(Actor.new("Player",  Sprite.new(Color3.new(1,1,1), "imagelinkhere")))
```

Additionally, actors can be moved, scaled, and rotated by their Transform properties, and also can be given collision.

```lua
Player.Transform:SetLocalPosition(Vector2.new(1,1))
```
More information regarding Transforms can be seen below.

## Transform
WIP






