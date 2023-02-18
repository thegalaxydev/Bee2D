-- Bee2D by Galaxy#1337
--- @class Bee2D
local Bee2D = {}
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TypeDef = require(script.Parent.Source.TypeDef)

local Window: ScreenGui
local Frame: Frame

type Cache = TypeDef.Cache

local _fullscreen = false;

--- @prop Bee2D.Fullscreen boolean
--- @within Bee2D
Bee2D.Fullscreen = _fullscreen

--- @prop Bee2D.WindowSizeAbsolute Vector2
--- @within Bee2D
Bee2D.WindowSizeAbsolute = nil;

--- @prop Bee2D.DefaultSize Vector2
--- @within Bee2D
Bee2D.DefaultSize = Vector2.new(800,450)

--- @prop Bee2D.WindowSize Vector2
--- @within Bee2D
Bee2D.WindowSize = Vector2.new(800,450)

--- @prop Bee2D.BackgroundColor Color3
--- @within Bee2D
Bee2D.BackgroundColor = Color3.fromRGB(0,0,0);

--- @prop Bee2D.FPS number
--- @within Bee2D
Bee2D.FPS = 0

--- @prop Bee2D.Camera {Position: Vector2, Zoom: number, Angle: number}
--- @within Bee2D
Bee2D.Camera = {
	Position = Vector2.new(0,0),
	Zoom = 1,
	Angle = 0
}

local _windowOpen

local _UIStorage

--- @prop Bee2D.ActiveCache Cache
--- @within Bee2D
Bee2D.ActiveCache = nil

--[=[
	Draws the FPS counter on the top left of the window
]=]
function Bee2D.DrawFPS()
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	_UIStorage.FPS:Clone().Parent = Frame
end

--[=[
	Set the window to fullscreen or not based on a bool if provided
]=]
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

--[=[
	Initialize the window with a size if provided, otherwise use the default size
]=]
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

--[=[
	Close the window
]=]
function Bee2D.CloseWindow()
	_windowOpen = false
end

--[=[
	Returns true if the window should close

	@return boolean -- True if the window should close
]=]
function Bee2D.WindowShouldClose(): boolean
	return _windowOpen
end

--[=[
	Clear the window background with a color if provided, otherwise use the default color

	@param color Color3? -- The color to clear the background with
]=]
function Bee2D.ClearBackground(color: Color3?)
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	Bee2D.WindowSizeAbsolute = Window.AbsoluteSize
	Bee2D.WindowSize = _fullscreen and Bee2D.WindowSizeAbsolute or Bee2D.DefaultSize
	Frame.BackgroundColor3 = color or Bee2D.BackgroundColor
end

--[=[
	Draws an image to the window

	@param texture string -- The texture to draw
	@param position Vector2 -- The position to draw the image at
	@param rotation number -- The rotation of the image
	@param size Vector2 -- The size of the image
	@param tint Color3 -- The tint of the image
	@param cacheIndex number? -- The cache index to pull from
	
	@return ImageLabel -- The image that was drawn
]=]
function Bee2D.DrawImage(texture: string, position: Vector2, rotation: number, size: Vector2, tint: Color3, cacheIndex: number?) : ImageLabel
	assert(Window and Frame, "[Bee2D] Window is not initialized")
	if not cacheIndex then warn("[Bee2D] Cache index is not provided. Draw caching may not work properly.") end

	local image

	if Bee2D.ActiveCache and Bee2D.ActiveCache:GetObject(cacheIndex) then
		image = Bee2D.ActiveCache:GetObject(cacheIndex)
	else
		image = _UIStorage.Image:Clone()
	end

	image.Image = texture
	image.Size = UDim2.new(0, size.X * Bee2D.Camera.Zoom, 0, size.Y * Bee2D.Camera.Zoom)

	image.Position = UDim2.new(0, (position.X - Bee2D.Camera.Position.X),
							   0, (position.Y - Bee2D.Camera.Position.Y))

	image.ImageColor3 = tint
	image.Rotation = rotation

	image.Parent = Frame

	return image
