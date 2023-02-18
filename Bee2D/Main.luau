-- Bee2D by Galaxy#1337
local Bee2D = {}
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

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

local _UIStorage

local _cache = {}



-- Draws the FPS counter on the top left of the window
function Bee2D.DrawFPS()
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	_UIStorage.FPS:Clone().Parent = Frame
end

-- Set the window to fullscreen or not based on a bool if provided
function Bee2D:SetFullscreen(bool: boolean)
	_fullscreen = if bool ~= nil then bool else not _fullscreen
	Bee2D.Fullscreen = _fullscreen
	Bee2D.WindowSize = _fullscreen and Bee2D.WindowSizeAbsolute or Bee2D.DefaultSize
end

function populateStorage()
	local fps = Instance.new("TextLabel")
	fps.Name = "FPS"
	fps.Text = "FPS: " .. tostring(math.round(Bee2D.FPS))
	fps.TextColor3 = Color3.new(1,1,1)
	fps.TextStrokeTransparency = 0
	fps.TextStrokeColor3 = Color3.new(0,0,0)
	fps.TextScaled = true
	fps.TextSize = 14
	fps.TextWrapped = true
	fps.TextXAlignment = Enum.TextXAlignment.Left
	fps.TextYAlignment = Enum.TextYAlignment.Top
	fps.BackgroundTransparency = 1
	fps.Size = UDim2.new(0, 100, 0, 20)
	fps.AnchorPoint = Vector2.new(1, 0)
	fps.Position = UDim2.new(1, 0, 0, 0)
	fps.Parent = _UIStorage

	local image = Instance.new("ImageLabel")
	image.Name = "Image"
	image.BackgroundTransparency = 1
	image.BackgroundColor3 = Color3.new(0,0,0)
	image.BorderColor3 = Color3.new(1,0,0)
	image.BorderSizePixel = 0
	image.ImageTransparency = 0
	image.Parent = _UIStorage

	local rect = Instance.new("Frame")
	rect.Name = "Rectangle"
	rect.BorderSizePixel = 0
	rect.Parent = _UIStorage

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "Text"
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel.TextYAlignment = Enum.TextYAlignment.Top
	textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabel.BackgroundTransparency = 1;
	textLabel.BackgroundColor3 = Color3.new(1,0,0)
	textLabel.Parent = _UIStorage
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

	_UIStorage = Instance.new("Folder")
	_UIStorage.Parent = script.Parent

	populateStorage()
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
function Bee2D.ClearBackground(color: Color3 | nil)
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	Bee2D.WindowSizeAbsolute = Window.AbsoluteSize
	Bee2D.WindowSize = _fullscreen and Bee2D.WindowSizeAbsolute or Bee2D.DefaultSize
	Frame.BackgroundColor3 = color or Bee2D.BackgroundColor

	for _, child in pairs(Frame:GetChildren()) do
		local id = child:GetAttribute("Identifier")

		if not id then continue end

		if not _cache[id] then
			_cache[id] = {
				Object = child,
				IsUsed = false
			}
		else
			if not _cache[id].IsUsed then
				_cache[id].Object:Destroy()
				_cache[id] = nil
			end
		end
	end
end

-- Draw an image to the window given a texture, position, rotation, size, and image tint
function Bee2D.DrawImage(texture: string, position: Vector2, rotation: number, size: Vector2, tint: Color3, identifier: number)
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	if not identifier then warn("[Bee2D] Identifier is not provided. Draw caching may not work properly.") end


	local image

	if _cache[identifier] then
		image = _cache[identifier].Object
		_cache[identifier].IsUsed = true
	else
		image = _UIStorage.Image:Clone()
	end

	image.Image = texture
	image.Size = UDim2.new(0, size.X * Bee2D.Camera.Zoom, 0, size.Y * Bee2D.Camera.Zoom)

	image.Position = UDim2.new(0, (position.X - Bee2D.Camera.Position.X),
							   0, (position.Y - Bee2D.Camera.Position.Y))

	image.ImageColor3 = tint
	image.Rotation = rotation

	if not image:GetAttribute("Identifier") then
		image:SetAttribute("Identifier", identifier)
	end

	image.Parent = Frame
