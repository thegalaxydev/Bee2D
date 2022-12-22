local Bee2D = {}
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Connections = require(ReplicatedStorage.Shared.Classes.Connections)
local Event = require(ReplicatedStorage.Shared.Classes.Event)

local Window: ScreenGui
local Frame: Frame

local _fullscreen = false;

Bee2D.WindowSizeAbsolute = nil;
Bee2D.WindowSize = Vector2.new(800,450)
Bee2D.FPS = 0

local _windowOpen

function Bee2D.DrawFPS()
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	local fps = Instance.new("TextLabel")
	fps.Name = "FPS"
	fps.Text = "FPS: " .. tostring(math.round(Bee2D.FPS))
	fps.TextColor3 = Color3.new(0,0,0)
	fps.TextStrokeTransparency = 0
	fps.TextStrokeColor3 = Color3.new(1,1,1)
	fps.TextScaled = true
	fps.TextSize = 14
	fps.TextWrapped = true
	fps.TextXAlignment = Enum.TextXAlignment.Left
	fps.TextYAlignment = Enum.TextYAlignment.Top
	fps.BackgroundTransparency = 1
	fps.Size = UDim2.new(0, 100, 0, 20)
	fps.AnchorPoint = Vector2.new(1, 0)
	fps.Position = UDim2.new(1, 0, 0, 0)
	fps.Parent = Frame
end

function Bee2D:SetFullscreen(bool: boolean)
	_fullscreen = if bool ~= nil then bool else not _fullscreen
end

function Bee2D.InitWindow(sizeX: number, sizeY: number)
	if Window then Window:Destroy() end
	Window = Instance.new("ScreenGui")
	Window.Name = "Bee2D"
	Window.IgnoreGuiInset = true
	Window.Parent = PlayerGui
	Bee2D.WindowSizeAbsolute = Window.AbsoluteSize

	if Frame then Frame:Destroy() end
	Frame = Instance.new("Frame")
	Frame.Name = "Main"

	Bee2D.WindowSize = (sizeX and sizeY) and Vector2.new(sizeX, sizeY) or Bee2D.WindowSize
	Frame.Size = (not _fullscreen) and UDim2.new(0, Bee2D.WindowSize.X, 0, Bee2D.WindowSize.Y) or UDim2.new(1, 0, 1, 0)
	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = Color3.new(1,1,1)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Parent = Window
end

function Bee2D.CloseWindow()
	_windowOpen = false
end

function Bee2D.WindowShouldClose(): boolean
	return _windowOpen
end

function Bee2D.ClearBackground(color: Color3)
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	Frame.BackgroundColor3 = color
	for _, child in pairs(Frame:GetChildren()) do
		child:Destroy()
	end
end

function Bee2D.DrawImage(texture: string, position: Vector2, rotation: number, scale: Vector2, tint: Color3)
	assert(Window and Frame, "[Bee2D] Window is not initialized")

	local image = Instance.new("ImageLabel")
	image.Name = "Image"
	image.Image = texture
	image.Size = UDim2.new(0, scale.X, 0, scale.Y)
	image.Position = UDim2.new(0, position.X, 0, position.Y)
	image.BackgroundTransparency = 0
	image.BackgroundColor3 = Color3.new(0,0,0)
	image.BorderColor3 = Color3.new(1,0,0)
	image.BorderSizePixel = 0
	image.ImageTransparency = 0
	image.ImageColor3 = tint
	image.Rotation = rotation
	image.Parent = Frame
end

function Bee2D.DrawRectangle(posX: number, posY: number, width: number, height: number, color: Color3)
	assert(Window and Frame, "[Bee2D] Window is not initialized")

	local rect = Instance.new("Frame")
	rect.Name = "Rectangle"
	rect.Size = UDim2.new(0, width, 0, height)
	rect.Position = UDim2.new(0, posX, 0, posY)
	rect.BorderSizePixel = 0
	rect.BackgroundColor3 = color
	rect.Parent = Frame
end

function Bee2D.DrawRectangleEx(posX: number, posY: number, width: number, height: number, rotation: number, color: Color3)
	assert(Window and Frame, "[Bee2D] Window is not initialized")

	local rect = Instance.new("Frame")
	rect.Name = "Rectangle"
	rect.Size = UDim2.new(0, width, 0, height)
	rect.Position = UDim2.new(0, posX, 0, posY)
	rect.Rotation = rotation
	rect.BorderSizePixel = 0
	rect.BackgroundColor3 = color
	rect.Parent = Frame
end

function Bee2D.DrawText(text: string, posX: number, posY: number, color: Color3, font: Enum.Font, size: number)
	assert(Window and Frame, "[Bee2D] Window is not initialized")

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "Text"
	textLabel.Text = text
	textLabel.TextColor3 = color
	textLabel.TextSize = size
	textLabel.Font = font
	textLabel.BackgroundTransparency = 1;
	textLabel.Position = UDim2.new(0, posX, 0, posY)
	textLabel.Parent = Frame

	textLabel.Size = UDim2.new(0, textLabel.TextBounds.X, 0, textLabel.TextBounds.Y)
end

function Bee2D:DrawElement(element: GuiObject)
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	assert(element:IsA("GuiObject"), "[Bee2D] Element is not a GuiObject");
	element.Parent = Frame
end

function Bee2D:AddToWindow(instance: string)
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	local inst = Instance.new(instance)
	inst.Parent = Frame
end

function Bee2D.DrawLine(lineStart: Vector2, lineEnd: Vector2, width: number, color: Color3)
	local line = Instance.new("Frame")
	line.Name = "Line"
	line.Size = UDim2.new(0, (lineStart - lineEnd).Magnitude, 0, width)
	line.BorderSizePixel = 0
	line.BackgroundColor3 = color
	
	line.Rotation = math.atan2(lineEnd.Y - lineStart.Y, lineEnd.X - lineStart.X) * 180 / math.pi
	line.Position = UDim2.new(0, (lineStart.X+lineEnd.X)/2, 0, (lineStart.Y+lineEnd.Y)/2)
	line.Parent = Frame
end

function Bee2D.DrawBezierQuad(startPos: Vector2, endPos: Vector2, controlPos: Vector2, width: number, color: Color3)
	local t = 1;
	local numSteps = 100;


	for i = 1, numSteps do
		local t = i / numSteps
		local point = (1 - t)^2 * startPos + 2 * (1 - t) * t * controlPos + t^2 * endPos
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, width, 0, width)
		frame.Position = UDim2.new(0, point.X, 0, point.Y)
		frame.BorderSizePixel = 0
		frame.BackgroundColor3 = color
		frame.Name = "BezierCurveQuad"
		frame.Parent = Frame
	end
end	

function Bee2D.DrawCircleLine(posX: number, posY: number, radius: number, color: Color3)
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	local backFrame = Instance.new("Frame")
	backFrame.Name = "Circle"
	backFrame.Size = UDim2.new(0, radius * 2, 0, radius * 2)
	backFrame.Position = UDim2.new(0, posX, 0, posY)
	backFrame.BackgroundTransparency = 1
	backFrame.Parent = Frame
	
	local circle = Instance.new("ImageLabel")
	circle.Size = UDim2.new(1, 0, 1, 0)
	circle.BackgroundTransparency = 1
	circle.Image = "rbxassetid://11507951972"
	circle.ImageColor3 = color
	circle.Parent = backFrame
end

return Bee2D