local Bee2D = {}
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Window: ScreenGui
local Frame: Frame

Bee2D.WindowSizeAbsolute = nil;
Bee2D.WindowSize = Vector2.new(800,450)

function Bee2D.DrawFPS()

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
    Frame.Size = UDim2.new(0, Bee2D.WindowSize.X, 0, Bee2D.WindowSize.Y)
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = Color3.new(1,1,1)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Parent = Window
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
    image.BackgroundTransparency = 1
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


return Bee2D