end

-- Draw a rectangle to the window given a position, size, optional rotation, and color
function Bee2D.DrawRectangle(posX: number, posY: number, width: number, height: number, color: Color3, rotation: number, identifier: number)
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	if not identifier then warn("[Bee2D] Identifier is not provided. Draw caching may not work properly.") end

	local rect

	if _cache[identifier] then
		rect = _cache[identifier].Object
		_cache[identifier].IsUsed = true
	else
		rect = _UIStorage.Rectangle:Clone()
	end

	rect.Size = UDim2.new(0, width * Bee2D.Camera.Zoom, 0, height * Bee2D.Camera.Zoom)
	
	rect.Position = UDim2.new(0, (posX - Bee2D.Camera.Position.X) * Bee2D.Camera.Zoom,
							  0, (posY - Bee2D.Camera.Position.Y) * Bee2D.Camera.Zoom)
	rect.Rotation = rotation or 0
	rect.BackgroundColor3 = color

	if not rect:GetAttribute("Identifier") then
		rect:SetAttribute("Identifier", identifier)
	end

	rect.Parent = Frame
end

-- Draws text on screen given a position, color, font, and text size.
function Bee2D.DrawText(text: string, posX: number, posY: number, color: Color3, font: Enum.Font, size: number, identifier: number)
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	if not identifier then warn("[Bee2D] Identifier is not provided. Draw caching may not work properly.") end

	local textLabel

	if _cache[identifier] then
		textLabel = _cache[identifier].Object
		_cache[identifier].IsUsed = true
	else
		textLabel = _UIStorage.Text:Clone()
	end

	textLabel.Text = text
	textLabel.TextColor3 = color
	textLabel.TextSize = size
	textLabel.Font = font

	textLabel.Position = UDim2.new(0,(posX - Bee2D.Camera.Position.X) * Bee2D.Camera.Zoom,
	0, (posY - Bee2D.Camera.Position.Y) * Bee2D.Camera.Zoom)

	textLabel.Parent = Frame

	textLabel.Size = UDim2.new(0, textLabel.TextBounds.X * Bee2D.Camera.Zoom,
	0, textLabel.TextBounds.Y * Bee2D.Camera.Zoom)

	if not textLabel:GetAttribute("Identifier") then
		textLabel:SetAttribute("Identifier", identifier)
	end
end

-- Draws a line on the screen given a start and end position, width, and color
function Bee2D.DrawLine(lineStart: Vector2, lineEnd: Vector2, width: number, color: Color3, identifier: number)
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	if not identifier then warn("[Bee2D] Identifier is not provided. Draw caching may not work properly.") end

	lineStart = (lineStart  - Bee2D.Camera.Position)  * Bee2D.Camera.Zoom
	lineEnd = (lineEnd - Bee2D.Camera.Position)  * Bee2D.Camera.Zoom

	local line

	if _cache[identifier] then
		line = _cache[identifier].Object
		_cache[identifier].IsUsed = true
	else
		line = _UIStorage.Rectangle:Clone()
	end

	line.Name = "Line"
	line.Size = UDim2.new(0, (lineStart - lineEnd).Magnitude * Bee2D.Camera.Zoom, 0, width * Bee2D.Camera.Zoom)
	line.BorderSizePixel = 0
	line.BackgroundColor3 = color
	
	line.Rotation = math.atan2(lineEnd.Y - lineStart.Y, lineEnd.X - lineStart.X) * 180 / math.pi
	line.Position = UDim2.new(0, (lineStart.X+lineEnd.X)/2, 0, (lineStart.Y+lineEnd.Y)/2)
	
	if not line:GetAttribute("Identifier") then
		line:SetAttribute("Identifier", identifier)
	end

	line.Parent = Frame
end

return Bee2D