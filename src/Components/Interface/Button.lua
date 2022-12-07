local Button = {}
Button.__index = Button
Button.__class = "Button"

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Event = require(ReplicatedStorage.Content.Classes.Event)

local Bee2D = require(script.Parent.Parent.Parent.Main)
local Input = require(script.Parent.Input)
local Sprite = require(script.Parent.Sprite)
local Vector2 = require(script.Parent.Parent.Parent.Math.Vector2)

export type Button = {
	MouseButton1Down: Event.Event,
	MouseButton1Up: Event.Event,
	MouseButton1IsDown: boolean,
	Position: Vector2,
	Size: Vector2


}

function Button.new(position: Vector2, size: Vector2)
	local self = setmetatable({}, Button)
	self.Position = position
	self.Size = size

	self.MouseButton1Down = Event.new()
	self.MouseButton1Up = Event.new()

	self.MouseButton1IsDown = false

	self.__EventConnections = {}
	self.__EventConnections.InputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mousePosition = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
			if mousePosition.X >= position.X and mousePosition.X <= position.X + size.X and mousePosition.Y >= position.Y and mousePosition.Y <= position.Y + size.Y then
				self.MouseButton1Down:Fire()
				self.MouseButton1IsDown = true
			end
		end
	end)
	self.__EventConnections.InputEnded = UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mousePosition = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
			if mousePosition.X >= position.X and mousePosition.X <= position.X + size.X and mousePosition.Y >= position.Y and mousePosition.Y <= position.Y + size.Y then
				self.MouseButton1Down:Fire()
				self.MouseButton1IsDown = false
			end
		end
	end)

	return self
end




