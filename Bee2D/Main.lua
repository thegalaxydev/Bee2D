-- Bee2D by Galaxy#1337


local Bee2D = {}
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Window: ScreenGui
local Frame: Frame

local _fullscreen = false;

Bee2D.Fullscreen = _fullscreen
Bee2D.WindowSizeAbsolute = nil;
Bee2D.DefaultSize = Vector2.new(800,450)
Bee2D.WindowSize = Vector2.new(800,450)
Bee2D.BackgroundColor = Color3.fromRGB(0,0,0);
Bee2D.FPS = 0

Bee2D.Camera = {
	Position = Vector2.new(0,0),
	Zoom = 1,
	Angle = 0
}

local _windowOpen

-- Draws the FPS counter on the top left of the window
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

-- Set the window to fullscreen or not based on a bool if provided
function Bee2D:SetFullscreen(bool: boolean)
	_fullscreen = if bool ~= nil then bool else not _fullscreen
	Bee2D.Fullscreen = _fullscreen
	Bee2D.WindowSize = _fullscreen and Bee2D.WindowSizeAbsolute or Bee2D.DefaultSize
end

-- Initialize the window with a size if provided
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
	Bee2D.DefaultSize = Bee2D.WindowSize
	Frame.Size = (not _fullscreen) and UDim2.new(0, Bee2D.WindowSize.X, 0, Bee2D.WindowSize.Y) or UDim2.new(1, 0, 1, 0)
	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = Bee2D.BackgroundColor
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Parent = Window
end

-- Close the window
function Bee2D.CloseWindow()
	_windowOpen = false
end

-- Is set to true if the window should close
function Bee2D.WindowShouldClose(): boolean
	return _windowOpen
end

-- Clear the window and set the background color
function Bee2D.ClearBackground(color: Color3)
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	Bee2D.WindowSizeAbsolute = Window.AbsoluteSize
	Bee2D.WindowSize = _fullscreen and Bee2D.WindowSizeAbsolute or Bee2D.DefaultSize
	Frame.BackgroundColor3 = color or Bee2D.BackgroundColor
	for _, child in pairs(Frame:GetChildren()) do
		child:Destroy()
	end
end

-- Draw an image to the window given a texture, position, rotation, size, and image tint
function Bee2D.DrawImage(texture: string, position: Vector2, rotation: number, size: Vector2, tint: Color3)
	assert(Window and Frame, "[Bee2D] Window is not initialized")

	local image = Instance.new("ImageLabel")
	image.Name = "Image"
	image.Image = texture
	image.Size = UDim2.new(0, size.X * Bee2D.Camera.Zoom, 0, size.Y * Bee2D.Camera.Zoom)

	image.Position = UDim2.new(0, (position.X - Bee2D.Camera.Position.X) * Bee2D.Camera.Zoom,
							   0, (position.Y - Bee2D.Camera.Position.Y) * Bee2D.Camera.Zoom)


	image.BackgroundTransparency = 1
	image.BackgroundColor3 = Color3.new(0,0,0)
	image.BorderColor3 = Color3.new(1,0,0)
	image.BorderSizePixel = 0
	image.ImageTransparency = 0
	image.ImageColor3 = tint
	image.Rotation = rotation
	image.Parent = Frame
end

-- Draw a rectangle to the window given a position, size, and color
function Bee2D.DrawRectangle(posX: number, posY: number, width: number, height: number, color: Color3)
	assert(Window and Frame, "[Bee2D] Window is not initialized")

	local rect = Instance.new("Frame")
	rect.Name = "Rectangle"
	rect.Size = UDim2.new(0, width * Bee2D.Camera.Zoom, 0, height * Bee2D.Camera.Zoom)

	rect.Position = UDim2.new(0, (posX - Bee2D.Camera.Position.X) * Bee2D.Camera.Zoom,
							  0, (posY - Bee2D.Camera.Position.Y) * Bee2D.Camera.Zoom)
	rect.BorderSizePixel = 0
	rect.BackgroundColor3 = color
	rect.Parent = Frame
end

-- Draw a rectangle to the window given a position, size, rotation, and color
function Bee2D.DrawRectangleEx(posX: number, posY: number, width: number, height: number, rotation: number, color: Color3)
	assert(Window and Frame, "[Bee2D] Window is not initialized")

	local rect = Instance.new("Frame")
	rect.Name = "Rectangle"
	rect.Size = UDim2.new(0, width * Bee2D.Camera.Zoom, 0, height * Bee2D.Camera.Zoom)
	
	rect.Position = UDim2.new(0, (posX - Bee2D.Camera.Position.X) * Bee2D.Camera.Zoom,
							  0, (posY - Bee2D.Camera.Position.Y) * Bee2D.Camera.Zoom)
	rect.Rotation = rotation
	rect.BorderSizePixel = 0
	rect.BackgroundColor3 = color
	rect.Parent = Frame
end