end

--[=[
	Draws a rectangle to the window

	@param posX number -- The X position to draw the rectangle at
	@param posY number -- The Y position to draw the rectangle at
	@param width number -- The width of the rectangle
	@param height number -- The height of the rectangle
	@param color Color3 -- The color of the rectangle
	@param rotation number -- The rotation of the rectangle
	@param cacheIndex number? -- The cache index to pull from

	@return Frame -- The rectangle that was drawn
]=]
function Bee2D.DrawRectangle(posX: number, posY: number, width: number, height: number, color: Color3, rotation: number, cacheIndex: number?)
	assert(Window and Frame, "[Bee2D] Window is not initialized")

	local rect

	if Bee2D.ActiveCache and Bee2D.ActiveCache:GetObject(cacheIndex) then
		rect = Bee2D.ActiveCache:GetObject(cacheIndex)
	else
		rect = _UIStorage.Rectangle:Clone()
	end
	
	rect.Size = UDim2.new(0, width * Bee2D.Camera.Zoom, 0, height * Bee2D.Camera.Zoom)
	
	rect.Position = UDim2.new(0, (posX - Bee2D.Camera.Position.X) * Bee2D.Camera.Zoom,
							  0, (posY - Bee2D.Camera.Position.Y) * Bee2D.Camera.Zoom)
	rect.Rotation = rotation or 0
	rect.BackgroundColor3 = color

	rect.Parent = Frame

	return rect
end

--[=[
	Draws text to the window

	@param text string -- The text to draw
	@param posX number -- The X position to draw the text at
	@param posY number -- The Y position to draw the text at
	@param color Color3 -- The color of the text
	@param font Enum.Font -- The font of the text
	@param size number -- The size of the text
	@param cacheIndex number? -- The cache index to pull from
	
	@return TextLabel -- The text that was drawn
]=]
function Bee2D.DrawText(text: string, posX: number, posY: number, color: Color3, font: Enum.Font, size: number, cacheIndex: number?)
	assert(Window and Frame, "[Bee2D] Window is not initialized")

	local textLabel
	
	if Bee2D.ActiveCache and Bee2D.ActiveCache:GetObject(cacheIndex) then
		textLabel = Bee2D.ActiveCache:GetObject(cacheIndex)
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

	return textLabel
end

--[=[
	Draws a line to the window

	@param lineStart Vector2 -- The start position of the line
	@param lineEnd Vector2 -- The end position of the line
	@param width number -- The width of the line
	@param color Color3 -- The color of the line
	@param cacheIndex number? -- The cache index to pull from

	@return Frame -- The line that was drawn
]=]
function Bee2D.DrawLine(lineStart: Vector2, lineEnd: Vector2, width: number, color: Color3, cacheIndex: number?) : Frame
	assert(Window and Frame, "[Bee2D] Window is not initialized")

	lineStart = (lineStart  - Bee2D.Camera.Position)  * Bee2D.Camera.Zoom
	lineEnd = (lineEnd - Bee2D.Camera.Position)  * Bee2D.Camera.Zoom

	local line

	if Bee2D.ActiveCache and Bee2D.ActiveCache:GetObject(cacheIndex) then
		line = Bee2D.ActiveCache:GetObject(cacheIndex)
	else
		line = _UIStorage.Rectangle:Clone()
	end
	

	line.Name = "Line"
	line.Size = UDim2.new(0, (lineStart - lineEnd).Magnitude * Bee2D.Camera.Zoom, 0, width * Bee2D.Camera.Zoom)
	line.BorderSizePixel = 0
	line.BackgroundColor3 = color
	
	line.Rotation = math.atan2(lineEnd.Y - lineStart.Y, lineEnd.X - lineStart.X) * 180 / math.pi
	line.Position = UDim2.new(0, (lineStart.X+lineEnd.X)/2, 0, (lineStart.Y+lineEnd.Y)/2)

	line.Parent = Frame

	return line
end

return Bee2D