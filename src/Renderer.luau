-- Renderer by Galaxy#1337
--- @class Renderer
local Renderer = {}
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local TypeDef = require(script.Parent.Class.TypeDef)

local Window: ScreenGui
local Frame: Frame

type Cache = TypeDef.Cache

local _fullscreen = false;

--- @prop Renderer.Fullscreen boolean
--- @within Renderer
Renderer.Fullscreen = _fullscreen

--- @prop Renderer.WindowSizeAbsolute Vector2
--- @within Renderer
Renderer.WindowSizeAbsolute = nil;

--- @prop Renderer.DefaultSize Vector2
--- @within Renderer
Renderer.DefaultSize = Vector2.new(800,450)

--- @prop Renderer.WindowSize Vector2
--- @within Renderer
Renderer.WindowSize = Vector2.new(800,450)

--- @prop Renderer.BackgroundColor Color3
--- @within Renderer
Renderer.BackgroundColor = Color3.fromRGB(0,0,0);

--- @prop Renderer.FPS number
--- @within Renderer
Renderer.FPS = 0

--- @prop Renderer.Camera {Position: Vector2, Zoom: number, Angle: number}
--- @within Renderer
Renderer.Camera = {
	Position = Vector2.new(0,0),
	Zoom = 1,
	Angle = 0
}

local _windowOpen

local _UIStorage

--- @prop Renderer.ActiveCache Cache
--- @within Renderer
Renderer.ActiveCache = nil

--[=[
	Draws the FPS counter on the top left of the window
]=]
function Renderer.DrawFPS()
	assert(Window and Frame, "[Renderer] Window is not initialized")
	_UIStorage.FPS:Clone().Parent = Frame
end

--[=[
	Set the window to fullscreen or not based on a bool if provided
]=]
function Renderer:SetFullscreen(bool: boolean)
	_fullscreen = if bool ~= nil then bool else not _fullscreen
	Renderer.Fullscreen = _fullscreen
	Renderer.WindowSize = _fullscreen and Renderer.WindowSizeAbsolute or Renderer.DefaultSize
end


function populateStorage()
	local fps = Instance.new("TextLabel")
	fps.Name = "FPS"
	fps.Text = "FPS: " .. tostring(math.round(Renderer.FPS))
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
function Renderer.InitWindow(sizeX: number, sizeY: number)
	if Window then Window:Destroy() end
	Window = Instance.new("ScreenGui")
	Window.Name = "Renderer"
	Window.IgnoreGuiInset = true
	Window.Parent = PlayerGui
	Renderer.WindowSizeAbsolute = Window.AbsoluteSize

	if Frame then Frame:Destroy() end
	Frame = Instance.new("Frame")
	Frame.Name = "Main"

	Renderer.WindowSize = (sizeX and sizeY) and Vector2.new(sizeX, sizeY) or Renderer.WindowSize
	Renderer.DefaultSize = Renderer.WindowSize
	Frame.Size = (not _fullscreen) and UDim2.new(0, Renderer.WindowSize.X, 0, Renderer.WindowSize.Y) or UDim2.new(1, 0, 1, 0)
	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = Renderer.BackgroundColor
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
function Renderer.CloseWindow()
	_windowOpen = false
end

--[=[
	Returns true if the window should close

	@return boolean -- True if the window should close
]=]
function Renderer.WindowShouldClose(): boolean
	return _windowOpen
end

