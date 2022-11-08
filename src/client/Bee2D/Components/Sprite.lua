local Sprite = {}
local Bee2D = require(script.Parent.Parent.Main)
local Transform2D = require(script.Parent.Transform2D)
Sprite.__index = Sprite
Sprite.__class = "Sprite"

export type Sprite = {
    Width: number,
    Height: number,
    Color: Color3,
    Image: string,
}

function Sprite.new(color: Color3, image: string)
    local self = setmetatable({}, Sprite)
    self.Width = newproxy()
    self.Height = newproxy()
    self.Color = color
    self.Image = image

    return self
end

function Sprite:Draw(transform: Transform2D.Transform)
    self.Width = math.round(transform:GetScale().X);
    self.Height = math.round(transform:GetScale().Y);

    local position = Vector2.new(transform:GetPosition().X, transform:GetPosition().Y)

    local rotation = transform.RotationAngle;

    Bee2D.DrawImage(self.Image, position, (rotation * 180 / math.pi), Vector2.new(self.Width, self.Height), self.Color)
end



return Sprite