-- Draws a model on screen with a viewport.
function Bee2D:DrawModel(model: Model, position: Vector2, rotation: number, scale: Vector2)
	assert(Window and Frame, "[Bee2D] Window is not initialized")

	local viewport = Instance.new("ViewportFrame")
	viewport.Name = "ModelHolder"
	viewport.Size = UDim2.new(0, scale.X * Bee2D.Camera.Zoom, 0, scale.Y * Bee2D.Camera.Zoom)
	viewport.Position = UDim2.new((position.X - Bee2D.Camera.Position.X) * Bee2D.Camera.Zoom, 0,
							   (position.Y - Bee2D.Camera.Position.Y) * Bee2D.Camera.Zoom, 0)
	viewport.BackgroundTransparency = 1
	viewport.Parent = Frame

	local modelClone = model:Clone()
	modelClone.Parent = viewport
	
	local camera = Instance.new("Camera")
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = modelClone.PrimaryPart and CFrame.new(modelClone.PrimaryPart.Position + Vector3.new(0, 0, -5), modelClone.PrimaryPart.Position) 
	or CFrame.new(modelClone:GetBoundingBox().Position + Vector3.new(0, 0, -5), modelClone:GetBoundingBox().Position)

	camera.Parent = viewport


	return modelClone, camera
end

-- Draws text on screen given a position, color, font, and text size.
function Bee2D.DrawText(text: string, posX: number, posY: number, color: Color3, font: Enum.Font, size: number)
	assert(Window and Frame, "[Bee2D] Window is not initialized")

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "Text"
	textLabel.Text = text
	textLabel.TextColor3 = color
	textLabel.TextSize = size
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel.TextYAlignment = Enum.TextYAlignment.Top

	textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabel.Font = font
	textLabel.BackgroundTransparency = 0;
	textLabel.BackgroundColor3 = Color3.new(1,0,0)
	textLabel.Position = UDim2.new(0,(posX - Bee2D.Camera.Position.X) * Bee2D.Camera.Zoom,
	0, (posY - Bee2D.Camera.Position.Y) * Bee2D.Camera.Zoom)
	
	textLabel.Parent = Frame
	textLabel.Size = UDim2.new(0, textLabel.TextBounds.X * Bee2D.Camera.Zoom,
	0, textLabel.TextBounds.Y * Bee2D.Camera.Zoom)
end

-- Draws an element on the screen given a GuiObject
function Bee2D:DrawElement(element: GuiObject)
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	assert(element:IsA("GuiObject"), "[Bee2D] Element is not a GuiObject");

	element.Position = UDim2.new(0, (element.Position.X.Offset - Bee2D.Camera.Position.X)  * Bee2D.Camera.Zoom, 0, (element.Position.Y.Offset - Bee2D.Camera.Position.Y) * Bee2D.Camera.Zoom) 

	element.Parent = Frame
end

-- Adds any instance to the window
function Bee2D:AddToWindow(instance: string)
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	local inst = Instance.new(instance)
	inst.Parent = Frame

	return inst
end

-- Draws a line on the screen given a start and end position, width, and color
function Bee2D.DrawLine(lineStart: Vector2, lineEnd: Vector2, width: number, color: Color3)
	lineStart = (lineStart  - Bee2D.Camera.Position)  * Bee2D.Camera.Zoom
	lineEnd = (lineEnd - Bee2D.Camera.Position)  * Bee2D.Camera.Zoom

	local line = Instance.new("Frame")
	line.Name = "Line"
	line.Size = UDim2.new(0, (lineStart - lineEnd).Magnitude * Bee2D.Camera.Zoom, 0, width * Bee2D.Camera.Zoom)
	line.BorderSizePixel = 0
	line.BackgroundColor3 = color
	
	line.Rotation = math.atan2(lineEnd.Y - lineStart.Y, lineEnd.X - lineStart.X) * 180 / math.pi
	line.Position = UDim2.new(0, (lineStart.X+lineEnd.X)/2, 0, (lineStart.Y+lineEnd.Y)/2)
	line.Parent = Frame
end

-- Draws a bezier curve on the screen given a start and end position, control point, width, and color
function Bee2D.DrawBezierQuad(startPos: Vector2, endPos: Vector2, controlPos: Vector2, width: number, color: Color3)
	local t = 1;
	local numSteps = 100;

	startPos = (startPos - Bee2D.Camera.Position) * Bee2D.Camera.Zoom
	endPos = (endPos - Bee2D.Camera.Position) * Bee2D.Camera.Zoom
	controlPos = (controlPos - Bee2D.Camera.Position) * Bee2D.Camera.Zoom

	for i = 1, numSteps do
		local t = i / numSteps
		local point = (1 - t)^2 * startPos + 2 * (1 - t) * t * controlPos + t^2 * endPos
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, width * Bee2D.Camera.Zoom, 0, width * Bee2D.Camera.Zoom)
		frame.Position = UDim2.new(0, point.X, 0, point.Y)
		frame.BorderSizePixel = 0
		frame.BackgroundColor3 = color
		frame.Name = "BezierCurveQuad"
		frame.Parent = Frame
	end
end

return Bee2D