--[=[
	Clear the window background with a color if provided, otherwise use the default color

	@param color Color3? -- The color to clear the background with
]=]
function Renderer.ClearBackground(color: Color3?)
	assert(Window and Frame, "[Renderer] Window is not initialized")
	Renderer.WindowSizeAbsolute = Window.AbsoluteSize
	Renderer.WindowSize = _fullscreen and Renderer.WindowSizeAbsolute or Renderer.DefaultSize
	Frame.BackgroundColor3 = color or Renderer.BackgroundColor
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
function Renderer.DrawImage(texture: string, position: Vector2, rotation: number, size: Vector2, tint: Color3, cacheIndex: number?) : ImageLabel
	assert(Window and Frame, "[Renderer] Window is not initialized")
	if not cacheIndex then warn("[Renderer] Cache index is not provided. Draw caching may not work properly.") end

	local image

	if Renderer.ActiveCache and Renderer.ActiveCache:GetObject(cacheIndex) then
		image = Renderer.ActiveCache:GetObject(cacheIndex)
	else
		image = _UIStorage.Image:Clone()
	end

	image.Image = texture
	image.Size = UDim2.new(0, size.X * Renderer.Camera.Zoom, 0, size.Y * Renderer.Camera.Zoom)

	image.Position = UDim2.new(0, (position.X - Renderer.Camera.Position.X),
							   0, (position.Y - Renderer.Camera.Position.Y))

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
function Renderer.DrawRectangle(posX: number, posY: number, width: number, height: number, color: Color3, rotation: number, cacheIndex: number?)
	assert(Window and Frame, "[Renderer] Window is not initialized")

	local rect

	if Renderer.ActiveCache and Renderer.ActiveCache:GetObject(cacheIndex) then
		rect = Renderer.ActiveCache:GetObject(cacheIndex)
	else
		rect = _UIStorage.Rectangle:Clone()
	end
	
	rect.Size = UDim2.new(0, width * Renderer.Camera.Zoom, 0, height * Renderer.Camera.Zoom)
	
	rect.Position = UDim2.new(0, (posX - Renderer.Camera.Position.X) * Renderer.Camera.Zoom,
							  0, (posY - Renderer.Camera.Position.Y) * Renderer.Camera.Zoom)
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
function Renderer.DrawText(text: string, posX: number, posY: number, color: Color3, font: Enum.Font, size: number, cacheIndex: number?)
	assert(Window and Frame, "[Renderer] Window is not initialized")

	local textLabel
	
	if Renderer.ActiveCache and Renderer.ActiveCache:GetObject(cacheIndex) then
		textLabel = Renderer.ActiveCache:GetObject(cacheIndex)
	else
		textLabel = _UIStorage.Text:Clone()
	end
		
	textLabel.Text = text
	textLabel.TextColor3 = color
	textLabel.TextSize = size
	textLabel.Font = font

	textLabel.Position = UDim2.new(0,(posX - Renderer.Camera.Position.X) * Renderer.Camera.Zoom,
		0, (posY - Renderer.Camera.Position.Y) * Renderer.Camera.Zoom)

	textLabel.Parent = Frame

	textLabel.Size = UDim2.new(0, textLabel.TextBounds.X * Renderer.Camera.Zoom,
		0, textLabel.TextBounds.Y * Renderer.Camera.Zoom)

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
function Renderer.DrawLine(lineStart: Vector2, lineEnd: Vector2, width: number, color: Color3, cacheIndex: number?) : Frame
	assert(Window and Frame, "[Renderer] Window is not initialized")

	lineStart = (lineStart  - Renderer.Camera.Position)  * Renderer.Camera.Zoom
	lineEnd = (lineEnd - Renderer.Camera.Position)  * Renderer.Camera.Zoom

	local line

	if Renderer.ActiveCache and Renderer.ActiveCache:GetObject(cacheIndex) then
		line = Renderer.ActiveCache:GetObject(cacheIndex)
	else
		line = _UIStorage.Rectangle:Clone()
	end
	

	line.Name = "Line"
	line.Size = UDim2.new(0, (lineStart - lineEnd).Magnitude * Renderer.Camera.Zoom, 0, width * Renderer.Camera.Zoom)
	line.BorderSizePixel = 0
	line.BackgroundColor3 = color
	
	line.Rotation = math.atan2(lineEnd.Y - lineStart.Y, lineEnd.X - lineStart.X) * 180 / math.pi
	line.Position = UDim2.new(0, (lineStart.X+lineEnd.X)/2, 0, (lineStart.Y+lineEnd.Y)/2)

	line.Parent = Frame

	return line
end

return Renderer